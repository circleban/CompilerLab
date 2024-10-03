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
ID (_|{letter})(_|{letter}|{digit})*

%%

"IS" {return(IS);}
"int" {return(INT);}
"IN" {return(SCAN);}
"OUT" {return(PRINT);}

{ID} { strcpy(yylval.str_val, yytext); return(ID);}
"(" {return(LP);}
")" {return(RP);}
{digit}+ {yylval.int_val=atoi(yytext); return(ICONST);}
"=" {return(ASSIGN);}
"+" {return(PLUS);}
"-" {return(MINUS);}
";" {return(SEMI);}

"\n"        { lineno += 1; }
[ \t\r\f]+  

.       { yyerror("Unrecognized character"); }

