%option noyywrap

%{
#include <stdio.h>
#include <vector>
#include <string>
using namespace std;

#define YY_DECL int yylex()

#include "calc.tab.h"

%}

%%

[ \t]	; // ignore all whitespace
[0-9]+\.[0-9]+ 	{yylval.fval = atof(yytext); return FLOAT;}
[0-9]+		{yylval.fval = atof(yytext); return FLOAT;}
\n		{return NEWLINE;}
"="   {return EQUAL;}
";"   {return DOTCOMA;}
"+"		{return PLUS;}
"-"		{return MINUS;}
"*"		{return MULTIPLY;}
"/"		{return DIVIDE;}
"("		{return LEFT;}
")"		{return RIGHT;}
"sin"     {return SIN;}
"cos"     {return COS;}
"tan"     {return TAN;}
"acos"     {return ACOS;}
"asin"     {return ASIN;}
"atan"     {return ATAN;}
"sinh"     {return SINH;}
"cosh"     {return COSH;}
"tanh"     {return TANH;}
"log"     {return LOG;}
"sqrt"    {return SQRT;}
"pi"      {return PI;}
"^"       {return POW;}
"e"       {return E;}
"x"       {return X;}
"exp"     {return EXP;}
"abs"     {return ABS;}
[a-zA-Z]+ {yylval.sval = strdup(yytext); return STRING;}
"between " {return INTER;}
"in color " {return COLOR;}
"draw "      {return DRAW;}

%%
