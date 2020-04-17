#include "lpc17xx.h"
#include "button.h"
#include "../timer/timer.h"

#define BOUNC 2500000

extern unsigned int PriceList[];
extern unsigned int ItemList[];
extern int sequentialSearch(unsigned int *Price_List, unsigned int *Item_List);
extern int binarySearch(unsigned int *Price_List, unsigned int *Item_List);
extern int pressed_button;
extern int result;
int counter = 0;

void EINT0_IRQHandler (void)	  
{
	pressed_button = 0;
	LPC_SC->EXTINT |= (1 << 0);    							/* clear pending interrupt         */
}

void EINT1_IRQHandler (void)	  
{
	pressed_button = 1;
	LPC_SC->EXTINT |= (1 << 1);    							/* clear pending interrupt         */
}

void EINT2_IRQHandler (void)	  
{
	pressed_button = 2;
	LPC_SC->EXTINT |= (1 << 2);     						/* clear pending interrupt         */    
}
