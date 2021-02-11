/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           funct_led.c
** Last modified Date:  2020-02-13
** Last Version:        V1.01
** Descriptions:        Power on/off the LEDs acting on the FIOSET and FIOCLR register
** Correlated files:    
**--------------------------------------------------------------------------------------------------------       
*********************************************************************************************************/

#include "LPC17xx.h"
#include "led.h"

/*----------------------------------------------------------------------------
  Function that switch on LEDs 4 and 11
 *----------------------------------------------------------------------------*/

void led4and11_On(void)
{
	LPC_GPIO2->FIOSET |= 0x00000081;
}

void led4_Off(void)
{
	LPC_GPIO2->FIOCLR |= 0x00000001;
}

void ledEvenOn_OddOf(void)
{
	LPC_GPIO2->FIOSET = 0x000000AA;
	LPC_GPIO2->FIOCLR = 0x00000055;
}

void LED_On(unsigned int num)							// better implementation with a case
{
	if (num==0)
		LPC_GPIO2->FIOSET |= 0x00000001;			// led 4 on
	else if (num==1)
		LPC_GPIO2->FIOSET |= 0x00000002;			// led 5 on
	else if (num==7)
		LPC_GPIO2->FIOSET |= 0x00000080;			// led 11 on
}

void LED_Off(unsigned int num)						// better implementation with a case
{
	if (num==0)
		LPC_GPIO2->FIOCLR |= 0x00000001;			// led 4 off
	else if (num==1)
		LPC_GPIO2->FIOCLR |= 0x00000002;			// led 5 off
	else if (num==7)
		LPC_GPIO2->FIOCLR |= 0x00000080;			// led 11 off
}

