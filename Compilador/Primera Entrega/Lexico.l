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
CONST_FLOAT		        {ENTERO}+\.{ENTERO}+
CONST_STRING            \"{CADENA}\"
T_ID			        {LETRA}({LETRA}|{ENTERO}|\_)*
CADENA                  ({LETRA}|{ENTERO}|\.|\:|\;\-|\_|\!|_|\n|\s|\t|\r)*
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
","			{ return yytext[0]; }
"<"			|
">"			|
">="		|
"<="		|
"=="		|
"!"			{ return OP_COMPARADOR; }
"true"		|
"false"		{ printf("bool"); return CONST_BOOL; }
"AND"		{ printf("AND"); return OP_OR; }
"OR"		{ printf("OR"); return OP_AND; }
"NOT"   	{ printf("NOT"); return OP_NOT; }
"WHILE" 	{ printf("WHILE"); return T_WHILE; }
"ENDWHILE"  { printf("ENDWHILE"); return T_ENDWHILE; }
"IF"     	{ printf("IF"); return T_IF; }
"ELSE"		{ printf("ELSE"); return T_ELSE; }
"ENDIF"     { printf("ENDIF"); return T_ENDIF; }
"READ"		{ printf("READ"); return T_READ; }
"DEFVAR"	{ printf("DEFVAR"); return T_DEFVAR; }
"ENDDEFVAR"	{ printf("ENDDEFVAR"); return T_ENDDEFVAR; }
"AVG"		{ printf("AVG"); return T_AVG; }
"STRING"	{ printf("STRING"); return T_STRING; }
"INT"		{ printf("INT"); return T_INT; }
"FLOAT"		{ printf("FLOAT"); return T_FLOAT; }
"WRITE"		{ printf("WRITE!"); return T_WRITE; }
{T_ID}  	{ printf("ID"); yylval.str_val = yytext; return ID; }
{CONST_STRING}      { yylval.str_val = yytext; printf("CONST_STR"); return CONST_STR; }
{CONST_FLOAT}       { printf("CONST_FLOAT"); yylval.val = atof(yytext); return CONST_FL; }
{CONST_INT}         { printf("CONT_INT"); yytext,yylval.intval; return ENTERO; }

"\n"	
"\t"
"{COMENTARIO}"

