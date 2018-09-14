
%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"

int yystopparser=0;
FILE  *yyin;
char *yyltext;
char *yytext;

%}

%union {
int intval;
double val;
char *str_val;
}

 
%token OP_SUMA 
%token OP_RESTA 
%token OP_MUL 
%token OP_DIV 
%token OP_ASIG 
%token P_A P_C
%token T_WHILE T_ENDWHILE 
%token T_IF T_ELSE T_ENDIF
%token T_WRITE T_READ 
%token T_DECVAR T_ENDDECVAR 
%token T_AVG
%token T_INT 
%token T_STRING 
%token T_FLOAT
%token C_A C_C
%token OP_MAYOR OP_MENOR OP_NOT
%token <str_val>ID
%token <int>ENTERO
%token <str_val>CONST_STR
%token <double>CONST_FL
%token COMAA

%%

programa : asignacion {printf("OK\n");}

asignacion: ID OP_ASIG expresion
;
		
expresion:
         termino
	 |expresion OP_RESTA termino {printf("Resta OK\n");}
       |expresion OP_SUMA termino  {printf("Suma OK\n");}

 	 ;

termino: 
       factor
       |termino OP_MUL factor  {printf("Multiplicacion OK\n");}
       |termino OP_DIV factor  {printf("Division OK\n");}
       ;

factor: 
      ID 
      | ENTERO {$1 = yylval ;printf("ENTERO es: %d\n", yylval);}
      |P_A expresion P_C  
    ;

int main(int argc,char *argv[])
{
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
	yyparse();
  }
  fclose(yyin);
  return 0;
}
int yyerror(void)
     {
       printf("Syntax Error\n");
	 system ("Pause");
	 exit (1);
     }




