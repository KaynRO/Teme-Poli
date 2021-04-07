%include "io.inc"

section .data
    string db "Lorem ipsum dolor sit amet.", 0
    print_strlen db "strlen: ", 10, 0
    print_occ db "occurences of `i`:", 10, 0

    occurences dd 0
    length dd 0    
    char db 'i'
    aux db ''

section .text
global CMAIN
CMAIN:
    push ebp
    mov ebp, esp
    xor eax, eax
    xor ebx, ebx
    
    lea edi, [string]
    jmp compare
    
compare:
    inc eax
    mov dl, [edi + eax]
    cmp dl, 0x0
    je end1
    jmp compare
    
end1:
    mov [length], eax
    PRINT_STRING print_strlen
    PRINT_UDEC 4, [length]
    NEWLINE
    
    xor eax, eax
    lea edi, [string]
    jmp iterate
    
iterate:
    inc eax
    mov dl, [edi + eax]
    cmp dl, 0x0
    je end2
    mov cl, [char]
    cmp dl, cl
    je increment
    jmp iterate

increment:
    inc ebx
    jmp iterate

end2:
    mov [occurences], ebx
    PRINT_STRING print_occ
    PRINT_UDEC 4, [occurences]
    NEWLINE

    xor eax, eax
    leave
    ret
