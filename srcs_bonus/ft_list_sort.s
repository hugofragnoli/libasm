; proto void ft_list_sort(t_list **begin_list, int (*cmp)())

global ft_list_sort

ft_list_sort:
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
    mov rax, [rdi]  ; On regarde le premier noeud.
    test rax, rax   ;  On test s il est NULL
    jz .clean       ;

    mov r13, rsi    ; On met ladresse de cmp dans r13 pour call plus tard. (pour cmp et swap si > 0)

.loop_main:         ; Bubble sort / remet le flag swap a 0.
    xor r14, r14    ; On remet le flag du swap a 0 au debut de chaque tour de boucle.
    mov rbx, [r12]    ; rbx = tete de liste pour repartir du debut.

.loop_inner:
    mov rdx, [rbx + 8]  ; next = current->next
    test rdx, rdx       ; Fin de liste ?
    jz .check_swap

    ; 4. Appel de fonction
    push rdi            ; On sauve RDI (begin_list) avant le call
    mov rdi, [rbx]      ; arg1 = current->data
    mov rsi, [rdx]      ; arg2 = next->data
    call r13            ; Appel de cmp
    pop rdi             ; Restauration de RDI
    
    ; 5. Analyse et Swap
    cmp eax, 0          ; si inf ou egale a 0 on swap pas.
    jle .no_swap

    ; Swap              ; si sup on tombe ici
    mov r8, [rbx]       ; tmp = current->data
    mov r9, [rdx]       ; r9 = next->data
    mov [rbx], r9
    mov [rdx], r8
    mov r14, 1          ; swapped = 1 pour mettre le flag a jouuuur

.no_swap:
    mov rbx, [rbx + 8]  ; rbx = rbx->next
    jmp .loop_inner

.check_swap:
    cmp r14, 1          ; Est-ce qu'on a fait un swap ?
    je .loop_main       ; Si oui, on repart pour une passe complète (Bubble sort)

.clean:
    pop r14         ; On clean dans lordre dinverse pour respecter lordre de la pile -> LIFO
    pop r13         ;
    pop r12         ;
    pop rbx         ;
    leave               ; on force la sortie et on clean rbp et rsp avec "leave".

.empty:
    ret
