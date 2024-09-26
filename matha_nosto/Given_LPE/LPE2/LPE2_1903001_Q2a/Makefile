input = input.txt
output = output.txt

main: lexer.l parser.y
	bison -d parser_copy.y 
	flex lexer.l 
	gcc parser_copy.tab.c lex.yy.c
	a <$(input)> $(output)

assembler:
	E:\masm32\bin\ml /c /coff /Cp prog.asm
	E:\masm32\bin\link -entry:main /subsystem:console prog.obj
	prog