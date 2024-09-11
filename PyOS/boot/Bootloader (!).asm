[BITS 16]
[ORG 0x7C00]

;  THE REAL MODE BOOTLOADER IS NOT TO BE USED!

start:
    ; Set up stack and segment registers
    mov ax, 0x07C0
    add ax, 288
    mov ss, ax
    mov sp, 4096

    mov bp, 0x9000
    mov ds, bp
    mov es, bp

    ; Disable and then enable interrupts
    cli
    mov ax, 0x2400
    mov ds, ax
    mov es, ax
    sti

    ; Print loading message
    mov si, loading_msg
    call print_string

    ; Load kernel from the second sector
    mov ah, 0x02
    mov al, 0x01
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    mov dl, 0x80
    mov bx, 0x1000
    int 0x13

    ; Check for errors
    jc disk_read_error

    ; Verify the kernel loaded correctly (simple checksum or magic number check)
    mov ax, 0x1000
    mov bx, 0xAA55  ; Use bx for the magic number
    cmp word [ax], bx ;This seems to be a problematic line.
    jne invalid_kernel

    ; Jump to the kernel
    jmp 0x1000:0000

disk_read_error:
    mov si, disk_read_error_msg
    call print_string
    hlt

invalid_kernel:
    mov si, invalid_kernel_msg
    call print_string
    hlt

bios_interrupt_error:
    mov si, bios_interrupt_error_msg
    call print_string
    hlt

unknown_error:
    mov si, unknown_error_msg
    call print_string
    hlt

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

loading_msg db 'Loading PyOS...', 0
disk_read_error_msg db 'Error VH01: DISK READ ERROR. STOP.', 0
invalid_kernel_msg db 'Error VH52: INVALID KERNEL DETECTED. CANNOT LOAD. STOP.', 0
bios_interrupt_error_msg db 'Error VH03: BIOS INTERRUPT ERROR. STOP.', 0
unknown_error_msg db 'ERROR STOP.', 0

times 510 - ($ - $$) db 0
dw 0xAA55
