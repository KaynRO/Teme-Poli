%include "io.inc"

%define ARRAY_SIZE    11

section .data
    byte_array dd 8, 19, 12, 3, 6, 120, 128, 19, 78, 102
    print_format_odd db "Array number of odd number ", 0
    print_format_even db "Array number of even number ", 0


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
    
    mov edx, dword[byte_array + 4 * ecx - 4]
    test edx, 1
    jnz odd
    test edx, 1
    jz even
    
print:
    PRINT_STRING print_format_odd
    PRINT_DEC 4, eax
    NEWLINE
    PRINT_STRING print_format_even
    PRINT_DEC 4, ebx
    
    leave
    ret
    
odd:
    inc ebx
    jmp iterate
    
even:
    inc eax
    jmp iterate
    