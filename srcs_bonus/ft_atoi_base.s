section .text
    global ft_atoi_base
    extern ft_strlen

ft_atoi_base:
    push rbp
    mov rbp, rsp

    ; --- 1. Vérification de la validité des pointeurs ---
    test rdi, rdi        ; Vérifie si la chaîne (str) est NULL
    jz .error_return     ; Si oui, retour 0
    test rsi, rsi        ; Vérifie si la base est NULL
    jz .error_return     ; Si oui, retour 0

.check_base:
    push rdi             ; Sauvegarde l'adresse de str car RDI va être modifié pour strlen
    mov rdi, rsi         ; RDI devient l'argument pour strlen(base)
    call ft_strlen      ; RAX contient maintenant la longueur de la base
    pop rdi              ; Restaure l'adresse de str dans RDI
    cmp rax, 2           ; La base doit faire au moins 2 caractères
    jl .error_return     ; Si len < 2, erreur
    mov r8, rax          ; R8 = Longueur de la base (pour les multiplications futures)

    ; --- 2. Vérification des caractères interdits et doublons dans la base ---
    xor rcx, rcx         ; RCX = compteur i = 0 (index principal)
.loop_base:
    movzx r9, byte [rsi + rcx] ; R9 = base[i]
    test r9, r9          ; Fin de la chaîne base ?
    jz .init_vars        ; Si oui, base valide, on passe à la suite
    
    ; Caractères interdits selon le sujet (signes et whitespaces)
    cmp r9, '+'
    je .error_return
    cmp r9, '-'
    je .error_return
    cmp r9, 32           ; ASCII 32 = espace
    jbe .error_return    ; Tout ce qui est <= 32 (tabs, espaces, \n...) est interdit
    
    ; Vérification des doublons : compare base[i] avec le reste de la chaîne
    mov rdx, rcx         ; On commence à comparer à partir de l'index i
    inc rdx              ; j = i + 1
.loop_double:
    movzx r10, byte [rsi + rdx] ; R10 = base[j]
    test r10, r10        ; Fin de la base ?
    jz .next_base        ; Si oui, pas de doublon pour ce caractère
    cmp r9, r10          ; base[i] == base[j] ?
    je .error_return     ; Si égal, doublon trouvé -> erreur
    inc rdx              ; j++
    jmp .loop_double
.next_base:
    inc rcx              ; i++
    jmp .loop_base

.init_vars:
    xor rax, rax         ; RAX = 0 (notre accumulateur de résultat)
    mov r11, 1           ; R11 = 1 (multiplicateur pour le signe final)

    ; --- 3. Sauter les espaces blancs au début de str ---
.skip_spaces:
    movzx r9, byte [rdi] ; R9 = str[current]
    cmp r9, 32           ; Espace ?
    je .next_space
    cmp r9, 9            ; Tabulation ? (\t)
    jb .parse_sign       ; Si < 9, pas un whitespace
    cmp r9, 13           ; \n, \v, \f, \r sont entre 9 et 13
    ja .parse_sign       ; Si > 13, pas un whitespace
.next_space:
    inc rdi              ; str++
    jmp .skip_spaces

    ; --- 4. Gestion des signes (+ et -) ---
.parse_sign:
    movzx r9, byte [rdi] ; Lire le caractère actuel
    cmp r9, '+'
    je .sign_plus
    cmp r9, '-'
    je .sign_minus       ; Sauter vers la gestion du moins
    jmp .convert_loop    ; Pas de signe ? On commence la conversion

.sign_minus:
    neg r11              ; R11 = -R11 (Inversion du signe à chaque '-')
.sign_plus:
    inc rdi              ; Passer au caractère suivant
    jmp .parse_sign      ; Autorise plusieurs signes d'affilée

    ; --- 5. Boucle principale de conversion ---
.convert_loop:
    movzx r9, byte [rdi] ; R9 = str[current]
    test r9, r9          ; Fin de str ?
    jz .finish
    
    ; Chercher si le caractère appartient à la base et trouver son index
    xor rcx, rcx         ; RCX = index dans la base = 0
.find_idx:
    movzx r10, byte [rsi + rcx] ; R10 = base[index]
    test r10, r10        ; Fin de la base atteinte ?
    jz .finish           ; Si oui, le caractère n'est pas dans la base -> fin
    cmp r9, r10          ; str[current] == base[index] ?
    je .apply_val        ; Trouvé ! On applique la valeur
    inc rcx              ; index++
    jmp .find_idx

.apply_val:
    ; Calcul du résultat intermédiaire
    imul rax, r8         ; res = res * base_len
    add rax, rcx         ; res = res + index_trouvé
    
    ; --- PROTECTION OVERFLOW ---
    ; On vérifie si la valeur absolue dépasse 2^31
    ; On utilise 2147483648 (INT_MAX + 1) car c'est la valeur absolue de INT_MIN
    cmp rax, 2147483648
    ja .error_return     ; Si RAX > 2147483648 -> Overflow définitif
    ; ---------------------------

    inc rdi              ; str++
    jmp .convert_loop

    ; --- 6. Finalisation et vérification des bornes de l'INT ---
.finish:
    imul rax, r11        ; Appliquer le multiplicateur de signe (1 ou -1)

    ; Cas où le nombre est positif (signe == 1)
    cmp r11, 1
    jne .check_min       ; Si négatif, on va vérifier la borne min
    cmp rax, 2147483647  ;
    jg .error_return     ;

.check_min:
    ; Cas où le nombre est négatif
    cmp rax, -2147483648 ; Comparer avec INT_MIN
    jl .error_return     ; Si RAX < -2147483648 -> Overflow

    leave                ; Nettoie la stack frame
    ret                  ; RAX contient le résultat final

.error_return:
    xor rax, rax         ; En cas d'erreur ou d'overflow, on retourne 0
    leave
    ret