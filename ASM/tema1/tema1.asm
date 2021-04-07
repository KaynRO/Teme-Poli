%include "io.inc"

%define MAX_INPUT_SIZE 4096

section .data
        integer dd  1
        
section .bss
	expr: resb MAX_INPUT_SIZE
        nothing: resd 4 * MAX_INPUT_SIZE ; auxiliary vector to copy parts of the expression
        string: resd    100

section .text
global CMAIN
CMAIN:
        mov ebp, esp    ; for correct debugging
        push ebp
        mov ebp, esp    ; initiliase all registers with zero
        xor ebx, ebx
        xor eax, eax
        xor ecx, ecx
        xor edx, edx

	GET_STRING expr, MAX_INPUT_SIZE
        lea edi, [expr]
        lea esi, [expr]
        
length: ; find string length
        inc ecx
        mov dl, [edi + ecx]
        cmp dl, 0x0
        jne length
        
strtok:
        dec ecx
        mov edx, ecx
        cmp ecx, 0  ; if the length is not 0
        jle final

        mov al, ' ' ; we will split the string by a delimiter which in our case is a simple space
        cld
        repne scasb ; scan the expression until we find the first delimiter
        sub edx, ecx
        xchg edx, ecx ; calculate how many bytes the first part have
        dec ecx   
        xor edx, edx
                  
        lea edi, [nothing + 4 * ebx]    
        repnz movsb ; copy the bytes before delimiter in edi               
        inc esi
                   
        cmp dword[nothing + 4 * ebx], 0x2B  ; if +
        je evalPlus       
        cmp dword[nothing + 4 * ebx], 0x2D  ; if -
        je evalMinus                
        cmp dword[nothing + 4 * ebx], 0x2A  ; if *
        je evalMultiply       
        cmp dword[nothing + 4 * ebx], 0x2F  ; if /
        je evalDivide
        
        lea edx, [nothing + 4 * ebx]    ; we have the number as string, we have to convert it to int
        push ecx    ; save current values
        push eax
        xor ecx, ecx
        xor eax, eax

convString:
        movsx ecx, byte[edx]
        inc edx
        cmp ecx, '-'    ; if we have a negative number we skip the - sign
        je negate

        cmp ecx, '0'    ; else if it's a valid char we convert it to int
        jb pushNumber
        cmp ecx, '9'
        ja pushNumber
        sub ecx, '0'
        
convString2:
        imul eax, 10    ; build the number based on the digits, nr = nr * 10 + digit
        add eax, ecx
        jmp convString

negate:
        mov dword[integer], -1  ; just remind we deal with e negative number
        mov ecx, 0
        jmp convString2
            
pushNumber:
        xchg edx, eax   ; push the current number into the stack
        pop eax ; restore values from stack
        pop ecx
        
        imul edx, [integer] ; if we had a negative number then make it negative
        mov dword[integer], 1
        push edx
 
strtok1:
        cmp edi, esi    ; if infinite loop then end
        je final           
        mov edi, esi
        inc ebx
        xor ecx, ecx
        
        cmp dword[esi], 0x2B    ; if the last part of the expression is a operand
        je evalPlus
        cmp dword[esi], 0x2D
        je evalMinus
        cmp dword[esi], 0x2A
        je evalMultiply
        cmp dword[esi], 0x2F
        je evalDivide
        
        jmp length  ; go to the next part of the expression
        
evalPlus:    ; do sum of the first 2 numbers on the stack
        xor ecx, ecx
        xor edx, edx
        pop edx
        pop ecx
        
        add ecx, edx
        push ecx
        
        xor edx, edx
        jmp strtok1
        
evalMinus:  ; do substraction
        xor ecx, ecx
        xor edx, edx
        pop edx
        pop ecx
        
        sub ecx, edx
        push ecx
        
        xor edx, edx
        jmp strtok1
        
evalMultiply:   ; multiply
        xor ecx, ecx
        xor edx, edx
        pop edx
        pop ecx
        
        push eax
        mov eax, ecx
        imul edx
        xchg eax, ecx
        pop eax
        push ecx
        
        xor edx, edx
        jmp strtok1
        
evalDivide: ; divide
        xor ecx, ecx
        xor edx, edx
        pop edx
        pop ecx

        push eax
        mov eax, ecx
        mov ecx, edx
        xor edx, edx    ; upper part = edx = 0, lower part = eax AND divide to cx
        cdq ; used in case eax is negative
        idiv ecx
        
        xchg eax, ecx
        pop eax
        push ecx
        
        xor edx, edx
        jmp strtok1
                
final:  ; print result from the stack
        pop eax
        PRINT_DEC 4, eax
        NEWLINE
        mov esp, ebp
        xor eax, eax
        pop ebp
        ret