; proto : void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *))
; The functions pointed to by cmp and free_fct will be used as: (*cmp)(list_ptr->data, data_ref);
;(*free_fct)(list_ptr->data);

global _ft_list_remove_if
extern _free

_ft_list_remove_if:
    test rdi, rdi           ; begin_list == NULL ?
    jz .ret                 ; return
    test rsi, rsi           ; data_ref == NULL ?
    jz .ret                 ;
    push rbp                ; push sur le sommet de la pile.
    mov rbp, rsp            ;
    push rbx                ; "current"
    push r12                ; "begin_list"
    push r13                ; "data_ref"
    push r14                ; "cmp"
    push r15                ; "free"

.keep_node:                 ; Pas dans le if donc on avance normalement.
    mov rbp, rbx            ; previous = current
    mov rbx, [rbx + 8]      ; current = current->next
    jmp .loop