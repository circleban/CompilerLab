%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "codeGen.c"
	void yyerror();
	extern int lineno;
	extern int yylex();
%}

%union
{
    char str_val[100];
    int int_val;
}

%token DIM AS INPUT LP RP OUTPUT ASSIGN MUL
%token<str_val> ID
%token<int_val> INT

%left MUL

%type<int_val> exp type T

%start code

%%
code: {gen_code(START, -1);}  statements  {gen_code(HALT, -1);};
statements: statements statement | ;
statement: declaration
            | scanf
            | printf
            | assignment;

declaration: DIM ID AS type
            {
                insert($2, $4); // no gen_code
            };
scanf: INPUT LP RP
    {
        char *name = "__TEMP__";
        int addr = idcheck(name);
        if(addr!=-1) gen_code(SCAN_INT_VALUE, addr);
        else {
            insert(name, INT_TYPE);
            addr = idcheck(name);
            gen_code(SCAN_INT_VALUE, addr);
        }
    };
printf: OUTPUT LP exp RP
    {
        char *name = "__TEMP__";
        int addr = idcheck(name);
        if(addr!=-1) gen_code(PRINT_INT_VALUE, addr);
        else exit(0);
    };
assignment: ID ASSIGN scanf
        {
            int addr = idcheck($1);
            char *name = "__TEMP__";
            int temp_addr = idcheck(name);
            if(addr!=-1){
                gen_code(LD_VAR, temp_addr);
                gen_code(STORE, addr);
            }

        };
exp: exp MUL T
    {
        gen_code(MULT, -1);
        char *name = "__TEMP__";
        int addr = idcheck(name);
        if(addr==-1){
            insert(name, INT_TYPE);
            addr = idcheck(name);
        }
        gen_code(STORE, addr);
    }
    | T 
    ;
T: ID
    {
        int addr = idcheck($1);
        if(addr!=-1) gen_code(LD_VAR, addr);
        else exit(0);
    };

type: INT{$$=INT_TYPE};
%%

void yyerror ()
{
	printf("Syntax error at line %d\n", lineno);
	exit(1);
}

int main (int argc, char *argv[])
{
	yyparse();
	printf("Parsing finished!\n");

    printf("============= INTERMEDIATE CODE===============\n");
    print_code();

    printf("============= ASM CODE===============\n");
    print_assembly();

	return 0;
}
