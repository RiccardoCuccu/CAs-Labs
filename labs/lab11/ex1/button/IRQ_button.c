#include "button.h"
#include "lpc17xx.h"
#include "../led/led.h"
#include "../timer/timer.h"

#define BOUNC 2500000

unsigned int counter = 0;
extern int selected_button;                         /* defined in sample.c             */

void EINT0_IRQHandler (void)
{
    counter++;
    if(counter == 1){
        for (int i = 1; i <= BOUNC; i++){};         /* debouncing                      */
        selected_button = 5;
        counter = 0;
        LPC_SC->EXTINT |= (1 << 0);                 /* clear pending interrupt         */
    }
}


void EINT1_IRQHandler (void)
{
    counter++;
    if(counter == 1){
        for (int i = 1; i <= BOUNC; i++){};         /* debouncing                      */
        selected_button = 7;
        counter = 0;
        LPC_SC->EXTINT |= (1 << 1);                 /* clear pending interrupt         */
    }
}

void EINT2_IRQHandler (void)
{
    counter++;
    if(counter == 1){
        for (int i = 1; i <= BOUNC; i++){};         /* debouncing                      */
        selected_button = 6;
        counter = 0;
        LPC_SC->EXTINT |= (1 << 2);                 /* clear pending interrupt         */
    }
}
