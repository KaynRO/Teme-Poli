extern puts
extern printf
extern strlen

%define BAD_ARG_EXIT_CODE -1

section .data
filename: db "./input0.dat", 0
inputlen: dd 2263

fmtstr:            db "Key: %d",0xa, 0
usage:             db "Usage: %s <task-no> (task-no can be 1,2,3,4,5,6)", 10, 0
error_no_file:     db "Error: No input file %s", 10, 0
error_cannot_read: db "Error: Cannot read input file %s", 10, 0
bit_message:    db  "%c", 0, 0
nothing:    db  "",0,0


section .text
global main

xor_strings:
        push ebp
        mov ebp, esp 
iterate1:       
        mov al, byte[edi]
        xor byte[esi], al   ; for each byte, until we hit the 0x00, we xor with the corresponding one
        inc esi ; from the key
        inc edi
        cmp byte[esi], 0h
        jne iterate1
        leave
	ret

rolling_xor:
	push ebp
        mov ebp, esp
        mov al, byte[edi]
        inc edi

iterate2:
        mov bl, byte[edi]   ; remember current byte for the next encryption step
        xor byte[edi], al   ; encrypt current byte
        xchg al, bl ;update encryption key
        inc edi
        cmp byte[edi], 0h   ; check if we reached end
        jne iterate2
        leave
	ret

xor_hex_strings:
        push ebp        
        mov ebp, esp  
        
        xor ebx, ebx
        xor eax, eax
        xor edi, edi
        
        sub esp, 800
        inc bh  ; bh is the index of the current character, starting from 1
                        
iterate3:
        xor eax, eax
        mov al, byte[esi]
        
        cmp byte[esi - 1], 0x00 ; looking if we reached end
        je final

iterate3_continue:
        
        cmp al, 97
        jge hex ; if we have a letter substract 'a' - 10 cuz 'a' = 10 in hex
        
        sub al, 48  ; otherwise a digit substract '0'
        jmp rotate
        
hex:
        sub al, 87
  
rotate:      
        inc bl  ; index of current byte
        rol al, 1   ; to create the binary value we have to rotate to left
        jc bit1 ; if the current bit is 1 or 0
        
        cmp bl, 5
        jl bit_loop
        
        or edi, 0   ; we OR the current value and 0 and then shift to left by one bit
        shl edi, 1
        
        jmp bit_loop
bit1:
        cmp bl, 5   ; being hex, the number has only 4 bits
        jl bit_loop
        
        or edi, 1
        shl edi, 1
                
bit_loop:
        cmp bl, 7   ; for all 8 bits we repeat the process
        jle rotate
        
        shr edi, 1             
        jmp next_val

final:
        cmp byte[esi - 2], 0x35 ; if it was the end and not the middle
        jne iterate3_continue
        lea edi, [ebp - 800]    ; store adress where binary data starts
        leave
        ret
 
next_val:  
        inc esi ; we go to next character      
        inc bh
        xor bl, bl
        
        push ecx
        xor ecx, ecx
        mov cl, bh  ; index of current character
        
        mov [ebp - 800 + ecx * 4], edi  ; save current binary value on stack  
        xor edi, edi      
        pop ecx        
        jmp iterate3

base32decode:
	; TODO TASK 4
	ret

bruteforce_singlebyte_xor:
        push ebp
        mov ebp, esp     
        xor eax, eax
        
iterate5:    
        xor eax, eax 
        mov eax, edi
        push ebx
        xor ebx, ebx
        mov bl, byte[esi]
        xor ebx, eax
        mov byte[esi], bl   ; for each byte, until we hit the 0x00, we xor with the corresponding one
        pop ebx
        inc esi ; from the key
        cmp byte[esi], 0h
        jne iterate5
        leave
	ret

decode_vigenere:
	; TODO TASK 6
	ret

