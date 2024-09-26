.section .text
.global _start

_start:
    b reset

reset:
    ldr sp, =0x8000          @ Set up stack pointer
    bl terminal_loop

terminal_loop:
    bl print_prompt          @ Print terminal prompt
    bl read_input            @ Read user input
    bl execute_command       @ Execute command
    b terminal_loop          @ Loop back to prompt

print_prompt:
    ldr r0, =terminal_prompt
    bl print_string
    bx lr

read_input:
    mov r1, #0               @ Clear buffer index
.read_loop:
    bl get_char              @ Read a single character from the keyboard
    cmp r0, #0x0D            @ Enter key ASCII code
    beq .done
    strb r0, [r1, r1]
    add r1, r1, #1
    b .read_loop
.done:
    strb r0, [r1, r1]        @ Null-terminate the string
    bx lr

execute_command:
    ldr r1, =buffer
    ldr r2, =read_cmd
    bl strcmp
    cmp r0, #0
    beq read_file

    ldr r1, =buffer
    ldr r2, =exit_cmd
    bl strcmp
    cmp r0, #0
    beq exit_terminal

    bl print_unknown_cmd
    bx lr

read_file:
    ldr r0, =file_read_msg
    bl print_string

    ; Read the file from disk (assuming it's in the next sector)
    ldr r0, =file_buffer
    mov r1, #0
    mov r2, #0x80
    mov r3, #0
    mov r4, #4
    mov r5, #1
    bl disk_read
    cmp r0, #0
    bne file_not_found

    ldr r0, =file_buffer
    bl print_string
    bx lr

file_not_found:
    ldr r0, =file_not_found_msg
    bl print_string
    bx lr

exit_terminal:
    b .

print_unknown_cmd:
    ldr r0, =unknown_cmd_msg
    bl print_string
    bx lr

print_string:
    ldr r1, =VGA_TEXT_MODE_ADDRESS
    mov r2, #VGA_WHITE_ON_BLACK
.next_char:
    ldrb r0, [r0], #1
    cmp r0, #0
    beq .done
    strh r0, [r1], #2
    b .next_char
.done:
    bx lr

strcmp:
    push {r1, r2, r3}
.next_char:
    ldrb r2, [r1], #1
    ldrb r3, [r2], #1
    cmp r2, r3
    bne .not_equal
    cmp r2, #0
    bne .next_char
    mov r0, #0
    pop {r1, r2, r3}
    bx lr
.not_equal:
    mov r0, #1
    pop {r1, r2, r3}
    bx lr

get_char:
    ; Placeholder for reading a character from the keyboard
    ; Implement this based on your hardware
    mov r0, #0x41  @ ASCII 'A'
    bx lr

disk_read:
    ; Placeholder for disk read function
    ; Implement this based on your hardware
    mov r0, #0  @ Success
    bx lr

.section .data
VGA_TEXT_MODE_ADDRESS = 0xB8000
VGA_WHITE_ON_BLACK = 0x0F00
VGA_RED_ON_BLACK = 0x4F00

terminal_prompt:
    .asciz "> "
file_read_msg:
    .asciz "Reading file..."
file_not_found_msg:
    .asciz "File not found."
unknown_cmd_msg:
    .asciz "Unknown command."

.section .bss
buffer:
    .space 128  @ Buffer for reading input
file_buffer:
    .space 512  @ Buffer for reading file contents

read_cmd:
    .asciz "read"
exit_cmd:
    .asciz "exit"
