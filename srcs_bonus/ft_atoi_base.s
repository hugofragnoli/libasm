section .text
    global _ft_atoi_base
    extern _ft_strlen

_ft_atoi_base:
    push rbp
    mov rbp, rsp

    ; 1. Verif NULL
    test rdi, rdi
    jz .error_return
    test rsi, rsi
    jz .error_return

.check_base:
    push rdi
    mov rdi, rsi        ; On check la base avec strlen
    call _ft_strlen
    pop rdi
    cmp rax, 2          ; Base doit être > 1
    jl .error_return
    mov r8, rax         ; on stocke base_len dans r8.

    ; 2. Verif validité base (Doublons/Interdits)
    xor rcx, rcx
.loop_base:
    movzx r9, byte [rsi + rcx]
    test r9, r9
    jz .init_vars
    ; Interdits: +, -, espaces, tabs
    cmp r9, '+'
    je .error_return
    cmp r9, '-'
    je .error_return
    cmp r9, 32
    jbe .error_return
    
    ; Check doublons
    mov rdx, rcx
    inc rdx
.loop_double:
    movzx r10, byte [rsi + rdx]
    test r10, r10
    jz .next_base
    cmp r9, r10
    je .error_return
    inc rdx
    jmp .loop_double
.next_base:
    inc rcx
    jmp .loop_base

.init_vars:
    xor rax, rax        ; res = 0
    mov r11, 1          ; r11 = multiplicateur de signe

.skip_spaces:
    movzx r9, byte [rdi]
    cmp r9, 32
    je .next_space
    cmp r9, 9
    jb .parse_sign
    cmp r9, 13
    ja .parse_sign
.next_space:
    inc rdi
    jmp .skip_spaces

.parse_sign:
    movzx r9, byte [rdi]
    cmp r9, '+'
    je .sign_plus
    cmp r9, '-'
    je .sign_minus        ; Utilise un saut explicite pour le moins
    jmp .convert_loop     ; Si c'est ni + ni -, on commence à convertir les chiffres

.sign_minus:
    neg r11               ; Inverse le signe (1 -> -1, -1 -> 1)
.sign_plus:
    inc rdi
    jmp .parse_sign       ; On reboucle pour attraper TOUS les signes consécutifs

.convert_loop:
    movzx r9, byte [rdi]
    test r9, r9
    jz .finish
    
    ; Trouver l'index de r9 dans base (rsi)
    xor rcx, rcx        ; index
.find_idx:
    movzx r10, byte [rsi + rcx]
    test r10, r10
    jz .finish          ; Caractère pas dans la base, on arrête
    cmp r9, r10
    je .apply_val
    inc rcx
    jmp .find_idx

.apply_val:
    imul rax, r8        ; res = res * base_len
    add rax, rcx        ; res = res + index
    inc rdi
    jmp .convert_loop

.finish:
    imul rax, r11       ; Appliquer le signe accumulé
    leave
    ret

.error_return:
    xor rax, rax
    leave
    ret