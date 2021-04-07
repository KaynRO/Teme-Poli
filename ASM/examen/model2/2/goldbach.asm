%include "io.inc"

extern fgets
extern stdin
extern printf

section .data
    n            dd 7
    format_str   dd "Number: %d", 13, 10, 0
    prime_format dd "isPrime: %d", 13, 10, 0
    string  db "String is: %s", 0

section .text
global main

;TODO b: Implement stringToNumber
stringToNumber:
    push ebp
    mov ebp, esp
    
    mov edi, ebx
    xor ecx, ecx
    not ecx
    
    ;string length
    mov al, 0
    repne scasb
    not ecx
    sub ecx, 2
    
    xor edx, edx
    mov edi, ebx
  
repeat:
    xor eax, eax
    movzx eax, byte[edi]
    sub eax, '0' ; convert to int
    imul edx, 10
    add edx, eax
    inc edi
    dec ecx
    jnz repeat
    
    mov eax, edx
    leave
    ret

;TODO c.: Add missing code bits
isPrime:
    push ebp
    mov ebp, esp
    
    xor edx, edx ; first part of the divident
    mov eax, [ebp + 8] ; second part
    mov ecx, 2 ; divisor
    mov edi, eax
    dec edi
        
loop:
    div ecx
    cmp edx, 0
    je not_prime
    inc ecx
    mov eax, [ebp + 8] ; + 8 is the first argument
    xor edx, edx
    cmp ecx, edi    ; divide with all numbers < eax
    jle loop
    
    mov eax, 1
    jmp done
    
not_prime:
    xor eax, eax
    jmp done
    
done:
    leave
    ret

CMAIN:
    push ebp
    mov ebp, esp

    ;TODO a.: allocate space on stack and call fgets
    sub esp, 100
    lea ebx, [ebp - 100]
    
    push dword[stdin]
    push 100
    push ebx
    call fgets
    add esp, 12
   
    ;TODO b.: call stringToNumber and print it using printf

    push ebx
    call stringToNumber
    add esp, 4
    
    push eax
    push eax
    push format_str
    call printf
    add esp, 8
    pop eax
    NEWLINE
    
    ;TODO c.: call isPrime and print result

    push eax
    call isPrime
    add esp, 4
    
    push eax
    push prime_format
    call printf
    add esp, 8
    NEWLINE
    
    leave
    ret
