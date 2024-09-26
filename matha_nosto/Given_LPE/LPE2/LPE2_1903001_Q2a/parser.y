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

%token SCAN PRINT MINUS PLUS RP LP ASSIGN IS DEF AS SEMI
%token<str_val> ID
%token<int_val> ICONST INT

%left PLUS MINUS

%type<int_val> type 

%start code

%%
code: {gen_code(START, -1);}  statements  {gen_code(HALT, -1);};
statements: statements statement | ;
statement:  printf
            | assignment;

printf: PRINT LP pexp RP SEMI
    {
        char* name = "__TEMP__";
        int addr = idcheck(name);
        if(addr==-1) {
            insert(name, INT_TYPE);
            addr = idcheck(name);
        }
        gen_code(PRINT_INT_VALUE, addr);
    };
assignment: DEF ID IS type ASSIGN exp SEMI
        {
            int addr = idcheck($2);
            if(addr==-1) {
                insert($2, $4);
                addr = idcheck($2);
            }
            gen_code(STORE, addr);
            
        }
        | DEF ID AS type ASSIGN exp SEMI
        {
            {
            int addr = idcheck($2);
            if(addr==-1) {
                insert($2, $4);
                addr = idcheck($2);
            }
            gen_code(STORE, addr);
            
        }
        }
        ;

pexp: pexp PLUS T 
    {
        gen_code(ADD, -1);
        char* name = "__TEMP__";
        int addr = idcheck(name);
        if(addr==-1) {insert(name, INT_TYPE);
        addr = idcheck(name);}
        gen_code(STORE, addr);
    }
    | T;
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
        if(addr!=-1) gen_code(LD_VAR, addr);
        else exit(0);
    }
   | ICONST
   {
        gen_code(LD_INT, $1);
   }
   | scanf
   ;
scanf: SCAN LP RP
    {
        char* name = "__TEMP__";
        int addr = idcheck(name);
        if(addr==-1) {
            insert(name, INT_TYPE);
            addr = idcheck(name);
        }
        
        gen_code(SCAN_INT_VALUE, addr);
        gen_code(LD_VAR, addr);
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
