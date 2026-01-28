#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>


// Prototypes de tes fonctions en assembleur
extern size_t	ft_strlen(const char *s);
extern char		*ft_strcpy(char *dest, const char *src);
extern int		ft_strcmp(const char *s1, const char *s2);
extern char		*ft_strdup(const char *s);
extern ssize_t ft_write(int fd, const void *buf, size_t count);

int main(void)
{
	printf("=== TEST FT_STRLEN ===\n");
	char *str_len = "Hello Worldgfdghdfhygdfhfghjfghfgfghfhfghfghfghfghfghgfhfghfghfghfgghfghfghfghfghfghfghfgghfghgfhfghfgghfgghfghfghgfhfghfghfghfghfghfghfghfghfghfghfghfghfghfghfghfghfghfghfghfghfghfghfghfghfghfghgfhfghghfghfghfghfghfghfgghfghfghfghfghfghfghgfhgfhfghfghfghfghfghfghfghfghfghfghfghfghfghghfghghfghfghfghfghfghfghfghfghfghfghfghfg";
    char *str_empty = "";
	printf("Libc: %zu | FT: %zu\n\n", strlen(str_len), ft_strlen(str_len));
    printf("Libc: %zu\n", strlen(str_empty));
    printf("FT: %zu\n\n", ft_strlen(str_empty));

	printf("=== TEST FT_STRCPY ===\n");
	char dest[150];
	char dest2[150];
	char *src = "Copie-moi dfgdfgdfgdfgdfgdfgddsfdsfdsfsdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfgdfgdfgdfgdfgdf!";  
	char *src1 = "";
	ft_strcpy(dest, src);
	printf("Src: %s | Dest: %s\n", src, dest);
	ft_strcpy(dest2, src1);
	printf("Src1: %s | Dest2: %s\n\n", src1, dest2);

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

	 printf("TEST ft_write : \n\n");
	 ft_write(1, "Test stdout\n", 12);
	ft_write(1, "mauvaise len en param (trop grande)\n", 120); // print de la memoire
	 ft_write(1, "mauvaise len en param (trop petite)\n", 12); // truncate a 12
	//  printf("TEST STRINGS VIDES ET NULL\n\n");
	//  ft_write(1, NULL, 0); // crash pas 
	//  ft_write(1,"h\n", 2);
	//  ft_write(1, "", 0); //crash pas
	//  ft_write(1, NULL, 1000); // print pas de memoire
	//  ft_write(1,"i\n", 2);
	//  ft_write(1, "", 1000); // print  de la memoire
	//  ft_write(1,"3\n", 2);

	 errno = 0;
	 ssize_t ret = ft_write(-42, "test", 4);
	 if (ret == -1)
     	printf("Succès : write a capturé l'erreur. Errno = %d\n", errno);


	 printf("TEST WRITE LIBC: \n\n");
	 write(1, "Test stdout\n", 12);
	 write(1, "mauvaise len en param (trop grande)\n", 120); // print de la memoire
	 write(1, "mauvaise len en param (trop petite)\n", 12); // truncate a 12
	// printf("TEST STRINGS VIDES ET NULL\n\n");
	// write(1, NULL, 0); // crash pas 
	// write(1,"H\n", 2);
	// write(1, "", 0); //crash pas
	// write(1,"HH\n", 3);
	// write(1, NULL, 1000); // print pas de memoire
	// write(1,"I\n", 2);
	// write(1, "", 1000); // print  de la memoire
	// write(1,"J\n", 2);

	 errno = 0;
	 ssize_t ret1 = write(-42, "test", 4);
	 if (ret1 == -1)
     	printf("Succès : write a capturé l'erreur. Errno = %d\n", errno);

	printf("TEST FT_READ :\n\n");

	int fd = open("test.txt", O_RDONLY);
	if (fd == -1)
	{
		printf("Failed to open\n");
		return 0;
	}
	char buffer[1024];
	ssize_t len_test = read(fd, buffer, 1023);
	buffer[len_test] = '\0';
	printf("contenu du fd : %s\n", buffer);
	printf("len_test = %zd\n\n", len_test);
	close(fd);

	printf("TEST READ LIBC :\n\n");

	int fd1 = open("test.txt", O_RDONLY);
	if (fd1 == -1)
	{
	 	printf("Failed to open\n");
	 	return 0;
	}
	char buffer1[1024];
	ssize_t len_test1 = read(fd1, buffer1, 1023);
	buffer1[len_test1] = '\0';
	printf("contenu du fd : %s\n", buffer1);
	printf("len_test = %zd\n", len_test1);
	close(fd1);
	
	return (0);
}