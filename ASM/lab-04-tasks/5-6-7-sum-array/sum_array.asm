%include "io.inc"

%define ARRAY_SIZE    10

section .data
    byte_array db 8, 19, 12, 3, 6, 200, 128, 19, 78, 102
    word_array dw 1893, 9773, 892, 891, 3921, 8929, 7299, 720, 2590, 28891
    dword_array dd 1392, 12544, 7992, 6992, 7202, 271887, 28789, 17897, 12988, 17992
    print_format db "Array sum is ", 0

section .text
global CMAIN
CMAIN:
    push ebp
    mov ebp, esp

    mov ecx, ARRAY_SIZE     ; Use ecx as loop counter.
    xor eax, eax            ; Use eax to store the sum.
    xor edx, edx            ; Store current value in dl; zero entire edx.
    xor ebx, ebx

add_byte_array_element:
    mov dl, byte [byte_array + ecx - 1]
    add eax, edx
    loop add_byte_array_element ; Decrement ecx, if not zero, add another element.

    PRINT_STRING print_format
    PRINT_UDEC 4, eax
    NEWLINE
    
    mov ecx, ARRAY_SIZE
    xor eax,eax
    xor edx,edx

add_word_array_element:

    mov dx, word[word_array + 2 * ecx - 2]
    add eax, edx
    loop add_word_array_element
    
    PRINT_STRING print_format
    PRINT_UDEC 4, eax
    NEWLINE
    
    mov ecx, ARRAY_SIZE
    xor eax,eax
    xor edx,edx
    
add_double_word_array_element:
    mov edx, dword[dword_array + 4 * ecx - 4]
    mov eax, edx
    mul edx
    
    add ebx, eax
    add ebx, edx
    loop add_double_word_array_element
    
    PRINT_STRING print_format
    PRINT_UDEC 4, ebx
    NEWLINE

    leave
    ret
