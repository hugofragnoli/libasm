; proto void ft_list_sort(t_list **begin_list, int (*cmp)())
; The function pointed to by cmp will be used as: *cmp)(list_ptr->data, list_other_ptr->data)

global _ft_list_sort

_ft_list_sort:




;Pour swap :
; RDI = pointeur A, RSI = pointeur B
mov rax, [rdi]    ; Charger valeur A dans RAX (temporaire)
mov rdx, [rsi]    ; Charger valeur B dans RDX
mov [rdi], rdx    ; Mettre valeur B à l'adresse A
mov [rsi], rax    ; Mettre valeur A (stockée dans RAX) à l'adresse B