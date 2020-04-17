/*----------------------------------------------------------------------------
 * Name:    sample.c
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 * Copyright (c) 2019 Politecnico di Torino. All rights reserved.
 *----------------------------------------------------------------------------*/
                  
#include <stdio.h>
#include "LPC17xx.h"                    /* LPC17xx definitions                */
#include "led/led.h"
#include "button/button.h"
#include "timer/timer.h"

#define V_ELEMENT 128										// 256 gives problems
void sleep(void);

int selected_button, timer_flag, button_flag;				/* Global variables		                */

/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void)
{  
	// Different state of FSM
	typedef enum
	{
		Reset_State,
		Idle_State,
		Random_LED_On_State,
		All_LEDs_Off_State,
		Check_Button_State,
		Wrong_Button_State,
		Correct_Button_State,
		Increment_LEDs_State,
	} eSystemState;

	// Variable initialization
	eSystemState eNextState = Reset_State;
	eSystemState eCurrentState;
	int i, j, n;
	int led_vector[V_ELEMENT];

	// System initialization
	LED_init();										/* LED Initialization												*/
	BUTTON_init();								/* BUTTON Initialization										*/
	//init_timer(0,0x023C3460);			/* TIMER0 Initialization => 1,5s at 25MHz		*/
	init_timer(0,0x00BEBC20);			/* Debugging mode	=> 0,5s at 25MHz					*/
	init_timer(1,0xFFFFFFFF);			/* TIMER1 Initialization										*/
	enable_timer(0);							/* TIMER0 Start															*/	
	enable_timer(1);							/* TIMER1 Start															*/
	
	while(1) {
		eCurrentState = eNextState;

		switch (eCurrentState)
		{
			
			case Reset_State:
				for (int i = 1; i <= V_ELEMENT; i++){ led_vector[i] = 0; }
				eNextState = Idle_State;
				break;
			
			case Idle_State:
				i = 0;
				j = 0;
				n = 1;
				eNextState = Random_LED_On_State;						/* Set eNextState 																															*/
				break;
			
			case Random_LED_On_State:
				reset_timer(0);															/* Reset TIMER0 to 1,5 seconds 																									*/
				enable_timer(0);														/* Start TIMER0								 																									*/
				sleep();																		/* Sleep until the timer reaches 1,5 seconds 																		*/
				if (i == n-1){
					led_vector[i] = random_LED_on();
				} else {
					LED_On(led_vector[i]);
				}
				i++;
				eNextState = All_LEDs_Off_State;						/* Set eNextState 																															*/
				break;
			
			case All_LEDs_Off_State:
				reset_timer(0);															/* Reset TIMER0 to 1,5 seconds 																									*/
				enable_timer(0);														/* Start TIMER0								 																									*/
				sleep();																		/* Sleep until the timer reaches 1,5 seconds 																		*/
				all_LED_off();
				if (i == n) {
					eNextState = Check_Button_State;					/* Set eNextState if the sequence is over																				*/
				} else {
					eNextState = Random_LED_On_State;					/* Set eNextState if the sequence isn't over																		*/
				}
				break;
				
			case Check_Button_State:
				sleep();																		/* Sleep until a button is pressed 																							*/
				if ( selected_button == led_vector[j] ) {
					eNextState = Correct_Button_State;				/* Set eNextState if the correct button was pressed															*/
				} else {
					eNextState = Wrong_Button_State;					/* Set eNextState if the wrong button was pressed																*/
				}
				break;
				
			case Wrong_Button_State:
				multiple_LED_on(j);													/* 4-11 LEDs power on according to the binary wrong number "j" to be displayed	*/
			  reset_timer(0);															/* Reset TIMER0 to 1,5 seconds 																									*/
				enable_timer(0);														/* Start TIMER0								 																									*/
				sleep();																		/* Sleep until the timer reaches 1,5 seconds 																		*/
				all_LED_off();
				eNextState = Idle_State;										/* Set eNextState 																															*/
				break;
			
			case Correct_Button_State:
				j++;
				if (j == n) {
					eNextState = Increment_LEDs_State;				/* Set eNextState if the user won																								*/
				} else {
					eNextState = Check_Button_State;					/* Set eNextState if the sequence isn't over																		*/
				}
				break;

			case Increment_LEDs_State:
				multiple_LED_on(n);													/* 4-11 LEDs power on according to the binary number "n" to be displayed				*/
			  reset_timer(0);															/* Reset TIMER0 to 1,5 seconds 																									*/
				enable_timer(0);														/* Start TIMER0								 																									*/
				sleep();																		/* Sleep until the timer reaches 1,5 seconds 																		*/
				all_LED_off();
				n++;
				i=0;
				j=0;
				eNextState = Random_LED_On_State;						/* Set eNextState 																															*/
				break;
			
			default:
				eNextState = Reset_State;										/* Set eNextState if there is any problem																				*/
				break;
		}
	}
}

void sleep(void) {
	LPC_SC->PCON |= 0x1;															/* power-down mode */								
	LPC_SC->PCON &= 0xFFFFFFFFD; 
	//SCB->SCR |= 0x2;																/* set SLEEPONEXIT */	
	__ASM("wfi");
	return;
}
