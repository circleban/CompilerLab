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

%token ASSIGN SEMI LP RP DIM AS SUB_HEAD END PLUS PRINT
%token<str_val> ID
%token<int_val> ICONST INT SINGLE


%type<int_val> type 

%start code

%%
code: {gen_code(START, -1);}  function  {gen_code(HALT, -1);};

function: SUB_HEAD ID LP RP statements END SUB_HEAD;

statements: statements statement | ;

statement: declaration
        | assignment
        | printf
        ;

declaration: DIM ID AS type
        {
            insert($2, $4);
        };

assignment: ID ASSIGN expr
            {
                int addr = idcheck($1);
                if(addr!=-1){
                    gen_code(STORE, addr);
                }
            };

expr: exp SEMI | T;

exp: exp PLUS T 
    {
        gen_code(ADD, -1);
    }
    | T;


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
   }
   ;

printf: PRINT LP ID RP
        {
            int addr = idcheck($3);
            if(addr!=-1){
                gen_code(PRINT_INT_VALUE, addr);
            }
        };

type: INT{$$=INT_TYPE;}
    | SINGLE {$$=SINGLE_TYPE;};
%%





void yyerror ()
{
	printf("Syntax error at line %d\n", lineno);
	exit(1);
}

int main (int argc, char *argv[])
{
    // E: E + T | T;
    // T: ID | const;
	yyparse();
	printf("Parsing finished!\n");

    printf("============= INTERMEDIATE CODE===============\n");
    print_code();

    printf("============= ASM CODE===============\n");
    print_assembly();

	return 0;
}
