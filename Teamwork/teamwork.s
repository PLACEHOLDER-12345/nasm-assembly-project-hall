; teamwork.s
DEFAULT REL

GLOBAL print_str

EXTERN printf

SECTION .text

print_str:
    push rbp
    mov  rbp, rsp
    sub  rsp, 32           ; shadow space

    ; RCX already contains the string from C
    ; printf needs a format string in RCX
    mov  rdx, rcx          ; 2nd arg = string
    lea  rcx, [rel fmt]    ; 1st arg = "%s\n"
    call printf

    add  rsp, 32
    pop  rbp
    ret

SECTION .rdata
fmt db "%s", 10, 0