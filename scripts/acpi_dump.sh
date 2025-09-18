#!/bin/bash

# dumps ACPI tables to a directory. human-readable *.dsl

# Ensure required tools are installed
if ! command -v acpidump &>/dev/null || ! command -v acpixtract &>/dev/null || ! command -v iasl &>/dev/null; then
    echo "Error: Please install acpica-tools (acpidump, acpixtract, iasl)"
    echo "On Debian/Ubuntu: sudo apt-get install acpica-tools"
    echo "On Fedora: sudo dnf install acpica-tools"
    exit 1
fi

# Create a temporary directory for ACPI tables
TEMP_DIR=$(mktemp -d acpi_dump_XXXX)
cd "$TEMP_DIR" || exit 1

# Dump all ACPI tables to binary files
acpidump >acpi_tables.txt
if [ $? -ne 0 ]; then
    echo "Error: Failed to dump ACPI tables with acpidump"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Extract DSDT and SSDT tables
acpixtract -a acpi_tables.txt
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract tables with acpixtract"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "Dumping Tables"
echo "=================================================="

# Process DSDT and SSDT files
for table in *.dat; do
    if [ -f "$table" ]; then
        # Disassemble the table to ASL
        iasl -d "$table" 2>/dev/null
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to disassemble $table" >>"$OUTPUT_FILE"
            continue
        fi
    fi
done
