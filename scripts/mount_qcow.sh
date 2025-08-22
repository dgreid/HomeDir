#!/bin/bash

# ==============================================================================
# mount-qcow2.sh: Mount a QCOW2 disk image to a temporary directory.
#
# Description:
#   This script connects a QCOW2 image to the first available Network Block
#   Device (NBD), probes for partitions, and mounts the first partition to a
#   newly created directory in /tmp.
#
# Usage:
#   sudo ./mount-qcow2.sh <path_to_qcow2_image>
#
# Dependencies:
#   - qemu-utils (provides qemu-nbd)
#   - util-linux (provides partprobe)
#
# Example:
#   sudo ./mount-qcow2.sh /var/lib/libvirt/images/ubuntu22.04.qcow2
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
IMAGE_NAME="${IMAGE_BASENAME%.*}"         # a.b.c.qcow2 -> a.b.c
MOUNT_POINT="/tmp/mount_${IMAGE_NAME}_$$" # Use PID to ensure uniqueness

# Create the mount point directory
echo "▶ Creating mount directory at '$MOUNT_POINT'..."
mkdir -p "$MOUNT_POINT"

# Ensure the nbd kernel module is loaded
echo "▶ Ensuring 'nbd' kernel module is loaded..."
modprobe nbd max_part=16

# Find a free NBD device
NBD_DEVICE=""
echo "▶ Searching for an available NBD device..."
for i in $(seq 0 15); do
    # Check if the /sys file for the NBD device's PID is empty
    if [[ ! -s "/sys/block/nbd${i}/pid" ]]; then
        NBD_DEVICE="/dev/nbd${i}"
        echo "✅ Found a free device: $NBD_DEVICE"
        break
    fi
done

if [[ -z "$NBD_DEVICE" ]]; then
    echo "❌ Error: No free NBD devices found (checked /dev/nbd0 through /dev/nbd15)."
    rmdir "$MOUNT_POINT"
    exit 1
fi

# Connect the QCOW2 image to the NBD device
# We use --read-only for safety. Remove this flag if you need write access.
echo "▶ Connecting '$IMAGE_PATH' to $NBD_DEVICE..."
qemu-nbd --connect="$NBD_DEVICE" --read-only "$IMAGE_PATH"

# Function to handle cleanup on failure
function cleanup_on_error {
    echo "An error occurred. Cleaning up..."
    # Check if the mount succeeded before another error
    if mountpoint -q "$MOUNT_POINT"; then
        umount "$MOUNT_POINT"
    fi
    qemu-nbd --disconnect "$NBD_DEVICE"
    rmdir "$MOUNT_POINT" 2>/dev/null
    echo "Cleanup complete."
}

# Trap errors and call the cleanup function
trap cleanup_on_error ERR

# Scan for partitions on the NBD device
echo "▶ Scanning for partitions on $NBD_DEVICE..."
partprobe "$NBD_DEVICE"
# Add a small delay for udev to create the device nodes
sleep 2

# Identify the first partition (most common use case)
# e.g., /dev/nbd0 becomes /dev/nbd0p1
PARTITION="${NBD_DEVICE}p1"

if [ ! -b "$PARTITION" ]; then
    echo "❌ Error: Partition $PARTITION not found after probe."
    echo "   Is the image partitioned correctly? Listing available devices:"
    ls -l /dev/nbd*
    exit 1
fi

echo "▶ Mounting partition '$PARTITION' to '$MOUNT_POINT'..."
mount "$PARTITION" "$MOUNT_POINT"

# --- Success Message ---

# Disable the error trap since we succeeded
trap - ERR

echo ""
echo "============================================================"
echo "✅ Success! Image mounted."
echo ""
echo "  Image File:        $IMAGE_PATH"
echo "  NBD Device:        $NBD_DEVICE"
echo "  Mounted Partition: $PARTITION"
echo "  Mount Point:       $MOUNT_POINT"
echo "============================================================"
echo ""
echo "To unmount and disconnect, run the following commands:"
echo "  sudo umount $MOUNT_POINT"
echo "  sudo qemu-nbd --disconnect $NBD_DEVICE"
echo "  sudo rmdir $MOUNT_POINT"
echo ""

exit 0