main:
        mov ebp, esp; for correct debugging
	push ebp
	mov ebp, esp
	sub esp, 2300

	; test argc
	mov eax, [ebp + 8]
	cmp eax, 2
	jne exit_bad_arg

	; get task no
	mov ebx, [ebp + 12]
	mov eax, [ebx + 4]
	xor ebx, ebx
	mov bl, [eax]
	sub ebx, '0'
	push ebx

	; verify if task no is in range
	cmp ebx, 1
	jb exit_bad_arg
	cmp ebx, 6
	ja exit_bad_arg

	; create the filename
	lea ecx, [filename + 7]
	add bl, '0'
	mov byte [ecx], bl

	; fd = open("./input{i}.dat", O_RDONLY):
	mov eax, 5
	mov ebx, filename
	xor ecx, ecx
	xor edx, edx
	int 0x80
	cmp eax, 0
	jl exit_no_input

	; read(fd, ebp - 2300, inputlen):
	mov ebx, eax
	mov eax, 3
	lea ecx, [ebp-2300]
	mov edx, [inputlen]
	int 0x80
	cmp eax, 0
	jl exit_cannot_read

	; close(fd):
	mov eax, 6
	int 0x80

	; all input{i}.dat contents are now in ecx (address on stack)
	pop eax
	cmp eax, 1
	je task1
	cmp eax, 2
	je task2
	cmp eax, 3
	je task3
	cmp eax, 4
	je task4
	cmp eax, 5
	je task5
	cmp eax, 6
	je task6
	jmp task_done

task1:
        xor eax, eax
        lea edi, [ecx]
        mov esi, edi

        mov al, 0h
        repne scasb ; we will get edi points to the beginning of the key and esi of the hole string
        
        push esi    ; save current adress of string
        call xor_strings
        pop esi        
        lea ecx, [esi]
        
	push ecx
	call puts                   ;print resulting string
	add esp, 4

	jmp task_done

task2:
        xor eax, eax
        xor ebx, ebx
        lea edi, [ecx]
        mov esi, edi
        
        call rolling_xor
        lea ecx, [esi]
        
	push ecx
	call puts
	add esp, 4

	jmp task_done

task3:
        xor eax, eax
        lea esi, [ecx]

        push esi    ; save current adress of string
        call xor_hex_strings
        pop esi

        xor ebx, ebx
        inc ebx ; character counter
        add edi, 8
        lea esi, [edi + 4 * 71] ;70 is delimiter so we iterate from 0
   
        xor ebx, ebx
        xor ecx, ecx

mloop:
        inc ebx  
        mov ecx, [esi]  ; we join 2 consecutive octets into one, like 0102 into 12
        shl ecx, 4
        or ecx, [esi + 4]
        mov [esi], ecx
        
        mov eax, [edi]  ; same here
        shl eax, 4
        or eax, [edi + 4]
        mov [edi], eax
       
        mov eax, [esi]  ; now we xor it
        xor [edi], eax
        mov eax, [edi]
        
        pusha
        push eax
        push bit_message
        call printf ; print the result
        add esp, 8
        popa 
        add esi, 8  ; go to +2 value
        add edi, 8
        cmp ebx, 34
        jle mloop 
        
        pusha
        push nothing
        call puts
        add esp, 4

	jmp task_done

task4:
	; TASK 4: decoding a base32-encoded string

	; TODO TASK 4: call the base32decode function
	
	push ecx
	call puts                    ;print resulting string
	pop ecx
	
	jmp task_done

task5: 
        xor eax, eax
        lea esi, [ecx]
        xor edi, edi
        mov edi, 0x11

key_loop:  
        ;lea eax, [esi   
        pusha
        call bruteforce_singlebyte_xor
        popa
        lea esi, [ecx]

        
        mov ecx, [esi]
        push ecx
        call puts
        add esp, 4
        
        add edi, 0x11
        cmp edi, 0xff
        jle key_loop

	;push eax                    ;eax = key value
	;push fmtstr
	;call printf                 ;print key value
	;add esp, 8

	jmp task_done

task6:
	; TASK 6: decode Vignere cipher

	; TODO TASK 6: find the addresses for the input string and key
	; TODO TASK 6: call the decode_vigenere function

	push ecx
	call strlen
	pop ecx

	add eax, ecx
	inc eax

	push eax
	push ecx                   ;ecx = address of input string 
	call decode_vigenere
	pop ecx
	add esp, 4

	push ecx
	call puts
	add esp, 4

task_done:
	xor eax, eax
	jmp exit

exit_bad_arg:
	mov ebx, [ebp + 12]
	mov ecx , [ebx]
	push ecx
	push usage
	call printf
	add esp, 8
	jmp exit

exit_no_input:
	push filename
	push error_no_file
	call printf
	add esp, 8
	jmp exit

exit_cannot_read:
	push filename
	push error_cannot_read
	call printf
	add esp, 8
	jmp exit

exit:
	mov esp, ebp
	pop ebp
	ret
