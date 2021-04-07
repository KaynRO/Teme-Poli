%include "io.inc"

section .data
	word_num1 dd 0xffffffff
	word_num2 dd 0x11111111
	big_num1 dd 0x11111111, 0x22222222, 0x33333333
	big_num2 dd 0xffffffff, 0x22222222, 0x33333333
	num_array1 dd 0x11111111, 0x22222222, 0x33333333, 0x12111211, 0x22232242, 0xff333333, 0xff123456, 0xff123456, 0xff123456
	num_array2 dd 0xffffffff, 0x22922252, 0x33033338, 0x12111211, 0x22232242, 0xff333333, 0xff123456, 0xff123456, 0xff123456
	length dd 3

section .bss
        	result_word resd 2
        	result_4word resd 4
	result_array resd 12


section .text
global main
main:
	push ebp
	mov ebp, esp

        ;task1
        mov ebx, dword[word_num1]
        mov eax, dword[word_num2]
        add eax, ebx
        jnc print
        PRINT_HEX 1, 1
        
print:
        PRINT_HEX 4, eax
        NEWLINE
        
        ;task2
        mov eax, dword[big_num1 + 8]
        add eax, dword[big_num2 + 8]
        
        mov ebx, dword[big_num1 + 4]
        adc ebx, dword[big_num2 + 4]
        
        mov ecx, dword[big_num1]
        adc ecx, dword[big_num2]
        jnc print2
        PRINT_HEX 1, 1
        
print2:
        PRINT_HEX 4, ecx
        PRINT_HEX 4, ebx
        PRINT_HEX 4, eax
        NEWLINE

        ;task3
        
        mov ecx, 9
        mov edx, 9
        clc
        
repeat:
        dec edx
        mov eax, dword[num_array1 + 4 * edx]
        adc eax, dword[num_array2 + 4 * edx]
        mov dword[result_array + 4 * edx], eax
        dec ecx
        jnz repeat
        
        jnc print3
        PRINT_HEX 1, 1
        
print3:
        mov ecx, 0
        
repeat2:
        mov eax, [result_array + 4 * ecx]
        PRINT_HEX 4, eax
        inc ecx
        cmp ecx, 8
        jle repeat2
        leave
        ret

