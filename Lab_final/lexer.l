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
ID ({letter})(_|{letter}|{digit})*

%%

"=" { return(ASSIGN); }
";" { return(SEMI); }
"(" { return(LP); }
")" { return(RP); }

"Dim" { return(DIM); }
"As" { return(AS); }
"Single" { return(SINGLE); }
"Sub" {return(SUB_HEAD);}
"Integer" { return(INT); }
"End" { return(END); }
"print" {return(PRINT);}

{ID} { strcpy(yylval.str_val, yytext); return(ID); }

"+" { return(PLUS);}
{digit}+ { yylval.int_val=atoi(yytext); return(ICONST); }



"\n"        { lineno += 1; }
[ \t\r\f]+  

.       { yyerror("Unrecognized character"); }

