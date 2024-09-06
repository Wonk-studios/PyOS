section .data
log_file db "error_log.txt", 0

section .bss
log_fd resd 1

section .text
global init_logger, log_error

; Initialize the logger by opening the log file
init_logger:
    mov eax, 5          ; sys_open
    mov ebx, log_file   ; filename
    mov ecx, 2          ; O_WRONLY
    mov edx, 64         ; O_CREAT | O_APPEND
    int 0x80
    mov [log_fd], eax
    ret

; Log an error message
log_error:
    pusha
    mov eax, 4          ; sys_write
    mov ebx, [log_fd]   ; file descriptor
    mov ecx, [esp + 32] ; message
    mov edx, [esp + 36] ; message length
    int 0x80
    popa
    ret