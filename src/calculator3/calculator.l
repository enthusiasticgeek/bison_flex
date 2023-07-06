%{
#include <stdio.h>
#include <stdlib.h>
#include "calculator.tab.h"
%}

%%
[ \t]+               /* ignore whitespace */
[0-9]+"."[0-9]+      { yylval = atof(yytext); return NUMBER; }  // Match floating-point numbers
[0-9]+               { yylval = atof(yytext); return NUMBER; }  // Match integers and convert to double
\n                   { return yytext[0]; }
.                    { return yytext[0]; }
%%

int yywrap() {
  return 1;
}

