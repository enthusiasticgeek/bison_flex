%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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
void handleIdentifier();
char* strdup(const char* s);

typedef struct {
  double value;
  char* name;
} Variable;

Variable* variables[100];  // Array to store variables
int var_count = 0;

Variable* getVariable(const char* name) {
  for (int i = 0; i < var_count; i++) {
    if (strcmp(variables[i]->name, name) == 0) {
      return variables[i];
    }
  }
  return NULL;
}

Variable* createVariable(const char* name, double value) {
  Variable* var = malloc(sizeof(Variable));
  if (var == NULL) {
    fprintf(stderr, "Failed to allocate memory for variable.\n");
    exit(1);
  }
  var->name = strdup(name);
  var->value = value;
  variables[var_count++] = var;
  return var;
}

void assignValue(Variable* var, double value) {
  var->value = value;
}

double degreesToRadians(double degrees) {
  return degrees * M_PI / 180.0;
}

double radiansToDegrees(double radians) {
  return radians * 180.0 / M_PI;
}

%}


%union {
  double number;
  char* string;
}

%token <number> NUMBER
%token <number> SQUARE
%token <number> SQUARE_ROOT
%token <number> PERCENT
%token <number> OF
%token <number> TO
%token <number> MODULO
%token <number> PI
%token <number> FACTORIAL
%token <number> SIN
%token <number> COS
%token <number> TAN
%token <number> ASIN
%token <number> ACOS
%token <number> ATAN
%token <number> LOG
%token <number> LN
%token <number> ABS
%token <number> INV
%token <number> EULER
%token <number> DEGREES
%token <number> RADIANS
%token <string> IDENTIFIER
%left '+' '-'
%left '*' '/'
%left <number> UMINUS

%type <number> exp term factor assignment

%%

input: /* empty */
     | input line
     ;

line: '\n'
    | exp '\n' { printf("[line %d] Result: %lf\n", line_num, $1); }  // Print result
    ;

exp: assignment
   | exp '+' assignment { $$ = $1 + $3; }
   | exp '-' assignment { $$ = $1 - $3; }
   ;

assignment: term
          | IDENTIFIER '=' assignment {
              Variable* var = getVariable($1);
              if (var == NULL) {
                var = createVariable($1, $3);
              } else {
                assignValue(var, $3);
              }
              $$ = $3;
            }
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
      | IDENTIFIER { Variable* var = getVariable($1); if (var != NULL) $$ = var->value; }
      | NUMBER TO RADIANS { $$ = degreesToRadians($1); }  // Rule for degrees to radians conversion
      | NUMBER TO DEGREES { $$ = radiansToDegrees($1); }  // Rule for radians to degrees conversion
      ;

%%

void handleIdentifier() {
  yylval.string = strdup(yytext);
}

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

char* strdup(const char* s) {
  size_t len = strlen(s);
  char* copy = malloc(len + 1);
  if (copy == NULL) {
    fprintf(stderr, "Failed to allocate memory.\n");
    exit(1);
  }
  strcpy(copy, s);
  return copy;
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

