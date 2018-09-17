%{

#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

%}

%option noyywrap  
%option yylineno 

ENTERO      			[0-9]
LETRA		        	[a-zA-Z]
CONST_INT               {ENTERO}+
CONST_FLOAT		        {ENTERO}+\.{ENTERO}*|{ENTERO}*\.{ENTERO}+
CONST_STRING            \"{CADENA}\"
T_ID			        {LETRA}({LETRA}|{ENTERO}|\_)*
CADENA                  ({LETRA}|{ENTERO}|\.|\:|\;\-|\_|\!|_|" "|\n|\s|\t|\r)*
COMENTARIOS             -\/{CADENA}\/-|-\/{CADENA}-\/{CADENA}\/-{CADENA}\/-|-\/-\/{CADENA}\/-{CADENA}\/-|-\/{CADENA}-\/{CADENA}\/-\/-

%%

"="     	|
"+"			|
"-"			|
"*"			|
"/"			|
"("			|
")"			|
"["			|
"]"			|
":"			|
","			{ return yytext[0]; }
"<"			|
">"			|
">="		|
"<="		|
"=="		{ printf("OP_COMPARADOR"); return OP_COMPARADOR; }			
"true"		|
"false"		{ printf("BOOL "); return CONST_BOOL; }
"&&"		|
"AND"		{ printf("AND "); return OP_AND; }
"||"		|
"OR"		{ printf("OR "); return OP_OR; }
"!"			|
"NOT"   	{ printf("NOT "); return OP_NOT; }
"WHILE" 	{ printf("WHILE "); return T_WHILE; }
"ENDWHILE"  { printf("ENDWHILE \n"); return T_ENDWHILE; }
"IF"     	{ printf("IF "); return T_IF; }
"ELSE"		{ printf("ELSE "); return T_ELSE; }
"ENDIF"     { printf("ENDIF "); return T_ENDIF; }
"READ"		{ printf("READ "); return T_READ; }
"DEFVAR"	{ printf("DEFVAR "); return T_DEFVAR; }
"ENDDEFVAR"	{ printf("ENDDEFVAR \n"); return T_ENDDEFVAR; }
"AVG"		{ printf("AVG "); return T_AVG; }
"STRING"	{ printf("STRING "); return T_STRING; }
"INT"		{ printf("INT "); return T_INT; }
"FLOAT"		{ printf("FLOAT "); return T_FLOAT; }
"WRITE"		{ printf("WRITE"); return T_WRITE; }
{T_ID}  	{ printf("ID "); yylval.str_val = yytext; return ID; }
{CONST_STRING}      { yylval.str_val = yytext; printf("CONST_STR \n"); return CONST_STR; }
{CONST_FLOAT}       { printf("CONST_FLOAT \n"); yylval.val = atof(yytext); return CONST_FL; }
{CONST_INT}         { printf("CONT_INT \n"); yytext,yylval.intval; return ENTERO; }

"\n"	
"\t"
{COMENTARIOS}

