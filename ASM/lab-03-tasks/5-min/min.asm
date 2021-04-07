%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;cele doua numere se gasesc in eax si ebx
    mov eax, 0
    mov ebx, 1 
    mov edx, eax
    cmp eax, ebx
    jg  swap
    
print:
    PRINT_DEC 4, eax ; afiseaza minimul
    NEWLINE
    ret
    
swap:
    xchg eax, ebx
    jmp print