%{
#include <stdio.h>
#include <stdlib.h>
#include "calculator.tab.h"
int line_num = 0;
%}

%%
[ \t]+               /* ignore whitespace */
[0-9]+"."[0-9]+      { yylval = atof(yytext); return NUMBER; }  // Match floating-point numbers
[0-9]+               { yylval = atof(yytext); return NUMBER; }  // Match integers and convert to double
\n                   { ++line_num; return '\n'; }
.                    { return yytext[0]; }
%%

int yywrap() {
  return 1;
}

