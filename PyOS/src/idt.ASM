section .data
align 16
idt:
    times 256 dq 0

idt_ptr:
    dw idt_end - idt - 1
    dd idt
    dq 0

idt_end:

section .text
global load_idt
load_idt:
    ; Load the IDT
    lidt [idt_ptr]
    ret

global isr_stub_table
isr_stub_table:
    times 256 dq 0

; Example ISR handler for interrupt 0 (divide by zero)
global isr0
isr0:
    cli
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push rbp
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15

    ; Handle the interrupt (print message, etc.)
    call isr0_handler

    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rbp
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    sti
    iretq

section .rodata
isr0_msg db 'Divide by zero error.', 0

section .text
global isr0_handler
isr0_handler:
    ; Print the error message
    mov rsi, isr0_msg
    call print_string
    hlt
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