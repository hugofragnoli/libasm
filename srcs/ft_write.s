extern  _ft_strlen


global  _ft_write

_ft_write:

    mov	edx,4		; message length
    mov	ecx,msg		; message to write
    mov	ebx,rdi		; file descriptor (stdout)
    mov	eax,4		; system call number (sys_write)
    int	0x80		; call kernel