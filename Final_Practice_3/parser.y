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

%token ASSIGN SEMI LP RP MINUS PLUS IS SCAN PRINT DIM AS
%token<str_val> ID 
%token<int_val> ICONST INT 

%type<int_val> dtype 

%start code

%%
code: {gen_code(START, -1);} statements {gen_code(HALT, -1);};

statements: statements statement | ;

statement: input
        | output
        | assignment
        | declaration
        ;

declaration: DIM ID AS dtype 
            {
                insert($2, $4);
            }
dtype: INT {$$ = INT_TYPE; }

input: SCAN LP ID RP 
        {
            int addr = idcheck($3);
            if(addr!=-1){
                gen_code(SCAN_INT_VALUE, addr);
            }
        }
        | ID ASSIGN SCAN LP RP SEMI 
        {
            int addr = idcheck($1);
            if(addr!=-1){
                
                gen_code(SCAN_INT_VALUE, addr);
            }
        } ;
assignment: ID ASSIGN exp optional_semi 
            {
                int addr = idcheck($1);
                if(addr!=-1){
                    
                    gen_code(STORE, addr);
                }
                else{
                    insert($1, INT_TYPE);
                    addr = idcheck($1);
                    gen_code(STORE, addr);
                }
            } ;
optional_semi: SEMI | ;

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
        else yyerror();
    }
    | ICONST
    {
        gen_code(LD_INT, $1);
    } 
    ;

output: PRINT LP ID RP optional_semi 
    {
        int addr = idcheck($3);
        if(addr!=-1){
            gen_code(PRINT_INT_VALUE, addr);
        }
        else yyerror();
    }
    | PRINT LP ICONST RP optional_semi
    {
        gen_code(PRINT_INT_CONST, $3);
    }
    
    ; 

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
	printf("Parsing finished!!\n");

    printf("============= INTERMEDIATE CODE===============\n");
    print_code();

    printf("============= ASM CODE===============\n");
    print_assembly();

	return 0;
}




