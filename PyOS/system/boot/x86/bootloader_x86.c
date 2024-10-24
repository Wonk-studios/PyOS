#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "bootloader.h"

#define KERNEL_LOAD_ADDRESS 0x100000

// Function to load the kernel for x86 architecture
bool load_kernel_x86(const char *kernel_path) {
    FILE *file = fopen(kernel_path, "rb");
    if (!file) {
        return false;
    }

    fseek(file, 0, SEEK_END);
    long size = ftell(file);
    fseek(file, 0, SEEK_SET);

    void *kernel_memory = (void *)KERNEL_LOAD_ADDRESS;
    size_t read_size = fread(kernel_memory, 1, size, file);
    fclose(file);

    return read_size == size;
}

// Function to jump to the kernel for x86 architecture
void jump_to_kernel_x86() {
    // Define a function pointer to the kernel entry point
    void (*kernel_entry)() = (void (*)())KERNEL_LOAD_ADDRESS;

    // Disable interrupts
    asm volatile ("cli");

    // Set up segment registers
    asm volatile (
        "mov $0x10, %%ax\n"
        "mov %%ax, %%ds\n"
        "mov %%ax, %%es\n"
        "mov %%ax, %%fs\n"
        "mov %%ax, %%gs\n"
        "mov %%ax, %%ss\n"
        :
        :
        : "ax"
    );

    // Set up the stack
    asm volatile ("mov $0x100000, %esp");

    // Jump to the kernel entry point
    kernel_entry();
}