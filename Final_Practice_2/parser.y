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

%token ASSIGN SEMI LP RP DIM AS SUB_H END PLUS FOR TO NEXT THEN IF GT PRINT
%token<str_val> ID
%token<int_val> ICONST INT SINGLE
%type<int_val> type 

%start code

%%
code: function ;
function: SUB_H ID LP RP statements END SUB_H ;
statements: statements statement | ;
statement: declaration
            | assignment
            | loop
            | conditional 
            | printf
            ;

declaration: DIM ID AS type ;
type: INT | SINGLE ;

assignment: ID ASSIGN exp optional_semi;
optional_semi: SEMI | ;


exp: exp PLUS T
    | exp GT T
    | T 
    ;
T: ID | ICONST ;

loop: FOR assignment TO ICONST statements NEXT ID ;

conditional: IF exp THEN statements END IF ;

printf: PRINT LP ID RP ;

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

    // printf("============= INTERMEDIATE CODE===============\n");
    // print_code();

    // printf("============= ASM CODE===============\n");
    // print_assembly();

	return 0;
}




