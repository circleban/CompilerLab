input = input.txt
output = output.txt

main: lexer2b.l parser2b.y
	bison -d parser2b.y 
	flex lexer2b.l 
	gcc parser2b.tab.c lex.yy.c
	a <$(input)> $(output)

assembler:
	E:\masm32\bin\ml /c /coff /Cp prog.asm
	E:\masm32\bin\link -entry:main /subsystem:console prog.obj
	prog