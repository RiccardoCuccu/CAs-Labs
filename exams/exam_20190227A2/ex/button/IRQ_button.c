#include "button.h"
#include "lpc17xx.h"

extern int pressed_button;

void EINT0_IRQHandler (void)	  
{
	pressed_button = 0;
	LPC_SC->EXTINT |= (1 << 0);     /* clear pending interrupt         */
}

void EINT1_IRQHandler (void)	  
{
	pressed_button = 1;
	LPC_SC->EXTINT |= (1 << 1);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void)	  
{
	pressed_button = 2;
	LPC_SC->EXTINT |= (1 << 2);     /* clear pending interrupt         */    
}
