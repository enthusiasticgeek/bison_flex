%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "calculator.tab.h"
int yylex(void);
void yyerror(const char* msg);
%}

%union {
  double number;
  char* string;
}

%token <number> NUMBER
%token <string> WORD

%type <number> exp term factor

%%

input: /* empty */
     | input line
     ;

line: '\n'
    | exp '\n' { printf("Result: %lf\n", $1); }
    ;

exp: term { $$ = $1; }
   | exp '+' term { $$ = $1 + $3; }
   | exp '-' term { $$ = $1 - $3; }
   ;

term: factor { $$ = $1; }
    | term '*' factor { $$ = $1 * $3; }
    | term '/' factor { $$ = $1 / $3; }
    ;

factor: NUMBER { $$ = $1; }
       | WORD { $$ = atof($1); }
       | '(' exp ')' { $$ = $2; }
       ;

%%

int main() {
  yyparse();
  return 0;
}

void yyerror(const char* msg) {
  fprintf(stderr, "Syntax Error: %s\n", msg);
}

