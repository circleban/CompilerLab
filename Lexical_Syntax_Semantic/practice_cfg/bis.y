%{
#include<stdio.h>
#include<stdlib.h>
int yylex();
void yyerror(char*);
%}
%token ZERO ONE
%start S

%%
S: ZERO S ONE S | ONE S ZERO S | ;
%%

int main()
{
    yyparse(); // if there is an error the line below wont execute
    printf("Parsing Finshed\n");
}

void yyerror(char *err){
    fprintf(stderr, "Error: %s\n", err);
    exit(1);
}