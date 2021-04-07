%include "io.inc"

section .text
global CMAIN
CMAIN:
    push ebp
    mov ebp, esp

    mov eax, 211    ; to be broken down into powers of 2
    mov ebx, 1      ; stores the current power
  
loop:  
    mov ecx, ebx
    and ecx, eax
    imul ebx, 2
    
    cmp ecx, 1
    jge print
    
continue:
    cmp ebx, eax
    jle loop
    leave
    ret

print:
    PRINT_UDEC 4, ecx
    NEWLINE
    jmp continue
    