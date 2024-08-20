[BITS 16]
[ORG 0x7C00]

start:
    cli                     ; Disable interrupts
    xor ax, ax              ; Clear registers
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00          ; Set stack pointer

    ; Load GDT
    lgdt [gdt_descriptor]

    ; Enable A20 line (required for memory above 1MB)
    in al, 0x92
    or al, 00000010b
    out 0x92, al

    ; Enter protected mode
    mov eax, cr0
    or eax, 1               ; Set PE bit (bit 0) to enable protected mode
    mov cr0, eax

    jmp 0x08:protected_mode_start ; Far jump to protected mode