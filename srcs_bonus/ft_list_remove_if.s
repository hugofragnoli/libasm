; proto : void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *))
; The functions pointed to by cmp and free_fct will be used as: (*cmp)(list_ptr->data, data_ref);
;(*free_fct)(list_ptr->data);

global ft_list_remove_if
extern free

ft_list_remove_if:
    test rdi, rdi           ; begin_list == NULL ?
    jz .empty                 ; return
    mov rax, [rdi]          ;
    test rax, rax           ;
    jz .empty               ;
    test rsi, rsi           ; data_ref == NULL ?
    jz .empty                 ;
    push rbp                ; push sur le sommet de la pile. + 8 -> ici on est a 16
    mov rbp, rsp            ;
    push rbx                ; "current" + 8
    push r12                ; "begin_list" + 8
    push r13                ; "data_ref" + 8
    push r14                ; "cmp" + 8
    push r15                ; "free" + 8
    push r9                 ; "previous" + 8 = 64 -> multiple de 16 donc ok pour alignement 

    ; ON ATTRIBUE LES VALEURS AUX REGISTRES INIT PRECEDEMMENT
    mov r12, rdi            ; **begin list
    mov r13, rsi            ; *data_ref
    mov r14, rdx            ; *cmp <- pointeur sur fonction
    mov r15, rcx            ; *free <- pointeur sur fonction
    xor r9, r9              ; init r9 a 0. (previous = NULL)
    mov rbx, [r12]          ; current = *begin_list;
 
 .loop:
    test rbx, rbx           ; current est il null ?
    jz .clean

    ; Comparaison
    mov rdi, [rbx]      ; arg1: current->data
    mov rsi, r13        ; arg2: data_ref
    call r14            ; call cmp()

    test eax, eax       ; On teste si 0 ! On utilise eax car le retour de cmp est un int (0 ou 1)-> 4 octets donc 32 bits donc eax 32 bitsc est parfait 
    jz .remove_node     ; si 0 on saute à la suppression
    jmp .keep_node      ; Sinon, on garde le nœud

.keep_node:                 ; Pas dans le if donc on avance normalement.
    mov r9, rbx            ; previous = current
    mov rbx, [rbx + 8]      ; current = current->next
    jmp .loop

.remove_node:
    mov r8, [rbx + 8]       ; registre volatile.

    test r9, r9             ; on teste previous ? 
    jz .is_first             ; si null cest qu on est sur la head.
    mov [r9 + 8], r8        ; previous->next = current ->next
    jmp .free               ;

.is_first:                    ;
    mov [r12], r8           ; *begin_list = current -> next

.free:
    ; On doit appeler free_fct(current->data) puis free(current)
    push r8             ; On sauve l'adresse du SUIVANT sur la pile (+8)
    sub rsp, 8          ; Alignement 16 octets (+8)
    
    mov rdi, [rbx]      ; rdi = current->data
    call r15            ; call free_fct(data)
    
    mov rdi, rbx        ; rdi = current (le nœud lui-même)
    call free          ; call free(node)
    
    add rsp, 8          ; On nettoie l'alignement
    pop rbx             ; On récupère le "suivant" directement dans rbx 
    jmp .loop           ; On repart au début de la boucle

.clean:
    pop r9             ;
    pop r15                 ;
    pop r14                 ;
    pop r13                 ;
    pop r12                 ;
    pop rbx                 ;
    leave                   ; libere rbp

.empty:
    ret