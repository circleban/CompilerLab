%{
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror();  // Only declare here; implementation stays in the Bison file
    extern int lineno;
    extern int yylex();
%}

%union
{
    char str_val[100];
    int int_val;
}

%token INT ID SEMI ASSIGN ICONST IF LP LT RP LB Print RB ELSE ADD

%start code
%%
code: L1 L2 L3 L4 L5 L6 L7;
L1: INT ID SEMI ;
L2: ID ASSIGN ICONST SEMI ;
L3: IF LP ID LT ICONST RP ;
L4: LB Print LP ID RP SEMI RB ;
L5: ELSE ;
L6: LB ID ASSIGN ID ADD ICONST SEMI RB ;
L7: Print LP ID RP SEMI ;
%%

int main()
{
    yyparse();
    printf("Parsing Finished\n");
    return 0;
}

void yyerror(char *err) {
    printf("Syntax error at line %d\n", lineno);
    exit(1);
}