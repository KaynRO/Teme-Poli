%include "io.inc"

extern printf

%DEFINE LENGTH 20

section .data
    string db "Nunc tristique ante maximus, dictum nunc in, ultricies dui.", 0
    char db 'a'

section .text
global CMAIN
CMAIN:
    push ebp
    mov ebp, esp

    mov al, byte[char]    ; TODO: set al to the char to memset with;

    lea edi, [string]     ; TODO: set edi to point to the destination string

    mov ecx, LENGTH       ; TODO: set ecx to the number of times stosb will be performed

    rep stosb             ; TODO: use a stosb loop to store to string; use no more than 1 instruction
    
    PRINT_STRING string

    xor eax, eax
    leave
    ret
