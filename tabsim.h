#include <stdlib.h> /* for atoi */
#include <stdio.h>
#include <string.h>

typedef struct _simbolo {
	struct _simbolo * sig;
	char nombre [20];
	//int valor;
	char tipo;
	union {
		char valor_cad[100];
		int valor_int;
	} info;
} simbolo;

typedef struct {
	char tipo;
	union {
		char valor_cad[100];
		int valor_int;
	} info;
} expresion;

 simbolo * crear();
 void insertar(simbolo **, simbolo *);
 simbolo *buscar(simbolo *, char[]);
 void imprimir(simbolo * );
