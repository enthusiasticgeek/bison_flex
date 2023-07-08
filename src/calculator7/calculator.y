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
double factorial(double x);  // Function prototype for factorial calculation
%}

%code requires {
  typedef double YYSTYPE;
  #define YYSTYPE_IS_DECLARED
}

%token NUMBER
%token SQUARE
%token SQUARE_ROOT
%token PERCENT
%token OF
%token MODULO
%token PI
%token FACTORIAL
%token SIN
%token COS
%token TAN
%token ASIN
%token ACOS
%token ATAN
%token LOG
%token LN
%token ABS
%token INV
%token EULER
%left '+' '-'
%left '*' '/'
%left UMINUS

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
    | term MODULO factor { $$ = fmod($1, $3); }  // Rule for modulo operator
    | PI              { $$ = M_PI; }  // Rule for pi constant
    | term '^' factor { $$ = pow($1, $3); }  // Rule for exponentiation
    | term FACTORIAL { $$ = factorial($1); }  // Rule for factorial calculation
    | EULER { $$ = 2.718281828459045; }  // Rule for Euler's number
    ;

factor: NUMBER { $$ = $1; }
      | '-' factor %prec UMINUS { $$ = -$2; }  // Rule for unary minus (right associativity)
      | '(' exp ')' { $$ = $2; }
      | SQUARE factor { $$ = square($2); }
      | SQUARE_ROOT factor { $$ = square_root($2); }
      | FACTORIAL factor { $$ = factorial($2); }
      | SIN factor { $$ = sin($2); }  // Rule for sine calculation
      | COS factor { $$ = cos($2); }  // Rule for cosine calculation
      | TAN factor { $$ = tan($2); }  // Rule for tangent calculation
      | ASIN factor { $$ = asin($2); }  // Rule for arcsine calculation
      | ACOS factor { $$ = acos($2); }  // Rule for arccosine calculation
      | ATAN factor { $$ = atan($2); }  // Rule for arctangent calculation
      | LOG factor { $$ = log($2); }  // Rule for logarithm calculation
      | LN factor { $$ = log($2) / log(2.718281828459045); }  // Rule for natural logarithm calculation (base e)
      | ABS factor { $$ = fabs($2); }  // Rule for abs
      | INV factor { $$ = (1/$2); }  // Rule for inversion
      | NUMBER PERCENT OF factor { $$ = $2 * ($4 / 100.0); }  // Rule for percentage calculation
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

double factorial(double x) {
  double result = 1;
  for (int i = 1; i <= x; i++) {
    result *= i;
  }
  return result;
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

