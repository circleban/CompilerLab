%option noyywrap

%{
	#define INT_TYPE 1
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "parser.tab.h"
	
	int lineno = 1; // initialize to 1
	void yyerror();
%}

letter [a-zA-Z]
digit [0-9]
ID ({letter})({letter}|{digit})*
ICONST {digit}+

%%
"IS" {return(IS);}
"IN" {return(SCAN);}
"INT" {return(INT);}
"OUT" {return(PRINT);}
"DEF" {return(DEF);}
"as" {return(AS);}
";" {return(SEMI);}
{ID} {strcpy(yylval.str_val, yytext); return(ID);}
"-" {return(MINUS);}
"+" {return(PLUS);}
{ICONST} {yylval.int_val=atoi(yytext); return(ICONST);}
")" {return(RP);}
"(" {return(LP);}
"=" {return(ASSIGN);}

"\n"        { lineno += 1; }
[ \t\r\f]+  

.       { yyerror("Unrecognized character"); }
