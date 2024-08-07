# Makefile for building PyOS

# Paths
BOOTLOADER_SRC = boot/bootloader.asm
KERNEL_SRC = src/kernel.asm
INTERPRETER_SRC = PyOS/interpret/interpreter.c
BOOTLOADER_BIN = bootloader.bin
KERNEL_BIN = kernel.bin
INTERPRETER_BIN = interpreter

# Tools
ASM = nasm
CC = gcc
LD = ld
OBJCOPY = objcopy

# Flags
ASM_FLAGS = -f bin
CC_FLAGS = -ffreestanding -c -o
LD_FLAGS = -Ttext 0x1000 --oformat binary
OBJ_FLAGS = -O binary

# Targets
all: $(BOOTLOADER_BIN) $(KERNEL_BIN) $(INTERPRETER_BIN) PyOS.iso

$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
	$(ASM) $(ASM_FLAGS) $< -o $@

$(KERNEL_BIN): $(KERNEL_SRC)
	$(ASM) $(ASM_FLAGS) $< -o $@

$(INTERPRETER_BIN): $(INTERPRETER_SRC)
	$(CC) $(INTERPRETER_SRC) -o $(INTERPRETER_BIN)

PyOS.iso: $(BOOTLOADER_BIN) $(KERNEL_BIN) 
	mkdir -p iso/boot/grub
	cp $(BOOTLOADER_BIN) iso/boot/
	cp $(KERNEL_BIN) iso/boot/
	echo 'set timeout=0' > iso/boot/grub/grub.cfg
	echo 'set default=0' >> iso/boot/grub/grub.cfg
	echo 'menuentry "PyOS" {' >> iso/boot/grub/grub.cfg
	echo '    multiboot /boot/kernel.bin' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg
	grub-mkrescue -o PyOS.iso iso

clean:
	rm -f $(BOOTLOADER_BIN) $(KERNEL_BIN) $(INTERPRETER_BIN) PyOS.iso
	rm -rf iso

.PHONY: all clean
