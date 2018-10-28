
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "symbol_table.h"
#include "queue.h"
#include "queue.c"
#include "string_tools.h"
#include "string_tools.c"
#include "stack.c"

#define YYDEBUG 1

int yystopparser=0;
char *yyltext;
char *yytext;

/* The symbol table: a chain of 'struct symrec'.  */
symrec *sym_table;
m10_stack_t *st;
m10_stack_t *stIdType;
t_queue queue;
t_queue pos_queue;
int current_pos;
char pos_str[30];
int func_avg_terms_counter = 0;

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

read: T_READ ID { enqueue(&queue, $2); enqueue(&queue, "READ"); };

write: T_WRITE ID { checkExist($2); enqueue(&queue, $2); enqueue(&queue, "WRITE"); }
	| T_WRITE CONST_STR { enqueue(&queue, yylval.str_val); enqueue(&queue, "WRITE"); }
;

avg: T_AVG '(' '[' lista_expr ']' ')' { 
		char str[16];
		sprintf(str, "%d", func_avg_terms_counter); 
		enqueue(&queue, str); 
		enqueue(&queue, "/"); 
	}
;

lista_expr: lista_expr ','  expresion { func_avg_terms_counter++; enqueue(&queue, "+"); }
	| expresion { func_avg_terms_counter++; }
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

lista_ids: lista_ids ',' ID { push(st,$3); }
	| ID { push(st,$1); }
; 

defvar: T_DEFVAR bloque_def T_ENDDEFVAR
;

while : T_WHILE '(' condicion ')' bloque T_ENDWHILE;

if : 
	/*T_IF '(' condicion ')' { 
		enqueue(&queue, "CMP"); 
		enqueue(&queue, "BGE"); 
		enqueue(&queue, ""); 
		current_pos = queue.last->pos; 
		enqueue(&pos_queue, itoa(current_pos, 10)); 
	} bloque { 
		current_pos = queue.last->pos; 
		dequeue(&pos_queue, pos_str); 
		set_in_pos_in_queue(&queue, atoi(pos_str), itoa(current_pos, 10)); 
	} T_ENDIF
	
	| T_IF '(' condicion ')' bloque T_ELSE { 
		enqueue(&queue, "BI"); 
		current_pos = queue.last->pos; 
		dequeue(&pos_queue, pos_str); 
		set_in_pos_in_queue(&queue, atoi(pos_str), itoa(current_pos, 10)+1); 
		enqueue(&pos_queue, itoa(current_pos, 10));
	} bloque { 
		current_pos = queue.last->pos; 
		dequeue(&pos_queue, pos_str);
		set_in_pos_in_queue(&queue, atoi(pos_str), itoa(current_pos, 10)); 
	} T_ENDIF*/ // TODO ver como resolver el conflicto de Shift / Reduce del IF cuando se ponen AS en el medio.
	T_IF '(' condicion ')' { 
		enqueue(&queue, "CMP"); 
		enqueue(&queue, "BGE"); 
		enqueue(&queue, ""); 
		current_pos = queue.last->pos; 
		enqueue(&pos_queue, itoa(current_pos, 10)); 
	} bloque endif
;

endif:
	{ 
		current_pos = queue.last->pos; 
		dequeue(&pos_queue, pos_str); 
		set_in_pos_in_queue(&queue, atoi(pos_str), itoa(current_pos+1, 10)); 
	} T_ENDIF
	| T_ELSE { 
		enqueue(&queue, "BI"); 
		current_pos = queue.last->pos; 
		dequeue(&pos_queue, pos_str); 
		set_in_pos_in_queue(&queue, atoi(pos_str), itoa(current_pos+2, 10)); 
		enqueue(&pos_queue, itoa(current_pos, 10));
	} bloque 
	{ 
		current_pos = queue.last->pos; 
		dequeue(&pos_queue, pos_str);
		set_in_pos_in_queue(&queue, atoi(pos_str), itoa(current_pos+1, 10)); 
	} T_ENDIF

lista_ids_asig: lista_ids_asig '=' ID { push(st,$3); enqueue(&queue, $3); enqueue(&queue, "="); }
	| ID { push(st,$1); enqueue(&queue, $1); }
;

asignacion: lista_ids_asig '=' CONST_STR  { checkListIDExist(); enqueue(&queue, yylval.str_val); enqueue(&queue, "="); }
	| lista_ids_asig '=' expresion { checkListIDExist(); enqueue(&queue, "="); }
;		

condicion:
	cond_termino// { verifyTypeOp(); }
   	| condicion '<' cond_termino { enqueue(&queue, "<"); }
   	| condicion '>' cond_termino { enqueue(&queue, ">"); }
   	| condicion OP_GE cond_termino { enqueue(&queue, ">="); }
   	| condicion OP_LE cond_termino { enqueue(&queue, "<="); }
   	| condicion OP_NE cond_termino { enqueue(&queue, "!="); }
   	| condicion OP_NE CONST_STR { enqueue(&queue, yylval.str_val); enqueue(&queue, "!="); }
   	| condicion OP_EQ cond_termino { enqueue(&queue, "=="); }
   	| condicion OP_OR cond_termino { enqueue(&queue, "||"); }
;	

cond_termino: 
	cond_factor
	| cond_termino OP_AND cond_factor { enqueue(&queue, "&&"); }
;

cond_factor: 
	ID { enqueue(&queue, $1); }
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
;

expresion:
	termino// { verifyTypeOp(); }
	| expresion '-' termino { enqueue(&queue, "-"); }
   	| expresion '+' termino { enqueue(&queue, "+"); }
;

termino: 
	factor
	| termino '*' factor { enqueue(&queue, "*"); }
	| termino '/' factor { enqueue(&queue, "/"); }
;

factor: 
	ID { enqueue(&queue, $1); }
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
	init_queue(&pos_queue);
  	
  	yydebug = 1;

  	yyin = pf;
	yyparse();
  	
	printf("Polaca Inversa:\n");
	print_queue(&queue);
	pretty_print_queue(&queue);

  	fclose(pf);
	clear(st);
	clear(stIdType);
	free_queue(&queue);
	free_queue(&pos_queue);

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