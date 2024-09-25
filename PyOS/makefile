# Define variables
CC = gcc
CFLAGS = -Wall -Wextra -O2 -m32 -ffreestanding
AS = nasm
ASFLAGS = -f elf
LD = ld
LDFLAGS = -m elf_i386 -T linker.ld

BOOTLOADER_SRC = boot/bootloader.asm
BOOTLOADER_BIN = bootloader.bin
KERNEL_SRC = src/kernel.asm
KERNEL_BIN = kernel.bin
ERROR_DUMP_SRC = src/error_dump.asm
ERROR_DUMP_OBJ = error_dump.o
KERNEL_TERMINAL_SRC = src/kernel-terminal.c
KERNEL_TERMINAL_OBJ = kernel-terminal.o
BOOTLOADER_TERMINAL_SRC = boot/bootloader-terminal.asm
BOOTLOADER_TERMINAL_BIN = bootloader-terminal.bin
INTERPRETER_SRC = src/interpreter.c
INTERPRETER_BIN = interpreter.bin
OS_IMAGE = os_image.bin
ISO_IMAGE = os_image.iso

# Default target
all: $(ISO_IMAGE)

# Assemble the bootloader
$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
	$(AS) $(ASFLAGS) -o $@ $<

# Assemble the bootloader terminal
$(BOOTLOADER_TERMINAL_BIN): $(BOOTLOADER_TERMINAL_SRC)
	$(AS) $(ASFLAGS) -o $@ $<

# Assemble the kernel
$(KERNEL_BIN): $(KERNEL_SRC) $(ERROR_DUMP_OBJ) $(KERNEL_TERMINAL_OBJ)
	$(AS) $(ASFLAGS) -o $@ $<

# Assemble the error dump
$(ERROR_DUMP_OBJ): $(ERROR_DUMP_SRC)
	$(AS) $(ASFLAGS) -o $@ $<

# Compile the kernel terminal
$(KERNEL_TERMINAL_OBJ): $(KERNEL_TERMINAL_SRC)
	$(CC) $(CFLAGS) -c -o $@ $<

# Compile the interpreter
$(INTERPRETER_BIN): $(INTERPRETER_SRC)
	$(CC) $(CFLAGS) -o $@ $<

# Link the kernel, error dump, and kernel terminal
kernel: $(KERNEL_BIN) $(ERROR_DUMP_OBJ) $(KERNEL_TERMINAL_OBJ)
	$(LD) $(LDFLAGS) -o $@ $(KERNEL_BIN) $(ERROR_DUMP_OBJ) $(KERNEL_TERMINAL_OBJ)

# Create the OS image
$(OS_IMAGE): $(BOOTLOADER_BIN) $(BOOTLOADER_TERMINAL_BIN) kernel $(INTERPRETER_BIN)
	cat $(BOOTLOADER_BIN) $(BOOTLOADER_TERMINAL_BIN) kernel $(INTERPRETER_BIN) > $@

# Create the bootable ISO image
$(ISO_IMAGE): $(OS_IMAGE)
	mkdir -p iso/boot/grub
	cp $(OS_IMAGE) iso/boot/
	echo 'set timeout=0' > iso/boot/grub/grub.cfg
	echo 'set default=0' >> iso/boot/grub/grub.cfg
	echo 'menuentry "My OS" {' >> iso/boot/grub/grub.cfg
	echo '  multiboot /boot/$(OS_IMAGE)' >> iso/boot/grub/grub.cfg
	echo '  boot' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg
	genisoimage -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -boot-info-table -o $(ISO_IMAGE) iso

# Clean up the build files
clean:
	rm -f $(BOOTLOADER_BIN) $(BOOTLOADER_TERMINAL_BIN) $(KERNEL_BIN) $(ERROR_DUMP_OBJ) $(KERNEL_TERMINAL_OBJ) $(INTERPRETER_BIN) kernel $(OS_IMAGE) $(ISO_IMAGE)
	rm -rf iso
