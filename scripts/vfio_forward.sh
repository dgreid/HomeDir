# Function to get PCI Vendor and Product IDs for a device
get_pci_ids() {
    local pci_address=$1
    local vendor=$(cat /sys/bus/pci/devices/${pci_address}/vendor)
    local device=$(cat /sys/bus/pci/devices/${pci_address}/device)
    echo "${vendor#0x} ${device#0x}"
}

# Function to get IOMMU group for a PCI device
get_iommu_group() {
    local pci_address=$1
    local iommu_group=$(readlink /sys/bus/pci/devices/${pci_address}/iommu_group)
    echo ${iommu_group##*/}
}

# Function to unbind a PCI device from its current driver
unbind_pci_device() {
    local pci_address=$1
    local skip_prompt=${2:-no}
    local driver_path="/sys/bus/pci/devices/${pci_address}/driver"

    # Check if device is bound to a driver
    if [ -e "$driver_path" ]; then
        local current_driver=$(basename $(readlink "$driver_path"))

        if [ "$skip_prompt" != "yes" ]; then
            read -p "Unbind ${pci_address} from ${current_driver}? [y/N] " response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
                echo "Skipping unbind of ${pci_address}"
                return
            fi
        fi

        echo "Unbinding ${pci_address} from ${current_driver}..."
        echo "${pci_address}" >"${driver_path}/unbind"
    else
        echo "Device ${pci_address} is not bound to any driver"
    fi
}

# Function to bind a device to the VFIO driver
bind_to_vfio() {
    local pci_address=$1
    local skip_prompt=${2:-no}
    local ids=($(get_pci_ids "$pci_address"))
    local vendor_id="${ids[0]}"
    local device_id="${ids[1]}"

    if [ "$skip_prompt" != "yes" ]; then
        read -p "Bind ${pci_address} (${vendor_id}:${device_id}) to vfio-pci? [y/N] " response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Skipping vfio-pci bind of ${pci_address}"
            return
        fi
    fi

    echo "Binding ${pci_address} ${vendor_id} ${device_id} to vfio-pci..."
    echo "${vendor_id} ${device_id}" >/sys/bus/pci/drivers/vfio-pci/new_id
}

# Function to bind all devices in an IOMMU group to VFIO
bind_group_to_vfio() {
    local pci_address=$1
    local skip_prompt=${2:-no}

    echo "Processing IOMMU group for device ${pci_address}..."

    # Get the list of devices into an array
    mapfile -t devices < <(get_group_devices "$pci_address")

    # First unbind all devices in the group
    for dev in "${devices[@]}"; do
        unbind_pci_device "$dev" "$skip_prompt"
    done

    # Then bind them all to vfio-pci
    for dev in "${devices[@]}"; do
        bind_to_vfio "$dev" "$skip_prompt"
    done
}

# Function to get all devices in the same IOMMU group as the given device
get_group_devices() {
    local pci_address=$1
    local group=$(get_iommu_group "$pci_address")
    local devices=()

    # Find all devices in the same IOMMU group
    for device in /sys/kernel/iommu_groups/${group}/devices/*; do
        devices+=($(basename "$device"))
    done

    # Sort the devices to ensure consistent output
    (
        IFS=$'\n'
        echo "${devices[*]}"
    ) | sort
}

# Parse command line arguments
skip_prompt="no"
pci_address=""

while [[ $# -gt 0 ]]; do
    case $1 in
    --unbind-all)
        skip_prompt="yes"
        shift
        ;;
    *)
        if [ -z "$pci_address" ]; then
            pci_address="$1"
        else
            echo "Error: Multiple PCI addresses specified"
            exit 1
        fi
        shift
        ;;
    esac
done

if [ -z "$pci_address" ]; then
    echo "Usage: $0 [--unbind-all] <PCI_ADDRESS>"
    echo "Options:"
    echo "  --unbind-all    Skip all confirmation prompts"
    exit 1
fi

# Load the VFIO PCI driver
if ! lsmod | grep -q '^vfio_pci'; then
    echo "Loading vfio-pci module..."
    sudo modprobe vfio-pci
fi

echo "Device $pci_address:"
echo "  IOMMU Group: $(get_iommu_group "$pci_address")"
echo "  VID:PID: $(get_pci_ids "$pci_address")"
echo "  Group Devices:"
mapfile -t devices < <(get_group_devices "$pci_address")
for dev in "${devices[@]}"; do
    echo "    $dev ($(get_pci_ids "$dev"))"
done

echo -e "\nPreparing to bind devices to VFIO..."
bind_group_to_vfio "$pci_address" "$skip_prompt"
chown $USER /dev/vfio/$(basename $(get_iommu_group "$pci_address"))
