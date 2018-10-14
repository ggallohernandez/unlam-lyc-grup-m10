parser: Lexico.l Sintactico.y
	bison -dyv Sintactico.y -t --graph
	flex Lexico.l
	gcc y.tab.c lex.yy.c -lfl -g -o parser

clean:
	rm -rf *.o parser