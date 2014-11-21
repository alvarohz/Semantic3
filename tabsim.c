 #include "tabsim.h"
 
 simbolo * crear() {
	return NULL;
 };
 void insertar(simbolo **pT, simbolo *s) {
	s->sig = (*pT);
	(*pT) = s;
 };
 simbolo *buscar(simbolo *t, char nombre[20]){
	while ( (t != NULL) && (strcmp(nombre, t->nombre)) )
		t = t->sig;
	return (t);
 };

 void imprimir(simbolo * t) {
	while (t != NULL) {
		printf("%s:%c: ", t->nombre, t->tipo);
	if(t->tipo == 'c') printf("%s\n", t->info.valor_cad);
	else if(t->tipo == 'e') printf("%d\n", t->info.valor_int);
	else printf("Indefinido\n");
	t = t->sig;
	}
};
