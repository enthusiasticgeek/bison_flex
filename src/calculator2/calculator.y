%{
#include <stdio.h>

int yylex();
void yyerror(const char* s);

%}

%token NUMBER
%left '+' '-'
%left '*' '/'

%%

input: /* empty */
     | input line
     ;

line: '\n'
    | exp '\n' { printf("Result: %d\n", $1); }
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

void yyerror(const char* s) {
  fprintf(stderr, "Error: %s\n", s);
}

int main() {
  yyparse();
  return 0;
}

