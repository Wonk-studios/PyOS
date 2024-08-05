; kernel.asm
BITS 16
ORG 0x1000

start:
    ; Set up the segment registers
    mov ax, 0x1000
    mov ds, ax
    mov es, ax

    ; Print "PyOS 1.0"
    mov si, msg_hello
print_msg:
    lodsb
    or al, al
    jz halt
    mov ah, 0x0E
    int 0x10
    jmp print_msg
halt:
    hlt

msg_hello db 'PyOS 1.0', 0
