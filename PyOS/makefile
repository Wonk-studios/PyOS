BOOT = boot/bootloader.asm
KERNEL = src/kernel.asm

all: os-image

os-image: bootloader.bin kernel.bin
	# Use tab instead of spaces here
	cat bootloader.bin kernel.bin > os-image

bootloader.bin: $(BOOT)
	# Use tab instead of spaces here
	nasm -f bin -o bootloader.bin $(BOOT)

kernel.bin: $(KERNEL)
	# Use tab instead of spaces here
	nasm -f bin -o kernel.bin $(KERNEL)

clean:
	# Use tab instead of spaces here
	rm -f *.bin os-image
