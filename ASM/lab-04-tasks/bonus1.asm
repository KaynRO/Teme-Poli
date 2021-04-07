%include "io.inc"

%define ARRAY_SIZE    11

section .data
    byte_array dd 8, -19, 12, 3, 6, -120, 128, -19, 78, 102
    print_format_positive db "Array number of positive number ", 0
    print_format_negative db "Array number of negative number ", 0


section .text
global CMAIN
CMAIN:
    push ebp
    mov ebp, esp

    mov ecx, ARRAY_SIZE     ; Use ecx as loop counter.
    xor edx, edx            ; Store current value in dl; zero entire edx.
    xor eax, eax
    xor ebx, ebx
    
iterate:
    dec ecx
    cmp ecx, 1
    jl print ;If out of bounds
    
    mov edx, dword[byte_array + 4 * ecx - 4] ; Copy the number
    cmp edx, 0 ; Compare it with 0 and do the apropriate incrementations
    jge higher
    cmp edx, 0
    jl lower
    
print:
    PRINT_STRING print_format_positive
    PRINT_DEC 4, eax
    NEWLINE
    PRINT_STRING print_format_negative
    PRINT_DEC 4, ebx
    
    leave
    ret
    
higher:
    inc eax
    jmp iterate
    
lower:
    inc ebx
    jmp iterate
    