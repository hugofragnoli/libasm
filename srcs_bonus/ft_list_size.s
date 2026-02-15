; proto int ft_list_size(t_list *begin_list);

global ft_list_size

ft_list_size:
    xor rax, rax            ; On init le compteur a 0.


.loop:
    test rdi, rdi           ; on test si rdi est NULL.
    jz .end                 ;                     *data -> 0 octet * next -> 8 octets
    inc rax                 ; Compteur + 1.
    mov rdi, [rdi + 8]      ; on met dans rdi offset + 8 pour aller sur lequiv du pointeur next de ta lst car adresse du pointeur de data = 0, deuxieme pointeur (next) = + 8.
    jmp .loop               ; Et cest repartiiiii

.end:
    ret                     ; ret -> rax. 