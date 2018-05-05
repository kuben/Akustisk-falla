#ifndef _COMMAND_LIB_H   /* Guard against multiple inclusion */
#define _COMMAND_LIB_H

#include "common.h"

struct Command {
#ifdef MCU_MASTER
    unsigned char comm[140];
#else
    unsigned char comm[2+CACHE_SIZE*N_SIGNALS];//This is the maximum amount needed
#endif
    int next_idx;//If next_idx == 0 then new command
};
static volatile struct Command command = {0};
void receive_command_char(char rx);

#ifndef MCU_SLAVE
struct Tx_buffer {
    char str[50];
    signed int pos;//-1 if not transmitting
};
static volatile struct Tx_buffer tx_buffer = {.pos = -1};
#define TRANSMITTING (tx_buffer.pos > -1)

char next_tx_char();
int transmit(char *new_status, ...);
#endif

#ifndef MCU_MASTER
struct Sequence {
    LAT_t *LATB_seq_begin, *LATB_seq_end;//First and lasts vectors in sequence
#ifdef MCU_SLAVE
    LAT_t *LATA_seq_begin, *LATC_seq_begin;//Slave also uses A, B and C
#endif
    int n;//Number of times sequence is to be played
};
static volatile struct Sequence sequence = {};
#endif

#ifdef MCU_MASTER

struct SPI_transmission {
    signed int slave_id;//-1 when empty spot in queue
    signed int pos;//-1 when transmitting command char
    char command;//'a' or 's'
    char data[26];
};
#define COMM_LEN(comm) ((comm == 'a')?26:((comm == 's')?2:0))

//#define TRANSMITTING (tx_buffer.pos > -1)

#define SPI_QUEUE_LEN 10
static volatile struct SPI_transmission spi_queue[SPI_QUEUE_LEN] = {{.slave_id = -1}};

int shift_queue();
char next_SPI_tx_char();
int queue_SPI_tx(int slave_id, char command, volatile unsigned char *data);

int set_single(int num, char val);
#else
void stop_sequence();
int command_load_sequence();
int command_init_sequence();
void increment_LAT_vects();
void begin_LAT_vects_sequence();
#endif
#ifdef MCU_PROTOTYP
int command_set_delay();
#else
int command_set_all();
int command_set_single();
#endif
void restart_command_timeout();
void clear_command_timeout();

#endif