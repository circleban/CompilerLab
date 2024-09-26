; start -1
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
number sdword ?

; assembly for
; int a 
; int b
; scan a
; scan b
; b=a+10-b
; print b

.code
main proc

push ebp
mov ebp, esp
sub ebp, 100
mov ebx, ebp
add ebx, 4

; scanf 0
push eax
push ebx
push ecx
push edx
push ebp
push [ebp-0]
push [ebp-4]
INVOKE scanf, ADDR input_integer_format, ADDR number
pop [ebp-4]
pop [ebp-0]
pop ebp
pop edx
pop ecx
pop ebx

mov eax, number
mov dword ptr [ebp-0], eax
pop eax

; scanf 1
push eax
push ebx
push ecx
push edx
push ebp
push [ebp-0]
push [ebp-4]
INVOKE scanf, ADDR input_integer_format, ADDR number
pop [ebp-4]
pop [ebp-0]
pop ebp
pop edx
pop ecx
pop ebx

mov eax, number
mov dword ptr [ebp-4], eax
pop eax

; b=a+10-b -> a 10 + b - b =

; LD_var 0
mov eax, [ebp-0]
mov [ebx], eax
add ebx, 4

; LD_int 20
mov eax, 20
mov [ebx], eax
add ebx, 4

; add -1
sub ebx, 4
mov eax, [ebx] ; eax = 10
sub ebx, 4 
mov edx, [ebx] ; edx = a

add edx, eax
mov [ebx], edx
add ebx, 4

; LD_var 1
mov eax, [ebp-4]
mov [ebx], eax
add ebx, 4

; sub -1
sub ebx, 4
mov eax, [ebx] ; eax = b
sub ebx, 4
mov edx, [ebx] ; edx = a+10
sub edx, eax
mov [ebx], edx
add ebx, 4

; STORE -1
mov dword ptr [ebp-4], edx


; print -1
push eax
push ebx
push ecx
push edx
push ebp
push [ebp-0]
push [ebp-4]
mov eax, [ebp-4]
INVOKE printf, ADDR output_integer_msg_format, eax
pop [ebp-4]
pop [ebp-0]
pop ebp
pop edx
pop ecx
pop ebx

EXIT_:
    ret
main endp
end