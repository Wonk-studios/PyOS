# Define variables
ASM = nasm
CC = gcc
LD = ld
PYTHON = python3
ASM_FLAGS = -f bin
CFLAGS = -ffreestanding -O2 -Wall -Wextra `pkg-config --cflags wayland-client`
LDFLAGS = -T linker.ld -nostdlib `pkg-config --libs wayland-client`

# Output binaries
BOOTLOADER_BIN = bootloader.bin
KERNEL_BIN = kernel.bin
INTERPRETER_BIN = interpreter.bin
OS_IMAGE = pyos.img
ISO = pyos.iso

# Directories
BOOT_DIR = boot
KERNEL_DIR = src
INTERPRETER_DIR = root/PyOS/interpret
SCRIPT_DIR = root/PyOS/interpret/script
ISO_DIR = iso

# Source files
BOOTLOADER_SRC = $(BOOT_DIR)/bootloader.asm
KERNEL_SRC = $(KERNEL_DIR)/kernel.c
INTERPRETER_SRC = $(INTERPRETER_DIR)/interpreter.c
WAYLAND_SRC = $(KERNEL_DIR)/wayland.c

# Build rules
$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
    $(ASM) $(ASM_FLAGS) -o $@ $<

$(KERNEL_BIN): $(KERNEL_SRC) $(WAYLAND_SRC)
    $(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

$(INTERPRETER_BIN): $(INTERPRETER_SRC)
    $(CC) $(CFLAGS) -o $@ $^

$(OS_IMAGE): $(BOOTLOADER_BIN) $(KERNEL_BIN) $(INTERPRETER_BIN)
    cat $^ > $@

$(ISO): $(OS_IMAGE)
    mkdir -p $(ISO_DIR)/boot/grub
    cp $< $(ISO_DIR)/boot/
    grub-mkrescue -o $@ $(ISO_DIR)

clean:
    rm -f $(BOOTLOADER_BIN) $(KERNEL_BIN) $(INTERPRETER_BIN) $(OS_IMAGE) $(ISO)
    rm -rf $(ISO_DIR)