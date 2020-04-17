/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_timer.c
** Descriptions:        interrupt handlers of Timer/Counter 0 and 1
** Correlated files:    timer.h
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include "lpc17xx.h"
#include "timer.h"

uint16_t SinTable[45] = { 410, 467, 523, 576, 627, 673, 714, 749, 778, 799, 813, 819, 817, 807, 789, 764, 732, 694, 650, 602, 550, 495, 438, 381, 324, 270, 217, 169, 125, 87, 55, 30, 12, 2, 0, 6, 20, 41, 70, 105, 146, 193, 243, 297, 353};

void TIMER0_IRQHandler (void)
{
  LPC_TIM0->IR = 1;			/* clear interrupt flag */
  return;
}

void TIMER1_IRQHandler (void)
{
	static int ticks = 0;
	LPC_DAC ->DACR = (SinTable[ticks]) << 6;
	ticks ++;
	if (ticks == 45)
		ticks = 0;
	
  LPC_TIM1->IR = 1;			/* clear interrupt flag */
  return;
}

