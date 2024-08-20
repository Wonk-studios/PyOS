#include <stdint.h>

void kernel_main() {
    // Initialize essential drivers, memory, etc.
    if (initialize_memory() == -1) {
        print("MEMORY INT FAILED! KERNEL ENTERED PANIC!");
        hlt();
    }

    if (initialize_devices() == -1) {
        print("DEVICE INT FAILED! KERNEL ENTERED PANIC!");
        hlt();
    }

    // Main loop of the kernel
    while (1) {
        // Kernel code...
    }
}

int initialize_memory() {
    // Error handling if memory setup fails
    if (!memory_check()) {
        return -1;
    }
    return 0;
}

int initialize_devices() {
    // Error handling for device setup
    if (!device_check()) {
        return -1;
    }
    return 0;
}

void print(const char* message) {
    // Basic print to the screen
    while (*message) {
        write_char(*message++);
    }
}

void hlt() {
    // Halt system
    asm volatile ("hlt");
}
