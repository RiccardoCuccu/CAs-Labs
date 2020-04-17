/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_adc.c
** Descriptions:        functions to manage A/D interrupts
** Correlated files:    adc.h
**--------------------------------------------------------------------------------------------------------       
*********************************************************************************************************/

#include "lpc17xx.h"
#include "adc_dac.h"

/*----------------------------------------------------------------------------
  A/D IRQ: Executed when A/D Conversion is ready (signal from ADC peripheral)
 *----------------------------------------------------------------------------*/

unsigned short AD_current;   

void ADC_IRQHandler(void) {
	unsigned short led_last, led_current;
  /* Use either one of these instructions to read conversion result */	
  // AD_current = ((LPC_ADC->ADGDR>>4) & 0xFFF);	/* if global interrupts are enabled */
	AD_current = ((LPC_ADC->ADDR5 >> 4) & 0xFFF);	/* if interrupts on channel 5 are enabled */	
}
