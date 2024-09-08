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
REQUIRED_PKGS=("gcc" "g++" "binutils" "nasm" "pkg-config" "libwayland-dev" "grub-pc-bin" "xorriso")
MAKE_CMD="make"
ISO_OUTPUT_PATH="$(dirname "$0")/../g/PyOS.iso"

# Functions
log() {
    local msg="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $msg" | tee -a "$LOG_FILE"
}

check_requirements() {
    log "Checking required packages..."
    $APT_LIST_CMD
    for pkg in "${REQUIRED_PKGS[@]}"; do
        if ! dpkg -l | grep -q "$pkg"; then
            log "Installing missing package: $pkg"
            $APT_INSTALL_CMD "$pkg"
        else
            log "Package $pkg is already installed"
        fi
    done
}

# Main script execution
log "Starting build process..."

# Check and install required packages
check_requirements

# Clean previous builds
log "Cleaning previous builds..."
$MAKE_CMD clean

# Build the project
log "Building the project..."
$MAKE_CMD

# Check if the ISO was created successfully
if [ -f "$ISO_OUTPUT_PATH" ]; then
    log "Build successful. ISO image created: $ISO_OUTPUT_PATH"
else
    log "Build failed. ISO image not created."
    exit 1
fi

log "Build process completed."