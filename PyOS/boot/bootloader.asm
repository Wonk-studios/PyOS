BITS 16
ORG 0x7C00

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

    ; Switch to protected mode
    call enter_protected_mode
    jc pm_error

    ; Load the kernel
    call load_kernel
    jc disk_read_error

    ; Jump to the kernel entry point
    jmp 0x1000:0x0000

a20_error:
    call handle_error
    push a20_error_msg
    call print_error_msg
    hlt

pm_error:
    call handle_error
    push pm_error_msg
    call print_error_msg
    hlt

disk_read_error:
    call handle_error
    push disk_read_error_msg
    call print_error_msg
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

; Error messages
a20_error_msg db 'Error VH14: A20 LINE FAILED TO EXECUTE. HALT.', 0
pm_error_msg db 'Error VH53: PROTECTED MODE FAILED TO EXECUTE. HALT.', 0
disk_read_error_msg db 'Error VH01: DISK READ ERROR. STOP.', 0

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

; VGA text mode constants
VGA_TEXT_MODE_ADDRESS equ 0xB8000
VGA_WIDTH equ 80
VGA_HEIGHT equ 25
VGA_RED_BACKGROUND equ 0x4F  ; Red background, white text

; Function to set the screen background color to red
set_screen_red:
    mov di, VGA_TEXT_MODE_ADDRESS
    mov cx, VGA_WIDTH * VGA_HEIGHT
    mov al, ' '  ; Space character
    mov ah, VGA_RED_BACKGROUND
    rep stosw
    ret

; Function to print an error message
print_error_msg:
    pusha
    mov si, [esp + 36]  ; Get the error message pointer from the stack
    mov di, VGA_TEXT_MODE_ADDRESS
    mov ah, VGA_RED_BACKGROUND
.print_loop:
    lodsb
    cmp al, 0
    je .done
    stosw
    jmp .print_loop
.done:
    popa
    ret

; Function to handle errors
handle_error:
    call set_screen_red
    ret