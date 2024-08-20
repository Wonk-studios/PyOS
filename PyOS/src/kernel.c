// kernel.c

#include "terminal.h"
#include "gdt.h"
#include "idt.h"
#include "isr.h"

void kernel_main(void) {
    terminal_initialize();

    // Print boot message
    terminal_writestring("...\n");

    // Initialize GDT
    gdt_install();

    // Initialize IDT and interrupts
    idt_install();
    isr_install();

    terminal_writestring("....\n");

    // Now enter an infinite loop
    while (1) {
        asm volatile("hlt");  // Halt the CPU when idle
    }
}
