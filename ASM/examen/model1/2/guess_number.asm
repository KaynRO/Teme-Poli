extern rand
extern time
extern srand
extern scanf
extern printf
extern puts


section .data
    uint_format    db "%zu", 0
    uint_format_newline    db "%zu", 10, 0
    msg    db "Insert number: ", 0
    scanf_format db "%d", 0
    int_number db "Number is %d", 10, 0
    is_smaller_string db "Numarul introdus este mai mic", 10, 0
    is_larger_string db "Numarul introdus este mai mare", 10, 0
    corect db "Corect", 10, 0


section .bss
    num resd 1

section .text

; TODO c: Create read_cmp() function.

read_cmp:
    push ebp
    mov ebp, esp
    
    sub esp, 4
    lea ebx, [ebp - 4]
    
    push ebx
    push scanf_format
    call scanf
    add esp, 8
    
    
    mov ebx, [ebp - 4]
    cmp ebx, [num]
    je ret1
    
ret0:
    cmp ebx, [num]
    jl less
    
    push is_larger_string
    call printf
    add esp, 4
    mov eax, 1
    jmp end

less:
    push is_smaller_string
    call printf
    add esp, 4
    mov eax, 1
    jmp end
       
ret1:
    push corect
    call printf
    add esp, 4
    xor eax, eax
    
end:
    leave
    ret
    


global main
main:
    push ebp
    mov ebp, esp 

    ; TODO a: Call srand(time(0)) and then rand() and store return value modulo 100 in num.
    
    push 0
    call time
    add esp, 4
    
    push eax
    call srand
    pop eax
  
    call rand
    
    xor edx, edx
    mov ecx, 100
    cdq
    idiv ecx
    
    mov [num], edx
    
    ; Debug only: Print value of num to check it was properly initialized.
    push dword [num]
    push uint_format_newline
    call printf
    add esp, 8

    ; Comment this out when doing TODO b. Uncomment it when doing TODO c and d.
   jmp make_call
    
    ; TODO b: Read numbers from keyboard in an infinite loop.

    mov ecx, 1  
    sub esp, 4
    
infinite_loop:

    push msg
    call printf
    add esp, 4
    
    lea ecx, [ebp - 4]
    push ecx
    push scanf_format
    call scanf
    add esp, 8
    
    mov ecx, [ebp - 4]
    push ecx
    push int_number
    call printf
    add esp, 8
       
    cmp ecx, -1
    jne infinite_loop


make_call:
    
    ; TODO d:
    call read_cmp
    cmp eax, 0
    jne make_call
    
    ; Return 0.
    xor eax, eax
    leave
    ret
