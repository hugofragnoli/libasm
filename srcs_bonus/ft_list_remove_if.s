; proto : void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *))
; The functions pointed to by cmp and free_fct will be used as: (*cmp)(list_ptr->data, data_ref);
;(*free_fct)(list_ptr->data);