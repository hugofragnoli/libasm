#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>

// --- STRUCTURE LISTE POUR LES BONUS ---
typedef struct s_list {
    void            *data;
    struct s_list   *next;
} t_list;

// --- PROTOTYPES DES FONCTIONS ASSEMBLEUR ---
extern size_t  ft_strlen(const char *s);
extern char    *ft_strcpy(char *dest, const char *src);
extern int     ft_strcmp(const char *s1, const char *s2);
extern char    *ft_strdup(const char *s);
extern ssize_t ft_write(int fd, const void *buf, size_t count);
extern ssize_t ft_read(int fd, void *buf, size_t count);
extern int     ft_atoi_base(char *str, char *base);

// --- PROTOTYPES DES BONUS ---
extern void    ft_list_push_front(t_list **begin_list, void *data);
extern void    ft_list_sort(t_list **begin_list, int (*cmp)());
extern void    ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));

// --- UTILS POUR LES TESTS ---
int     cmp_str(char *s1, char *s2) { return strcmp(s1, s2); }
void    free_node_data(void *data) { free(data); }

void    print_list(t_list *lst) {
    while (lst) {
        printf("[%s] -> ", lst->data ? (char *)lst->data : "NULL");
        lst = lst->next;
    }
    printf("NULL\n");
}

// ==========================================
// MODULE 1: STRINGS
// ==========================================
void test_strings() {
    printf("\n--- [ MODULE: STRINGS ] ---\n");
    
    // FT_STRLEN
    char *long_str = "Ceci est une chaine un peu longue pour tester le compteur.";
    printf("Strlen: Libc: %zu | FT: %zu\n", strlen(long_str), ft_strlen(long_str));
    printf("Strlen (vide): Libc: %zu | FT: %zu\n", strlen(""), ft_strlen(""));

    // FT_STRCPY
    char dest[100];
    ft_strcpy(dest, "Machine Code");
    printf("Strcpy: %s (Attendu: Machine Code)\n", dest);

    // FT_STRCMP
    printf("Strcmp (identiques): Libc: %d | FT: %d\n", strcmp("abc", "abc"), ft_strcmp("abc", "abc"));
    printf("Strcmp (diff): Libc: %d | FT: %d\n", strcmp("abc", "abd"), ft_strcmp("abc", "abd"));

    // FT_STRDUP
    char *d = ft_strdup("Memory allocation test");
    printf("Strdup: %s\n", d);
    free(d);
}

// ==========================================
// MODULE 2: SYSTEM CALLS (WRITE / READ)
// ==========================================
void test_sys_calls() {
    printf("\n--- [ MODULE: SYSTEM CALLS ] ---\n");

    // FT_WRITE
    printf("Write (stdout): ");
    ft_write(1, "OK\n", 3);
    
    errno = 0;
    ssize_t w_err = ft_write(-1, "err", 3);
    printf("Write (error -1): Ret: %zd | Errno: %d (%s)\n", w_err, errno, strerror(errno));

    // FT_READ
    char buf[50];
    int fd = open("test_read.txt", O_CREAT | O_RDWR, 0644);
    write(fd, "Lecture Assembleur", 18);
    lseek(fd, 0, SEEK_SET);
    
    ft_read(fd, buf, 18);
    buf[18] = '\0';
    printf("Read (file): %s\n", buf);
    close(fd);
    unlink("test_read.txt");
}

// ==========================================
// MODULE 3: ATOI_BASE
// ==========================================
void test_atoi_base() {
    printf("\n--- [ MODULE: ATOI_BASE ] ---\n");
    printf("Base 10: %d\n", ft_atoi_base("   ---+--42", "0123456789"));
    printf("Base 2 : %d\n", ft_atoi_base("101010", "01"));
    printf("Base 16: %d\n", ft_atoi_base("2a", "0123456789abcdef"));
    printf("Invalide (double char): %d\n", ft_atoi_base("42", "01223"));
}

// ==========================================
// MODULE 4: LIST BONUS
// ==========================================
void test_list_bonus() {
    printf("\n--- [ MODULE: LIST BONUS ] ---\n");
    t_list *list = NULL;

    printf("1. Push Front: 30, 20, 10\n");
    ft_list_push_front(&list, strdup("30"));
    ft_list_push_front(&list, strdup("20"));
    ft_list_push_front(&list, strdup("10"));
    print_list(list);

    printf("2. Sort (Alphabétique):\n");
    ft_list_sort(&list, cmp_str);
    print_list(list);

    printf("3. Remove If (data == '20'):\n");
    char *ref = "20";
    ft_list_remove_if(&list, ref, cmp_str, free_node_data);
    print_list(list);

    // Clean total
    while (list) {
        t_list *tmp = list;
        list = list->next;
        free(tmp->data);
        free(tmp);
    }
}

// ==========================================
// MAIN
// ==========================================
int main(void) {
    test_strings();
    test_sys_calls();
    test_atoi_base();
    test_list_bonus();

    printf("\n--- [ TESTS TERMINÉS ] ---\n");
    return (0);
}