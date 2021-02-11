#include "button.h"
#include "lpc17xx.h"
#include "../led/led.h"

#define BOUNC 2500000

unsigned int counter = 0;

void EINT0_IRQHandler (void)
{
    all_LED_off();
    LED_On(3);
    LPC_SC->EXTINT |= (1 << 0);         /* clear pending interrupt         */
}

void EINT1_IRQHandler (void)
{
    counter++;
    if(counter == 1){
        for (int i = 1; i <= BOUNC; i++){};
        counter = 0;
        int current_led = decoder(LPC_GPIO2->FIOSET & 0x000000FF);
        int next_led = (current_led + 1) % 8;
        LED_On(next_led);
        LED_Off(current_led);
        LPC_SC->EXTINT |= (1 << 1);     /* clear pending interrupt         */
    }
}

void EINT2_IRQHandler (void)
{
    counter++;
    if(counter == 1){
        for (int i = 1; i <= BOUNC; i++){};
        int next_led;   
        counter = 0;
        int current_led = decoder(LPC_GPIO2->FIOSET & 0x000000FF);
        if (current_led == 0) {
            next_led = 7;
        } else {
            next_led = (current_led - 1);
        }
        LED_On(next_led);
        LED_Off(current_led);
        LPC_SC->EXTINT |= (1 << 2);     /* clear pending interrupt         */
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
