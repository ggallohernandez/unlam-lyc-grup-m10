#include "queue.h"

void init_queue(t_queue *p)
{
	p->first = p->last = NULL;
}

void enqueue(t_queue *p, t_info *d)
{
	t_node *n = (t_node *)malloc(sizeof(t_node));
	
	if (n == NULL)
		exit(-1);

	n->info = *d;
	n->next = NULL;
	
	if (p->first == NULL)
		p->first = n;
	else
		p->last->next = n;
	
	p->last = n;
}

void dequeue(t_queue *p, t_info *d)
{
	t_node *aux = p->first;
	*d = aux->info;
	p->first = aux->next;
	
	if (p->first == NULL)
		p->last = NULL;
	
	free(aux);
}

void top_queue(t_queue *p, t_info *d)
{
	*d = p->first->info;
}

int is_queue_empty(t_queue *p)
{
	return p->first == NULL;
}

void free_queue(t_queue *p)
{
	t_nodo *aux;

	while(p->pri)
	{
		aux = p->first;
		p->first = aux->next;
		free(aux);
	}

	p->last = NULL;
}
