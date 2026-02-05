%ifidn __OUTPUT_FORMAT__, elf64
    %define FT_WRITE ft_write
    %define SYSCALL_WRITE 1
    %define ERRNO_FUNC __errno_location
%else
    %define FT_WRITE _ft_write
    %define SYSCALL_WRITE 0x02000004
    %define ERRNO_FUNC ___error
%endif

extern ERRNO_FUNC
global FT_WRITE

FT_WRITE:
    mov rax, SYSCALL_WRITE
    syscall
    
    ; --- GESTION ERREUR ---
    %ifidn __OUTPUT_FORMAT__, elf64
        cmp rax, 0          ; Sur Linux, erreur si RAX < 0
        jl .error_linux
    %else
        jc .error_mac       ; Sur Mac, erreur si Carry Flag est mis
    %endif
    ret

.error_linux:
    neg rax                 ; Linux renvoie -ERRNO, on le rend positif
    push rax
    jmp .set_errno

.error_mac:
    push rax                ; Mac met déjà le code positif dans RAX

.set_errno:
    sub rsp, 8              ; Alignement pile avant call
    call ERRNO_FUNC
    add rsp, 8
    pop r8
    mov [rax], r8
    mov rax, -1
    ret