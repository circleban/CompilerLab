
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
inp_msg_format byte "%s", 0
output_msg_format byte "%s", 0Ah, 0
input_integer_format byte "%d",0


number sdword ?


; int a;
; int count=0
; scanf(a);
; for (i=0 to a-1, i++){
;     if(i==3) count*=3
;     else if(i%4==0) count+=4
;     else if (i%5==0) count-=8
;     else count++
; }
; print(count)


.code

main proc

push ebp
mov ebp, esp
sub ebp, 100

push ebp
INVOKE scanf, ADDR input_integer_format, ADDR number
pop ebp
mov eax, number
mov dword ptr [ebp], eax ; a
mov dword ptr [ebp-4], 0 ;count
mov ecx, 0 ; i

L:
    mov eax, [ebp]
    cmp ecx, eax
    jz PRINT_
    ; if i==3
    mov eax, 3
    cmp ecx, eax
    jne elif1_
    mov edx, 3
    mov eax, [ebp-4]
    mul edx
    mov dword ptr [ebp-4], eax
    jmp continue

    elif1_:
    ; if i%4==0
    mov eax, ecx
    mov ebx, 4
    xor edx, edx
    div ebx
    cmp edx, 0
    jne elif2_
    mov eax, [ebp-4]
    add eax, 4
    mov dword ptr [ebp-4], eax
    jmp continue

    elif2_:
    ; (i%5==0) count-=8
    mov eax, ecx
    mov ebx, 5
    xor edx, edx
    div ebx
    cmp edx, 0
    jne else_
    mov eax, [ebp-4]
    sub eax, 8
    mov dword ptr [ebp-4], eax
    jmp continue

    else_:
    ; count++
    mov eax, [ebp-4]
    inc eax
    mov dword ptr [ebp-4], eax

    continue:
        add ecx, 1
        jmp L

PRINT_:
mov eax, [ebp-4]
INVOKE printf, ADDR output_integer_msg_format, eax

EXIT_:
    ret    

main endp
end
