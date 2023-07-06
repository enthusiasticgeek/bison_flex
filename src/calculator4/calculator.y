%{
#include <stdio.h>
#include <stdlib.h>
#include "calculator.tab.h"

extern int yylex();
extern int yylineno;
extern char* yytext;
extern FILE *yyin;
extern int line_num;

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
    | exp '\n' { printf("[line %d] Result: %lf\n", line_num, $1); }  // Print as double
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
  FILE* inputFile = fopen("input.txt", "r");
  if (inputFile == NULL) {
    printf("Failed to open the input file.\n");
    return 1;
  }
  yyin = inputFile;
/*
  // parse through the input until there is no more:
  do {
    yyparse();
  } while (!feof(yyin));
*/
// parse through the input until there is no more:
int token;
do {
  yyparse();
  token = yylex();
} while (token != 0);


  fclose(inputFile);

  return 0;
}

