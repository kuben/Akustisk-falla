#ifndef _DEFINITIONS_H    /* Guard against multiple inclusion */
#define _DEFINITIONS_H

#define GET_PIN_A(i) (PORTA & (1<<i))
#define GET_PIN_B(i) (PORTB & (1<<i))
#define SET_PIN_A(i,x) (LATASET x?(1<<i):0)
#define SET_PIN_B(i,x) (LATBSET x?(1<<i):0)

//#define UPDATE_PERIOD (update & 0x1)
#define UPDATE_LATVECT (update & 0x2)
//#define UPDATE_PERIOD_SET update |= 0x1
#define UPDATE_LATVECT_SET update |= 0x2
//#define UPDATE_PERIOD_CLR update &= ~(0x1)
#define UPDATE_LATVECT_CLR update &= ~(0x2)




#endif