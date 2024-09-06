#!/bin/bash

# Configuration
CONFIG_FILE="$(dirname "$0")/config.sh"
BUILD_DIR="$(dirname "$0")/../g"
LOG_FILE="$(dirname "$0")/build.log"
APT_LIST_CMD="apt-get update"
APT_INSTALL_CMD="apt-get install -y"
REQUIRED_PKGS=("gcc" "g++" "binutils" "nasm")
MAKE_CMD="make"
ISO_OUTPUT_PATH="$(dirname "$0")/../g/PyOS.img"

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
                read -p "Press Enter to close..."
                exit 1
            fi
        else
            log "Package $pkg is already installed."
        fi
    done
}

load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        log "Loading configuration from $CONFIG_FILE"
        source "$CONFIG_FILE"
    else
        log "Configuration file $CONFIG_FILE not found!"
        read -p "Press Enter to close..."
        exit 1
    fi
}

build_project() {
    log "Starting build process..."
    if [ -d "$BUILD_DIR" ]; then
        cd "$BUILD_DIR" || { log "Failed to change directory to $BUILD_DIR."; read -p "Press Enter to close..."; exit 1; }
        $MAKE_CMD | tee -a "$LOG_FILE"
        if [ $? -ne 0 ]; then
            log "Build failed!"
            read -p "Press Enter to close..."
            exit 1
        fi
        log "Build succeeded."
    else
        log "Build directory $BUILD_DIR not found!"
        read -p "Press Enter to close..."
        exit 1
    fi
}

create_iso() {
    log "Creating ISO image..."
    if [ -f "$ISO_OUTPUT_PATH" ]; then
        rm "$ISO_OUTPUT_PATH"
    fi
    genisoimage -o "$ISO_OUTPUT_PATH" -b boot/bootloader.bin -no-emul-boot -boot-load-size 4 -boot-info-table "$BUILD_DIR" | tee -a "$LOG_FILE"
    if [ $? -ne 0 ]; then
        log "ISO creation failed!"
        read -p "Press Enter to close..."
        exit 1
    fi
    log "ISO image created at $ISO_OUTPUT_PATH."
}

main() {
    log "Build script started."
    load_config
    check_requirements
    build_project
    create_iso
    log "Build script completed."
}

main "$@"