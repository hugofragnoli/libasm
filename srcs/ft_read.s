; Détection du format pour adapter les symboles et syscalls
%ifidn __OUTPUT_FORMAT__, elf64
    %define FT_READ ft_read
    %define SYSCALL_READ 0        ; ID Read sur Linux
    %define ERRNO_FUNC __errno_location
%else
    %define FT_READ _ft_read
    %define SYSCALL_READ 0x02000003 ; ID Read sur macOS
    %define ERRNO_FUNC ___error
%endif

extern ERRNO_FUNC
global FT_READ

FT_READ:
    mov rax, SYSCALL_READ
    syscall
    
    ; --- GESTION ERREUR ---
    %ifidn __OUTPUT_FORMAT__, elf64
        cmp rax, 0          ; Linux : erreur si RAX < 0
        jl .error_linux
    %else
        jc .error_mac       ; Mac : erreur si Carry Flag (CF) est à 1
    %endif
    ret

.error_linux:
    neg rax                 ; Linux renvoie -code_erreur, on le repasse en positif
    push rax
    jmp .set_errno

.error_mac:
    push rax                ; Mac met déjà le code positif dans RAX

.set_errno:
    sub rsp, 8              ; Aligner la pile à 16 octets avant le call
    call ERRNO_FUNC         ; RAX = &errno
    add rsp, 8
    pop r8                  ; Récupère le code d'erreur
    mov [rax], r8           ; *errno = code
    mov rax, -1             ; Retourne -1 comme spécifié par man read
    ret