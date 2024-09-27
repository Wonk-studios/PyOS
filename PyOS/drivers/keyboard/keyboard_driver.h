#ifndef KEYBOARD_DRIVER_H
#define KEYBOARD_DRIVER_H

#include <stdint.h>

// Define the keyboard driver namespace
namespace KeyboardDriver {

	// Initialize the keyboard driver
	void initialize();

	// Handle keyboard interrupts
	void handleInterrupt();

	// Get the last pressed key
	char getLastKeyPressed();

	// Check if a key is currently pressed
	bool isKeyPressed(uint8_t keycode);

	// Key event callback type
	typedef void (*KeyEventCallback)(uint8_t keycode, bool pressed);

	// Register a callback for key events
	void registerKeyEventCallback(KeyEventCallback callback);

}

#endif // KEYBOARD_DRIVER_H
