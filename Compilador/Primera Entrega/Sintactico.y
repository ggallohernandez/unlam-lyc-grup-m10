
%{
#include <stdio.h>
#include <stdlib.h>
#include "symbol_table.h"

#define YYDEBUG 1

int yystopparser=0;
char *yyltext;
char *yytext;

/* The symbol table: a chain of 'struct symrec'.  */
symrec *sym_table;

// stuff from flex that bison needs to know about:
extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;

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
%token T_DEFVAR T_ENDDEFVAR 
%token T_AVG
%token T_INT 
%token T_STRING 
%token T_FLOAT
%token OP_COMPARADOR
%token OP_AND OP_OR OP_NOT
%token OP_GE OP_LE OP_NE OP_EQ  
%token <str_val>ID
%token <bool>CONST_BOOL
%token <int>ENTERO
%token <str_val>CONST_STR
%token <double>CONST_FL

%%

programa: bloqueprogram
	| bloque_main
;

bloqueprogram: defvar bloque_main
;

bloque_main: bloque
;

bloque: sentencia
	| bloque sentencia
;

sentencia: if
	| while
	| read
	| write
	| asignacion
;

read: T_READ ID;

write: T_WRITE ID
	| T_WRITE CONST_STR
;

avg: T_AVG '(' '[' lista_expr ']' ')'
;

lista_expr: lista_expr ','  expresion
	| expresion
;

bloque_def: sentencia_def
	| bloque_def sentencia_def
;

sentencia_def: asignacion_def
; 

asignacion_def: lista_ids ':' T_FLOAT
	| lista_ids ':' T_STRING
	| lista_ids ':' T_INT
;

lista_ids: lista_ids ',' ID
	| ID
; 

defvar: T_DEFVAR bloque_def T_ENDDEFVAR
;

while : T_WHILE '(' expresion ')' bloque T_ENDWHILE;

if : T_IF '(' expresion ')' bloque T_ELSE bloque T_ENDIF
	| T_IF '(' expresion ')' bloque T_ENDIF
;

asignacion: ID '=' asignacion
	| ID '=' CONST_STR
	| ID '=' expresion
;
		
expresion:
	termino
	| expresion '-' termino { printf("Resta OK\n"); }
   	| expresion '+' termino  { printf("Suma OK\n"); }
   	| expresion '<' termino  { printf("LT OK\n"); }
   	| expresion '>' termino  { printf("GT OK\n"); }
   	| expresion OP_GE termino  { printf("GE OK\n"); }
   	| expresion OP_LE termino  { printf("LE OK\n"); }
   	| expresion OP_NE termino  { printf("NE OK\n"); }
   	| expresion OP_NE CONST_STR { printf("NE OK\n"); }
   	| expresion OP_EQ termino  { printf("EQ OK\n"); }
   	| expresion OP_OR termino  { printf("OR OK\n"); }
   	| expresion OP_COMPARADOR termino  { printf("COMP OK\n"); }
;

termino: 
	factor
	| termino '*' factor  { printf("Multiplicacion OK\n"); }
	| termino '/' factor  { printf("Division OK\n"); }
	| termino OP_AND factor  { printf("AND OK\n"); }
;

factor: 
	ID 
	| ENTERO { printf("ENTERO es:\n"); }
	| CONST_FL
	| CONST_BOOL
	| avg
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
  	
  	yydebug = 1;

  	yyin = pf;
	yyparse();
  	
  	fclose(pf);

  	return 0;
}

void yyerror(const char *s)
{
	printf("Syntax Error en linea %d : %s\n", yylineno, s);
	printf("Press a key to continue ... ");
	getchar();

	exit(-1);
}

