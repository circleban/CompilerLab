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

%token ASSIGN SEMI LP RP MINUS PLUS IS SCAN PRINT
%token<str_val> ID 
%token<int_val> ICONST INT 

%type<int_val> type 

%start code

%%
code: {gen_code(START, -1);} statements {gen_code(HALT, -1);};

statements: statements statement | ;

statement: declaration
        | output
        ;

declaration: ID IS type ASSIGN exp SEMI
        {
            insert($1, $3);
            int addr = idcheck($1);
            if(addr!=-1){
                gen_code(STORE, addr);
            }
            else yyerror();
        } ; 

type: INT {$$=INT_TYPE;} ;

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
    | input
    ;

output: PRINT LP ID RP SEMI 
    {
        int addr = idcheck($3);
        if(addr!=-1){
            gen_code(PRINT_INT_VALUE, addr);
        }
        else yyerror();
    }
    | PRINT LP ICONST RP SEMI
    {
        gen_code(PRINT_INT_CONST, $3);
    }
    
    ; 

input: SCAN LP RP 
    {
        char* name = "__TEMP__";
        int addr = idcheck(name);
        if(addr==-1){
            insert(name, INT_TYPE);
            addr = idcheck(name);
        }
        gen_code(SCAN_INT_VALUE, addr);

        gen_code(LD_VAR, addr);
    };

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




