#!/usr/bin/env bash

set -e

echo "========================================"
echo "WRN Patch Installer"
echo "Downloading required scripts..."
echo "========================================"

WORKDIR="$HOME/Downloads/wrn_patch"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo "Downloading update_fstab.sh..."
wget -q https://raw.githubusercontent.com/bbradford1/WRN-V3/main/update_fstab.sh

echo "Downloading fix_wrn_failboot_log_cs_250314.sh..."
wget -q https://raw.githubusercontent.com/bbradford1/WRN-V3/main/fix_wrn_failboot_log_cs_250314.sh

chmod +x *.sh

echo
echo "========================================"
echo "Running update_fstab.sh"
echo "========================================"
sudo bash update_fstab.sh

echo
echo "========================================"
echo "Running log cleanup patch"
echo "========================================"
sudo bash fix_wrn_failboot_log_cs_250314.sh

echo
echo "========================================"
echo "WRN patch completed successfully"
echo "Scripts stored in:"
echo "$WORKDIR"
echo "========================================"
