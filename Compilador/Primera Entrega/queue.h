#ifndef QUEUE_H
#define QUEUE_H
#include <stdlib.h>
#include "symbol_table.h"

typedef char t_info[MAX_STRING];

typedef struct s_node
{
	t_info info;
	struct s_node *next;
} t_node;

typedef struct
{
	t_node *first;
	t_node *last;
} t_queue;

void init_queue(t_queue)
void enqueue(t_queue, t_info)
void dequeue(t_queue, t_info)
void top_queue(t_queue, t_info)
int is_queue_empty(t_queue)
void free_queue(t_queue)

#endif