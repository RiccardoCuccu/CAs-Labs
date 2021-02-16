#include "lpc17xx.h"
#include "adc_dac.h"

/*----------------------------------------------------------------------------
  Function that initializes ADC
 *----------------------------------------------------------------------------*/
void ADC_init (void)
{
  LPC_PINCON->PINSEL3 |=  (3UL<<30);    /* P1.31 is AD0.5                     */

  LPC_SC->PCONP       |=  (1<<12);      /* Enable power to ADC block          */

  LPC_ADC->ADCR        =  (1<< 5) |     /* select AD0.5 pin                   */
                          (4<< 8) |     /* ADC clock is 25MHz/5               */
                          (1<<21);      /* enable ADC                         */ 
	
	/* Use either one of these instructions to enable interrupt */
  // LPC_ADC->ADINTEN = (1 << 8); /* global enable interrupt  */
  LPC_ADC->ADINTEN = (1 << 5);    /* interrupt generated after completing a conversion on channel 5 */
  
	NVIC_EnableIRQ(ADC_IRQn);             /* enable ADC Interrupt               */
}

void ADC_start_conversion (void) {
	/* Use either one of these instructions */
	//LPC_ADC->ADCR |=  (1<<24);          /* Start one A/D Conversion 			*/
	LPC_ADC->ADCR |=  (1<<16);            /* Start burst A/D Conversion 		*/
}				 

/*----------------------------------------------------------------------------
  Function that initializes DAC
 *----------------------------------------------------------------------------*/
void DAC_init (void)
{
  LPC_PINCON->PINSEL1 |= (1<<21);
	LPC_PINCON->PINSEL1 &= ~(1<<20);
	LPC_GPIO0->FIODIR |= (1<<26);
}
