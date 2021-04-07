%include "io.inc"

section .data
source_text: db "ABCABCBABCBABCBBBABABBCBABCBAAACCCB", 0
substring: db "BABC", 0

source_length: resd 1
substr_length: dd 4

print_format: db "Substring found at index: ", 0

section .text
global CMAIN
CMAIN:
    push ebp
    mov ebp, esp

    ; TODO: Fill source_length with the length of the source_text string.
    ; Find the length of the string using scasb.
    mov al, 0x0
    mov ecx, 100
    lea edi, [source_text]
    repne scasb
    
    mov ebx, 100
    sub ebx, ecx
    mov [source_length], ebx
    
    lea esi, [source_text]
    mov edx, [source_length]
    sub edx, [substr_length]
    
    jmp repeat
    
repeat:
    lea edi, [substring]
    mov ecx, [substr_length]
    cld
    repe cmpsb
    jz found

continue:   
    dec edx
    and edx,edx
    jnz repeat
    leave 
    ret

found:
    PRINT_STRING print_format
    sub edx, [substr_length]
    PRINT_UDEC 4, edx
    add edx, [substr_length]
    NEWLINE
    jmp continue
