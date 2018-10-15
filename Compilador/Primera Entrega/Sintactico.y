
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "symbol_table.h"
#include "queue.h"
#include "queue.c"
#include "stack.c"

#define YYDEBUG 1

int yystopparser=0;
char *yyltext;
char *yytext;

/* The symbol table: a chain of 'struct symrec'.  */
symrec *sym_table;
stack_t *st;
stack_t *stIdType;
t_queue queue;

// stuff from flex that bison needs to know about:
extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;

void yyerror(const char *);
void setType(int );
void checkExist(const char *);
void checkListIDExist(void );
void verifyTypeOp(void );

%}

%union {
	int intval;
	bool bool_val;
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
%token <bool_val>CONST_BOOLEAN
%token <intval>ENTERO
%token <str_val>CONST_STR
%token <val>CONST_FL
%left '-' '+'
%left '*' '/'

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

write: T_WRITE ID { checkExist($2); }
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

asignacion_def: lista_ids ':' T_FLOAT { setType(DT_FLOAT);}
	| lista_ids ':' T_STRING { setType(DT_STRING);}
	| lista_ids ':' T_INT { setType(DT_INT);}
;

lista_ids: lista_ids ',' ID { push(st,$3);}
	| ID { push(st,$1);}
; 

defvar: T_DEFVAR bloque_def T_ENDDEFVAR
;

while : T_WHILE '(' expresion ')' bloque T_ENDWHILE;

if : T_IF '(' expresion ')' bloque T_ELSE bloque T_ENDIF
	| T_IF '(' expresion ')' bloque T_ENDIF
;

lista_ids_asig: lista_ids_asig '=' ID { push(st,$3);}
	| ID { push(st,$1);}
; 

asignacion: lista_ids_asig '=' CONST_STR  { checkListIDExist(); }
	| lista_ids_asig '=' expresion { checkListIDExist(); }
;		

expresion:
	termino// { verifyTypeOp(); }
	| expresion '-' termino
   	| expresion '+' termino
   	| expresion '<' termino
   	| expresion '>' termino
   	| expresion OP_GE termino
   	| expresion OP_LE termino
   	| expresion OP_NE termino
   	| expresion OP_NE CONST_STR
   	| expresion OP_EQ termino
   	| expresion OP_OR termino
   	| expresion OP_COMPARADOR termino
;

termino: 
	factor
	| termino '*' factor
	| termino '/' factor
	| termino OP_AND factor
;

factor: 
	ID //{ checkExist($1);} push(stIdType,$1); }
	| ENTERO  { 
		char str[16];
		sprintf(str, "%d", yylval.intval); 
		enqueue(&queue, str); 
	}
	| CONST_FL { 
		char str[16];
		sprintf(str, "%.2f", yylval.val); 
		enqueue(&queue, str); 
	}
	| CONST_BOOLEAN { enqueue(&queue, ($1 ? "true" : "false")); }
	| avg
	| '(' expresion ')'
	| '-' ID %prec OP_NOT /* TODO GG: Verificar si esta regla es necesaria, no entiendo el sentido. */
	| '-' CONST_FL %prec OP_NOT /* TODO GG: Verificar si esta regla es necesaria, no entiendo el sentido. */
	| '-' ENTERO %prec OP_NOT /* TODO GG: Verificar si esta regla es necesaria, no entiendo el sentido. */
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
	  
    st = newStack();
	stIdType = newStack();

	init_queue(&queue);
  	
  	yydebug = 1;

  	yyin = pf;
	yyparse();
  	
	printf("Polaca Inversa:\n");
	print_queue(&queue);

  	fclose(pf);
	clear(st);
	clear(stIdType);
	free_queue(&queue);

  	return 0;
}

void yyerror(const char *s)
{
	printf("Syntax Error en linea %d : %s\n", yylineno, s);
	printf("Press a key to continue ... ");
	getchar();

	exit(-1);
}

//En el lexico guarde en la tabla de simbolos los ids 
//ahora en el sintactico les asigno el tipo  
void setType(int type)
{
	char idName[11]; 
	symrec *sym;

	while(top(st)!=NULL)
	{	  
	    strcpy(idName,top(st));
		sym = getsym(idName);
		if(sym!=0)
		{
			if(sym->type==DT_UNDEFINED)
			{
				sym->type=type;
			}
			else
			{
				yyerror("Variable ya declarada anteriormente, \n");
			}
		}
		pop(st);
	}
}

void checkExist(const char *s)
{
	symrec *sym;
	sym = getsym(s);
	printf("%s  \n\n\n\n\n",s);
  	if(sym->type==DT_UNDEFINED)
	{
		char error[256];
		snprintf(error, sizeof error, "%s %s", s, "Variable no declarada\n");

		yyerror(error);
	}
}

void checkListIDExist()
{
	char idName[11]; 
	symrec *sym;

	while(top(st)!=NULL)
	{		
	    strcpy(idName,top(st));		
		sym = getsym(idName);
		printf("%s  \n\n\n\n\n",idName);

		if(sym!=0)
		{
			if(sym->type==DT_UNDEFINED)
			{
				char error[256];
				snprintf(error, sizeof error, "%s %s", idName, "Variable no declarada\n");

				yyerror(error);
			}
		}
		pop(st);
	}
}

void verifyTypeOp()
{
	char idName[11]; 
	symrec *sym;
	int idType;

	strcpy(idName,top(stIdType));
	sym = getsym(idName);
	if(sym!=0)
	{
		idType=sym->type;
	}

	while(top(stIdType)!=NULL)
	{	  
	    strcpy(idName,top(stIdType));
		sym = getsym(idName);
		if(sym!=0)
		{
			if(sym->type!=idType)
			{
				yyerror("No coinciden el tipo de dato de cada ID de la expresion \n");
			}
		}
		pop(stIdType);
	}
}