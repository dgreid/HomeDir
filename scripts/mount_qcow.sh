#!/bin/bash

# ==============================================================================
# mount-qcow2-all-partitions.sh: Mount all partitions from a QCOW2 disk image.
#
# Description:
#   This script connects a QCOW2 image to a free Network Block Device (NBD),
#   probes for all partitions, and mounts each one to its own subdirectory
#   inside a temporary base directory in /tmp.
#
# Usage:
#   sudo ./mount-qcow2-all-partitions.sh <path_to_qcow2_image>
#
# Dependencies:
#   - qemu-utils (provides qemu-nbd)
#   - util-linux (provides partprobe)
#
# ==============================================================================

set -e # Exit immediately if a command exits with a non-zero status.

# --- Sanity Checks and Initialization ---

# 1. Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "❌ Error: This script must be run as root."
    exit 1
fi

# 2. Check for required command dependencies
for cmd in qemu-nbd partprobe; do
    if ! command -v $cmd &>/dev/null; then
        echo "❌ Error: Required command '$cmd' not found."
        echo "Please install the necessary package (e.g., 'qemu-utils', 'util-linux')."
        exit 1
    fi
done

# 3. Check for correct number of arguments
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <path_to_qcow2_image>"
    exit 1
fi

IMAGE_PATH="$1"

# 4. Check if the image file exists
if [[ ! -f "$IMAGE_PATH" ]]; then
    echo "❌ Error: Image file not found at '$IMAGE_PATH'"
    exit 1
fi

# --- Script Logic ---

# Derive names from the image path
IMAGE_BASENAME=$(basename -- "$IMAGE_PATH")
IMAGE_NAME="${IMAGE_BASENAME%.*}"
# Create a single base directory for all mounts
BASE_MOUNT_DIR="/tmp/mount_${IMAGE_NAME}_$$"

echo "▶ Creating base mount directory at '$BASE_MOUNT_DIR'..."
mkdir -p "$BASE_MOUNT_DIR"

# Store successfully mounted paths for cleanup
declare -a MOUNTED_PATHS

# Ensure the nbd kernel module is loaded
echo "▶ Ensuring 'nbd' kernel module is loaded..."
modprobe nbd max_part=16

# Find a free NBD device
NBD_DEVICE=""
echo "▶ Searching for an available NBD device..."
for i in $(seq 0 15); do
    if [[ ! -s "/sys/block/nbd${i}/pid" ]]; then
        NBD_DEVICE="/dev/nbd${i}"
        echo "✅ Found a free device: $NBD_DEVICE"
        break
    fi
done

if [[ -z "$NBD_DEVICE" ]]; then
    echo "❌ Error: No free NBD devices found (checked /dev/nbd0 through /dev/nbd15)."
    rm -r "$BASE_MOUNT_DIR"
    exit 1
fi

# Connect the QCOW2 image. Remove --read-only if you need write access.
echo "▶ Connecting '$IMAGE_PATH' to $NBD_DEVICE..."
qemu-nbd --connect="$NBD_DEVICE" --read-only "$IMAGE_PATH"

function cleanup_on_error {
    echo "An error occurred. Cleaning up..."
    # Unmount in reverse order of how they were added
    for ((i = ${#MOUNTED_PATHS[@]} - 1; i >= 0; i--)); do
        if mountpoint -q "${MOUNTED_PATHS[i]}"; then
            echo "  - Unmounting ${MOUNTED_PATHS[i]}"
            umount "${MOUNTED_PATHS[i]}"
        fi
    done
    echo "  - Disconnecting $NBD_DEVICE"
    qemu-nbd --disconnect "$NBD_DEVICE"
    if [ -d "$BASE_MOUNT_DIR" ]; then
        echo "  - Removing directory $BASE_MOUNT_DIR"
        rm -r "$BASE_MOUNT_DIR"
    fi
    echo "Cleanup complete."
}

trap cleanup_on_error ERR

# Scan for partitions on the NBD device
echo "▶ Scanning for partitions on $NBD_DEVICE..."
partprobe "$NBD_DEVICE"
sleep 2

# Find all partition devices (e.g., /dev/nbd0p1, /dev/nbd0p2)
PARTITIONS=(${NBD_DEVICE}p*)

# Check if any partitions were found
if [ ! -b "${PARTITIONS[0]}" ]; then
    echo "⚠️ No partitions found on $NBD_DEVICE. Cleaning up."
    qemu-nbd --disconnect "$NBD_DEVICE"
    rm -r "$BASE_MOUNT_DIR"
    exit 0
fi

echo "▶ Found ${#PARTITIONS[@]} partition(s). Attempting to mount all of them..."
declare -a FINAL_MOUNTS

for PARTITION in "${PARTITIONS[@]}"; do
    PART_NAME=$(basename "$PARTITION")
    PART_MOUNT_POINT="${BASE_MOUNT_DIR}/${PART_NAME}"

    echo "  - Creating directory '$PART_MOUNT_POINT' for '$PARTITION'..."
    mkdir -p "$PART_MOUNT_POINT"

    # Attempt to mount, but don't exit if one fails (e.g., a swap partition)
    if mount "$PARTITION" "$PART_MOUNT_POINT" &>/dev/null; then
        echo "    ✅ Mounted '$PARTITION' successfully."
        FINAL_MOUNTS+=("$PARTITION -> $PART_MOUNT_POINT")
        MOUNTED_PATHS+=("$PART_MOUNT_POINT")
    else
        echo "    ⚠️ Could not mount '$PARTITION'. It might be a swap partition or an unsupported filesystem. Skipping."
        rmdir "$PART_MOUNT_POINT"
    fi
done

# Check if any partitions were successfully mounted
if [ ${#MOUNTED_PATHS[@]} -eq 0 ]; then
    echo "❌ Error: Found partitions, but failed to mount any of them."
    exit 1 # This will trigger the ERR trap and cleanup
fi

# --- Success Message ---
trap - ERR

echo ""
echo "============================================================"
echo "✅ Success! All mountable partitions are mounted."
echo ""
echo "  Image File:     $IMAGE_PATH"
echo "  NBD Device:     $NBD_DEVICE"
echo "  Base Directory: $BASE_MOUNT_DIR"
echo ""
echo "  Mounted Partitions:"
for mount_info in "${FINAL_MOUNTS[@]}"; do
    echo "    - $mount_info"
done
echo "============================================================"
echo ""
echo "To unmount everything and clean up, run the following commands:"
# Generate umount commands
for mount_path in "${MOUNTED_PATHS[@]}"; do
    echo "  sudo umount $mount_path"
done
echo "  sudo qemu-nbd --disconnect $NBD_DEVICE"
echo "  sudo rm -r $BASE_MOUNT_DIR"
echo ""

exit 0
