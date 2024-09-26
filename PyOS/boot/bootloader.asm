BITS 16
ORG 0x7C00 ;Boot sector origin (Parser issue)

section .data
VGA_TEXT_MODE_ADDRESS equ 0xB8000
VGA_WHITE_ON_BLACK equ 0x0F00
VGA_RED_ON_BLACK equ 0x4F00

boot_msg db 'Bootloader loaded. Press ESC to enter terminal.', 0
f12_message db 'Press F12 for terminal', 0
error_dump_msg db 'Error Dump:', 0

config_buffer times 512 db 0  ; Buffer to hold the config.ini content

section .text
global start
extern terminal_loop

start:
    ; Set up the stack
    xor ax, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Clear interrupts
    cli

    ; Load the config.ini file from disk
    call load_config

    ; Parse the config.ini file
    call parse_config

    ; Check if show_message is true
    cmp byte [show_message], 1
    jne skip_message
    ; Print boot message
    mov si, boot_msg
    call print_string
skip_message:

    ; Halt the CPU
    hlt

; Load the config.ini file from disk
load_config:
    mov bx, config_buffer
    mov dh, 0
    mov dl, 0x80
    mov ch, 0
    mov cl, 2
    mov ah, 0x02
    mov al, 1
    int 0x13
    jc disk_read_error
    ret

disk_read_error:
    ; Handle disk read error (simplified example)
    hlt

; Parse the config.ini file
parse_config:
    mov si, config_buffer
    call find_show_message
    ret

; Find the show_message setting in the config.ini file
find_show_message:
    mov di, show_message_str
    call find_string
    cmp byte [si], '='
    jne not_found
    inc si
    cmp byte [si], 't'
    jne not_true
    mov byte [show_message], 1
    ret
not_true:
    mov byte [show_message], 0
    ret
not_found:
    mov byte [show_message], 0
    ret

; Find a string in the config.ini file
find_string:
    push si
    push di
next_char:
    lodsb
    cmp al, 0
    je not_found
    cmp al, [di]
    jne next_char
    inc di
    cmp byte [di], 0
    je found
    jmp next_char
found:
    pop di
    pop si
    ret

show_message_str db 'show_message', 0
show_message db 0

; Print string
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

times 510-($-$$) db 0   ; Fill boot sector up to 510 bytes
dw 0xAA55               ; Boot sector signature
