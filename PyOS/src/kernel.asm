section .data
gdt64:
    dq 0x0000000000000000  ; Null descriptor
    dq 0x00af9a000000ffff  ; 64-bit code segment
    dq 0x00af92000000ffff  ; 64-bit data segment

gdt64_end:

gdt64_ptr:
    dw gdt64_end - gdt64 - 1
    dd gdt64
    dq 0

; Error messages
kernel_msg db '...bootdevice/ROOT/PyOS/SRC/kernel.bin/...> ESC to enter terminal.', 0
kernel_error_msg db 'ERROR VH05 UNKNOWN KERNEL ERROR. MANUAL REBOOT REQUIRED. STOP.', 0
kernel_initialization_error_msg db 'Error VH21: KERNEL INITIALIZATION ERROR. MANUAL REBOOT REQUIRED. STOP.', 0
memory_allocation_error_msg db 'Error VH22: MEMORY ALLOCATION ERROR. MANUAL REBOOT REQUIRED. STOP.', 0
unknown_error_msg db 'ERROR STOP.', 0

section .bss
align 4096
pml4_table:
    resq 512

pdp_table:
    resq 512

pd_table:
    resq 512

section .text
global start
extern isr_keyboard_handler
extern terminal_loop

start:
    ; Set up the GDT
    lgdt [gdt64_ptr]

    ; Enable PAE
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; Enable Long Mode
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; Set up page tables
    ; Identity map the first 2MB of memory
    mov rax, pd_table
    or rax, 0x3
    mov [pdp_table], rax

    mov rax, pdp_table
    or rax, 0x3
    mov [pml4_table], rax

    mov rax, 0x0000000000000003
    mov [pd_table], rax

    ; Load the address of the PML4 table into CR3
    mov rax, pml4_table
    mov cr3, rax

    ; Enable paging
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ; Set up IDT for keyboard interrupt
    lidt [idt_ptr]

    ; Enable interrupts
    sti

    ; Jump to 64-bit code segment
    jmp 0x08:long_mode_entry

section .text64
bits 64
long_mode_entry:
    ; 64-bit code here
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Print a message to the screen
    call print_kernel_msg

    ; Halt the CPU
    hlt

print_kernel_msg:
    mov rsi, kernel_msg
    call print_string
    ret

print_string:
    mov rbx, 0xb8000  ; Video memory address
    mov rcx, -1       ; Max length
.next_char:
    lodsb             ; Load next byte from string
    test al, al       ; Check for null terminator
    jz .done
    mov [rbx], al     ; Write character to video memory
    inc rbx
    mov byte [rbx], 0x07  ; Attribute byte (white on black)
    inc rbx
    loop .next_char
.done:
    ret

error_handler:
    ; Set screen color to red
    call set_screen_color
    ; Display error message
    mov rsi, kernel_error_msg
    call print_string
    hlt

set_screen_color:
    ; VGA text buffer starts at 0xB8000
    mov rdi, 0xB8000
    ; Red background, white text: 0x4F
    mov al, 0x4F
    mov ecx, 2000  ; 80x25 screen, 2 bytes per character
.set_color_loop:
    mov [rdi], ax
    add rdi, 2
    loop .set_color_loop
    ret

; Keyboard interrupt handler
isr_keyboard_handler:
    pusha
    ; Read the scan code from the keyboard controller
    in al, 0x60
    cmp al, 0x01  ; ESC key scan code
    je enter_terminal
    popa
    iret

enter_terminal:
    call terminal_loop
    popa
    iret

; End of kernel
times 512 - ($ - $$) db 0  ; Fill remaining space to 512 bytes
