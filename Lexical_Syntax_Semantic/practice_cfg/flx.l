%option noyywrap

%{
#include "bis.tab.h"
%}


%%
"0" {return (ZERO);}
"1" {return (ONE);}
%%

// int main()
// {
//     yylex();
//     return 0;
// }