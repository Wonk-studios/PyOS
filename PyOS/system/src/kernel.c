#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "acpi.h"
#include "keyboard.h"
#include "mouse.h"
#include "display.h"

#define MAX_LINE_LENGTH 256
#define INI_FILE_PATH "/system/setup/boot.ini"
#define INTERPRETER_PATH "/system/interpreter/interpreter.bin"

// Structure to hold boot configuration values
typedef struct {
    int timeout;
    bool verbose_mode;
} BootConfig;

// Function to log errors
void log_error(const char *message) {
    FILE *file = fopen("kernel_error.log", "a");
    if (file) {
        fprintf(file, "Error: %s\n", message);
        fclose(file);
    }
}

// Function to dump the state of registers into an error.dmp file
void dump_registers() {
    uint64_t rax, rbx, rcx, rdx, rsi, rdi, rsp, rbp, r8, r9, r10, r11, r12, r13, r14, r15, rip, rflags;

    asm volatile ("mov %%rax, %0" : "=r"(rax));
    asm volatile ("mov %%rbx, %0" : "=r"(rbx));
    asm volatile ("mov %%rcx, %0" : "=r"(rcx));
    asm volatile ("mov %%rdx, %0" : "=r"(rdx));
    asm volatile ("mov %%rsi, %0" : "=r"(rsi));
    asm volatile ("mov %%rdi, %0" : "=r"(rdi));
    asm volatile ("mov %%rsp, %0" : "=r"(rsp));
    asm volatile ("mov %%rbp, %0" : "=r"(rbp));
    asm volatile ("mov %%r8, %0" : "=r"(r8));
    asm volatile ("mov %%r9, %0" : "=r"(r9));
    asm volatile ("mov %%r10, %0" : "=r"(r10));
    asm volatile ("mov %%r11, %0" : "=r"(r11));
    asm volatile ("mov %%r12, %0" : "=r"(r12));
    asm volatile ("mov %%r13, %0" : "=r"(r13));
    asm volatile ("mov %%r14, %0" : "=r"(r14));
    asm volatile ("mov %%r15, %0" : "=r"(r15));
    asm volatile ("lea (%%rip), %0" : "=r"(rip));
    asm volatile ("pushfq; popq %0" : "=r"(rflags));

    FILE *file = fopen("error.dmp", "w");
    if (file) {
        fprintf(file, "RAX: 0x%016lx\n", rax);
        fprintf(file, "RBX: 0x%016lx\n", rbx);
        fprintf(file, "RCX: 0x%016lx\n", rcx);
        fprintf(file, "RDX: 0x%016lx\n", rdx);
        fprintf(file, "RSI: 0x%016lx\n", rsi);
        fprintf(file, "RDI: 0x%016lx\n", rdi);
        fprintf(file, "RSP: 0x%016lx\n", rsp);
        fprintf(file, "RBP: 0x%016lx\n", rbp);
        fprintf(file, "R8: 0x%016lx\n", r8);
        fprintf(file, "R9: 0x%016lx\n", r9);
        fprintf(file, "R10: 0x%016lx\n", r10);
        fprintf(file, "R11: 0x%016lx\n", r11);
        fprintf(file, "R12: 0x%016lx\n", r12);
        fprintf(file, "R13: 0x%016lx\n", r13);
        fprintf(file, "R14: 0x%016lx\n", r14);
        fprintf(file, "R15: 0x%016lx\n", r15);
        fprintf(file, "RIP: 0x%016lx\n", rip);
        fprintf(file, "RFLAGS: 0x%016lx\n", rflags);
        fclose(file);
    }
}

// Function to parse the boot.ini file for configuration values
void parse_boot_ini(BootConfig *config) {
    FILE *file = fopen(INI_FILE_PATH, "r");
    if (file == NULL) {
        print_text("Error opening boot.ini file\n");
        return;
    }

    char line[MAX_LINE_LENGTH];
    char section[MAX_LINE_LENGTH] = {0};

    while (fgets(line, sizeof(line), file)) {
        if (line[0] == '[') {
            sscanf(line, "[%[^]]]", section);
        } else if (strstr(section, "General")) {
            if (strstr(line, "timeout")) {
                sscanf(line, "timeout=%d", &config->timeout);
            } else if (strstr(line, "verbose_mode")) {
                char verbose_mode_str[MAX_LINE_LENGTH];
                sscanf(line, "verbose_mode=%s", verbose_mode_str);
                config->verbose_mode = (strcmp(verbose_mode_str, "true") == 0);
            }
        }
    }

    fclose(file);
}

