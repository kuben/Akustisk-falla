#ifndef _ACOUSTIC_H    /* Guard against multiple inclusion */
#define _ACOUSTIC_H

extern volatile int update;
extern volatile unsigned char delay_array[4];
extern volatile unsigned char period;
static volatile unsigned int flashes = 0;

void InitializeSystem(void);
void initSlaveSPI(void);

#endif