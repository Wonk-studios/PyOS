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
    lgdt [gdt_descriptor] ;This is the first thing NASM doesnt like.

    ; Enable A20 line (required for memory above 1MB)
    in al, 0x92
    or al, 00000010b
    out 0x92, al

    ; Check if A20 is enabled
    in al, 0x92
    test al, 00000010b
    jz a20_error            ; Jump if A20 line failed to enable

    ; Enter protected mode
    mov eax, cr0
    or eax, 1               ; Set PE bit (bit 0) to enable protected mode
    mov cr0, eax

    ; Verify protected mode enabled
    mov eax, cr0
    test eax, 1
    jz pm_error             ; Jump if protected mode failed to enable

    ; Far jump to protected mode
    jmp 0x08:protected_mode_start ;This seems to be the next issue NASM has compiling the files

a20_error:
    mov si, a20_error_msg   ; Display error message
    call print_string
    hlt                     ; Halt the system

pm_error:
    mov si, pm_error_msg    ; Display error message
    call print_string
    hlt                    ; Halt the system

disk_read_error:
    mov si, disk_read_error_msg
    call print_string
    hlt                     ; Halt the system

invalid_kernel:
    mov si, invalid_kernel_msg
    call print_string
    hlt                     ; Halt the system

bios_interrupt_error:
    mov si, bios_interrupt_error_msg
    call print_string
    hlt                     ; Halt the system

unknown_error:
    mov si, unknown_error_msg
    call print_string
    hlt                     ; Halt the system

; The following code starts after entering protected mode

[BITS 32]

protected_mode_start:
    ; Protected mode code starts here
    ; Initialize segment registers, etc.
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x9C00         ; Set stack pointer for protected mode

    ; Continue kernel execution...

    hlt                     ; Temporary halt after execution

; Print string function
print_string:
    mov ah, 0x0E
.repeat:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .repeat
.done:
    ret

; Error messages
loading_msg db 'cmd...' , 0
a20_error_msg db 'Error: A20 line failed to enable. HALT.', 0
pm_error_msg db 'Error: Protected mode failed to enable. HALT.', 0
disk_read_error_msg db 'Error VH01: DISK READ ERROR. STOP.', 0
invalid_kernel_msg db 'Error VH52: INVALID KERNEL DETECTED. CANNOT LOAD. STOP.', 0
bios_interrupt_error_msg db 'Error VH03: BIOS INTERRUPT ERROR. STOP.', 0
unknown_error_msg db 'ERROR STOP.', 0

; GDT descriptor and table
gdt_descriptor:
    dw gdt_end - gdt - 1    ; GDT size
    dd gdt                  ; GDT base address

gdt:
    ; Null descriptor
    dd 0x00000000
    dd 0x00000000

    ; Code segment descriptor
    dw 0xFFFF               ; Segment limit (low 16 bits)
    dw 0x0000               ; Base address (low 16 bits)
    db 0x00                 ; Base address (next 8 bits)
    db 10011010b            ; Access byte: Present, Ring 0, Code segment, Executable, Readable
    db 11001111b            ; Flags: 32-bit segment, 4KB granularity
    db 0x00                 ; Base address (high 8 bits)

    ; Data segment descriptor
    dw 0xFFFF               ; Segment limit (low 16 bits)
    dw 0x0000               ; Base address (low 16 bits)
    db 0x00                 ; Base address (next 8 bits)
    db 10010010b            ; Access byte: Present, Ring 0, Data segment, Writable
    db 11001111b            ; Flags: 32-bit segment, 4KB granularity
    db 0x00                 ; Base address (high 8 bits)

gdt_end:
    times 510-($-$$) db 0   ; Fill boot sector up to 510 bytes
    dw 0xAA55               ; Boot sector signature
