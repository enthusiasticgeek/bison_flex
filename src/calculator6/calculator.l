%{
#include <stdio.h>
#include <stdlib.h>
#include "calculator.tab.h"
int line_num = 0;
double square(double x);
double square_root(double x);
%}

%%
[ \t]+               /* ignore whitespace */
[0-9]+"."[0-9]+      { yylval = atof(yytext); return NUMBER; }  // Match floating-point numbers
[0-9]+               { yylval = atof(yytext); return NUMBER; }  // Match integers and convert to double
\n                   { ++line_num; return '\n'; }
"square"             { return SQUARE; }  // Match the "square" function name
"square_root"        { return SQUARE_ROOT; }  // Match the "square_root" function name
"%"                  { return PERCENT; }  // Match the "%" operator
"percent"                  { return PERCENT; }  // Match the "%" operator
"of"                 { return OF; }  // Match the "OF" keyword
"mod"                { return MODULO; }  // Match the "mod" keyword for modulo operator
"pi"                 { return PI; }  // Match the "pi" constant
.                    { return yytext[0]; }
%%

