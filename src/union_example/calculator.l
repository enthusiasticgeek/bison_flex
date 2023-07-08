%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "calculator.tab.h"
extern int yylineno;
extern char* yytext;
extern FILE* yyin;
//extern double yylval;

void yyerror(const char* msg);

%}

%%
[0-9]+"."[0-9]+      { yylval.number = atof(yytext); return NUMBER; }  // Match floating-point numbers
[0-9]+               { yylval.number = atof(yytext); return NUMBER; }  // Match integers and convert to double
[a-zA-Z]+            { yylval.string = strdup(yytext); return WORD; }  // Match words and return as string
\n                   { return '\n'; }
.                    { return yytext[0]; }
%%

int yywrap() {
  return 1;
}

