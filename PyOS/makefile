# Define variables
ASM = nasm
CC = gcc
LD = ld
PYTHON = python3
ASM_FLAGS = -f bin
CFLAGS = -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -T linker.ld -nostdlib

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
SCRIPT_SRC = $(SCRIPT_DIR)/script.py

# Build rules
all: $(ISO)

# Assemble bootloader
$(BOOT_DIR)/$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
    $(ASM) $(ASM_FLAGS) $(BOOTLOADER_SRC) -o $(BOOT_DIR)/$(BOOTLOADER_BIN)

# Compile kernel
$(KERNEL_DIR)/kernel.o: $(KERNEL_SRC)
    $(CC) $(CFLAGS) -c $(KERNEL_SRC) -o $(KERNEL_DIR)/kernel.o

# Link kernel
$(KERNEL_DIR)/$(KERNEL_BIN): $(KERNEL_DIR)/kernel.o
    $(LD) $(LDFLAGS) -o $(KERNEL_DIR)/$(KERNEL_BIN) $(KERNEL_DIR)/kernel.o

# Compile interpreter
$(INTERPRETER_DIR)/interpreter.o: $(INTERPRETER_SRC)
    $(CC) $(CFLAGS) -c $(INTERPRETER_SRC) -o $(INTERPRETER_DIR)/interpreter.o

# Link interpreter
$(INTERPRETER_DIR)/$(INTERPRETER_BIN): $(INTERPRETER_DIR)/interpreter.o
    $(LD) $(LDFLAGS) -o $(INTERPRETER_DIR)/$(INTERPRETER_BIN) $(INTERPRETER_DIR)/interpreter.o

# Create ISO image
$(ISO): $(BOOT_DIR)/$(BOOTLOADER_BIN) $(KERNEL_DIR)/$(KERNEL_BIN) $(INTERPRETER_DIR)/$(INTERPRETER_BIN)
    mkdir -p $(ISO_DIR)/boot
    cp $(BOOT_DIR)/$(BOOTLOADER_BIN) $(ISO_DIR)/boot/bootloader.bin
    cp $(KERNEL_DIR)/$(KERNEL_BIN) $(ISO_DIR)/boot/kernel.bin
    cp $(INTERPRETER_DIR)/$(INTERPRETER_BIN) $(ISO_DIR)/boot/interpreter.bin
    $(MKISOFS) -o $(ISO) -b boot/bootloader.bin -no-emul-boot -boot-load-size 4 -boot-info-table $(ISO_DIR)

# Clean up
clean:
    rm -f $(BOOTLOADER_BIN) $(KERNEL_DIR)/*.o $(KERNEL_BIN) $(INTERPRETER_DIR)/*.o $(INTERPRETER_BIN) $(ISO)
    rm -rf $(ISO_DIR)

.PHONY: all clean