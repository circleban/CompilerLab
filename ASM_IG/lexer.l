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

%%
" " {}
"int" {printf("%s -> INT_TYPE\n", yytext); return(INT);}
"scan" {printf("%s -> SCAN\n", yytext); return(SCAN);}
"print" {printf("%s -> PRINT\n", yytext); return(PRINT);}
";" {printf("%s -> SEMI\n", yytext); return(SEMI);}
"+" {printf("%s -> PLUS\n", yytext); return(PLUS);}
"-" {printf("%s -> MINUS\n", yytext); return(MINUS);}
"(" {printf("%s -> LPAREN\n", yytext); return(LP);}
")" {printf("%s -> RPAREN\n", yytext); return(RP);}
"=" {printf("%s -> ASSIGN\n", yytext); return(ASSIGN);}
{ID} {printf("%s -> ID\n", yytext); strcpy(yylval.str_val, yytext); return(ID);}
{digit}+ {printf("%s -> INT_NUM\n", yytext); yylval.int_val=atoi(yytext); return(ICONST);}

"\n"        { lineno += 1; }
[ \t\r\f]+  

.       { yyerror("Unrecognized character"); }
