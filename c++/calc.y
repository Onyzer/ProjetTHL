%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <vector>
#include <string>
#include <iostream>
#include <boost/lexical_cast.hpp>

using namespace std;
vector<int> postfixedexp;
vector<float> values;
vector<float> pile;

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	float fval;
}

%token<fval> FLOAT
%token PI E X
%token PLUS MINUS MULTIPLY DIVIDE LEFT RIGHT
%token SIN COS SQRT EXP ABS
%token NEWLINE QUIT
%left PLUS MINUS
%left MULTIPLY DIVIDE
%left POW

%type<fval> expression

%start calculation

%%

calculation:
	   | calculation line
;

line: NEWLINE
    | expression NEWLINE {}
;

expression: FLOAT                 		 { postfixedexp.push_back(FLOAT); values.push_back($1);}
	  | expression PLUS expression	 { postfixedexp.push_back(PLUS); values.push_back(0);}
	  | expression MINUS expression	 { postfixedexp.push_back(MINUS); values.push_back(0);}
	  | expression MULTIPLY expression { postfixedexp.push_back(MULTIPLY); values.push_back(0);}
	  | expression DIVIDE expression	 { postfixedexp.push_back(DIVIDE); values.push_back(0);}
		| LEFT expression RIGHT		 {}
		| SIN LEFT expression RIGHT { postfixedexp.push_back(SIN); values.push_back(0);}
		| COS LEFT expression RIGHT { postfixedexp.push_back(COS); values.push_back(0);}
		| SQRT LEFT expression RIGHT { postfixedexp.push_back(SQRT); values.push_back(0);}
		| PI { postfixedexp.push_back(FLOAT); values.push_back(3.141592);}
		| E { postfixedexp.push_back(FLOAT); values.push_back(2.718282);}
		| X { postfixedexp.push_back(X); values.push_back(0);}
		| MINUS expression { postfixedexp.push_back(MINUS); values.push_back(-$2);}
		| expression POW expression { postfixedexp.push_back(POW); values.push_back(0);}
		| EXP LEFT expression RIGHT { postfixedexp.push_back(EXP); values.push_back(0);}
		| ABS LEFT expression RIGHT { postfixedexp.push_back(ABS); values.push_back(0);}
;

%%

float depiler_operande(int func, int i){
	float v1 = pile.back();
	pile.pop_back();
	float v2;
	switch (func){
		case PLUS:
				v2 = pile.back();
				pile.pop_back();
				return(v2+v1);
			break;
		case MINUS:
			if(values[i] == 0){
				v2 = pile.back();
				pile.pop_back();
				return(v2-v1);
			}else{
				return(-v1);
			}
			break;
		case MULTIPLY:
			v2 = pile.back();
			pile.pop_back();
			return(v2*v1);
			break;
		case DIVIDE:
			v2 = pile.back();
			pile.pop_back();
			return(v2/v1);
			break;
		case POW:
			v2 = pile.back();
			pile.pop_back();
			return(pow(v2,v1));
			break;
		case ABS:
			return(abs(v1));
			break;
		case SIN:
			return(sin(v1));
			break;
		case COS:
			return(cos(v1));
			break;
		case SQRT:
			return(sqrt(v1));
			break;
		case EXP:
			return(exp(v1));
			break;


	}
}

int main() {

	yyin = stdin;
	vector<int>::iterator it;
	do {
		yyparse();
	} while(!feof(yyin));

	for( float x = -10; x <= 10; x++){
		int i = 0;
		while(i < postfixedexp.size()){
			if(postfixedexp[i] == FLOAT){
				pile.push_back(values[i]);
			}else if(postfixedexp[i] == X){
				pile.push_back(x);
			}else{
				pile.push_back(depiler_operande(postfixedexp[i], i));
			}
			i++;
		}
		cout << "f(" << x << ") = " << pile.back() << endl;
	}

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
