%{
#include "tabsim.h"
#include "y.tab.h"
#include <string.h>
extern simbolo *t;
//int yylineno = 1;
%}
%%
[0-9]+ 		{
			yylval.numero = atoi(yytext);
			return NUMERO;
		}
\"[^\"]*\" 	{
			strcpy(yylval.cadena, yytext+1); //omitir las comillas dobles
			yylval.cadena[yyleng-2] = 0; //quitar comillas dobles
			return CADENA;
		}
"print"		{return PRINT;}
"toInt"		{return TOINT;}
"toString"	{return TOSTRING;}
[-+()=/*] 	{return *yytext; }	/* operadores */ 
[{]		{return *yytext;}	/* operadores */
[}]		{return *yytext;}	/* operadores */
[a-zA-Z][a-zA-Z0-9]*	{
				if (strlen(yytext)>19) yytext[19]=0;
				yylval.ptr_simbolo = (simbolo *)buscar(t,yytext);
				if (yylval.ptr_simbolo == NULL)
				{
					yylval.ptr_simbolo=(simbolo *) malloc(sizeof(simbolo));
					strcpy(yylval.ptr_simbolo->nombre, yytext);
					yylval.ptr_simbolo->tipo='i';
					insertar(&t, yylval.ptr_simbolo);
				}
				return ID;
			}
[ \t]   	; /* skip whitespace */
[\n]		{yylineno++;return *yytext;}
.		yyerror("invalid character");
%%
int yywrap(void) {
    return 1;
}
