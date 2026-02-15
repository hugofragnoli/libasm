global ft_strlen

ft_strlen:
    mov rax, rdi            ; On sauvegarde l'adresse de départ(input) dans rax (valeur de retour)

.loop:
    cmp byte [rax], 0       ; On regarde directement là où pointe rax
    jz .done                ; Si c'est zéro, on a fini
    inc rax                 ; Sinon, on passe à l'adresse mémoire suivante
    jmp .loop

.done:
    sub rax, rdi            ; Résultat = (Adresse finale) - (Adresse de départ) Le prog va regarder ce quil y a dans rax et le retourner.
    ret