
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

.code

main proc

push ebp
mov ebp, esp
sub ebp, 100

mov dword ptr [ebp-0], 60 ;H
mov dword ptr [ebp-4], 70;U
mov eax, [ebp-0]
mov ebx, [ebp-4]
add eax, 40
sub eax, ebx
mov dword ptr [ebp-8], eax ; F

mov eax, [ebp-4]
cmp eax, 0
jng ELSE_
mov eax, [ebp-8]
cmp eax, 0
jng ELSE_
push [ebp-8]
push [ebp-4]
push [ebp-0]
push ebp
INVOKE printf, ADDR output_integer_msg_format, eax
pop ebp
pop [ebp-0]
pop [ebp-4]
pop [ebp-8]
jmp EXIT_

ELSE_:
push [ebp-8]
push [ebp-4]
push [ebp-0]
push ebp
mov eax, [ebp]
INVOKE printf, ADDR output_integer_msg_format, eax
pop ebp
pop [ebp-0]
pop [ebp-4]
pop [ebp-8]


EXIT_:
    ret
main endp
end
