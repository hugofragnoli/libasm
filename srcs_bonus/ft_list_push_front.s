; proto void ft_list_push_front(t_list **begin_list, void *data);

global _ft_list_push_front
extern _malloc

_ft_list_push_front:
    push rbp            ; push le sommet de la pile.
    mov rbp, rsp        ; on save son adresse a la base de la pile.
    push rbx            ; Pour sauver begin_list
    push r12            ; Pour sauver data
    
    mov rbx, rdi        ; rbx = begin_list
    mov r12, rsi        ; r12 = data

    ; Préparation du malloc
    mov rdi, 16         ; Taille d'une struct (2 pointeurs de 8 octets * data et *next !!)
    call _malloc        ; RAX contient maintenant l'adresse du nouveau noeud
    test rax, rax       ; Si malloc échoue
    jz .err
    mov [rax], r12      ; new_node->data = data
    mov r11, [rbx]      ; On récupère l'adresse de l'ancienne tête dans un registre temporaire
    mov [rax + 8], r11  ; new_node->next = ancienne_tête
    mov [rbx], rax      ; *begin_list = new_node

.err:                   ; On arrive ici si malloc echoue.
    pop r12                 ; on libere le registre 
    pop rbx                 ; on libere ici aussi.
    leave                  ; on libere rbp ici.
.ret:
    ret