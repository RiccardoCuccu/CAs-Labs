/*----------------------------------------------------------------------------
 * Name:    main.c
 * Purpose:
 * Note(s):
 *----------------------------------------------------------------------------
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 *----------------------------------------------------------------------------*/
                  
#include <stdio.h>
#include "LPC17xx.H"                    /* LPC17xx definitions                */
#include "main.h"
#include "led/led.h"
#include "timer/timer.h"

void sleep(void);

/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main(void) 
{
  LED_init();                           /* LED Initialization                 */
	init_timer(0,0x00BEBC20);							/* Debugging mode	=> 0,5s at 25MHz		*/
	int x = 4;
	int y = 8;
	unsigned int z = binaryGCD(x, y);
	unsigned int C = binaryExtendedGCD(x, y);
	unsigned int D = (z - C * x) / y;
	
	if (C < 255) {
		multiple_LED_on(C);
	} else {
		all_LED_on();
	}
	
	enable_timer(0);											/* Start TIMER0								 				*/
	sleep();
	all_LED_off();
	
	if (D < 255) {
		multiple_LED_on(D);
	} else {
		all_LED_on();
	}
	
  while (1);                            /* Loop forever                       */	
}

void sleep(void) {
	LPC_SC->PCON |= 0x1;									/* power-down mode										*/								
	LPC_SC->PCON &= 0xFFFFFFFFD; 
	//SCB->SCR |= 0x2;										/* set SLEEPONEXIT 										*/	
	__ASM("wfi");
	return;
}
