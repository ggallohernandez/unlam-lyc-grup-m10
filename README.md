# UNLaM TP Lenguajes y Compiladores
**Grupo: M-10**

**Integrantes:**

- Gonzalez, Gustavo
- Gallo Hernández, Luis Guillermo

### Linux

#### Building 

```sh
$ cd "Compilador/Primera Entrega"
$ bison -dyv Sintactico.y
$ flex Lexico.l
$ gcc y.tab.c lex.yy.c -lfl -o Primera
$ ./Primera Prueba.txt 
```
