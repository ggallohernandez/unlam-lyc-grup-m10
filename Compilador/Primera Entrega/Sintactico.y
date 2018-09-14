
%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
int yylval;
int yystopparser=0;
FILE  *yyin;
char *yyltext;
char *yytext;

%}

%token ID
%token ENTERO
%token OP_SUMA 
%token OP_RESTA 
%token OP_MUL 
%token OP_DIV  
%token ASIG 
%token P_A P_C 
%token C_MAYOR C_MENOR 
%token C_NOT 
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
%token T_ID
%token CONST_INT
%token CONST_STRING
%token CONST_FLOAT
%token COMA


%%

seleccion: 
    	 IF {printf("     IF\n");}
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




