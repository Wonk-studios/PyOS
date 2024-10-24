# Define the compiler and flags
CC = gcc
CFLAGS = -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -Ttext 0x1000 --oformat binary

# Define the assembler and flags
AS = nasm
ASFLAGS = -f bin

# Define the directories
BOOT_DIR = system/boot
SRC_DIR = system/src
DRIVERS_DIR = $(SRC_DIR)/drivers/HID
SETUP_DIR = usr/setup
INTERPRET_DIR = usr/interpret
COMPILED_DIR = /workspaces/PyOS-Pro-ED/compiled/

# Define the output files
BOOTLOADER_BIN = $(COMPILED_DIR)/bootloader.bin
KERNEL_BIN = $(COMPILED_DIR)/kernel.bin
OS_IMAGE = $(COMPILED_DIR)/os_image.bin

# Define the source files
BOOTMGR_SRC = $(BOOT_DIR)/bootmngr.c
BOOTLOADER_X86_SRC = $(BOOT_DIR)/x86/bootloader_x86.c
BOOTLOADER_ARM_SRC = $(BOOT_DIR)/ARM/bootloader_arm.c
KERNEL_SRC = $(SRC_DIR)/kernel.c $(SRC_DIR)/acpi.c $(DRIVERS_DIR)/keyboard/main/keyboard.c $(DRIVERS_DIR)/mouse/main/mouse.c
SETUP_SRC = $(SETUP_DIR)/setup.c
INTERPRET_SRC = $(INTERPRET_DIR)/interpreter.c $(INTERPRET_DIR)/entry.c $(INTERPRET_DIR)/handler/error_handler.c

# Define the object files
BOOTMGR_OBJ = $(COMPILED_DIR)/bootmngr.o
BOOTLOADER_X86_OBJ = $(COMPILED_DIR)/bootloader_x86.o
BOOTLOADER_ARM_OBJ = $(COMPILED_DIR)/bootloader_arm.o
KERNEL_OBJ = $(COMPILED_DIR)/kernel.o $(COMPILED_DIR)/acpi.o $(COMPILED_DIR)/keyboard.o $(COMPILED_DIR)/mouse.o
SETUP_OBJ = $(COMPILED_DIR)/setup.o
INTERPRET_OBJ = $(COMPILED_DIR)/interpreter.o $(COMPILED_DIR)/entry.o $(COMPILED_DIR)/error_handler.o

# Default target
all: $(OS_IMAGE)

# Build the bootloader
$(BOOTLOADER_BIN): $(BOOTMGR_OBJ) $(BOOTLOADER_X86_OBJ) $(BOOTLOADER_ARM_OBJ)
	$(CC) $(CFLAGS) -o $@ $^

# Build the kernel
$(KERNEL_BIN): $(KERNEL_OBJ)
	$(CC) $(CFLAGS) -o $@ $^

# Create the OS image
$(OS_IMAGE): $(BOOTLOADER_BIN) $(KERNEL_BIN)
	cat $(BOOTLOADER_BIN) $(KERNEL_BIN) > $@

# Compile the boot manager
$(BOOTMGR_OBJ): $(BOOTMGR_SRC)
	$(CC) $(CFLAGS) -c $< -o $@

# Compile the x86 bootloader
$(BOOTLOADER_X86_OBJ): $(BOOTLOADER_X86_SRC)
	$(CC) $(CFLAGS) -c $< -o $@

# Compile the ARM bootloader
$(BOOTLOADER_ARM_OBJ): $(BOOTLOADER_ARM_SRC)
	$(CC) $(CFLAGS) -c $< -o $@

# Compile the kernel
$(KERNEL_OBJ): $(KERNEL_SRC)
	$(CC) $(CFLAGS) -c $< -o $@

# Compile the setup utility
$(SETUP_OBJ): $(SETUP_SRC)
	$(CC) $(CFLAGS) -c $< -o $@

# Compile the interpreter
$(INTERPRET_OBJ): $(INTERPRET_SRC)
	$(CC) $(CFLAGS) -c $< -o $@

# Clean up build files
clean:
	rm -f $(COMPILED_DIR)/*

# Run the OS image using QEMU
run: $(OS_IMAGE)
	qemu-system-i386 -fda $(OS_IMAGE)

.PHONY: all clean run