; Proto %rax	System call	    %rdi	            %rsi	            %rdx
;          0	sys_read	    unsigned int fd	    char *buf	        size_t count

extern ___error
global _ft_read

_ft_read:
    mov rax, 0x2000003      ; Code de sys_read
    syscall                 ; Le Kernel remplit le buffer en RSI
    jc .error               ; Si carry flag = 1, erreur (code dans RAX)
    ret                     ; RAX contient déjà le nombre d'octets lus

.error:
    push rbp                ; Aligne la stack sur 16 octets et save lancienne valeeur de rbp sur la pile
    mov rbp, rsp            ; On annonce que le bas de notre nouvelle zone est lendroit actuel de la pile. Ca permet au debugueur de sy retrouver dans la hierarchie des appels.
    mov rdi, rax            ; Sauvegarde le code d'erreur
    call ___error           ; RAX = pointeur vers errno
    mov [rax], rdi          ; *errno = code_erreur
    mov rax, -1             ; Retourne -1
    pop rbp                 ; alignement de la pile. (16 octets).
    ret