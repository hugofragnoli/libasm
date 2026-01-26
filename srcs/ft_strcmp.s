global  _ft_strcmp

_ft_strcmp:
    xor rax, rax                ; On nettoie rax (prêt pour movzx) xor permet des binaires plus legers. Mov devmande dencoder 0 de maniere explicite alors que xor  trvaille sur elle meme
    xor rdx, rdx                ; On nettoie rdx. Avec xor,, le processeur ne fait pas de calcul, Il comprend que le result sera 0 et reinit le registre au niveau materiel sans utiliser d unité de calcul.

.loop:
    mov al, byte [rdi]          ; On charge le caractère de s1 dans rax (partie basse 'al')
    mov dl, byte [rsi]          ; On charge le caractère de s2 dans rdx (partie basse 'dl')

    cmp al, 0                   ; Est-ce la fin de s1 ?
    je .done
    cmp al, dl                  ; Est-ce que les caractères sont différents ?
    jne .done

    inc rdi                     ; On avance le pointeur s1
    inc rsi                     ; On avance le pointeur s2
    jmp .loop                   ; On recommence

.done:
    movzx rax, al               ; On s'assure que le reste de rax est propre
    movzx rdx, dl               ; On s'assure que le reste de rdx est propre
    sub rax, rdx                ; Différence finale (s1[i] - s2[i])
    ret