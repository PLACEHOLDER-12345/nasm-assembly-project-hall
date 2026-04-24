; sleep

default rel
global main

extern ExitProcess
extern sleep
extern puts

SECTION .data
    msg db "I'm tired...", 0

SECTION .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 32 ; shadow space

    lea ecx, [msg] ; address
    call puts

    mov ecx, 5000 ; ms
    call sleep

    add rsp, 32
    pop rbp

    xor ecx, ecx
    call ExitProcess