%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "calc.tab.h"

%}

%%

[ \t]	; // ignore all whitespace
[0-9]+\.[0-9]+ 	{yylval.fval = atof(yytext); return FLOAT;}
[0-9]+		{yylval.fval = atof(yytext); return FLOAT;}
\n		{return NEWLINE;}
"+"		{return PLUS;}
"-"		{return MINUS;}
"*"		{return MULTIPLY;}
"/"		{return DIVIDE;}
"("		{return LEFT;}
")"		{return RIGHT;}
"exit"		{return QUIT;}
"quit"		{return QUIT;}
"sin"     {return SIN;}
"cos"     {return COS;}
"sqrt"    {return SQRT;}
"pi"      {return PI;}
"^"       {return POW;}
"e"       {return E;}
"x"       {return X;}
"exp"     {return EXP;}
"abs"     {return ABS;}

%%
