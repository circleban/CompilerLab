%option noyywrap

%{
	#define INT_TYPE 1
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "parser2b.tab.h"
	
	int lineno = 1; // initialize to 1
	void yyerror();
%}

letter [a-zA-Z]
digit [0-9]
ID ({letter})({letter}|{digit})*
ICONST {digit}+

%%
"integer" {return(INT);}
"dim" {return(DIM);}
"as" {return(AS);}
"input" {return(INPUT);}
"(" {return(LP);}
")" {return(RP);}
"output" {return(OUTPUT);}
"=" {return(ASSIGN);}
"*" {return(MUL);}
{ID} {strcpy(yylval.str_val, yytext); return(ID);}

"\n"        { lineno += 1; }
[ \t\r\f]+  

.       { yyerror("Unrecognized character"); }
