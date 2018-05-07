#ifndef _COMMON_H    /* Guard against multiple inclusion */
#define _COMMON_H

//#define MCU_PROTOTYP
//#define MCU_SLAVE
#define MCU_MASTER

#include <xc.h>

#ifndef MCU_MASTER
extern void gen_LAT_vects();
#define PRESCALE_TMR 4
#endif
#define PERIOD 62   //Pbclk/40kHz/2^PRESCALE_TMR =  1000/2^PRESCALE_TMR
#define FAS(t) t*PERIOD/250
#define TMR_MAX 61  //PERIOD - 1
#define N_SIGNALS 26

#ifdef MCU_PROTOTYP
#define N_SIGNALS 4
#define CACHE_SIZE 230

typedef uint16_t LAT_t;

//Use only B-registers so that the cache can be larger
extern volatile LAT_t LATB_cache[CACHE_SIZE][PERIOD];
extern volatile LAT_t *volatile LATB_vect;
extern volatile unsigned char phase_shift;
extern void init_LAT_vects();
#else
#endif
#define DUTY PERIOD/2 //PERIOD/2 for 50% duty cycle
#ifdef MCU_SLAVE
#define CACHE_SIZE 10

typedef uint32_t LAT_t;

struct signal {
    unsigned char up;
};
#define SET_SIGNAL(signal,delay) signal.up = delay
extern volatile struct signal signal_array[N_SIGNALS];
extern volatile LAT_t LATA_cache[CACHE_SIZE][PERIOD],
        LATB_cache[CACHE_SIZE][PERIOD],LATC_cache[CACHE_SIZE][PERIOD];
extern volatile LAT_t *volatile LATA_vect, *volatile LATB_vect, *volatile LATC_vect;
#endif
#ifdef MCU_MASTER
extern void gen_LAT_vects_sequence(char *phases, char *LAT_vects);
#endif

struct pin_struct {
    uint32_t A_mask;
    uint32_t B_mask;
#ifndef MCU_PROTOTYP
    uint32_t C_mask;
#endif
};

#ifndef MCU_SLAVE
#define PIN_CONF_OUTPUT(pin) TRISACLR = (pin).A_mask; TRISBCLR = (pin).B_mask
#define PIN_SET(pin) LATASET = (pin).A_mask; LATBSET = (pin).B_mask
#define PIN_CLR(pin) LATACLR = (pin).A_mask; LATBCLR = (pin).B_mask
#define PIN_GET(pin) ((PORTA & (pin).A_mask) || (PORTB & (pin).B_mask))
#define PIN_TOGGLE(pin) {LATAINV = (pin).A_mask; LATBINV = (pin).B_mask;}
#else
#define PIN_CONF_OUTPUT(pin) TRISACLR = (pin).A_mask; TRISBCLR = (pin).B_mask; TRISCCLR = (pin).C_mask
#define PIN_SET(pin) LATASET = (pin).A_mask; LATBSET = (pin).B_mask; LATCSET = (pin).C_mask
#define PIN_CLR(pin) LATACLR = (pin).A_mask; LATBCLR = (pin).B_mask LATCCLR = (pin).C_mask
#define PIN_GET(pin) ((PORTA & (pin).A_mask) || (PORTB & (pin).B_mask) || (PORTC & (pin).C_mask))
#define PIN_TOGGLE(pin) {LATAINV = (pin).A_mask; LATBINV = (pin).B_mask; LATCINV = (pin).C_mask;}
#endif
#define PIN_A_STRUCT(i) ((struct pin_struct) { .A_mask = 1<<i})
#define PIN_B_STRUCT(i) ((struct pin_struct) { .B_mask = 1<<i})
#ifndef MCU_PROTOTYP
#define PIN_C_STRUCT(i) ((struct pin_struct) { .C_mask = 1<<i})
#endif


#ifdef MCU_MASTER
#define SEL_SLAVE(i) LATB = ((PORTB|0x0f80)^(1<<(7+i))) //Slave 0 - RB7
#define UNSEL_ALL_SLAVES LATBSET = 0x0f80
#define SEL_ALL_SLAVES LATBCLR = 0x0f80
#define PIN_GREEN PIN_A_STRUCT(4)
#define PIN_YELLOW PIN_B_STRUCT(4)
#define PIN_RED PIN_A_STRUCT(2)
#endif

#endif