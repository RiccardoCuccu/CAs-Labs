/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           lib_led.c
** Descriptions:        Atomic led init functions    
**--------------------------------------------------------------------------------------------------------       
*********************************************************************************************************/
#include "LPC17xx.h"
#include "led.h"

const unsigned long led_mask[] = {1UL << 7, 1UL << 6, 1UL << 5, 1UL << 4, 1UL << 3, 1UL << 2, 1UL << 1, 1UL};
unsigned char led_value;

/*----------------------------------------------------------------------------
  Function that initializes LEDs
 *----------------------------------------------------------------------------*/

void LED_init(void)
{
	LPC_PINCON->PINSEL4 &= 0xFFFF0000;	// PIN mode GPIO: P2.0-P2.7 are set to zero
	LPC_GPIO2->FIODIR |= 0x000000FF;		// P2.0-P2.7 on PORT2 defined as Output
}

void LED_deinit(void)
{
	LPC_GPIO2->FIODIR &= 0xFFFFFF00;
}


/*----------------------------------------------------------------------------
  Functions that turn on/off the requested led
 *----------------------------------------------------------------------------*/
void LED_On(unsigned int num)
{
 	LPC_GPIO2->FIOPIN |= led_mask[num];
	led_value = LPC_GPIO2->FIOPIN;
}

void LED_Off(unsigned int num)
{
 	LPC_GPIO2->FIOPIN &= ~led_mask[num];
	led_value = LPC_GPIO2->FIOPIN;
}

void LEDs_on(unsigned int num)
{
	LPC_GPIO2->FIOSET = num;
	//led_value = LPC_GPIO2->FIOPIN;
}
