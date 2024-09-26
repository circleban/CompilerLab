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



.code
main proc
mov eax, 10
mov ecx, 3
xor edx, edx
div ecx
INVOKE printf, ADDR output_integer_msg_format, eax

EXIT_:
    ret
main endp
end

10 / 4 = 2 -> eax
rem -> edx