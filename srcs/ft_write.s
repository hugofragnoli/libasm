extern ___error          ; 
global _ft_write         ;

_ft_write:
    mov rax, 0x02000004     ; Id de sys_write sur MACOS
    syscall                 ; Appel Kernel
    jc .error               ; Jump if "Carry" -> si le carry est a 1, ERREUR (specificite MAC -> sur linux si value negative cest ERREUR)
    ret                     ;

.error:
    push rax                ; On save ce code sur la pile (ce push aligne aussi la pile a 16 octets)

    call ___error           ; On appelle la fonction pour savoir ou estt errno -> maintenant rax contient errno.
    pop r8                  ; On recup le code derreur dans r8
    mov [rax], r8           ; On met la valeur de lerreur (r8) a l'adresse de rax.
    mov rax, -1             ; On ret -1 comme la doc de write.
    ret
