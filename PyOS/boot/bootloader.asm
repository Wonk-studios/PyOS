[BITS 16]
[ORG 0x7C00]

start:
    mov ax, 0x07C0
    add ax, 288
    mov ss, ax
    mov sp, 4096

    mov bp, 0x9000
    mov ds, bp
    mov es, bp

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

    ; Jump to the kernel
    jmp 0x1000:0000

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

times 510 - ($ - $$) db 0
dw 0xAA55
