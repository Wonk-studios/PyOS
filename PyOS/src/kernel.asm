[BITS 32]

protected_mode_start:
    ; Set segment registers for protected mode
    mov ax, 0x10            ; Data segment selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x9C00         ; Set stack pointer

    ; Call the kernel's entry point
    call kernel_main

hang:
    hlt                     ; Halt CPU
    jmp hang

gdt_start:
    dd 0                    ; Null descriptor
    dd 0

    dd 0x0000FFFF           ; Code segment descriptor
    dd 0x00CF9A00

    dd 0x0000FFFF           ; Data segment descriptor
    dd 0x00CF9200

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start
gdt_end:

times 510 - ($ - $$) db 0
dw 0xAA55                   ; Boot signature