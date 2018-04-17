#ifndef _COMMON_H    /* Guard against multiple inclusion */
#define _COMMON_H

#include <xc.h>

//#define DEBUG
//#define MCU_PROTOTYP
//#define MCU_SLAVE
#define MCU_MASTER


#ifdef MCU_PROTOTYP
#define N_SIGNALS 4
struct signal {
    unsigned char up;
    unsigned char down;
};
#define SET_SIGNAL_DUR(signal,delay,dur) {signal.up = delay;\
                                 signal.down = delay + dur;\
                                 if(signal.down >= period) signal.down -= period;}
#endif
#ifdef MCU_SLAVE
#define N_SIGNALS 26
#define STEG 25
#define FAS(t) t*STEG/(period+1)
struct signal {
    unsigned char up;
};
#define SET_SIGNAL(signal,delay) signal.up = delay
#endif

#ifndef MCU_MASTER
extern volatile struct signal signal_array[N_SIGNALS];

extern volatile int update;
extern volatile unsigned char period;
//static volatile unsigned int flashes = 0;

//#define SGNLUP(u_gt_d,i_gt_u,i_lt_d) u_gt_d?(i_gt_u || i_lt_d):(i_gt_u && i_lt_d)
//#define SIGNAL_UP(i,up,dn) SGNLUP((up > dn),(i >= up),(i<dn))

//#define UPDATE_PERIOD (update & 0x1)
#define UPDATE_LATVECT (update & 0x2)
//#define UPDATE_PERIOD_SET update |= 0x1
#define UPDATE_LATVECT_SET update |= 0x2
//#define UPDATE_PERIOD_CLR update &= ~(0x1)
#define UPDATE_LATVECT_CLR update &= ~(0x2)

#endif

#define GET_PIN_A(i) (PORTA & (1<<(i)))
#define GET_PIN_B(i) (PORTB & (1<<(i)))
#define TOGGLE_PIN_A(i) (LATA = GET_PIN_A(i)^(1<<(i)))
#define TOGGLE_PIN_B(i) (LATB = GET_PIN_B(i)^(1<<(i)))
#define SET_PIN_A(i,x) if(x) LATASET = (1<<(i)); else LATACLR = (1<<(i))
#define SET_PIN_B(i,x) if(x) LATBSET = (1<<(i)); else LATBCLR = (1<<(i))

#ifdef MCU_MASTER
#define SEL_SLAVE(i) LATB = (PORTB|0x0f80)^(1<<(7+i)) //Slave 0 - RB7
#define UNSEL_ALL_SLAVES LATBSET = 0x0f80
#endif

struct pin_struct {
    uint32_t A_mask;
    uint32_t B_mask;
#ifdef MCU_SLAVE
    uint32_t C_mask;
#endif
};

#ifndef MCU_SLAVE
#define PIN_CONF_OUTPUT(pin) TRISACLR = pin.A_mask; TRISBCLR = pin.B_mask
#define PIN_SET(pin) LATASET = pin.A_mask; LATBSET = pin.B_mask
#define PIN_CLR(pin) LATACLR = pin.A_mask; LATBCLR = pin.B_mask
#else
#define PIN_CONF_OUTPUT(pin) TRISACLR = pin.A_mask; TRISBCLR = pin.B_mask; TRISCCLR = pin.C_mask
#define PIN_SET(pin) LATASET = pin.A_mask; LATBSET = pin.B_mask; LATCSET = pin.C_mask
#define PIN_CLR(pin) LATACLR = pin.A_mask; LATBCLR = pin.B_mask LATCCLR = pin.C_mask
#endif
#define PIN_A_STRUCT(i) (struct pin_struct) { .A_mask = 1<<i}
#define PIN_B_STRUCT(i) (struct pin_struct) { .B_mask = 1<<i}
#ifdef MCU_SLAVE
#define PIN_C_STRUCT(i) (struct pin_struct) { .C_mask = 1<<i}
#endif

#endif