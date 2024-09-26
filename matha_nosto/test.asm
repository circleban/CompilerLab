.686
.model flat, c
include E:\masm32\include\msvcrt.inc
includelib E:\masm32\lib\msvcrt.lib

.stack 100h
printf PROTO arg1:Ptr Byte, printlist:VARARG
scanf PROTO arg2:Ptr Byte, inputlist:VARARG

.data
input_integer_format byte "%d", 0
output_msg_format byte "%s", 0
output_integer_msg_format byte "%d", 0Ah, 0
inp_msga byte "Enter a: ", 0
inp_msgb byte "Enter b: ", 0
out_msg byte "a + 10 - b = ", 0
number sdword ?

; assembly for
; int a 
; int b
; scan a
; scan b
; b=a+10 - b
; print b

.code
main proc

push ebp
mov ebp, esp
sub ebp, 100
mov ebx, ebp
add ebx, 4

push ebp
; printf("%s", inp_msga)
INVOKE printf, ADDR output_msg_format, ADDR inp_msga
; scanf("%d", &a)
INVOKE scanf, ADDR input_integer_format, ADDR number
; save korbo
pop ebp
mov eax, number
mov dword ptr [ebp-0], eax ; int a save korlam

; b input
; printf("%s", inp_msga)
push ebp
push [ebp-0]
INVOKE printf, ADDR output_msg_format, ADDR inp_msgb
; scanf("%s", &b)
INVOKE scanf, ADDR input_integer_format, ADDR number
pop [ebp-0]
pop ebp
mov eax, number
mov dword ptr [ebp-4], eax ; int b save korlam

; b=a+10 - b
mov eax, [ebp-0]
add eax, 10
mov edx, [ebp-4]
sub eax, edx
mov dword ptr [ebp-4], eax

push ebp
push [ebp-0]
push [ebp-4]
INVOKE printf, ADDR output_msg_format, ADDR out_msg
pop [ebp-4]
pop [ebp-0]
pop ebp
mov eax, [ebp-4]

;printf("%d", eax)
INVOKE printf, ADDR output_integer_msg_format, eax

EXIT_:
    ret
main endp
end