# Define variables
CC = gcc
CFLAGS = -Wall -Wextra -O2 -m32 -ffreestanding
AS = nasm
ASFLAGS = -f elf
LD = ld
LDFLAGS = -m elf_i386 -T linker.ld

BOOTMGR_SRC = boot/bootmngr.asm
BOOTMGR_BIN = bootmngr.bin
ARM_BOOTLOADER_SRC = boot/arm/bootloader.asm
ARM_BOOTLOADER_BIN = arm_bootloader.bin
X86_BOOTLOADER_SRC = boot/x86/bootloader.asm
X86_BOOTLOADER_BIN = x86_bootloader.bin
KERNEL_SRC = src/kernel.c
KERNEL_OBJ = kernel.o
ERROR_DUMP_SRC = src/error_dump.asm
ERROR_DUMP_OBJ = error_dump.o
KERNEL_TERMINAL_SRC = src/kernel-terminal.c
KERNEL_TERMINAL_OBJ = kernel-terminal.o
BOOTLOADER_TERMINAL_SRC = boot/bootloader-terminal.asm
BOOTLOADER_TERMINAL_BIN = bootloader-terminal.bin
INTERPRETER_SRC = src/interpreter.c
INTERPRETER_BIN = interpreter.bin
SETUP_SRC = src/setup.c
SETUP_OBJ = setup.o
INI_SRC = src/ini.c
INI_OBJ = ini.o
KEYBOARD_DRIVER_SRC = drivers/keyboard_driver.c
KEYBOARD_DRIVER_OBJ = drivers/keyboard_driver.o
OS_IMAGE = os_image.bin
ISO_IMAGE = os_image.iso

# Default target
all: $(ISO_IMAGE)

# Assemble the boot manager
$(BOOTMGR_BIN): $(BOOTMGR_SRC)
	$(AS) -f bin $(BOOTMGR_SRC) -o $(BOOTMGR_BIN)

# Assemble the ARM bootloader
$(ARM_BOOTLOADER_BIN): $(ARM_BOOTLOADER_SRC)
	$(AS) -f bin $(ARM_BOOTLOADER_SRC) -o $(ARM_BOOTLOADER_BIN)

# Assemble the x86 bootloader
$(X86_BOOTLOADER_BIN): $(X86_BOOTLOADER_SRC)
	$(AS) -f bin $(X86_BOOTLOADER_SRC) -o $(X86_BOOTLOADER_BIN)

# Assemble the bootloader terminal
$(BOOTLOADER_TERMINAL_BIN): $(BOOTLOADER_TERMINAL_SRC)
	$(AS) $(ASFLAGS) -o $@ $<

# Compile the kernel
$(KERNEL_OBJ): $(KERNEL_SRC)
	$(CC) $(CFLAGS) -c -o $@ $<

# Assemble the error dump
$(ERROR_DUMP_OBJ): $(ERROR_DUMP_SRC)
	$(AS) $(ASFLAGS) -o $@ $<

# Compile the kernel terminal
$(KERNEL_TERMINAL_OBJ): $(KERNEL_TERMINAL_SRC)
	$(CC) $(CFLAGS) -c -o $@ $<

# Compile the interpreter
$(INTERPRETER_BIN): $(INTERPRETER_SRC)
	$(CC) $(CFLAGS) -o $@ $<

# Compile the setup
$(SETUP_OBJ): $(SETUP_SRC)
	$(CC) $(CFLAGS) -c -o $@ $<

# Compile the INI parser
$(INI_OBJ): $(INI_SRC)
	$(CC) $(CFLAGS) -c -o $@ $<

# Compile the keyboard driver
$(KEYBOARD_DRIVER_OBJ): $(KEYBOARD_DRIVER_SRC)
	$(CC) $(CFLAGS) -c -o $@ $<

# Link the kernel, error dump, kernel terminal, setup, INI parser, and keyboard driver
kernel: $(KERNEL_OBJ) $(ERROR_DUMP_OBJ) $(KERNEL_TERMINAL_OBJ) $(SETUP_OBJ) $(INI_OBJ) $(KEYBOARD_DRIVER_OBJ)
	$(LD) $(LDFLAGS) -o $@ $(KERNEL_OBJ) $(ERROR_DUMP_OBJ) $(KERNEL_TERMINAL_OBJ) $(SETUP_OBJ) $(INI_OBJ) $(KEYBOARD_DRIVER_OBJ)

# Create the OS image
$(OS_IMAGE): $(BOOTMGR_BIN) $(ARM_BOOTLOADER_BIN) $(X86_BOOTLOADER_BIN) $(BOOTLOADER_TERMINAL_BIN) kernel $(INTERPRETER_BIN)
	cat $(BOOTMGR_BIN) $(ARM_BOOTLOADER_BIN) $(X86_BOOTLOADER_BIN) $(BOOTLOADER_TERMINAL_BIN) kernel $(INTERPRETER_BIN) > $@

# Create the bootable ISO image
$(ISO_IMAGE): $(OS_IMAGE)
	mkdir -p iso/boot/grub
	cp $(OS_IMAGE) iso/boot/
	cp config.ini iso/boot/
	echo 'set timeout=0' > iso/boot/grub/grub.cfg
	echo 'set default=0' >> iso/boot/grub/grub.cfg
	echo 'menuentry "My OS" {' >> iso/boot/grub/grub.cfg
	echo '  multiboot /boot/$(OS_IMAGE)' >> iso/boot/grub/grub.cfg
	echo '  boot' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg
	genisoimage -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -boot-info-table -o $(ISO_IMAGE) iso

# Clean up the build files
clean:
	rm -f $(BOOTMGR_BIN) $(ARM_BOOTLOADER_BIN) $(X86_BOOTLOADER_BIN) $(BOOTLOADER_BIN) $(BOOTLOADER_TERMINAL_BIN) $(KERNEL_OBJ) $(ERROR_DUMP_OBJ) $(KERNEL_TERMINAL_OBJ) $(INTERPRETER_BIN) $(SETUP_OBJ) $(INI_OBJ) $(KEYBOARD_DRIVER_OBJ) kernel $(OS_IMAGE) $(ISO_IMAGE)
	rm -rf iso
6
