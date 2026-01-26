; filepath: /home/hfragnol/libasm/ft_strlen.s
bits 64

section .data
    msg db rdi  ; Ajoute un saut de ligne si tu veux

section .text
    global _start

_start:
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; file descriptor: stdout
    mov rsi, msg        ; adresse du message
    mov rdx, 5          ; longueur (4 lettres + \n)
    syscall

    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; code de retour 0
    syscall