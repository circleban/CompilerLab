%option noyywrap
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "bis.tab.h"
    // This should be declared as extern
%}

/* Definitions for identifiers and numbers */
letter [a-zA-Z]
digit [0-9]
ID ({letter})(_|{letter}|{digit})*
ws [ \n]

%%

"int"        { return(INT); }
"n"          { return(ID); }
";"          { return(SEMI); }
"="          { return(ASSIGN); }
"3"          { return(ICONST); }

"if"         { return(IF); }
"("          { return(LP); }
"<"          { return(LT); }
"10"         { return(ICONST); }
")"          { return(RP); }

"{"          { return(LB); }
"print"      { return(Print); }
"}"          { return(RB); }
"else"       { return(ELSE); }
"+"          { return(ADD); }

%%

int main(){
	yylex();
	return 0;
}