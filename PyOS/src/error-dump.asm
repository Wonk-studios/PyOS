BITS 32
SECTION .text

global error_check
global dump_error

; Function to check for errors
error_check:
    ; Check for specific error conditions here
    ; For demonstration, we'll just call dump_error directly
    call dump_error
    ret

; Function to dump the state of all registers
dump_error:
    pusha

    ; Print error dump message
    mov si, error_dump_msg
    call print_string

    ; Dump all registers
    mov ax, [esp + 32]  ; EAX
    call print_register
    mov ax, [esp + 28]  ; EBX
    call print_register
    mov ax, [esp + 24]  ; ECX
    call print_register
    mov ax, [esp + 20]  ; EDX
    call print_register
    mov ax, [esp + 16]  ; ESI
    call print_register
    mov ax, [esp + 12]  ; EDI
    call print_register
    mov ax, [esp + 8]   ; EBP
    call print_register
    mov ax, [esp + 4]   ; ESP
    call print_register
    popa
    ret

; Function to print a register value as a hexadecimal number
print_register:
    pusha
    mov cx, 8
.print_hex_digit:
    rol eax, 4
    mov bl, al
    and bl, 0x0F
    cmp bl, 10
    jl .digit_is_number
    add bl, 'A' - 10
    jmp .print_digit
.digit_is_number:
    add bl, '0'
.print_digit:
    mov ah, VGA_WHITE_ON_BLACK
    stosw
    loop .print_hex_digit
    popa
    ret

; Function to print a string
print_string:
    mov di, VGA_TEXT_MODE_ADDRESS
    mov ah, VGA_WHITE_ON_BLACK
.next_char:
    lodsb
    cmp al, 0
    je .done
    stosw
    jmp .next_char
.done:
    ret

SECTION .data
VGA_TEXT_MODE_ADDRESS equ 0xB8000
VGA_WHITE_ON_BLACK equ 0x0F00
error_dump_msg db 'Error Dump:', 0
