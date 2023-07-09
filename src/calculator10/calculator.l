%{
#include <stdio.h>
#include <stdlib.h>
#include "calculator.tab.h"
int line_num = 0;
double square(double x);
double square_root(double x);
double factorial(double x);
void handleIdentifier();
char* strdup(const char* s);
double degreesToRadians(double degrees);
double radiansToDegrees(double radians);
%}

%%
[ \t]+               /* ignore whitespace */
[0-9]+"."[0-9]+      { yylval.number = atof(yytext); return NUMBER; }  // Match floating-point numbers
[0-9]+               { yylval.number = atof(yytext); return NUMBER; }  // Match integers and convert to double
\n                   { ++line_num; return '\n'; }
"square"             { return SQUARE; }  // Match the "square" function name
"square_root"        { return SQUARE_ROOT; }  // Match the "square_root" function name
"%"                  { return PERCENT; }  // Match the "%" operator
"percent"            { return PERCENT; }  // Match the "%" operator
"of"                 { return OF; }  // Match the "OF" keyword
"to"                 { return TO; }  // Match the "TO" keyword
"mod"                { return MODULO; }  // Match the "mod" keyword for modulo operator
"pi"                 { return PI; }  // Match the "pi" constant
"!"                  { return FACTORIAL; }  // Match the "!" operator for factorial
"factorial"          { return FACTORIAL; }  // Match the "!" operator for factorial
"^"                  { return '^'; }  // Match the "%" operator
"sin"                { return SIN; }  // Match the "sin" function name
"cos"                { return COS; }  // Match the "cos" function name
"tan"                { return TAN; }  // Match the "tan" function name
"asin"               { return ASIN; }  // Match the "asin" function name
"acos"               { return ACOS; }  // Match the "acos" function name
"atan"               { return ATAN; }  // Match the "atan" function name
"log"                { return LOG; }  // Match the "log" function name
"ln"                 { return LN; }  // Match the "ln" function name
"abs"                { return ABS; }  // Match the "abs" function name
"inv"                { return INV; }  // Match the "inv" function name
"euler"              { return EULER; }  // Match the "inv" function name
"degrees"            { return DEGREES; }  // Match the "degrees" keyword
"radians"            { return RADIANS; }  // Match the "radians" keyword
[a-zA-Z][a-zA-Z0-9]* { handleIdentifier(); return IDENTIFIER; }  // Match identifiers
.                    { return yytext[0]; }
%%


