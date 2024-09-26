BITS 16
ORG 0x2000 ;this line has a parser issue (it's not a label)

section .data
VGA_TEXT_MODE_ADDRESS equ 0xB8000
VGA_WHITE_ON_BLACK equ 0x0F00
VGA_RED_ON_BLACK equ 0x4F00

terminal_prompt db '> ', 0
file_read_msg db 'Reading file...', 0
file_not_found_msg db 'File not found.', 0
unknown_cmd_msg db 'Unknown command.', 0

section .bss
buffer resb 128  ; Buffer for reading input
file_buffer resb 512  ; Buffer for reading file contents

section .text
global terminal_loop

terminal_loop:
    ; Print terminal prompt
    call print_prompt

    ; Read user input
    call read_input

    ; Execute command
    call execute_command

    ; Loop back to prompt
    jmp terminal_loop

print_prompt:
    mov si, terminal_prompt
    call print_string
    ret

read_input:
    ; Read a single character from the keyboard
    xor cx, cx
.read_loop:
    in al, 0x60
    test al, 0x80
    jnz .read_loop
    in al, 0x60
    cmp al, 0x1C  ; Enter key scan code
    je .done
    stosb
    jmp .read_loop
.done:
    stosb
    ret

execute_command:
    ; Compare the input with "read"
    mov si, buffer
    mov di, read_cmd
    call strcmp
    jz read_file

    ; Compare the input with "exit"
    mov si, buffer
    mov di, exit_cmd
    call strcmp
    jz exit_terminal

    ; Unknown command
    call print_unknown_cmd
    ret

read_file:
    ; Print reading file message
    mov si, file_read_msg
    call print_string

    ; Read the file from disk (assuming it's in the next sector)
    mov bx, file_buffer
    mov dh, 0
    mov dl, 0x80
    mov ch, 0
    mov cl, 4
    mov ah, 0x02
    mov al, 1
    int 0x13
    jc file_not_found

    ; Display the file contents
    mov si, file_buffer
    call print_string
    ret

file_not_found:
    mov si, file_not_found_msg
    call print_string
    ret

exit_terminal:
    ; Exit the terminal
    hlt
    ret

print_unknown_cmd:
    mov si, unknown_cmd_msg
    call print_string
    ret

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

strcmp:
    ; Compare two strings
    cld
.next_char:
    lodsb
    scasb
    jne .not_equal
    test al, al
    jnz .next_char
    xor ax, ax
    ret
.not_equal:
    mov ax, 1
    ret

read_cmd db 'read', 0
exit_cmd db 'exit', 0
