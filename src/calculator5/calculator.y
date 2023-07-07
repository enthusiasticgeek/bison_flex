%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "calculator.tab.h"

extern int yylex();
extern int yylineno;
extern char* yytext;
extern FILE *yyin;
extern int line_num;

void yyerror(const char* msg);
double square_root(double x);
double square(double x);
%}

%code requires {
  typedef double YYSTYPE;
  #define YYSTYPE_IS_DECLARED
}

%token NUMBER
%token SQUARE
%token SQUARE_ROOT
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
      | SQUARE factor { $$ = square($2); }  // Rule for square function
      | SQUARE_ROOT factor { $$ = square_root($2); }  // Rule for square root function
      ;

%%

void yyerror(const char* msg) {
  fprintf(stderr, "Syntax Error at line %d: %s. Near token: %s\n", yylineno, msg, yytext);
}

double square(double x) {
  return x * x;
}

double square_root(double x) {
  return sqrt(x);
}


int main() {
  FILE* inputFile = fopen("input.txt", "r");
  if (inputFile == NULL) {
    printf("Failed to open the input file.\n");
    return 1;
  }
  yyin = inputFile;

  int token;
  do {
    yyparse();
    token = yylex();
  } while (token != 0);

  fclose(inputFile);

  return 0;
}

