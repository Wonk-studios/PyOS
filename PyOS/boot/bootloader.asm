; bootloader.asm
BITS 16
ORG 0x7C00

start:
    ; Set up the stack
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Print "Loading PyOS..."
    mov si, msg_loading
print_msg:
    lodsb
    or al, al
    jz done
    mov ah, 0x0E
    int 0x10
    jmp print_msg
done:

    ; Load the kernel
    mov bx, 0x1000   ; Load address
    mov dh, 0        ; Head
    mov dl, 0        ; Drive number (0 = first floppy)
    mov ch, 0        ; Track
    mov cl, 2        ; Sector
    mov ah, 0x02     ; Function: Read sectors
    mov al, 1        ; Number of sectors to read
    int 0x13

    ; Jump to kernel
    jmp 0x1000:0000

msg_loading db 'Loading PyOS...', 0

TIMES 510 - ($ - $$) db 0
DW 0xAA55
