#include "queue.h"

void init_queue(t_queue *p)
{
	p->first = p->last = NULL;
}

void enqueue(t_queue *p, char *d)
{
	t_node *n = (t_node *) malloc(sizeof(t_node));
	n->info = (char *) malloc(sizeof(char) * 30);
	
	if (n == NULL)
		exit(-1);

	strcpy(n->info, d);
	n->next = NULL;
	
	if (p->first == NULL)
		p->first = n;
	else
		p->last->next = n;
	
	p->last = n;
}

void dequeue(t_queue *p, char *d)
{
	t_node *aux = p->first;
	strcpy(d, aux->info);
	p->first = aux->next;
	
	if (p->first == NULL)
		p->last = NULL;
	
	free(aux);
}

void top_queue(t_queue *p, char *d)
{
	strcpy(d, p->first->info);
}

int is_queue_empty(t_queue *p)
{
	return p->first == NULL;
}

void print_queue(t_queue *p)
{
	t_node *aux;

	if (is_queue_empty(p))
		return;

	aux = p->first;

	while(aux)
	{
		printf("%s", aux->info);

		if (aux->next)
			printf(", ");
		else 
			printf("\n");

		aux = aux->next;
	}
}

void free_queue(t_queue *p)
{
	t_node *aux;

	while(p->first)
	{
		aux = p->first;
		p->first = aux->next;
		free(aux->info);
		free(aux);
	}

	p->last = NULL;
}
