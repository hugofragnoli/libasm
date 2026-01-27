#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

// Prototypes de tes fonctions en assembleur
extern size_t	ft_strlen(const char *s);
extern char		*ft_strcpy(char *dest, const char *src);
extern int		ft_strcmp(const char *s1, const char *s2);
extern char		*ft_strdup(const char *s);

int main(void)
{
	printf("=== TEST FT_STRLEN ===\n");
	char *str_len = "Hello World";
    //char *str_nul = NULL;
	printf("Libc: %zu | FT: %zu\n\n", strlen(str_len), ft_strlen(str_len));
   // printf("Libc: %zu\n", strlen(str_nul));
    //printf("FT: %zu\n\n", ft_strlen(str_nul));

	printf("=== TEST FT_STRCPY ===\n");
	char dest[20];
	char *src = "Copie-moi !";  
	ft_strcpy(dest, src);
	printf("Src: %s | Dest: %s\n\n", src, dest);

	printf("=== TEST FT_STRCMP ===\n");
	char *s1 = "Assembleur";
	char *s2 = "Assembl";
	char *s3 = "Assembzeur";
    //char *s4 = NULL;
	printf("Identiques : Libc: %d | FT: %d\n", strcmp(s1, s2), ft_strcmp(s1, s2));
	printf("Différents : Libc: %d | FT: %d\n\n", strcmp(s1, s3), ft_strcmp(s1, s3));
    //printf("NULL String : Libc: %d | FT: %d\n\n", strcmp(s1, s4), ft_strcmp(s1, s4));
    //printf("NULL String : Libc: %d\n", strcmp(s4, s1));

	printf("=== TEST FT_STRDUP ===\n");
	char *to_dup = "Je suis dupliqué sur la Heap";
	char *dup = ft_strdup(to_dup);
	if (dup)
	{
        printf("Original  : %s\n", to_dup);
        printf("Copie (FT): %s\n", dup);
        printf("------------------------------------------\n");
        printf("Preuve du contenu à l'adresse %p :\n", (void*)dup);
        printf("Valeur lue: %s\n", dup); 
        printf("------------------------------------------\n");
        printf("Vérification Adresses :\n");
        printf("  Origine (Stack/Data) : %p\n", (void*)to_dup);
        printf("  Copie   (Heap)       : %p\n", (void*)dup);
        
        free(dup); // Libération de la mémoire allouée par ton ft_strdup
    }
	else
		printf("Erreur d'allocation malloc.\n");

	printf("TEST WRITE LIBC: \n\n");
	write(1, "Test stdout\n", 12);
	write(1, "mauvaise len en param (trop petite)\n", 12); // truncate a 12
	write(1, "mauvaise len en param (trop grande)\n", 120); // print de la memoire
	printf("TEST STRINGS VIDES ET NULL\n\n");
	write(1, NULL, 0); // crash pas 
	write(1,"\n", 1);
	write(1, "", 0); //crash pas
	write(1, NULL, 1000); // print pas de memoire
	write(1,"\n", 1);
	write(1, "", 1000); // print  de la memoire
	write(1,"\n", 1);


	return (0);
}