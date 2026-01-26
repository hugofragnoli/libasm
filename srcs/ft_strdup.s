extern  _malloc
extern  _ft_strlen
extern  _ft_strcpy

global  _ft_strdup

_ft_strdup:
    push    rdi                 ; On save s1 car on en aura besoin pour strcpy. push rdi met ton adresse à l'abri et fait plaisir au processeur en alignant la mémoire. C'est une "pierre deux coups"..

    call    _ft_strlen           ; On strlen rdi. Le res est placé dans rax.

	inc		rax					; On met +1 pour le '\0'
	mov		rdi, rax			; On stocke la size qui est initialement dans rax vers rdi pour le passer a malloc car malloc attend son argument dans rdi.
	call	_malloc				; ON malloc la bonne size stockee dans rdi. Ici on renvoie un pointeur -> si succes rax contient ladresse du premier octet de la zone memoire quil a reserve sur la heap. Echec -> Malloc renvoie l adresse 0  (NULL en C).

	test	rax, rax			; On test si rax vaut 0. ?? Malloc met a jour errno lui meme en cas derreur
	jz		.error				; on saute a error qui va ret 0 (comportement strdup).

	mov		rdi, rax			; On prepare lappel a strcpy. La dest (rdi) doit etre la nouvelle memoire que malloc vient de nous donner(qui etait dans le rax).
	pop 	rsi					; On recup s1 original. On la met dans rsi car cest le deuxieme arg pour strcpy.
	call	_ft_strcpy			; On copie la chaine. 
	ret							; Strcpy renvoie ladresse de la dest dans rax. Cest ce que strdup doit renvoyer. Ici on ret rax comme dhab.


.error:
	add		rsp, 8				; On "oublie" la valeur sauvegardee sur la pile.
	ret							; On repart avec rax qui vaut 0.
