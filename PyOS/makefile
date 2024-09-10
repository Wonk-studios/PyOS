# Define variables
CC = gcc
CFLAGS = -Wall -Wextra -O2
AS = nasm
ASFLAGS = -f bin
LD = ld
LDFLAGS = -T linker.ld

BOOTLOADER_SRC = bootloader.asm
BOOTLOADER_BIN = bootloader.bin
KERNEL_SRC = kernel.asm
KERNEL_BIN = kernel.bin
INTERPRETER_SRC = interpreter.c
INTERPRETER_BIN = interpreter.bin
OS_IMAGE = os_image.bin
ISO = os.iso
ISO_DIR = iso_dir

# Default target
all: $(ISO)

# Build the bootloader
$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
    $(AS) $(ASFLAGS) -o $@ $<

# Build the kernel
$(KERNEL_BIN): $(KERNEL_SRC)
    $(AS) $(ASFLAGS) -o $@ $<

# Build the interpreter
$(INTERPRETER_BIN): $(INTERPRETER_SRC)
    $(CC) $(CFLAGS) -o $@ $^

# Create the OS image
$(OS_IMAGE): $(BOOTLOADER_BIN) $(KERNEL_BIN) $(INTERPRETER_BIN)
    cat $^ > $@

# Create the ISO
$(ISO): $(OS_IMAGE)
    mkdir -p $(ISO_DIR)/boot/grub
    cp $< $(ISO_DIR)/boot/
    grub-mkrescue -o $@ $(ISO_DIR)

# Clean up build artifacts
clean:
    rm -f $(BOOTLOADER_BIN) $(KERNEL_BIN) $(INTERPRETER_BIN) $(OS_IMAGE) $(ISO)
    rm -rf $(ISO_DIR)