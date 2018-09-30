#include <stdlib.h>
#include <string.h>


struct stack_entry {
  char *data;
  struct stack_entry *next;
};

struct stack_t
{
  struct stack_entry *head;
  size_t stackSize; 
};

struct stack_t *newStack(void)
{
  struct stack_t *stack = malloc(sizeof *stack);
  if (stack)
  {
    stack->head = NULL;
    stack->stackSize = 0;
  }
  return stack;
};

char *copyString(char *);
void push(struct stack_t *, char *value);
char *top(struct stack_t *);
void pop(struct stack_t *);
void clear (struct stack_t *);
void destroyStack(struct stack_t **);

typedef struct stack_t stack_t;
extern stack_t *st;
extern stack_t *stIdType;

char *copyString(char *str)
{
  char *tmp = malloc(strlen(str) + 1);
  if (tmp)
    strcpy(tmp, str);
  return tmp;
}

void push(struct stack_t *theStack, char *value)
{
  struct stack_entry *entry = malloc(sizeof *entry); 
  if (entry)
  {
    entry->data = copyString(value);
    entry->next = theStack->head;
    theStack->head = entry;
    theStack->stackSize++;
  }
  else
  {
    // handle error here
  }
}

char *top(struct stack_t *theStack)
{
  if (theStack && theStack->head)
    return theStack->head->data;
  else
    return NULL;
}

void pop(struct stack_t *theStack)
{
  if (theStack->head != NULL)
  {
    struct stack_entry *tmp = theStack->head;
    theStack->head = theStack->head->next;
    free(tmp->data);
    free(tmp);
    theStack->stackSize--;
  }
}

void clear (struct stack_t *theStack)
{
  while (theStack->head != NULL)
    pop(theStack);
}

void destroyStack(struct stack_t **theStack)
{
  clear(*theStack);
  free(*theStack);
  *theStack = NULL;
}