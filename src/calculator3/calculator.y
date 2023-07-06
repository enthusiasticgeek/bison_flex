%{
#include <stdio.h>
#include <stdlib.h>
#include "calculator.tab.h"

extern int yylex();
extern int yylineno;
extern char* yytext;

void yyerror(const char* msg);

%}

%code requires {
  typedef double YYSTYPE;
  #define YYSTYPE_IS_DECLARED
}

%token NUMBER
%left '+' '-'
%left '*' '/'

%%

input: /* empty */
     | input line
     ;

line: '\n'
    | exp '\n' { printf("Result: %lf\n", $1); }  // Print as double
    ;

exp: term
   | exp '+' term { $$ = $1 + $3; }
   | exp '-' term { $$ = $1 - $3; }
   ;

term: factor
    | term '*' factor { $$ = $1 * $3; }
    | term '/' factor { $$ = $1 / $3; }
    ;

factor: NUMBER { $$ = $1; }
      | '(' exp ')' { $$ = $2; }
      ;

%%

void yyerror(const char* msg) {
  fprintf(stderr, "Syntax Error at line %d: %s. Near token: %s\n", yylineno, msg, yytext);
}

int main() {
  yyparse();
  return 0;
}

