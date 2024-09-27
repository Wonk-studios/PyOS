#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/io.h>

#define KEYBOARD_DATA_PORT 0x60
#define KEYBOARD_STATUS_PORT 0x64
#define KEYBOARD_COMMAND_PORT 0x64

#define KEYBOARD_STATUS_MASK_OUT_BUF 0x01

void initialize_keyboard() {
	// Enable keyboard
	outb(0xF4, KEYBOARD_COMMAND_PORT);
}

char read_scan_code() {
	while (1) {
		if (inb(KEYBOARD_STATUS_PORT) & KEYBOARD_STATUS_MASK_OUT_BUF) {
			return inb(KEYBOARD_DATA_PORT);
		}
	}
}

void handle_key_press(char scan_code) {
	printf("Scan Code: %x\n", scan_code);
}

int main() {
	if (ioperm(KEYBOARD_DATA_PORT, 1, 1) == -1 ||
		ioperm(KEYBOARD_STATUS_PORT, 1, 1) == -1 ||
		ioperm(KEYBOARD_COMMAND_PORT, 1, 1) == -1) {
		perror("ioperm");
		exit(1);
	}

	initialize_keyboard();

	while (1) {
		char scan_code = read_scan_code();
		handle_key_press(scan_code);
	}

	return 0;
}
