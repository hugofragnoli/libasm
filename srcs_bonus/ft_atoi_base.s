; proto : int       ft_atoi_base(char *str, char *base)

extern  _ft_strlen              ;
global  _ft_atoi_base           ;

._ft_atoi_base:
    push rbp                    ;
    mov rbp, rsp                ;
    xor rax, rax                ; init le res a 0
    valid_base, rdi             ;
    cmp rdi, 0                  ;

.valid_base:
    push rdi                    ; Save RDI car strlen va le modif
    mov rdi, rsi                ; On met la base dans rdi pour ft_strlen 
    call _ft_strlen             ; On appelle strlen
    pop rdi                     ; on libere la pile pour que rdi ne contienne plus ladresse de labase mais celle de str.
    
    cmp rax, 2                  ; on recupere notre pointeur vers str
    jl  .error_return           ; Si rax < 2, jump vers le retour direct.
    mov r8, rax                 ; on stocke la taille de la base dans r8 pour plus tard.

.skip_spaces:
    mov al, [rdi]       ; On charge le caractère actuel dans AL (8 bits)
    
    cmp al, 32          ; Espace ' '
    je .next_char
    cmp al, 9           ; Tabulation '\t'
    je .next_char
    cmp al, 10          ; Nouvelle ligne '\n'
    je .next_char
    cmp al, 11          ; Tabulation verticale '\v'
    je .next_char
    cmp al, 12          ; Form feed '\f'
    je .next_char
    cmp al, 13          ; Retour chariot '\r'
    je .next_char
    
    jmp .parse_sign     ; Si ce n'est pas un espace, on passe à la suite

.next_char:
    inc rdi             ; Caractère suivant
    jmp .skip_spaces    ; On recommence

