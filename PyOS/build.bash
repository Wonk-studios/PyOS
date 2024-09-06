#!/bin/bash

# Configuration
CONFIG_FILE="$(dirname "$0")/config.sh"
BUILD_DIR="$(dirname "$0")/../g"
LOG_FILE="$(dirname "$0")/build.log"
APT_LIST_CMD="apt-get update"
APT_INSTALL_CMD="apt-get install -y"
REQUIRED_PKGS=("gcc" "g++" "binutils" "nasm")
MAKE_CMD="make"
ISO_OUTPUT_PATH="/g/PyOS.img"

# Functions
log() {
    local msg="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $msg" | tee -a "$LOG_FILE"
}

check_command() {
    local cmd="$1"
    command -v "$cmd" >/dev/null 2>&1 || { log "Command $cmd not found. Exiting."; exit 1; }
}

install_missing_packages() {
    for pkg in "${REQUIRED_PKGS[@]}"; do
        if ! dpkg -l | grep -q "^ii  $pkg "; then
            log "$pkg is not installed. Installing..."
            sudo $APT_INSTALL_CMD "$pkg" || { log "Failed to install $pkg. Exiting."; exit 1; }
        else
            log "$pkg is already installed."
        fi
    done
}

# Main script
log "Script started."

# Check required commands
check_command "sudo"
check_command "dpkg"
check_command "grep"

# Load configuration if available
if [ -f "$CONFIG_FILE" ]; then
    log "Loading configuration from $CONFIG_FILE."
    source "$CONFIG_FILE"
else
    log "No configuration file found. Using defaults."
fi

# Navigate to build directory
if [ ! -d "$BUILD_DIR" ]; then
    log "Build directory $BUILD_DIR does not exist. Exiting."
    exit 1
fi

cd "$BUILD_DIR" || { log "Failed to change directory to $BUILD_DIR."; exit 1; }
log "Changed directory to $BUILD_DIR."

# Update APT package list
log "Updating APT package list."
sudo $APT_LIST_CMD || { log "Failed to update APT package list. Exiting."; exit 1; }
log "APT package list updated."

# Install required packages
install_missing_packages
log "All required packages are installed."

# Build the project
log "Building the project using $MAKE_CMD."
$MAKE_CMD || { log "$MAKE_CMD failed with exit code $?. Exiting."; exit 1; }
log "Build complete. Image is expected at $ISO_OUTPUT_PATH."

# Optionally, handle post-build actions here, e.g., move the image, verify integrity, etc.
# Example:
if [ -f "$ISO_OUTPUT_PATH" ]; then
    log "Build successful. ISO image located at $ISO_OUTPUT_PATH."
else
    log "Build failed. ISO image not found at $ISO_OUTPUT_PATH."
    exit 1
fi

log "Script completed."
