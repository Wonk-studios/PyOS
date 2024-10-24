#include <stdint.h>
#include "mouse.h"

#define MOUSE_DATA_PORT 0x60
#define MOUSE_STATUS_PORT 0x64
#define MOUSE_COMMAND_PORT 0x64
#define MOUSE_IRQ 12

static uint8_t mouse_cycle = 0;
static int8_t mouse_bytes[3];

// Function to initialize the mouse
void init_mouse() {
    // Enable the auxiliary device (mouse)
    outb(MOUSE_COMMAND_PORT, 0xA8);

    // Enable the interrupts
    outb(0x21, inb(0x21) & ~0x02);
    outb(0xA1, inb(0xA1) & ~0x02);

    // Tell the mouse to use default settings
    outb(MOUSE_COMMAND_PORT, 0xD4);
    outb(MOUSE_DATA_PORT, 0xF6);
    inb(MOUSE_DATA_PORT);  // Acknowledge

    // Enable the mouse
    outb(MOUSE_COMMAND_PORT, 0xD4);
    outb(MOUSE_DATA_PORT, 0xF4);
    inb(MOUSE_DATA_PORT);  // Acknowledge
}

// Function to handle mouse interrupts
void mouse_interrupt_handler() {
    uint8_t status = inb(MOUSE_STATUS_PORT);
    while (status & 0x01) {
        mouse_bytes[mouse_cycle++] = inb(MOUSE_DATA_PORT);
        if (mouse_cycle == 3) {
            mouse_cycle = 0;
            // Process mouse data here
        }
        status = inb(MOUSE_STATUS_PORT);
    }
}