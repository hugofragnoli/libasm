# 📘 Aide-Mémoire Assembleur x86_64 (Libasm)

---

## 🏗️ Instructions de Flux et de Pile
*Gèrent la structure de la fonction et la sauvegarde des données temporaires.*

| Instruction | Action | Description / Effet |
| :--- | :--- | :--- |
| **`push`** | Empiler | Ajoute une valeur en haut de la pile (ex: `push rdi` pour sauvegarder l'adresse de la chaine avant un `call`). |
| **`pop`** | Dépiler | Retire la valeur au sommet de la pile et la remet dans un registre. |
| **`call`** | Appel | Appelle une fonction externe (ex: `_ft_strlen`). |
| **`leave`** | Quitter | Raccourci pour restaurer la pile (`mov rsp, rbp` puis `pop rbp`). Prépare la sortie. |
| **`ret`** | Retour | Sort de la fonction et reprend l'exécution. **Le résultat doit être dans `RAX`**. |

---

## 🔢 Instructions Arithmétiques et Logiques
*Manipulent les valeurs et les registres.*

- **`mov`** : Copie une valeur d'un endroit à un autre. `mov r8, rax` duplique la donnée.
- **`movzx`** (Move with Zero Extend) : Copie un petit élément (ex: 8-bit `char`) dans un grand registre (64-bit) en remplissant le reste de zéros. *Indispensable pour nettoyer les registres avant calcul.*
- **`xor`** : Opération logique. `xor rax, rax` est la méthode la plus rapide pour mettre un registre à **zéro**.
- **`inc`** : Incrémente de 1 (équivalent à `i++`).
- **`imul`** : Multiplication signée. Multiplie le registre par la valeur donnée. *Opération plus lente qu'une addition.*
- **`neg`** : Transforme un nombre positif en négatif (complément à deux). Utilisé pour gérer le signe `-`.

---

## ⚖️ Instructions de Test et de Comparaison
*Modifient les drapeaux (flags) du processeur pour les branchements.*

- **`cmp A, B`** : Compare A et B en effectuant une soustraction virtuelle `(A - B)`.
    - Si `A == 10` et `B == 9`, le résultat est positif -> A est plus grand.
- **`test A, A`** : Compare une valeur à elle-même. Si le registre est à 0, le drapeau **ZERO FLAG** s'active. *Utilisé pour vérifier les pointeurs **NULL**.*

---

## 🔀 Les Sauts (Jumps)
*Permettent de créer des boucles et des conditions (if/else).*

| Saut | Nom | Condition |
| :--- | :--- | :--- |
| **`jmp`** | Jump | Saute toujours (sans condition). |
| **`jz`** / **`je`** | Zero / Equal | Saute si le résultat précédent est 0 ou si `A == B`. |
| **`jne`** | Not Equal | Saute si les deux valeurs sont différentes. |
| **`jl`** | Less | Saute si `A < B` (signé). |
| **`jg`** | Greater | Saute si `A > B` (signé). |
| **`jbe`** | Below or Equal | Saute si `A <= B` (non-signé). |
| **`ja`** | Above | Saute si `A > B` (non-signé). Utilisé pour détecter les **overflows**. |

---

## 🗄️ Les Registres (Convention x86_64)

### 📥 Arguments d'entrée
- **`RDI`** : 1er argument de la fonction.
- **`RSI`** : 2ème argument de la fonction.

### 🛠️ Registres de travail (Scratch)
- **`RAX`** : Registre de retour (résultat final).
- **`RCX`** : Souvent utilisé comme compteur de boucles (`i`).
- **`RDX`** : Utilisé comme deuxième compteur (`j`).
- **`R8`**, **`R9`** : Stockage de valeurs temporaires.

### 📍 Gestion de la pile
- **`RBP`** : Pointe sur la base de la "stack frame" actuelle.
- **`RSP`** : Pointe sur le sommet de la pile (bouge à chaque `push`/`pop`).

