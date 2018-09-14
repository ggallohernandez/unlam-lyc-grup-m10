# UNLaM TP Lenguajes y Compiladores
**Grupo: M-10**

**Integrantes:**

- Gonzalez, Gustavo
- Gallo Hernández, Luis Guillermo

#### Building

```sh
$ cd "Compilador/Primera Entrega"
$ bison -d Sintactico.y
$ flex Lexico.l
$ gcc Sintactico.tab.c lex.yy.c -lfl -o compiler
$ ./compiler Prueba.txt 
```
