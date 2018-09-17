
/* Data type for links in the chain of symbols.  */
struct symrec
{
  	char *name;  /* name of symbol */
  	int type;    /* type of symbol */
  	union {
		int intval;
		double val;
		char *str_val;
	};
  	struct symrec *next;  /* link field */
};

typedef struct symrec symrec;

/* The symbol table: a chain of 'struct symrec'.  */
extern symrec *sym_table;

symrec *putsym (char const *, int);
symrec *getsym (char const *);