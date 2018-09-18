%{

#include <stdio.h>
#include <stdlib.h>
#include <float.h>
#include "y.tab.h"
int isValidInt(int );
int isValidFloat(double );
int createSymbolTable();
%}

%option noyywrap  
%option yylineno 

ENTERO      			[0-9]
LETRA		        	[a-zA-Z]
CONST_INT               {ENTERO}+
CONST_FLOAT		        {ENTERO}+\.{ENTERO}*|{ENTERO}*\.{ENTERO}+
CONST_STRING            \"{CADENA}\"
T_ID			        {LETRA}({LETRA}|{ENTERO}|\_)*
CADENA                  ({LETRA}|{ENTERO}|\.|\:|\;\-|\_|\!|_|" "|\n|\s|\t|\r|\@|\%\º)*
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
"!="        |
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
{CONST_FLOAT}       { 
        yylval.val = atof(yytext);
		if(isValidFloat(atof(yytext))==1)
        {
            return CONST_FL;
        }
        else
        {
            yyerror("Error. Flotante fuera de rango.\n");
        }
    }
        
{CONST_INT}         { 
        yylval.val = atoi(yytext);
        if(isValidInt(atoi(yytext))==1)
        {
            return ENTERO;
        }
        else
        {
            yyerror("Error. Entero fuera de rango.\n");
        }
    }

"\n"	
"\t"
{COMENTARIOS}

%%
int isValidInt(int entero)
{
	if(entero >= 0 && entero <= 65535)
    {
        //Si no existe guardar en tabla de simbolos aca
		printf("CONT_INT \n"); 
        return 1; 
	}
    return 0;
}

int isValidFloat(double num)
{
    printf("Flotante  %f",num);
	if(num >= FLT_MIN && num <= FLT_MAX )
    {
        //Si no existe guardar en tabla de simbolos aca
		printf("CONST_FLOAT \n"); 
        return 1; 
	}
    return 0;
}

int createSymbolTable(){
	FILE *pf; 
	int i;
	pf = fopen("ts.txt","w"); 

	if (!pf)
		return 0;

	fclose(pf); 

	return 1;
}