#ifndef _COMMON_H    /* Guard against multiple inclusion */
#define _COMMON_H

#include <xc.h>

//#define MCU_PROTOTYP
#define MCU_SLAVE

struct signal {
    unsigned char up;
    unsigned char down;
};
#ifdef MCU_PROTOTYP
extern volatile struct signal signal_array[4];
#endif
#ifdef MCU_SLAVE
extern volatile struct signal signal_array[26];
#endif
#define SET_SIGNAL(signal,delay) signal.up = delay;\
                                 signal.down = delay + period/2;\
                                 if(signal.down > period) signal.down -= period

extern volatile int update;
extern volatile unsigned char period;
static volatile unsigned int flashes = 0;


#define SGNLUP(u_gt_d,i_gt_u,i_lt_d) u_gt_d?(i_gt_u || i_lt_d):(i_gt_u && i_lt_d)
#define SIGNAL_UP(i,up,dn) SGNLUP(up > dn,i > up,i<dn)


#define GET_PIN_A(i) (PORTA & (1<<i))
#define GET_PIN_B(i) (PORTB & (1<<i))
#define TOGGLE_PIN_A(i) (PORTA ^= (1<<i))
#define TOGGLE_PIN_B(i) (PORTA ^= (1<<i))
#define SET_PIN_A(i,x) LATASET = ((x)?(1<<i):0)
#define SET_PIN_B(i,x) LATBSET = ((x)?(1<<i):0)

struct pin_struct {
    volatile uint32_t *tris_set;
    volatile uint32_t *set;
    volatile uint32_t *clr;
    uint32_t mask;
};

#define PIN_CONF_OUTPUT(pin) *pin.tris_set = pin.mask
#define PIN_SET(pin) *pin.set = pin.mask
#define PIN_CLR(pin) *pin.clr = pin.mask


#define PIN_A_STRUCT(i) (struct pin_struct) { .tris_set = &TRISASET, .set = &LATASET, .clr = &LATACLR, .mask = 1<<i}
#define PIN_B_STRUCT(i) (struct pin_struct) { .tris_set = &TRISBSET, .set = &LATBSET, .clr = &LATBCLR, .mask = 1<<i}
#define PIN_C_STRUCT(i) (struct pin_struct) { .tris_set = &TRISCSET, .set = &LATCSET, .clr = &LATCCLR, .mask = 1<<i}

//#define UPDATE_PERIOD (update & 0x1)
#define UPDATE_LATVECT (update & 0x2)
//#define UPDATE_PERIOD_SET update |= 0x1
#define UPDATE_LATVECT_SET update |= 0x2
//#define UPDATE_PERIOD_CLR update &= ~(0x1)
#define UPDATE_LATVECT_CLR update &= ~(0x2)

#endif