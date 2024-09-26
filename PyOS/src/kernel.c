#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include "terminal.h"

// Buffer to hold the config.ini content
#define CONFIG_BUFFER_SIZE 512
char config_buffer[CONFIG_BUFFER_SIZE];

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
        terminal_writestring("Verbose mode enabled.\n");
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
    uint16_t offset = 0x0000;
    uint8_t drive = 0x80; // First hard drive
    uint8_t head = 0;
    uint8_t sector = 2;
    uint8_t cylinder = 0;
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
