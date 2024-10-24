#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "bootloader.h"

#define KERNEL_LOAD_ADDRESS 0x80000

// Function to load the kernel for ARM architecture
bool load_kernel_arm(const char *kernel_path) {
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

// Function to jump to the kernel for ARM architecture
void jump_to_kernel_arm() {
    asm volatile (
        "ldr sp, =0x80000\n"
        "ldr pc, =0x80000\n"
        :
        :
        : "memory"
    );
}