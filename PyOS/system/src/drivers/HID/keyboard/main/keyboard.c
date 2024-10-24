#include <stdint.h>
#include "keyboard.h"
#include "display.h"

#define KEYBOARD_DATA_PORT 0x60
#define KEYBOARD_STATUS_PORT 0x64
#define KEYBOARD_IRQ 1

static bool shift_pressed = false;
static bool caps_lock = false;

// Function to initialize the keyboard
void init_keyboard() {
    // Enable keyboard interrupts
    outb(0x21, inb(0x21) & ~0x02);
}

// Function to handle keyboard interrupts
void keyboard_interrupt_handler() {
    uint8_t status = inb(KEYBOARD_STATUS_PORT);
    if (status & 0x01) {
        uint8_t keycode = inb(KEYBOARD_DATA_PORT);
        handle_keycode(keycode);
    }
}

// Function to handle keycodes
void handle_keycode(uint8_t keycode) {
    bool key_released = keycode & 0x80;
    keycode &= 0x7F;

    switch (keycode) {
        case 0x2A: // Left Shift
        case 0x36: // Right Shift
            shift_pressed = !key_released;
            break;
        case 0x3A: // Caps Lock
            if (!key_released) {
                caps_lock = !caps_lock;
            }
            break;
        default:
            if (!key_released) {
                print_key(keycode);
            }
            break;
    }
}

// Function to print the received key press
void print_key(uint8_t keycode) {
    char *key = "Unknown";
    bool uppercase = shift_pressed ^ caps_lock;

    switch (keycode) {
        case 0x02: key = uppercase ? "!" : "1"; break;
        case 0x03: key = uppercase ? "@" : "2"; break;
        case 0x04: key = uppercase ? "#" : "3"; break;
        case 0x05: key = uppercase ? "$" : "4"; break;
        case 0x06: key = uppercase ? "%" : "5"; break;
        case 0x07: key = uppercase ? "^" : "6"; break;
        case 0x08: key = uppercase ? "&" : "7"; break;
        case 0x09: key = uppercase ? "*" : "8"; break;
        case 0x0A: key = uppercase ? "(" : "9"; break;
        case 0x0B: key = uppercase ? ")" : "0"; break;
        case 0x0C: key = uppercase ? "_" : "-"; break;
        case 0x0D: key = uppercase ? "+" : "="; break;
        case 0x1E: key = uppercase ? "A" : "a"; break;
        case 0x30: key = uppercase ? "B" : "b"; break;
        case 0x2E: key = uppercase ? "C" : "c"; break;
        case 0x20: key = uppercase ? "D" : "d"; break;
        case 0x12: key = uppercase ? "E" : "e"; break;
        case 0x21: key = uppercase ? "F" : "f"; break;
        case 0x22: key = uppercase ? "G" : "g"; break;
        case 0x23: key = uppercase ? "H" : "h"; break;
        case 0x17: key = uppercase ? "I" : "i"; break;
        case 0x24: key = uppercase ? "J" : "j"; break;
        case 0x25: key = uppercase ? "K" : "k"; break;
        case 0x26: key = uppercase ? "L" : "l"; break;
        case 0x32: key = uppercase ? "M" : "m"; break;
        case 0x31: key = uppercase ? "N" : "n"; break;
        case 0x18: key = uppercase ? "O" : "o"; break;
        case 0x19: key = uppercase ? "P" : "p"; break;
        case 0x10: key = uppercase ? "Q" : "q"; break;
        case 0x13: key = uppercase ? "R" : "r"; break;
        case 0x1F: key = uppercase ? "S" : "s"; break;
        case 0x14: key = uppercase ? "T" : "t"; break;
        case 0x16: key = uppercase ? "U" : "u"; break;
        case 0x2F: key = uppercase ? "V" : "v"; break;
        case 0x11: key = uppercase ? "W" : "w"; break;
        case 0x2D: key = uppercase ? "X" : "x"; break;
        case 0x15: key = uppercase ? "Y" : "y"; break;
        case 0x2C: key = uppercase ? "Z" : "z"; break;
        case 0x39: key = " "; break;
        case 0x1C: key = "\n"; break;
        case 0x0E: key = "\b"; break;
    }
    print_text(key);
}