#include "button.h"
#include "lpc17xx.h"
#include "../led/led.h"

#define BOUNC 2500000

unsigned int counter = 0;
extern unsigned int random;

void EINT0_IRQHandler (void)	  
{
	LED_Off(3);
	LED_Off(2);
	LED_Off(1);
	LED_Off(0);
	counter++;
	if(counter == 1){
		//for (int i = 1; i <= BOUNC; i++){};					/* debouncing												*/
		int led;
		if (random % 2 == 0) {
			led = 3;																	/* LED8															*/
		} else {
			led = 2;																	/* LED9															*/
		}
		LED_On(led);
		int wheels = LPC_GPIO2->FIOSET & 0x000000FF;
		if ((wheels == 0x000000A8) || (wheels == 0x00000054)) {    		/* LEDs 4, 6, 8 on || LEDs 5, 7, 9 on       */
			LED_On(0);																/* LED10														*/
		} else {
			LED_On(1);																/* LED11														*/
		}
		counter = 0;
		LPC_SC->EXTINT |= (1 << 0);     						/* clear pending interrupt					*/
	} 
}

void EINT1_IRQHandler (void)	  
{
	all_LED_off();
	counter++;
	if(counter == 1){
		//for (int i = 1; i <= BOUNC; i++){};					/* debouncing												*/
		int led;
		if (random % 2 == 0) {
			led = 7;																	/* LED4															*/
		} else {
			led = 6;																	/* LED5															*/
		}
		LED_On(led);
		counter = 0;
		LPC_SC->EXTINT |= (1 << 1);     						/* clear pending interrupt					*/
	}
}

void EINT2_IRQHandler (void)	  
{
	LED_Off(5);
	LED_Off(4);
	counter++;
	if(counter == 1){
		//for (int i = 1; i <= BOUNC; i++){};					/* debouncing												*/
		int led;
		if (random % 2 == 0) {
			led = 5;																	/* LED6															*/
		} else {
			led = 4;																	/* LED7															*/
		}
		LED_On(led);
		counter = 0;
		LPC_SC->EXTINT |= (1 << 2);     						/* clear pending interrupt					*/
	}   
}

int decoder (unsigned int num)
{
	int result;
	switch(num) {
      case 0x00000001 :
         result = 0; break;
      case 0x00000002 :
         result = 1; break;
      case 0x00000004 :
         result = 2; break;
      case 0x00000008 :
         result = 3; break;
      case 0x00000010 :
         result = 4; break;
      case 0x00000020 :
         result = 5; break;
      case 0x00000040 :
         result = 6; break;
      case 0x00000080 :
         result = 7; break;
      default :
         result = 0; break;
	}
	return result;
}
