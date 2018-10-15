%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include <stdbool.h>
#include "y.tab.h"
#include "symbol_table.h"
#include "symbol_table.c"

extern void yyerror(const char *s);

int isValidInt(int );
int isValidFloat(double );
int createSymbolTable();
void getAllSymbols(FILE*);
char * getDataTypeName(int);

#define MAX_STRING 30

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
","			|
"<"			|
">"			{ return yytext[0]; }
">="		{ return OP_GE; }
"<="		{ return OP_LE; }
"!="        { return OP_NE; }
"=="		{ return OP_EQ; }
"&&"		|
"AND"		{ return OP_AND; }
"||"		|
"OR"		{ return OP_OR; }
"!"			|
"NOT"   	{ return OP_NOT; }
"true"      |
"false"     |
"TRUE"      |
"FALSE"     {    
    bool aux;

    if (0 == strcmp(yytext, "true") || 0 == strcmp(yytext, "TRUE"))
        aux = true;
    else if (0 == strcmp(yytext, "false") || 0 == strcmp(yytext, "FALSE"))
        aux = false;
    else
        yyerror("Error. Valor booleano invalido.\n");

    yylval.bool_val = aux;

    symrec *s;
    s = getsym(aux ? "true" : "false");
    
    if (s == 0)
    {
        putsym(aux ? "true" : "false", DT_BOOL);
    }

    return CONST_BOOLEAN;
}
"WHILE" 	{ return T_WHILE; }
"ENDWHILE"  { return T_ENDWHILE; }
"IF"     	{ return T_IF; }
"ELSE"		{ return T_ELSE; }
"ENDIF"     { return T_ENDIF; }
"READ"		{ return T_READ; }
"DEFVAR"	{ return T_DEFVAR; }
"ENDDEFVAR"	{ return T_ENDDEFVAR; }
"AVG"		{ return T_AVG; }
"STRING"	{ return T_STRING; }
"INT"		{ return T_INT; }
"FLOAT"		{ return T_FLOAT; }
"WRITE"		{ return T_WRITE; }
{T_ID}  	{ 
    yylval.str_val = strdup(yytext); 
                
    if (strlen(yytext) <= 10)
    {
        symrec *s;
        s = getsym(yylval.str_val);
        
        if (s == 0)
        {
            putsym(yylval.str_val, DT_UNDEFINED);
        }
        
        return ID;
    }
    else
    {
        yyerror("Nombre de variable muy extensa, debe ser menor a 10 caracteres \n");
    }
}
{CONST_STRING} { 
    yylval.str_val = strdup(yytext);

    if (strlen(yytext) <= MAX_STRING)
    {
        symrec *s;
        s = getsym(yytext);

        if (s == 0)
        {
            putsym(yytext,DT_CONST_STR);
        }
        
        return CONST_STR;
    }
    else
    {
        yyerror("Error. Cadena de caracteres supera el maximo.\n");
    }

    return CONST_STR; 
}
{CONST_FLOAT} { 
    float aux;
    sscanf(yytext, "%f", &aux);
    yylval.val = aux;

    if (isValidFloat(aux) == 1)
    {
        symrec *s;
        s = getsym(yytext);
        if (s == 0)
        {
            putsym(yytext,DT_CONST_FL);
        }
        return CONST_FL;
    }
    else
    {
        yyerror("Error. Flotante fuera de rango.\n");
    }
}
        
{CONST_INT} { 
    int aux;
    sscanf(yytext,"%d",&aux);
    yylval.intval = aux;

    if (isValidInt(aux) == 1)
    {
        symrec *s;
        s = getsym(yytext);
        
        if (s == 0)
        {
            putsym(yytext, DT_ENTERO);
        }

        return ENTERO;
    }
    else
    {
        yyerror("Error. Entero fuera de rango.\n");
    }
}

<<EOF>> {
    if (createSymbolTable() == 0)
    {
        yyerror("Error al crear tabla de simbolos \n");
    }

    yyterminate();
}
"\r\n"
" "
"\t"
{COMENTARIOS}
. { printf("Caracter invalido!");  exit(1);}

%%

int isValidInt(int entero)
{
	if (entero >= -32768 && entero <= 32767)
    {
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
		printf("CONST_FLOAT \n"); 
        return 1; 
	}
    return 0;
}

int createSymbolTable(){
	FILE *pf; 
	pf = fopen("ts.txt","w"); 
    printf("\nCreando tabla de simbolos: \n");
	if (!pf)
		return 0;
    getAllSymbols(pf);
	fclose(pf); 

	return 1;
}

void getAllSymbols(FILE* pf) {
    symrec *ptr;
    char idName[MAX_STRING];

    fprintf(pf,"\t---------------------------------------------------------------------------------------------------------\n");
    fprintf(pf,"\t|\t%-30s\t|\t%-20s\t|\t%-32s\t|\t\n","Symbol","Type","Length");
    fprintf(pf,"\t---------------------------------------------------------------------------------------------------------\n");

  	for (ptr = sym_table; ptr != (symrec *) 0; ptr = (symrec *)ptr->next)
    {
        strcpy(idName,"_");
        fprintf(pf,"\t|\t%-30s\t|\t%-20s\t|\t%-32d\t|\t\n",strcat(idName,ptr->name),getDataTypeName(ptr->type),ptr->len);
    }

    fprintf(pf,"\t---------------------------------------------------------------------------------------------------------\n");
}

char * getDataTypeName(int value)
{
    switch(value)
    {
        case 1  :
            return "CONST_FL";
            break;
        case 2  :
            return "ENTERO";
            break;
        case 3  :
            return "CONST_STR";
            break;
        case 4  :
            return "CONST_BOOL";
            break;
        case 5  :
            return "DT_UNDEFINED";
            break;
        case 6  :
            return "DT_FLOAT";
            break;
        case 7  :
            return "DT_INT";
            break;
        case 8  :
            return "DT_STRING";
            break;
        case 9  :
            return "DT_BOOL";
            break;
        default : 
            return "DT_UNDEFINED";
    }
}