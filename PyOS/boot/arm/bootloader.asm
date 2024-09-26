.section .text
.global _start

_start:
    b reset

reset:
    ldr sp, =0x8000          @ Set up stack pointer
    bl load_config           @ Load the config.ini file from disk
    bl parse_config          @ Parse the config.ini file

    ldr r0, =show_message
    ldrb r0, [r0]
    cmp r0, #1
    bne skip_message

    ldr r0, =boot_msg
    bl print_string

skip_message:
    b .

load_config:
    ldr r0, =config_buffer
    bl disk_read_error_handle
    bx lr

disk_read_error_handle:
    ldr r0, =fatal_disk_read_error
    bl handle_error
    bx lr

handle_error:
    bl print_string
    b .

parse_config:
    ldr r0, =config_buffer
    bl find_show_message
    bx lr

find_show_message:
    ldr r1, =show_message_str
    bl find_string
    ldrb r0, [r0]
    cmp r0, #'='
    bne not_found
    add r0, r0, #1
    ldrb r0, [r0]
    cmp r0, #'t'
    bne not_true
    mov r0, #1
    strb r0, [r1]
    bx lr

not_true:
    mov r0, #0
    strb r0, [r1]
    bx lr

not_found:
    mov r0, #0
    strb r0, [r1]
    bx lr

find_string:
    push {r0, r1, r2, r3}

next_char:
    ldrb r2, [r0], #1
    cmp r2, #0
    beq not_found
    ldrb r3, [r1], #1
    cmp r2, r3
    bne next_char
    add r1, r1, #1
    ldrb r3, [r1]
    cmp r3, #0
    beq found
    b next_char

found:
    pop {r0, r1, r2, r3}
    bx lr

show_message_str:
    .asciz "show_message"
show_message:
    .byte 0

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

VGA_TEXT_MODE_ADDRESS = 0xB8000
VGA_WHITE_ON_BLACK = 0x0F00

boot_msg:
    .asciz "ESC for terminal..."

fatal_disk_read_error:
    .asciz "FATAL VH001: FAILED TO READ DISK 0x7C00. HLT"

config_buffer:
    .space 512

.section .bss
    .space 512
