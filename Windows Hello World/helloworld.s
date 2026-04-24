DEFAULT rel
GLOBAL  main

EXTERN  GetStdHandle
EXTERN  WriteConsoleA
EXTERN  MessageBoxA
EXTERN  ExitProcess

SECTION .data
    msg            db "Hello World!", 0
    msg_len        equ $ - msg
    written        dd 0          ; receives DWORD chars written (4 bytes is enough)

SECTION .text
main:
    ; Prologue:  shadow space (32) + align-fix after push (8) = 40 bytes total
    PUSH rbp
    MOV  rbp, rsp
    SUB  rsp, 40                 ; now calls are 16-byte aligned and shadow is ready

    ; HANDLE h = GetStdHandle(STD_OUTPUT_HANDLE);
    MOV  ecx, -11
    CALL GetStdHandle            ; RAX = handle

    ; BOOL WriteConsoleA(h, msg, msg_len, &written, NULL);
    ; Arg1..Arg4 in RCX,RDX,R8,R9;  5th arg at [rsp+32]
    MOV  rcx, rax                ; hConsoleOutput (arg1)
    LEA  rdx, [msg]              ; lpBuffer       (arg2)
    MOV  r8d, msg_len            ; nCharsToWrite  (arg3) (DWORD)
    LEA  r9,  [written]          ; lpCharsWritten (arg4)
    MOV  QWORD [rsp+32], 0       ; lpReserved     (arg5) on stack
    CALL WriteConsoleA

    ; ExitProcess(0); (does not return)
    ADD  rsp, 40 ; epilogue
    POP  rbp
    XOR  ecx, ecx
    CALL ExitProcess