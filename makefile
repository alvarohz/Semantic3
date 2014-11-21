calc: y.tab.c lex.yy.c
	gcc y.tab.c lex.yy.c -o calc
	
y.tab.c: calc.y
	bison -d calc.y -o y.tab.c
	
lex.yy.c: calc.l
	lex calc.l
	
clean:
	rm calc
	rm lex.yy.c
	rm y.tab.c
	rm y.tab.h
