objects = y.o l.o

parser: $(objects)
	gcc -o parser $(objects) -lfl -g -std=gnu99

y.o: Sintactico.y
	bison -dyv Sintactico.y -t --graph
	gcc -o y.o -c y.tab.c -std=gnu99

l.o: Lexico.l y.o
	flex Lexico.l
	gcc -o l.o -c lex.yy.c -std=gnu99

.PHONY: clean
clean:
	-rm -rf *.o parser *.yy.c *.tab.c *.tab.h *.dot *.output ts.txt rpn.txt