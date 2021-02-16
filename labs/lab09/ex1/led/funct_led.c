/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           funct_led.c
** Last modified Date:  2020-02-13
** Last Version:        V1.00
** Descriptions:        Power on the LEDs 4 and 11 acting on the FIOSET register
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