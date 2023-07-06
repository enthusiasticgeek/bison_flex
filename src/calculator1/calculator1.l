%{
#include "calculator1.tab.h"
%}

%%
[ \t]+       /* ignore whitespace */
[0-9]+       { yylval = atoi(yytext); return NUMBER; }
\n           { return yytext[0]; }
.            { return yytext[0]; }
%%

int yywrap() {
  return 1;
}


