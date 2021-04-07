%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov eax, 8
    mov ebx, 0
    mov edx, 1
    sub eax, 1
 
cont:
    sub eax, 1
    cmp eax, 0
    jge  calc
    jl print            ; vrem sa aflam al N-lea numar; N = 7
    ret
    
calc:
   xchg ebx, edx
   add edx, ebx
   jmp cont
   
print:
    PRINT_DEC 4, ebx
    ret