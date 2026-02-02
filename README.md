libasm
Libasm est un projet du cursus 42 visant à se familiariser avec l'assembleur x86-64. L'objectif est de réimplémenter plusieurs fonctions de la bibliothèque standard C (libc) en manipulant directement les registres, la pile (stack) et les appels système (syscalls).

Pour compiler :
1 / Telecharger tout ce repertoire (actuellement directement compilable sur MAC OS ARM 64 (Apple Silicon)).
2/ dans un terminal, au root du repertoire faire make pour obtenir l'archve libasm.a
2 bis/ Si vous désirez tester les fonctions, un main.c est fourni et modifiable. Pour le compiler apres l'archive et obtenir l'éxecutable de test faire : Make test.
3/ run ./tester

4/ Pour tout supprimer : Make Fclean
5/ Pour recompiler : make re
5 bis/ Recompiler avec les test : make re test
Si vous voulez compiler ce projet sur architecture AMD 64 :
1/ il faudra modifier les noms des fonctions : _ft_strlen -> ft_strlen
2/ Modifier les appels pour check errno car le fonctionnement d'errno est different sur ARM 64.
3/ N'hesitez pas a me faire un retour s il y a autre chose !

Merci pour l'intéret porté au projet !!

Hugo
