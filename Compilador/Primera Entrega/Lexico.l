%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
FILE  *yyin;
int yylval;

%}
%option noyywrap  
%option yylineno 

ENTERO      			[0-9]
LETRA		        	[a-zA-Z]
CONST_INT               {ENTERO}+
CONST_FLOAT		        {ENTERO}+"."{ENTERO}+
CONST_STRING            "({LETRA}|{ENTERO}|.)+"
COMA                    ","
T_ID			        {LETRA}({LETRA}|{ENTERO}|_)*
OP_COMP_MENOR           "<"
OP_COMP_MAYOR           ">"
OP_SUMA                 "+"
OP_RESTA                "-"
OP_MUL                  "*"
OP_DIV                  "/"
OP_ASIG   		        "="
OP_LOG_AND              AND"
OP_LOG_OR               "OR"
OP_LOG_NOT              "NOT"
C_A                     "["
C_C                     "]"
P_A                     "("
P_C                     ")"

CADENA                  ({LETRA}|{ENTERO}|_|\n|\s|\t|\r)*
COMENTARIOS             -\/{CADENA}\/-|-\/{CADENA}-\/{CADENA}\/-\{CADENA}/-

%%

"="			            { return ASIG;}
"+"			            { return OP_SUMA;}
"-"			            { return OP_RESTA;}
"*"			            { return OP_MUL;}
"/"			            { return OP_DIV;}
"("			            { return P_A;}
")"			            { return P_C;}
"["			            { return C_A;}
"]"			            { return C_C;}
"<"			            { return OP_MAYOR;}
">"			            { return OP_MENOR;}
"NOT"			        { return OP_NOT;}
{T_ID}		            { return T_ID;}
"WHILE"		            { return T_WHILE;}
"ENDWHILE"		        { return T_ENDWHILE;}
"IF"     		        { return T_IF;}
"ELSE"			        { return T_ELSE;}
"ENDIF"			        { return T_ENDIF;}
"WRITE"			        { return T_WRITE;}
"READ"			        { return T_READ;}
"DECVAR"	            { return T_DECVAR;}
"ENDDECVAR"		        { return T_ENDDECVAR;}
"AVG"		            { return T_AVG;}
"STRING"		        { return T_INT;}
"INT"		            { return T_STRING;}
"FLOAT"		            { return T_FLOAT;}
{CONST_INT}		        { return CONST_INT;}
{CONST_STRING}		    { return CONST_STRING;}
{CONST_FLOAT}		    { return CONST_FLOAT;}
{COMA}		            { return COMA;}
{ENTERO}+	            { yylval = atoi( yytext ) ;return ENTERO;}

"\n"      		
"\t"


