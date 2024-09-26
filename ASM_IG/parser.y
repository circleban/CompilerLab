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

%token SCAN PRINT SEMI PLUS MINUS LP RP ASSIGN
%token<str_val> ID 
%token<int_val> ICONST
%token<int_val> INT

%left PLUS MINUS

%type<int_val> type exp T

%start code
%%
code: {gen_code(START, -1);} statements {gen_code(HALT, -1);};
statements: statements statement | ;
statement: declaration
           | scanf
           | assignment
           | printf
           ;

declaration: type ID SEMI
            {
                insert($2, $1);
            }
            | type ID ASSIGN exp SEMI
            {
                insert($2, $1);
                int addr = idcheck($2);
                gen_code(STORE, addr);
            };
scanf: SCAN LP ID RP SEMI
        {
            int addr = idcheck($3);
            if(addr!=-1){
                gen_code(SCAN_INT_VALUE, addr);
            }
            
        };
assignment: ID ASSIGN exp SEMI
            {
                int addr = idcheck($1);
                if(addr!=-1){
                    gen_code(STORE, addr);
                }
            };
printf: PRINT LP ID RP SEMI
        {
            int addr = idcheck($3);
            if(addr!=-1){
                gen_code(PRINT_INT_VALUE, addr);
            }
        };
exp: exp PLUS T
    {
        gen_code(ADD, -1);
    }
    | exp MINUS T
    {
        gen_code(SUB, -1);
    }
    | T
    ;
T: ID
    {
        int addr = idcheck($1);
        if(addr!=-1){
            gen_code(LD_VAR, addr);
        }
    }
    | ICONST
    {
        gen_code(LD_INT, $1);
    };
type: INT{$$=INT_TYPE;};
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
