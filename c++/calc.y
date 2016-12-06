%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <vector>
#include <string>
#include <iostream>
#include <map>
//#include <boost/lexical_cast.hpp>

using namespace std;
map<string, vector<int> > functions;
map<string, vector<float> > f_values;
map<string, string> f_colors;
vector<int> postfixedexp;
vector<float> values;
vector<float> pile;
string color;
float xmin = -10, xmax = 10, lines = 0;

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	float fval;
	char *sval;
}

%token<fval> FLOAT
%token<sval> STRING
%token COLOR INTER DRAW
%token PI E X
%token PLUS MINUS MULTIPLY DIVIDE LEFT RIGHT
%token SIN COS SQRT EXP ABS LOG TANH COSH SINH ATAN ASIN ACOS TAN
%token NEWLINE
%left PLUS MINUS EQUAL DOTCOMA
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
		| STRING LEFT X RIGHT EQUAL expression NEWLINE {functions[$1] = postfixedexp; for(int i = 0; i < postfixedexp.size(); i++){postfixedexp.pop_back();} f_values[$1] = values; for(int i = 0; i < values.size(); i++){values.pop_back();} }
		| DRAW STRING COLOR STRING {f_colors[$2]=$4;}
		| DRAW INTER LEFT FLOAT DOTCOMA FLOAT RIGHT {if($4 > $6){xmax = $4; xmin = $6;}else{xmin = $4; xmax = $6;}}
		| DRAW INTER LEFT MINUS FLOAT DOTCOMA FLOAT RIGHT {xmin = -$5; xmax = $7;}
		| DRAW INTER LEFT FLOAT DOTCOMA MINUS FLOAT RIGHT {xmin = -$7; xmax = $4;}
		| DRAW INTER LEFT MINUS FLOAT DOTCOMA MINUS FLOAT RIGHT {if(-$5 > -$8){xmax = -$5; xmin = -$8;}else{xmin = -$5; xmax = -$8;}}
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
		| TAN LEFT expression RIGHT { postfixedexp.push_back(TAN); values.push_back(0);}
		| ACOS LEFT expression RIGHT { postfixedexp.push_back(ACOS); values.push_back(0);}
		| ASIN LEFT expression RIGHT { postfixedexp.push_back(ASIN); values.push_back(0);}
		| ATAN LEFT expression RIGHT { postfixedexp.push_back(ATAN); values.push_back(0);}
		| SINH LEFT expression RIGHT { postfixedexp.push_back(SINH); values.push_back(0);}
		| COSH LEFT expression RIGHT { postfixedexp.push_back(COSH); values.push_back(0);}
		| TANH LEFT expression RIGHT { postfixedexp.push_back(TANH); values.push_back(0);}
		| LOG LEFT expression RIGHT { postfixedexp.push_back(LOG); values.push_back(0);}
		| ABS LEFT expression RIGHT { postfixedexp.push_back(ABS); values.push_back(0);}
;

%%

float depiler_operande(int func, int i, string name){
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
			if(f_values[name][i] == 0  && functions[name][i-1] != X){
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
		case TAN:
			return(tan(v1));
			break;
		case ACOS:
			return(acos(v1));
			break;
		case ASIN:
			return(asin(v1));
			break;
		case ATAN:
			return(atan(v1));
			break;
		case SINH:
			return(sinh(v1));
			break;
		case COSH:
			return(cosh(v1));
			break;
		case TANH:
			return(tanh(v1));
			break;
		case LOG:
			return(log(v1));
			break;

	}
}

int main() {

	yyin = stdin;
	do {
		yyparse();
	} while(!feof(yyin));

	map<string, vector<int> >::iterator it;
	cout << "{"<<endl;
	float step = (xmax-xmin)/100;
	for(it = functions.begin(); it != functions.end(); it++){
		if(it!=functions.begin()){
			cout << "," << endl;
		}
		cout << "\""<<it->first<<"\":["<<endl;
		for( float x = xmin; x <= xmax; x+=step){
			if(x > xmin){
				cout <<"," << endl;
			}else{
				cout << "{\"color\":\""<<f_colors[it->first]<<"\"},"<<endl;
			}
			int i = 0;
			while(i < it->second.size()){
				if(it->second[i] == FLOAT){
					pile.push_back(f_values[it->first][i]);
				}else if(it->second[i] == X){
					pile.push_back(x);
				}else{
					pile.push_back(depiler_operande(it->second[i], i, it->first));
				}
				i++;
			}
			cout << "{\"x\":\"" << x << "\" , \"y\":\"" << pile.back() << "\"}";
			//cout << it->first << "(" << x << ") = " << pile.back() << endl;
		}
		cout <<"]" << endl;
	}
	cout <<"}";

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
