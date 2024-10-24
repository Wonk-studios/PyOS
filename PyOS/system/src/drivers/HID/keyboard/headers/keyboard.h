#ifndef KEYBOARD_H
#define KEYBOARD_H

#include <stdint.h>

void init_keyboard();
void keyboard_interrupt_handler();
void handle_keycode(uint8_t keycode);
void print_key(uint8_t keycode);

#endif // KEYBOARD_H