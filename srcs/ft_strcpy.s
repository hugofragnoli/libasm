global _ft_strcpy

_ft_strcpy:
    mov rax, rdi            ; On sauvegarde rdi (dest) dans rax pour le return final
    xor rcx, rcx            ; On utilise rcx comme index (compteur = 0)

.loop:
    mov dl, byte [rsi + rcx] ; 1. On lit un caractère de la source dans un registre temporaire (dl)
    mov byte [rdi + rcx], dl ; 2. On écrit ce caractère dans la destination
    
    cmp dl, 0                ; 3. Est-ce que c'était le caractère nul \0 ?
    je .done                 ; Si oui, on a fini
    
    inc rcx                  ; 4. Sinon, index suivant
    jmp .loop                ; 5. On recommence

.done:
    ret                      ; rax contient l'adresse de destination (rdi initial)