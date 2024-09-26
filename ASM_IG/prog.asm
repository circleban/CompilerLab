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
output_string_msg_format byte "%s", 0
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

; a = [ebp-0]
; b = [ebp-4]
; c = [ebp-8]

INVOKE printf, ADDR output_string_msg_format, ADDR inp_msga
INVOKE scanf, ADDR input_integer_format, ADDR number

mov eax, number
mov dword ptr [ebp-0], eax

push [ebp-0]
push ebp

INVOKE printf, ADDR output_string_msg_format, ADDR inp_msgb
INVOKE scanf, ADDR input_integer_format, ADDR number

pop ebp
pop [ebp-0]

mov eax, number
mov dword ptr [ebp-4], eax

; b = a + 10 - b
; a 10 + b - b =

mov eax, [ebp-0]
mov dword ptr [ebx], eax
add ebx, 4

mov eax, 10
mov dword ptr [ebx], eax
add ebx, 4

sub ebx, 4
mov eax, [ebx] ; 10
sub ebx, 4
mov edx, [ebx] ; a

add edx, eax
mov dword ptr [ebx], edx
add ebx, 4

mov eax, [ebp-4]
mov dword ptr [ebx], eax
add ebx, 4

sub ebx, 4
mov eax, [ebx]
sub ebx, 4
mov edx, [ebx]
sub edx, eax

mov [ebp-4], edx

push [ebp-4]
push [ebp-0]
push ebp
; push eax
INVOKE printf, ADDR output_msg_format, ADDR out_msg
; pop eax
pop ebp
pop [ebp-0]
pop [ebp-4]

mov eax, [ebp-4]

INVOKE printf, ADDR output_integer_msg_format, eax



pop ebp
EXIT_:
    ret
main endp
end