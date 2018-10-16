#include "queue.h"

void init_queue(t_queue *p)
{
	p->first = p->last = NULL;
	p->counter = 0;
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

	n->pos = p->counter++;
}

void dequeue(t_queue *p, char *d)
{
	t_node *aux = p->first;
	strcpy(d, aux->info);
	p->first = aux->next;
	
	if (p->first == NULL)
		p->last = NULL;

	free(aux);

	p->counter--;
}

void set_in_pos_in_queue(t_queue *p, int pos, char *d)
{
	if (is_queue_empty(p))
		return;

	if (pos > p->counter)
		return;

	t_node *aux = p->first;

	for (int i = 0; i < pos; i++)
		aux = aux->next;

	strcpy(aux->info, d);
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

void pretty_print_queue(t_queue *p)
{
	FILE *pf; 
	pf = fopen("rpn.txt","w"); 

	t_node *aux;

	if (is_queue_empty(p))
		return;

	aux = p->first;

	fprintf(pf, "--");

	while(aux)
	{
		fprintf(pf, "------------------------------");

		if (aux->next)
			fprintf(pf, "---");
		else 
			fprintf(pf, "--\n");

		aux = aux->next;
	}

	aux = p->first;

	fprintf(pf, "| ");

	while(aux)
	{
		fprintf(pf, "%-15d%-15p", aux->pos, (void *) aux);

		if (aux->next)
			fprintf(pf, " | ");
		else 
			fprintf(pf, " |\n");

		aux = aux->next;
	}

	aux = p->first;

	fprintf(pf, "--");

	while(aux)
	{
		fprintf(pf, "------------------------------");

		if (aux->next)
			fprintf(pf, "---");
		else 
			fprintf(pf, "--\n");

		aux = aux->next;
	}

	aux = p->first;

	fprintf(pf, "| ");

	while(aux)
	{
		fprintf(pf, "%-30s", aux->info);

		if (aux->next)
			fprintf(pf, " | ");
		else 
			fprintf(pf, " |\n");

		aux = aux->next;
	}

	aux = p->first;

	fprintf(pf, "--");

	while(aux)
	{
		fprintf(pf, "------------------------------");

		if (aux->next)
			fprintf(pf, "---");
		else 
			fprintf(pf, "--\n");

		aux = aux->next;
	}

	fclose(pf); 
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
	p->counter = 0;
}
