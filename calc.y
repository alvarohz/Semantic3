%{
#include "tabsim.c"
#include <string.h>
#include <stdlib.h>
void yyerror(char *);
int yylex(void);
extern int yylineno;	// predefinida en lex.c
int esNumero(char * s){
	int i=0;
	if (s[i] == '-') i++;
	for(; s[i] != 0; i++)
	if ((s[i]<'0') || (s[i]>'9')) return 0;
	return 1;
}
simbolo *t=NULL;
%}
%union {
	char cadena[100];
	int numero;
	simbolo * ptr_simbolo;
	expresion valor;
	}
%token <numero> NUMERO
%token <ptr_simbolo> ID
%token <cadena> CADENA 
%token TOSTRING TOINT PRINT
%type <valor> expr
%start prog
%left '+'
%left '*'
%%
prog: 		
	prog asig '\n' 			{;}
	|prog PRINT expr '\n' 	{ 
								if ($3.tipo == 'e')
									printf("%d\n",$3.info.valor_int);
								else if ($3.tipo == 'c')
									printf("%s\n",$3.info.valor_cad);
								else{
									//no hacer nada
								}
							}
	|prog error '\n'		{ yyerrok;}
	|						{;}
	;
asig: 		
	ID '=' expr 		{
						if($1->tipo == 'i')
							$1->tipo = $3.tipo;
						if ($3.tipo == 'i'){
							//No hacer nada							     
						}else
							if ($3.tipo != $1->tipo)
								printf("ERROR: Tipos incompatibles en linea %d.\n",yylineno-1);
							else if($1->tipo =='e')
								$1->info.valor_int = $3.info.valor_int;
							else
								strcpy($1->info.valor_cad, $3.info.valor_cad);								
						}					
	;
expr: 		
	expr '+' expr 		{
						if(($1.tipo == 'c') && ($3.tipo == 'c')) {
							$$.tipo = 'c';
							sprintf($$.info.valor_cad, "%s%s", $1.info.valor_cad, $3.info.valor_cad);
						} else if(($1.tipo == 'e') && ($3.tipo == 'e')) {
							$$.tipo = 'e';
							$$.info.valor_int = $1.info.valor_int + $3.info.valor_int;
						} else {
							$$.tipo = 'i';
							if (($1.tipo != 'i') && ($3.tipo != 'i'))
								printf("ERROR en Expresion: No se pueden sumar cadenas y enteros en linea %d.\n",yylineno-1);
						}
						}
	| expr '*' expr 	{
						if(($1.tipo == 'c') || ($3.tipo == 'c')) {
							$$.tipo = 'i';
							printf("Error en Expresion: Se requiere solo enteros en operacion %d.\n",yylineno-1);
						} else if(($1.tipo == 'e') || ($3.tipo == 'e')) {
							$$.tipo = 'e';
							$$.info.valor_int = $1.info.valor_int * $3.info.valor_int;
						} else
							$$.tipo = 'i';			
						}
	| ID				{
						$$.tipo = $1->tipo;
						if ($$.tipo == 'i'){
							printf("ERROR: Tipo de '%s' no definido en linea %d.\n",$1->nombre,yylineno);
						}else
							if ($$.tipo == 'e')
								$$.info.valor_int = $1->info.valor_int;
							else
								strcpy($$.info.valor_cad, $1->info.valor_cad);
						}
	| NUMERO		{
						$$.tipo = 'e';
						$$.info.valor_int = $1;
					}	
	| CADENA		{
						$$.tipo = 'c';
						strcpy($$.info.valor_cad, $1);
					}
	| TOSTRING '(' expr ')'		{
									if ($3.tipo != 'e') {
										$$.tipo = 'i';
										printf("Error de Conversion: Se requiere un entero en linea %d.\n",yylineno);
									} else {
										$$.tipo = 'c';
										//itoa($3.info.valor_int, $$.info.valor_cad, 10);
										//$$.info.valor_cad = std::to_string($3.info.valor_int);
										snprintf($$.info.valor_cad, sizeof($$.info.valor_cad), "%d",$3.info.valor_int);
									};										
								}
	| TOINT '(' expr ')'		{
									if ($3.tipo != 'c') {
										$$.tipo = 'i';
										printf("ERROR de conversion: Se requiere una cadena en linea %d.\n",yylineno);
									} else if (esNumero($3.info.valor_cad)){
										$$.tipo = 'e';
										$$.info.valor_int= atoi($3.info.valor_cad);
									} else{
										$$.tipo = 'i';
										printf("ERROR: La cadena a convertir solo puede tener digitos en linea %d.\n",yylineno);
									}
								}
	;
%%
void yyerror(char *s)
{
	
	extern char *yytext;	// predefinida en lex.c
	
printf("ERROR: %s en simbolo \"%s\" en linea %d \n",s,yytext,yylineno); 
}
void main()
{ 
	t = crear();
	yyparse();	
	imprimir(t);
}
