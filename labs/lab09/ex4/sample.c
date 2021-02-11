/*----------------------------------------------------------------------------
 * Name:    sample.c
 * Purpose: to control led through EINT buttons
 * Note(s):
 *----------------------------------------------------------------------------
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 * Copyright (c) 2019 Politecnico di Torino. All rights reserved.
 *----------------------------------------------------------------------------*/

#include <stdio.h>
#include "LPC17xx.H"                    /* LPC17xx definitions                */
#include "led/led.h"

/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void) 
{
    LED_init();                         /* LED Initialization                 */
    all_LED_on();
    all_LED_off();
    //led4and11_On();
    //led4_Off();
    //ledEvenOn_OddOf();
    LED_On(0);
    LED_On(1);
    LED_On(7);
    while (1);                          /* Loop forever                       */
}
