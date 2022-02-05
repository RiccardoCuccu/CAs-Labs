#include <stdio.h>
#include "LPC17xx.h"                    /* LPC17xx definitions                */
#include "led/led.h"
#include "button/button.h"

int X = 0;                        			/* Global variable                    */
int k = 0;                        			/* Global variable                    */

/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
 
int main (void)
{
		// System initialization
    LED_init();                         /* LED Initialization                 */
    BUTTON_init();                      /* BUTTON Initialization              */
		while (1) {}                        /* Loop forever                       */
}
