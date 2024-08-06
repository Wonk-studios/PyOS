[BITS 16]
[ORG 0x1000]

start:
    ; Print kernel loaded message
    mov si, kernel_msg
    call print_string

    ; Halt the CPU
    hlt
    jmp $

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

kernel_msg db 'PyOS!', 0
