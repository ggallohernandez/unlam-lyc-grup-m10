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
T_ID			        {LETRA}({LETRA}|{ENTERO}|_)*


CADENA                  ({LETRA}|{ENTERO}|_|\n|\s|\t|\r)*
COMENTARIOS             -\/{CADENA}\/-|-\/{CADENA}-\/{CADENA}\/-\{CADENA}/-

%%

"="     { return OP_ASIG;}
"+"		{ return OP_SUMA;}
"-"		{ return OP_RESTA;}
"*"		{ return OP_MUL;}
"/"		{ return OP_DIV;}
"("		{ return P_A;}
")"		{ return P_C;}
"["		{ return C_A;}
"]"		{ return C_C;}
"<"		{ return OP_MAYOR;}
">"		{ return OP_MENOR;}
"NOT"   { return OP_NOT;}
{T_ID}  { yylval.str_val = yytext; printf( "Identificador en lexico: %s (%s)\n", yytext,yylval.str_val); return T_ID;}
"WHILE" { return T_WHILE;}
"ENDWHILE"  { return T_ENDWHILE;}
"IF"     	{ return T_IF;}
"ELSE"		{ return T_ELSE;}
"ENDIF"     { return T_ENDIF;}
"WRITE"		{ return T_WRITE;}
"READ"		{ return T_READ;}
"DECVAR"	{ return T_DECVAR;}
"ENDDECVAR"	{ return T_ENDDECVAR;}
"AVG"		{ return T_AVG;}
"STRING"	{ return T_INT;}
"INT"		{ return T_STRING;}
"FLOAT"		{ return T_FLOAT;}
","		    { return COMA;}
{CONST_STRING}      { yylval.str_val = yytext; printf( "String en lexico: %s (%s)\n", yytext,yylval.str_val); return CONST_STRING;}
{CONST_FLOAT}       { yylval.val = atof(yytext); printf( "Float en lexico: %s (%f)\n", yytext,yylval.val) ; return CONST_FLOAT;}
{CONST_INT}         { yytext,yylval.intval;  printf( "Entero en lexico: %s (%d)\n", yytext,yylval.intval); return ENTERO;}


"\n"      		
"\t"


