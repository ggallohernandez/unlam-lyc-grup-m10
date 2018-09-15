
%{
#include <stdio.h>
#include <stdlib.h>

int yystopparser=0;
char *yyltext;
char *yytext;

// stuff from flex that bison needs to know about:
extern int yylex();
extern int yyparse();
extern FILE *yyin;

void yyerror(const char *s);

%}

%union {
	int intval;
	double val;
	char *str_val;
}

%token T_WHILE T_ENDWHILE 
%token T_IF T_ELSE T_ENDIF
%token T_WRITE T_READ 
%token T_DECVAR T_ENDDECVAR 
%token T_AVG
%token T_INT 
%token T_STRING 
%token T_FLOAT
%token <str_val>ID
%token <int>ENTERO
%token <str_val>CONST_STR
%token <double>CONST_FL

%%

programa: bloque;

bloque: sentencia
	| bloque sentencia
;

sentencia: if
	| asignacion
;

if : T_IF '(' expresion ')' '{' bloque '}' T_ELSE '{' bloque '}'
	| T_IF '(' expresion ')' T_ELSE '{' bloque '}'
	| T_IF '(' expresion ')'
;

asignacion: ID '=' asignacion
	| ID '=' expresion
;
		
expresion:
	termino
	| expresion '-' termino { printf("Resta OK\n"); }
   	| expresion '+' termino  { printf("Suma OK\n"); }
;

termino: 
	factor
	| termino '*' factor  { printf("Multiplicacion OK\n"); }
	| termino '/' factor  { printf("Division OK\n"); }
;

factor: 
	ID 
	| ENTERO { printf("ENTERO es:\n"); }
	| CONST_FL
	| '(' expresion ')'
;

%%

int main(int argc, char *argv[])
{
	FILE *pf = fopen(argv[1], "rt");

	if (!pf)
  	{
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
		return -1;
  	}
  	
  	yyin = pf;
	yyparse();
  	
  	fclose(pf);

  	return 0;
}

void yyerror(const char *s)
{
	printf("Syntax Error\n");
	printf("Press a key to continue ... ");
	getchar();

	exit(-1);
}

