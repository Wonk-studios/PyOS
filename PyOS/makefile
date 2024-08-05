# Makefile
BOOT = boot/bootloader.asm
KERNEL = src/kernel.asm

all: os-image

os-image: bootloader.bin kernel.bin
	# Combine bootloader and kernel into a single OS image
	cat bootloader.bin kernel.bin > os-image

bootloader.bin: $(BOOT)
	# Assemble the bootloader
	nasm -f bin -o bootloader.bin $(BOOT)

kernel.bin: $(KERNEL)
	# Assemble the kernel
	nasm -f bin -o kernel.bin $(KERNEL)

clean:
	# Remove the generated files
	rm -f *.bin os-image
