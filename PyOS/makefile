# Define variables
ASM = nasm
CC = gcc
LD = ld
ASM_FLAGS = -f bin
CFLAGS = -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -T linker.ld -nostdlib

# Output binaries
BOOTLOADER_BIN = bootloader.bin
KERNEL_BIN = kernel.bin
OS_IMAGE = pyos.img

# Directories
BOOT_DIR = boot
KERNEL_DIR = kernel
INTERPRETER_DIR = root/PyOS/interpret
SCRIPT_DIR = root/PyOS/interpret/script

# Source files
BOOTLOADER_SRC = $(BOOT_DIR)/bootloader.asm
KERNEL_SRC = $(KERNEL_DIR)/kernel.asm
INTERPRETER_SRC = $(INTERPRETER_DIR)/interpreter.c

# Ensure directories exist
$(BOOT_DIR) $(KERNEL_DIR) $(INTERPRETER_DIR):
	mkdir -p $@

# Build rules
all: $(OS_IMAGE)

$(BOOTLOADER_BIN): $(BOOTLOADER_SRC) | $(BOOT_DIR)
	$(ASM) $(ASM_FLAGS) $(BOOTLOADER_SRC) -o $(BOOT_DIR)/$(BOOTLOADER_BIN)

$(KERNEL_BIN): $(KERNEL_SRC) | $(KERNEL_DIR)
	$(ASM) $(ASM_FLAGS) $(KERNEL_SRC) -o $(KERNEL_DIR)/$(KERNEL_BIN)

$(INTERPRETER_DIR)/interpreter.bin: $(INTERPRETER_SRC) | $(INTERPRETER_DIR)
	$(CC) $(CFLAGS) -c $(INTERPRETER_SRC) -o $(INTERPRETER_DIR)/interpreter.o
	$(LD) $(LDFLAGS) -o $(INTERPRETER_DIR)/interpreter.bin $(INTERPRETER_DIR)/interpreter.o

$(OS_IMAGE): $(BOOTLOADER_BIN) $(KERNEL_BIN) $(INTERPRETER_DIR)/interpreter.bin
	dd if=/dev/zero of=$(OS_IMAGE) bs=512 count=2880
	dd if=$(BOOT_DIR)/$(BOOTLOADER_BIN) of=$(OS_IMAGE) conv=notrunc
	dd if=$(KERNEL_DIR)/$(KERNEL_BIN) of=$(OS_IMAGE) seek=1 conv=notrunc
	dd if=$(INTERPRETER_DIR)/interpreter.bin of=$(OS_IMAGE) seek=2 conv=notrunc

clean:
	rm -f $(BOOT_DIR)/*.bin $(KERNEL_DIR)/*.bin $(INTERPRETER_DIR)/*.o $(INTERPRETER_DIR)/*.bin $(OS_IMAGE)
