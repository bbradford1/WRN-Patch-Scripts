#!/usr/bin/env bash

set -euo pipefail

REPO_BASE="https://raw.githubusercontent.com/bbradford1/WRN-Patch-Scripts/main"
WORKDIR="${HOME}/Downloads/wrn_patch"
SCRIPT1="update_fstab.sh"
SCRIPT2="fix_wrn_failboot_log_cs_250314.sh"

echo "========================================"
echo "WRN Patch Script Downloader"
echo "========================================"
echo

# Require sudo/root
if [[ "${EUID}" -ne 0 ]]; then
  echo "ERROR: Please run this installer with sudo."
  echo
  echo "Example:"
  echo "curl -s ${REPO_BASE}/install.sh | sudo bash"
  exit 1
fi

# Determine real user home when running under sudo
REAL_USER="${SUDO_USER:-$(id -un)}"
REAL_HOME="$(getent passwd "${REAL_USER}" | cut -d: -f6)"

if [[ -n "${REAL_HOME}" && -d "${REAL_HOME}" ]]; then
  WORKDIR="${REAL_HOME}/Downloads/wrn_patch"
fi

mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

echo "Working directory: ${WORKDIR}"
echo

echo "Downloading ${SCRIPT1}..."
wget -q -O "${SCRIPT1}" "${REPO_BASE}/${SCRIPT1}"

echo "Downloading ${SCRIPT2}..."
wget -q -O "${SCRIPT2}" "${REPO_BASE}/${SCRIPT2}"

chmod +x "${SCRIPT1}" "${SCRIPT2}"

echo
echo "Download complete."
echo

echo "========================================"
echo "System Pre-Check"
echo "========================================"

ROOT_USAGE="$(df -h / | awk 'NR==2 {print $5 " used (" $4 " free)"}')"
echo "OS drive usage: ${ROOT_USAGE}"

echo
echo "Checking WRN/WAVE recording mount points..."

MOUNT_WARN=0
for MP in /mnt/sda /mnt/sdb /mnt/sdc /mnt/sdd; do
  if [[ -d "${MP}" ]]; then
    if mountpoint -q "${MP}"; then
      echo "OK: ${MP} is mounted"
    else
      echo "WARNING: ${MP} exists but is NOT mounted"
      MOUNT_WARN=1
    fi
  fi
done

echo
if [[ "${MOUNT_WARN}" -eq 1 ]]; then
  echo "WARNING: One or more storage mounts are not active."
  echo "WAVE may write recording data to the OS drive if storage is missing."
  echo
fi

echo "========================================"
echo "Scripts Ready"
echo "========================================"
echo

echo "Scripts have been downloaded to:"
echo "${WORKDIR}"
echo

echo "To execute the patches manually run:"
echo
echo "cd ${WORKDIR}"
echo "sudo bash ${SCRIPT1}"
echo "sudo bash ${SCRIPT2}"
echo

echo "========================================"
echo "Installer completed"
echo "========================================"
