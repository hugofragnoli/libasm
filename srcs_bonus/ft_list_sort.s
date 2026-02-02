; proto void ft_list_sort(t_list **begin_list, int (*cmp)())
; The function pointed to by cmp will be used as: *cmp)(list_ptr->data, list_other_ptr->data)

global _ft_list_sort

_ft_list_sort:
    ; TEST NULL
    test rdi, rdi       ; Check si pointeur **begin list est NULL.
    jz .empty             ; si oui on leave / ret rien car rax est NULL ? 

    ; Preparation des registres (push) pour stocker nos variables / fcts.
    push rbp        ; Crée le cadre de pile
    mov rbp, rsp    ;
    push rbx        ; Utilisé pour le noeud actuel
    push r12        ; Utilisé pour la tête de liste
    push r13        ; Utilisé pour l'adresse de la fonction cmp
    push r14        ; Utilisé comme flag de swap

    ; INIT 
    mov r12, rdi    ; r_12 = *begin_list (adresse du 1er noeud ici)
    test r12, r12   ;
    jz .clean       ;

    mov r13, rsi    ; On met ladresse de cmp dans r13 pour call plus tard. (pour cmp et swap si > 0)
    mov rdi, [rdi + 8];
    mov r14, rdi    ;
    test r14, r14   ;
    jz.clean        ;

.clean:
    pop r14         ; On clean dans lordre dinverse pour respecter lordre de la pile -> LIFO
    pop r13         ;
    pop r12         ;
    pop rbx         ;
    pop rbp         ;

.empty:
    ret

;Pour swap :
; RDI = pointeur A, RSI = pointeur B
;mov rax, [rdi]    ; Charger valeur A dans RAX (temporaire)
;mov rdx, [rsi]    ; Charger valeur B dans RDX
;mov [rdi], rdx    ; Mettre valeur B à l'adresse A
;mov [rsi], rax    ; Mettre valeur A (stockée dans RAX) à l'adresse B 

;jle -> pour cmp if less or equal on swap pas.
