#!/bin/bash

# Ensure the script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exec sudo "$0" "$@"
fi

# Configuration
CONFIG_FILE="$(dirname "$0")/config.sh"
BUILD_DIR="$(dirname "$0")/../g"
LOG_FILE="$(dirname "$0")/build.log"
APT_LIST_CMD="apt-get update"
APT_INSTALL_CMD="apt-get install -y"
REQUIRED_PKGS=("gcc" "g++" "binutils" "nasm")
MAKE_CMD="make"
ISO_OUTPUT_PATH="$(dirname "$0")/../g/PyOS.img"

check_requirements

# Functions
log() {
    local msg="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $msg" | tee -a "$LOG_FILE"
}

check_requirements() {
    log "Checking required packages..."
    for pkg in "${REQUIRED_PKGS[@]}"; do
        if ! dpkg -l | grep -q "$pkg"; then
            log "Package $pkg is not installed. Installing..."
            $APT_INSTALL_CMD "$pkg" | tee -a "$LOG_FILE"
            if [ $? -ne 0 ]; then
                log "Failed to install $pkg. Exiting."
                exit 1
            fi
        fi
    done
}