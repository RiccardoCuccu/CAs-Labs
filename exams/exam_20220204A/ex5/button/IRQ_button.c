#include "button.h"
#include "lpc17xx.h"
#include "../led/led.h"

#define BOUNC 2500000

extern int X;                                   /* defined in main.c               */
extern int k;                                   /* defined in main.c               */
extern int restoringSquareRoot(int X, int k);   /* defined in startup_LPC17xx.s    */
extern void LEDs_on(int Q);                     /* defined in lib_led.c            */

void EINT0_IRQHandler (void)                    /* INT0                            */
{
    for (int i = 0; i <= BOUNC; i++){};         /* debouncing                      */
    int Q = restoringSquareRoot(X, k);
    LEDs_on(Q);
    LPC_SC->EXTINT |= (1 << 0);                 /* clear pending interrupt         */
}


void EINT1_IRQHandler (void)                    /* KEY1                            */
{
    for (int i = 0; i <= BOUNC; i++){};         /* debouncing                      */
    X = X << 1;                                 /* insert a new digit equal to 0   */
    k++;                                        /* increment digit counter         */
    LPC_SC->EXTINT |= (1 << 1);                 /* clear pending interrupt         */
}

void EINT2_IRQHandler (void)                    /* KEY2                            */
{
    for (int i = 0; i <= BOUNC; i++){};         /* debouncing                      */
    X = X << 1;                                 /* insert a new digit equal to 1   */
    X++;
    k++;                                        /* increment digit counter         */
    LPC_SC->EXTINT |= (1 << 2);                 /* clear pending interrupt         */
}
