[BITS 16]
[org 0x7C00]

section .text
global _start

_start:
    ; Detect processor type
    call detect_processor

    ; Check if ARM processor
    cmp ax, 0x414D  ; 'AM' for ARM
    je boot_arm

    ; Check if x86 processor
    cmp ax, 0x5836  ; 'X6' for x86
    je boot_x86

    ; If unknown processor, halt
    hlt

detect_processor:
    ; Placeholder for processor detection logic
    ; This should set AX to 'AM' for ARM or 'X6' for x86
    ; For demonstration, we'll assume it's ARM
    mov ax, 0x414D  ; 'AM' for ARM
    ret

boot_arm:
    ; Load ARM bootloader
    mov bx, 0x0000  ; Segment address for ARM bootloader
    mov es, bx
    mov bx, 0x8000  ; Offset address for ARM bootloader
    mov ah, 0x02    ; BIOS read sector function
    mov al, 0x01    ; Number of sectors to read
    mov ch, 0x00    ; Cylinder number
    mov cl, 0x02    ; Sector number
    mov dh, 0x00    ; Head number
    mov dl, 0x80    ; Drive number (first hard disk)
    int 0x13        ; BIOS interrupt
    jmp 0x0000:0x8000  ; Jump to ARM bootloader

boot_x86:
    ; Load x86 bootloader
    mov bx, 0x0000  ; Segment address for x86 bootloader
    mov es, bx
    mov bx, 0x9000  ; Offset address for x86 bootloader
    mov ah, 0x02    ; BIOS read sector function
    mov al, 0x01    ; Number of sectors to read
    mov ch, 0x00    ; Cylinder number
    mov cl, 0x02    ; Sector number
    mov dh, 0x00    ; Head number
    mov dl, 0x80    ; Drive number (first hard disk)
    int 0x13        ; BIOS interrupt
    jmp 0x0000:0x9000  ; Jump to x86 bootloader

times 510-($-$$) db 0  ; Fill the rest of the boot sector with zeros
dw 0xAA55               ; Boot signature
