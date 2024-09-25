BITS 16
ORG 0x7C00

section .data
VGA_TEXT_MODE_ADDRESS equ 0xB8000
VGA_WHITE_ON_BLACK equ 0x0F00
VGA_RED_ON_BLACK equ 0x4F00

boot_msg db 'Bootloader loaded. Press ESC to enter terminal.', 0
f12_message db 'Press F12 for terminal', 0
error_dump_msg db 'Error Dump:', 0

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

    ; Load the GDT
    lgdt [gdt_descriptor]

    ; Enable A20 line
    call enable_a20
    jc a20_error

    ; Display "Press F12 for terminal" message
    call print_f12_message

    ; Wait for key press
    call wait_for_keypress

    ; Switch to protected mode
    call enter_protected_mode
    jc pm_error

    ; Load the kernel
    call load_kernel
    jc disk_read_error

    ; Jump to the kernel entry point
    jmp 0x1000:0x0000

a20_error:
    call dump_error
    hlt

pm_error:
    call dump_error
    hlt

disk_read_error:
    call dump_error
    hlt

; Enable A20 line
enable_a20:
    in al, 0x64
    test al, 2
    jnz enable_a20
    mov al, 0xD1
    out 0x64, al
    in al, 0x64
    test al, 2
    jnz enable_a20
    mov al, 0xDF
    out 0x60, al
    ret

; Enter protected mode
enter_protected_mode:
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x08:protected_mode_entry

protected_mode_entry:
    ; Set up segment registers
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x9000

    ; Jump to the kernel entry point
    jmp 0x1000:0x0000

; Load the kernel
load_kernel:
    mov bx, 0x1000
    mov dh, 0
    mov dl, 0x80
    mov ch, 0
    mov cl, 2
    mov ah, 0x02
    mov al, 1
    int 0x13
    jc disk_read_error
    ret

; Print "Press F12 for terminal" message
print_f12_message:
    mov si, f12_message
    call print_string
    ret

; Wait for key press
wait_for_keypress:
    in al, 0x60
    cmp al, 0x58  ; F12 key scan code
    je enter_terminal
    ret

enter_terminal:
    call load_terminal
    ret

; Load the terminal
load_terminal:
    ; Load the terminal code (assuming it's in the next sector)
    mov bx, 0x2000
    mov dh, 0
    mov dl, 0x80
    mov ch, 0
    mov cl, 3
    mov ah, 0x02
    mov al, 1
    int 0x13
    jc disk_read_error
    jmp 0x2000:0x0000

; Error dumping
dump_error:
    pusha
    mov si, error_dump_msg
    call print_string

    ; Dump all registers
    mov ax, [sp + 16]  ; AX
    call print_register
    mov ax, [sp + 14]  ; BX
    call print_register
    mov ax, [sp + 12]  ; CX
    call print_register
    mov ax, [sp + 10]  ; DX
    call print_register
    mov ax, [sp + 8]   ; SI
    call print_register
    mov ax, [sp + 6]   ; DI
    call print_register
    mov ax, [sp + 4]   ; BP
    call print_register
    mov ax, [sp + 2]   ; SP
    call print_register
    popa
    ret

print_register:
    ; Print AX register as a hexadecimal number
    pusha
    mov cx, 4
.print_hex_digit:
    rol ax, 4
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

; GDT descriptor and table
gdt_descriptor:
    dw gdt_end - gdt - 1    ; GDT size
    dd gdt                  ; GDT base address

gdt:
    ; Null descriptor
    dd 0x00000000
    dd 0x00000000

    ; Code segment descriptor
    dw 0xFFFF               ; Limit (low 16 bits)
    dw 0x0000               ; Base address (low 16 bits)
    db 0x00                 ; Base address (next 8 bits)
    db 10011010b            ; Access byte: Present, Ring 0, Code segment, Executable, Readable
    db 11001111b            ; Flags: 32-bit segment, 4KB granularity
    db 0x00                 ; Base address (high 8 bits)

    ; Data segment descriptor
    dw 0xFFFF               ; Limit (low 16 bits)
    dw 0x0000               ; Base address (low 16 bits)
    db 0x00                 ; Base address (next 8 bits)
    db 10010010b            ; Access byte: Present, Ring 0, Data segment, Writable
    db 11001111b            ; Flags: 32-bit segment, 4KB granularity
    db 0x00                 ; Base address (high 8 bits)

gdt_end:
    times 510-($-$$) db 0   ; Fill boot sector up to 510 bytes
    dw 0xAA55               ; Boot sector signature
