%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include "y.tab.h"
#include "symbol_table.h"
#include "symbol_table.c"

extern void yyerror(const char *s);

int isValidInt(int );
int isValidFloat(double );
int createSymbolTable();
void getAllSymbols(FILE*);
char * getDataTypeName(int);
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
">="		{ printf("GE "); return OP_GE; }
"<="		{ printf("LE "); return OP_LE; }
"!="        { printf("NE "); return OP_NE; }
"=="		{ printf("EQ "); return OP_EQ; }			
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
{T_ID}  	{ printf("ID "); yylval.str_val = yytext; 
                
                if(strlen(yytext)<=10)
                {
                    symrec *s;
                    s = getsym(yylval.str_val);
                    if (s == 0)
                    {
                        putsym(yylval.str_val,DT_UNDEFINED);
                    }
                    return ID;
                }
                else
                {
                    yyerror("Nombre de variable muy extensa, debe ser menor a 10 caracteres \n");
                }
            }
{CONST_STRING}      { yylval.str_val = yytext; printf("CONST_STR \n"); 
            if(strlen(yytext)<MAX_STRING)
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
            return CONST_STR; }
{CONST_FLOAT}       { 
            float aux;
            sscanf(yytext,"%f",&aux);
            yylval.val = aux;
            if(isValidFloat(aux)==1)
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
        
{CONST_INT}         { 
        int aux;
        sscanf(yytext,"%d",&aux);
        yylval.val = aux;
        if(isValidInt(aux)==1)
        {
                symrec *s;
                s = getsym(yytext);
                if (s == 0)
                {
                    putsym(yytext,DT_ENTERO);
                }
                return ENTERO;
        }
        else
        {
            yyerror("Error. Entero fuera de rango.\n");
        }
    }
<<EOF>> {
            if (createSymbolTable()==0)
            {
                yyerror("Error al crear tabla de simbolos \n");
            }
            yyterminate();
        }

"\r\n"
" "
"\t"
{COMENTARIOS}
.           { printf("Caracter invalido!");  exit(1);}

%%

int isValidInt(int entero)
{
	if(entero >= -32768 && entero <= 32767)
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
	pf = fopen("ts.txt","w"); 
    printf("\nCreando tabla de simbolos: \n");
	if (!pf)
		return 0;
    getAllSymbols(pf);
	fclose(pf); 

	return 1;
}

void getAllSymbols(FILE* pf) {
    printf("\nMostrando tabla de simbolos: \n");
    symrec *ptr;
    char idName[MAX_STRING];
  	for (ptr = sym_table; ptr != (symrec *) 0; ptr = (symrec *)ptr->next)
    {
        strcpy(idName,"_");
        printf("Nombre: %s, Tipo: %d\n",ptr->name,ptr->type);
        fprintf(pf,"%s %s %d \n",strcat(idName,ptr->name),getDataTypeName(ptr->type),ptr->len);
    }
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