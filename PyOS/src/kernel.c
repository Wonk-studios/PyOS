#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include "terminal.h"

bool show_message = false;

void find_show_message();

void parse_config() {
	find_verbose_mode();
	find_show_message();
}

void find_show_message() {
	const char *show_message_str = "show_message";
	char *ptr = config_buffer;

	while (*ptr) {
		if (strncmp(ptr, show_message_str, strlen(show_message_str)) == 0) {
			ptr += strlen(show_message_str);
			if (*ptr == '=') {
				ptr++;
				if (strncmp(ptr, "true", 4) == 0) {
					show_message = true;
				} else {
					show_message = false;
				}
				return;
			}
		}
		ptr++;
	}
}

void kernel_main() {
	// Initialize terminal
	terminal_initialize();

	// Load the config.ini file from disk
	load_config();

	// Parse the config.ini file
	parse_config();

	// Check if verbose_mode is true
	if (verbose_mode) {
		terminal_writestring("[Bootloader] [Process: Transfer] Transferring and mounting /bootdevice/ROOT/PyOS/SRC...\n");
	}

	// Check if show_message is true
	if (show_message) {
		terminal_writestring("PyOS 0.0.D, (DEVTEST VERSION!!!) (C) Wonk Studios, 2024 all rights reserved\n");
	}

	if (verbose_mode) {
		terminal_writestring("[Kernel] [Process: Transfer] All files have been successfully transferred and mounted to /bootdevice/ROOT/PyOS/SRC. Bootloader may now terminate.\n");
	}

	if (verbose_mode) {
		char address_str[20];
		snprintf(address_str, sizeof(address_str), "%p", (void*)kernel_main);
		terminal_writestring("[Kernel] [Process: Boot] Entering Kernel Main Loop at ");
		terminal_writestring(address_str);
		terminal_writestring("\n");
	}

	// Kernel main loop
	while (1) {
		// Kernel operations
	}
}

if(verbose_mode) {
	terminal_writestring("[Kernel] [Process: Buffering] Buffering config.ini file...\n");

// Buffer to hold the config.ini content
#define CONFIG_BUFFER_SIZE 512
char config_buffer[CONFIG_BUFFER_SIZE];

if(verbose_mode) {
	terminal_writestring("[Kernel] [Process: Saving] Storing settings...\n");
}

// Variables to store the settings
bool verbose_mode = false;

// Function prototypes
void load_config();
void parse_config();
void find_verbose_mode();

void kernel_main() {
    // Initialize terminal
    terminal_initialize();

    // Load the config.ini file from disk
    load_config();

    // Parse the config.ini file
    parse_config();

    // Check if verbose_mode is true
    if (verbose_mode) {
        terminal_writestring("[Kernel] [Process: Read/Load CFG] Reading config.INI\n");
		terminal_writestring("[Kernel] [Process: Read/Load CFG] Loading config.INI\n");
    }

    // Kernel main loop
    while (1) {
        // Kernel operations
    }
}

// Load the config.ini file from disk
void load_config() {
    // Simplified example: Assume config.ini is at a known sector
    uint16_t segment = 0x1000;
	if(verbose_mode) {
		terminal_writestring("[Kernel] [Process: Memory] Segmenting memory...\n");
    uint16_t offset = 0x0000;
	if(verbose_mode) {
		terminal_writestring("[Kernel] [Process: Memory] Offsetting memory...\n");
    uint8_t drive = 0x80; // First hard drive
	if(verbose_mode) {
		terminal_writestring("[Kernel] [Process: Drive] Selecting drive...\n");
    uint8_t head = 0;
	if(verbose_mode) {
		terminal_writestring("[Kernel] [Process: Head] Selecting head...\n");
    uint8_t sector = 2;
	if(verbose_mode) {
		terminal_writestring("[Kernel] [Process: Sector] Selecting sector...\n");
    uint8_t cylinder = 0;
	if(verbose_mode) {
		terminal_writestring("[Kernel] [Process: Cylinder] Selecting cylinder...\n");
    uint8_t num_sectors = 1;

    asm volatile (
        "int $0x13"
        : // No output operands
        : "a"(0x0201), "b"(config_buffer), "c"((cylinder << 8) | sector), "d"((head << 8) | drive)
        : "cc", "memory"
    );
}

// Parse the config.ini file
void parse_config() {
    find_verbose_mode();
}

// Find the verbose_mode setting in the config.ini file
void find_verbose_mode() {
    const char *verbose_mode_str = "verbose_mode";
    char *ptr = config_buffer;

    while (*ptr) {
        if (strncmp(ptr, verbose_mode_str, strlen(verbose_mode_str)) == 0) {
            ptr += strlen(verbose_mode_str);
            if (*ptr == '=') {
                ptr++;
                if (strncmp(ptr, "true", 4) == 0) {
                    verbose_mode = true;
                } else {
                    verbose_mode = false;
                }
                return;
            }
        }
        ptr++;
    }
}