// Function to initialize the Global Descriptor Table (GDT)
bool init_gdt() {
    // Implementation of GDT initialization
    return true; // Return true if successful
}

// Function to initialize the Interrupt Descriptor Table (IDT)
bool init_idt() {
    // Implementation of IDT initialization
    return true; // Return true if successful
}

// Function to handle basic interrupts
bool handle_interrupts() {
    // Implementation of interrupt handling
    return true; // Return true if successful
}

// Function to load and execute the interpreter
void boot_to_interpreter(bool verbose_mode) {
    if (verbose_mode) {
        print_text("[Kernel] [Process: boot_to_interpreter] Opening interpreter binary...\n");
    }

    FILE *file = fopen(INTERPRETER_PATH, "rb");
    if (file == NULL) {
        log_error("Failed to open interpreter binary");
        dump_registers();
        while (1) {
            asm volatile ("hlt");
        }
    }

    if (verbose_mode) {
        print_text("[Kernel] [Process: boot_to_interpreter] Getting size of interpreter binary...\n");
    }

    // Get the size of the interpreter binary
    if (fseek(file, 0, SEEK_END) != 0) {
        log_error("Failed to seek to end of interpreter binary");
        fclose(file);
        dump_registers();
        while (1) {
            asm volatile ("hlt");
        }
    }

    long size = ftell(file);
    if (size == -1) {
        log_error("Failed to get size of interpreter binary");
        fclose(file);
        dump_registers();
        while (1) {
            asm volatile ("hlt");
        }
    }

    if (fseek(file, 0, SEEK_SET) != 0) {
        log_error("Failed to seek to start of interpreter binary");
        fclose(file);
        dump_registers();
        while (1) {
            asm volatile ("hlt");
        }
    }

    if (verbose_mode) {
        print_text("[Kernel] [Process: boot_to_interpreter] Allocating memory for interpreter binary...\n");
    }

    // Allocate memory for the interpreter binary
    void *interpreter_memory = malloc(size);
    if (interpreter_memory == NULL) {
        log_error("Failed to allocate memory for interpreter binary");
        fclose(file);
        dump_registers();
        while (1) {
            asm volatile ("hlt");
        }
    }

    if (verbose_mode) {
        print_text("[Kernel] [Process: boot_to_interpreter] Reading interpreter binary into memory...\n");
    }

    // Read the interpreter binary into memory
    size_t read_size = fread(interpreter_memory, 1, size, file);
    if (read_size != size) {
        log_error("Failed to read interpreter binary into memory");
        free(interpreter_memory);
        fclose(file);
        dump_registers();
        while (1) {
            asm volatile ("hlt");
        }
    }

    fclose(file);

    if (verbose_mode) {
        print_text("[Kernel] [Process: boot_to_interpreter] Jumping to interpreter entry point...\n");
    }

    // Jump to the interpreter entry point
    void (*interpreter_entry)() = interpreter_memory;
    interpreter_entry();

    // If the interpreter returns, halt the system
    log_error("Interpreter returned unexpectedly");
    free(interpreter_memory);
    dump_registers();
    while (1) {
        asm volatile ("hlt");
    }
}

// Main kernel entry point
void kmain() {
    BootConfig config = {0};

    // Initialize the display
    init_display();

    // Parse boot.ini for configuration
    parse_boot_ini(&config);

    // Print verbose mode message if enabled
    if (config.verbose_mode) {
        print_text("[Kernel] [Process: check] Verbose mode enabled.\n");
    }

    // Initialize hardware
    if (!init_gdt()) {
        log_error("Failed to initialize GDT");
        dump_registers();
        while (1) {
            asm volatile ("hlt");
        }
    }

    if (!init_idt()) {
        log_error("Failed to initialize IDT");
        dump_registers();
        while (1) {
            asm volatile ("hlt");
        }
    }

    // Handle interrupts
    if (!handle_interrupts()) {
        log_error("Failed to handle interrupts");
        dump_registers();
        while (1) {
            asm volatile ("hlt");
        }
    }

    // Initialize ACPI
    if (!acpi_init()) {
        log_error("Failed to initialize ACPI");
        dump_registers();
        while (1) {
            asm volatile ("hlt");
        }
    }

    // Initialize keyboard and mouse
    init_keyboard();
    init_mouse();

    // Main kernel logic
    print_text("Kernel is running...\n");

    // Boot to the interpreter
    boot_to_interpreter(config.verbose_mode);

    // If booting to the interpreter fails, halt the system
    log_error("Failed to boot to interpreter");
    dump_registers();
    while (1) {
        asm volatile ("hlt");
    }
}