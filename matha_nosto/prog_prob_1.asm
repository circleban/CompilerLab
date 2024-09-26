

;   int V, I, R; 
;   printf("Current = ");
;   scanf("%d", &I);
;   printf("Resistance = ");
;   scanf("%d", &R);
;   V = I*R;
;   printf("Voltage = %d", V);



;start -1
.686
.model flat, c
include E:\masm32\include\msvcrt.inc
includelib E:\masm32\lib\msvcrt.lib

.stack 100h
printf PROTO arg1:Ptr Byte, printlist:VARARG
scanf PROTO arg2:Ptr Byte, inputlist:VARARG

.data
output_integer_msg_format byte "%d", 0Ah, 0
output_string_msg_format byte "%s", 0Ah, 0
input_integer_format byte "%d",0
output_msg byte "Current = ",0
output_msg1 byte "Resistance = ",0
output_msg2 byte "Voltage = ",0

number sdword ?

.code

main proc
	push ebp
	mov ebp, esp
	sub ebp, 100
	mov ebx, ebp
	add ebx, 4
 ;print output_msg
    push ebp
    push eax
    push ebx
    push ecx
    push edx
	push [ebp-12]
	push [ebp-8]
	push [ebp-4]
	push [ebp-0]
    INVOKE printf, ADDR output_string_msg_format, ADDR output_msg
	pop [ebp-0]
	pop [ebp-4]
	pop [ebp-8]
	pop [ebp-12]
    pop edx
    pop ecx
    pop ebx
    pop eax
	pop ebp
 ;scan_int_value 0
	push ebp
	push eax
	push ebx
	push ecx
	push edx
	push [ebp-12]
	push [ebp-8]
	push [ebp-4]
	push [ebp-0]
	push ebp
	INVOKE scanf, ADDR input_integer_format, ADDR number
	pop ebp
	pop [ebp-0]
	pop [ebp-4]
	pop [ebp-8]
	pop [ebp-12]
	mov eax, number
	mov dword ptr [ebp-0], eax   ; [ebp-0] = I
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
 ;print output_msg1
	push ebp
    push eax
    push ebx
    push ecx
    push edx
	push [ebp-12]
	push [ebp-8]
	push [ebp-4]
	push [ebp-0]
	push ebp
    INVOKE printf, ADDR output_string_msg_format, ADDR output_msg1
	pop ebp
	pop [ebp-0]
	pop [ebp-4]
	pop [ebp-8]
	pop [ebp-12]
    pop edx
    pop ecx
    pop ebx
    pop eax
	pop ebp
 ;scan_int_value 1
	push ebp
	push eax
	push ebx
	push ecx
	push edx
	push [ebp-12]
	push [ebp-8]
	push [ebp-4]
	push [ebp-0]
	push ebp
	INVOKE scanf, ADDR input_integer_format, ADDR number
	pop ebp
	pop [ebp-0]
	pop [ebp-4]
	pop [ebp-8]
	pop [ebp-12]
	mov eax, number
	mov dword ptr [ebp-4], eax   ; [ebp-4] = R
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp

 ;ld_var 0 (I)
	mov eax, [ebp-0]
	mov dword ptr [ebx], eax
	add ebx, 4


 ;ld_var 1 (R)
	mov eax, [ebp-4]
	mov dword ptr [ebx], eax
	add ebx, 4


 ;multiply -1
	sub ebx, 4
	mov eax, [ebx]
	sub ebx, 4
	mov edx, [ebx]
	mul edx
	mov dword ptr [ebx], eax
	add ebx, 4



 ;store 0
	mov dword ptr [ebp-0], eax

 ;print output_msg2
	push ebp
    push eax
    push ebx
    push ecx
    push edx
	push [ebp-12]
	push [ebp-8]
	push [ebp-4]
	push [ebp-0]
	push ebp
    INVOKE printf, ADDR output_string_msg_format, ADDR output_msg2
	pop ebp
	pop [ebp-0]
	pop [ebp-4]
	pop [ebp-8]
	pop [ebp-12]
    pop edx
    pop ecx
    pop ebx
    pop eax
	pop ebp
 ;print_int_value 0
	push ebp
	push eax
	push ebx
	push ecx
	push edx
	push [ebp-12]
	push [ebp-8]
	push [ebp-4]
	push [ebp-0]
	push [ebp+4]
	mov eax, [ebp-0]
	push ebp
	INVOKE printf, ADDR output_integer_msg_format, eax
	pop ebp
	pop [ebp+4]
	pop [ebp-0]
	pop [ebp-4]
	pop [ebp-8]
	pop [ebp-12]
	pop edx
	pop ecx
	pop ebx
	pop eax
    pop ebp
 ;halt -1
	add ebp, 10
	mov esp, ebp
	pop ebp
	ret
main endp
end