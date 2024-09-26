
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
current byte "Current = ", 0
res byte "Resistence = ", 0
volt byte "Voltage = ", 0

number sdword ?

.code

main proc
	
push ebp
mov ebp, esp
sub ebp, 100

push ebp
INVOKE printf, ADDR inp_msg_format, ADDR current
INVOKE scanf, ADDR input_integer_format, ADDR number
pop ebp
mov eax, number
mov dword ptr [ebp], eax

push [ebp]
push ebp
INVOKE printf, ADDR inp_msg_format, ADDR res
INVOKE scanf, ADDR input_integer_format, ADDR number
pop ebp
pop [ebp]

mov eax, number
mov dword ptr [ebp-4], eax


mov edx, [ebp]
mul edx

mov dword ptr [ebp-8], eax

push [ebp-8]
push ebp
INVOKE printf, ADDR inp_msg_format, ADDR volt
pop ebp
pop [ebp-8]

mov eax, [ebp-8]

INVOKE printf, ADDR output_integer_msg_format, eax

main endp
end
