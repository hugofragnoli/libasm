#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>

typedef struct s_list {
    void            *data;
    struct s_list   *next;
} t_list;

// Prototypes ASM
extern size_t  ft_strlen(const char *s);
extern char    *ft_strcpy(char *dest, const char *src);
extern int     ft_strcmp(const char *s1, const char *s2);
extern char    *ft_strdup(const char *s);
extern ssize_t ft_write(int fd, const void *buf, size_t count);
extern ssize_t ft_read(int fd, void *buf, size_t count);
extern int     ft_atoi_base(char *str, char *base);

// Prototypes Bonus
extern void    ft_list_push_front(t_list **begin_list, void *data);
extern void    ft_list_sort(t_list **begin_list, int (*cmp)());
extern void    ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));

// Utils
int  cmp_int(int *a, int *b) { return (*a - *b); }
void free_nothing(void *d) { (void)d; }

// ==========================================
// TEST : STRINGS (Limites)
// ==========================================
void test_strings_hard() {
    printf("\n🔥 [ TEST HARD: STRINGS ]\n");
    
    // Strlen sur chaine vide
    printf("Strlen empty: %zu\n", ft_strlen(""));
    
    // Strcmp avec des valeurs non-ASCII (unsigned char check)
    char s1[] = { (char)200, 0 };
    char s2[] = { (char)150, 0 };
    printf("Strcmp unsigned check: %d (FT: %d)\n", strcmp(s1, s2), ft_strcmp(s1, s2));

    // Strcpy : Source vide vers dest remplie
    char d[50] = "A ne pas voir";
    ft_strcpy(d, "");
    printf("Strcpy empty: '%s' (doit être vide)\n", d);
}

// ==========================================
// TEST : I/O & ERRNO (Le vrai stress)
// ==========================================
void test_io_hard() {
    printf("\n🔥 [ TEST HARD: I/O ]\n");

    // Write sur un FD fermé
    errno = 0;
    ssize_t r = ft_write(999, "test", 4);
    printf("Write FD 999: ret=%zd, errno=%d (%s)\n", r, errno, strerror(errno));

    // Read sur un dossier (doit mettre errno à EISDIR)
    errno = 0;
    r = ft_read(open(".", O_RDONLY), NULL, 10);
    printf("Read on directory: ret=%zd, errno=%d (%s)\n", r, errno, strerror(errno));
}

// ==========================================
// TEST : ATOI_BASE (Cas tordus)
// ==========================================
void test_atoi_hard() {
    printf("\n🔥 [ TEST HARD: ATOI_BASE ]\n");
    
    printf("Base avec espaces: %d (Attendu: 0)\n", ft_atoi_base("10", "01 "));
    printf("Base avec signes : %d (Attendu: 0)\n", ft_atoi_base("10", "01-"));
    printf("Base trop petite : %d (Attendu: 0)\n", ft_atoi_base("10", "0"));
    printf("Signes infinis   : %d\n", ft_atoi_base("  ---+++---42", "0123456789"));
    printf("Valeur hors base : %d (Attendu: 0)\n", ft_atoi_base("9", "01234567"));
}

// ==========================================
// TEST : LISTES 
// ==========================================
void test_list_hard() {
    printf("\n🔥 [ TEST HARD: LISTES ]\n");
    t_list *list = NULL;

    // Remove_if sur liste NULL
    printf("Remove_if sur NULL... ");
    ft_list_remove_if(NULL, "data", strcmp, free);
    printf("OK (pas de crash)\n");

    // Push front de 1000 éléments pour tester la stack
    printf("Stress test: Push 1000 nodes...\n");
    for (int i = 0; i < 1000; i++) {
        int *val = malloc(sizeof(int));
        *val = i;
        ft_list_push_front(&list, val);
    }
    printf("Push OK.\n");

    // Sort sur 1000 éléments
    printf("Sorting 1000 nodes...\n");
    ft_list_sort(&list, cmp_int);
    printf("Sort OK.\n");

    // Remove_if tout sauf le dernier
    printf("Removing nodes...\n");
    // On vide tout pour le test
    while (list) {
        t_list *tmp = list;
        list = list->next;
        free(tmp->data);
        free(tmp);
    }
    printf("List clean.\n");
}

int main() {
    test_strings_hard();
    test_io_hard();
    test_atoi_hard();
    test_list_hard();
    return 0;
}