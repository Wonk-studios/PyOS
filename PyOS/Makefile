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

# Define the output files
BOOTLOADER_BIN = bootloader.bin
KERNEL_BIN = kernel.bin
OS_IMAGE = os_image.bin

# Define the source files
BOOTMGR_SRC = $(BOOT_DIR)/bootmngr.c
BOOTLOADER_X86_SRC = $(BOOT_DIR)/x86/bootloader_x86.c
BOOTLOADER_ARM_SRC = $(BOOT_DIR)/ARM/bootloader_arm.c
KERNEL_SRC = $(SRC_DIR)/kernel.c $(SRC_DIR)/acpi.c
KEYBOARD_SRC = $(DRIVERS_DIR)/keyboard/main/keyboard.c
MOUSE_SRC = $(DRIVERS_DIR)/mouse/main/mouse.c
SETUP_SRC = $(SETUP_DIR)/setup.c
INTERPRET_SRC = $(INTERPRET_DIR)/interpreter.c $(INTERPRET_DIR)/entry.c $(INTERPRET_DIR)/handler/error_handler.c

# Define the object files
BOOTMGR_OBJ = bootmngr.o
BOOTLOADER_X86_OBJ = bootloader_x86.o
BOOTLOADER_ARM_OBJ = bootloader_arm.o
KERNEL_OBJ = kernel.o acpi.o
KEYBOARD_OBJ = keyboard.o
MOUSE_OBJ = mouse.o
SETUP_OBJ = setup.o
INTERPRET_OBJ = interpreter.o entry.o error_handler.o

# Default target
all: $(OS_IMAGE)

# Build the bootloader
$(BOOTLOADER_BIN): $(BOOTMGR_OBJ) $(BOOTLOADER_X86_OBJ) $(BOOTLOADER_ARM_OBJ)
    $(CC) $(CFLAGS) -o $@ $^

# Build the kernel
$(KERNEL_BIN): $(KERNEL_OBJ) $(KEYBOARD_OBJ) $(MOUSE_OBJ)
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

# Compile the keyboard driver
$(KEYBOARD_OBJ): $(KEYBOARD_SRC)
    $(CC) $(CFLAGS) -c $< -o $@

# Compile the mouse driver
$(MOUSE_OBJ): $(MOUSE_SRC)
    $(CC) $(CFLAGS) -c $< -o $@

# Compile the setup utility
$(SETUP_OBJ): $(SETUP_SRC)
    $(CC) $(CFLAGS) -c $< -o $@

# Compile the interpreter
$(INTERPRET_OBJ): $(INTERPRET_SRC)
    $(CC) $(CFLAGS) -c $< -o $@

# Clean up build files
clean:
    rm -f $(BOOTMGR_OBJ) $(BOOTLOADER_X86_OBJ) $(BOOTLOADER_ARM_OBJ) $(KERNEL_OBJ) $(KEYBOARD_OBJ) $(MOUSE_OBJ) $(SETUP_OBJ) $(INTERPRET_OBJ) $(BOOTLOADER_BIN) $(KERNEL_BIN) $(OS_IMAGE)

.PHONY: all clean