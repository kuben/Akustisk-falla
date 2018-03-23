#ifndef _COMMAND_LIB_H   /* Guard against multiple inclusion */
#define _COMMAN_LIB_H

#include "acoustic.h"

struct Status {
    char str[50];
    int pos;
};

struct Command {
    char comm[20];
    int next_idx;//If next_idx == 0 then new command
};
static volatile char next_tx = 0;
static volatile struct Status status = {0};
static volatile struct Command command = {0};

char get_status_char();
void set_status(char *new_status, ...);
void restart_command_timeout();
void clear_command_timeout();
int set_single(char num, char val);

#endif