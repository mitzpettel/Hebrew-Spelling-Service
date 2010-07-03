/* Copyright (C) 2003 Nadav Har'El and Dan Kenigsberg */
/* Modified for HSpellService by Mitz Pettel on Fri Dec 2 2005.*/

#ifndef INCLUDED_RADIX_H
#define INCLUDED_RADIX_H

#include <stdbool.h>

/* The following structure is opaque for the user - its fields can only
   be accessed by calling functions, and it can only be instantiated as
   a pointer (by calling new_dict_radix).
   This is object-oriented programming in C :)
*/
struct dict_radix;

struct dict_radix *new_dict_radix(void);
void delete_dict_radix(struct dict_radix *dict);
int allocate_nodes(struct dict_radix *dict, int nsmall, int nmedium, int nfull);

int read_dict(struct dict_radix *dict, const char *dir);
void print_tree(struct dict_radix *dict);
void print_sizes(struct dict_radix *dict);
void print_stats(struct dict_radix *dict);

int lookup(const struct dict_radix *dict, const char *word);

typedef void (dfs_callback)(const char *completion, void *context);

void dfs(const struct dict_radix *dict, const char *prefix, unsigned offset, bool avoid_initial_waw, int value_mask, unsigned max_results, dfs_callback *callback, void *context);

#endif /* INCLUDED_RADIX_H */
