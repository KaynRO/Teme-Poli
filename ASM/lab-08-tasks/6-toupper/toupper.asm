%include "io.inc"
extern printf

section .data
    before_format db "before %s", 13, 10, 0
    after_format db "after %s", 13, 10, 0
    mystring db "aBcdefghij2", 0

section .text
global CMAIN

toupper:
    push ebp
    mov ebp, esp

    mov eax, dword[ebp + 8]
    jmp upper

finish:
    leave
    ret
    
upper:
    mov bl, byte[eax]
    test bl,bl
    je finish
    
    cmp bl, 'a'
    jb continue
    cmp bl, 'z'
    ja continue
    
    sub byte[eax], 0x20
continue:
    inc eax
    jmp upper

CMAIN:
    push ebp
    mov ebp, esp

    push mystring
    push before_format
    call printf
    add esp, 8

    push mystring
    call toupper
    add esp, 4

    push mystring
    push after_format
    call printf
    add esp, 8

    leave
    ret
