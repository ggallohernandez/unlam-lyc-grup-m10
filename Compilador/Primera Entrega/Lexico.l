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
CONST_FLOAT		        {ENTERO}+"."{ENTERO}+
CONST_STRING            "({LETRA}|{ENTERO}|.)+"
T_ID			        {LETRA}({LETRA}|{ENTERO}|_)*
CADENA                  ({LETRA}|{ENTERO}|_|\n|\s|\t|\r)*
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
"<"			|
","		    |
">"			{ return yytext[0]; }
"NOT"   	{ return OP_NOT; }
{T_ID}  	{ yylval.str_val = yytext; return ID; }
"WHILE" 	{ return T_WHILE; }
"ENDWHILE"  { return T_ENDWHILE; }
"IF"     	{ return T_IF; }
"ELSE"		{ return T_ELSE; }
"ENDIF"     { return T_ENDIF; }
"WRITE"		{ return T_WRITE; }
"READ"		{ return T_READ; }
"DECVAR"	{ return T_DECVAR; }
"ENDDECVAR"	{ return T_ENDDECVAR; }
"AVG"		{ return T_AVG; }
"STRING"	{ return T_STRING; }
"INT"		{ return T_INT; }
"FLOAT"		{ return T_FLOAT; }
{CONST_STRING}      { yylval.str_val = yytext; return CONST_STR; }
{CONST_FLOAT}       { yylval.val = atof(yytext); return CONST_FL; }
{CONST_INT}         { yytext,yylval.intval; return ENTERO; }

"\n"	
"\t"


