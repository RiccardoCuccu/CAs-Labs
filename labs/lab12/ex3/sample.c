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
#include "ADC_DAC/adc_dac.h"

#define MAX 50
#define N 30
#define M 4

unsigned int PriceList[60] = {0x004, 20, 0x006, 15, 0x007, 10, 0x00A, 5, 0x010, 8,
                              0x012, 7, 0x016, 22, 0x017, 17, 0x018, 38, 0x01A, 22,
                              0x01B, 34, 0x01E, 11, 0x022, 3, 0x023, 9, 0x025, 40,
                              0x027, 12, 0x028, 11, 0x02C, 45, 0x02D, 10, 0x031, 40,
                              0x033, 45, 0x035, 9, 0x036, 11, 0x039, 12, 0x03C, 19,
                              0x03E, 1, 0x041, 20, 0x042, 30, 0x045, 12, 0x047, 7};

unsigned int ItemList[8] = {0x022, 4, 0x006, 1, 0x03E, 10, 0x017, 2};

unsigned int pressed_button;
unsigned int result;

extern int sequentialSearch(unsigned int *Price_List, unsigned int *Item_List);
extern int binarySearch(unsigned int *Price_List, unsigned int *Item_List);
void check_result(unsigned int result);
void sleep(void);

/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void)
{  
    BUTTON_init();                          /* BUTTON Initialization          */
    DAC_init();
    
    while(1) {
        sleep();
        if (pressed_button == 1) {
            result = sequentialSearch(PriceList, ItemList);
            check_result(result);
        } else if (pressed_button == 2) {
            result = binarySearch(PriceList, ItemList);
            check_result(result);
        }
    }
}

void check_result(unsigned int result) {
    if (result > MAX) {
        init_timer(0,0xFFFFFFFF);                   /* TIMER0 Initialization               */
        enable_timer(0);
        init_timer(1,0x0000DDAE);                   /* TIMER1 Initialization to 2,27 ms    */
        enable_timer(1);
        while (LPC_TIM0->TC < 0x02FAF080) {         /* While LPC_TIM0->TC is less than 2 s */
            reset_timer(1);
            enable_timer(1);
            sleep();
        }
        reset_timer(0);
        reset_timer(1);
    }
}

void sleep(void) {
    LPC_SC->PCON |= 0x1;                            /* Power-down mode                      */
    LPC_SC->PCON &= 0xFFFFFFFFD; 
    //SCB->SCR |= 0x2;                              /* Set SLEEPONEXIT                      */
    __ASM("wfi");
}

/******************** Sequential Search ********************/
/*
int sequentialSearch(int *Price_list, int *Item_list) {
    int i, j = 0;
    int partial_cost = 0;                                                                       // reset the partial cost
    int total_cost = 0;                                                                         // reset the total cost
    int *catalogue_address_code = Price_list;                                                   // copy the address of the first element of Price_list
    int *list_address_code = Item_list;                                                         // copy the address of the first element of Item_list
    while (i < M) {                                                                             // cycle to the end of Item_list
        while (j < N) {                                                                         // cycle to the end of Price_list
            if (*catalogue_address_code == *list_address_code) {                                // compare the code of the lists
                partial_cost = *(catalogue_address_code + 1) * *(list_address_code + 1);        // calculate the cost of the item for its quantity
                total_cost = total_cost + partial_cost;                                         // calculate the total cost of all items
                break;                                                                          // exit when it finds the corresponding element
            }
            j++;
            catalogue_address_code = catalogue_address_code + 2;                                // update the address of the Price_list
        }
        j = 0;
        catalogue_address_code = Price_list;                                                    // reset the address of the Price_list
        i++; 
        list_address_code = list_address_code + 2;                                              // update the address of the Item_list
    }
    return total_cost;
}
*/

/******************** Binary Search ********************/
/*
int binarySearch (int *Price_list, int *Item_list) {
    int i = 0;
    int middle, first, last;
    int partial_cost = 0;                                                                       // reset the partial cost
    int total_cost = 0;                                                                         // reset the total cost
    int *catalogue_address_code = Price_list;                                                   // copy the address of the first element of Price_list
    int *list_address_code = Item_list;                                                         // copy the address of the first element of Item_list
    while (i < M) {                                                                             // cycle to the end of Item_list
        first = 0;
        last = N - 1;
        while (1) {
            middle = (first + last) / 2;
            if (*(catalogue_address_code + middle*2) == *list_address_code) {
                break;                                                                          // element found
            } else
                if (*(catalogue_address_code + middle*2) > *list_address_code)
                    last = middle - 1;
                else
                    first = middle + 1;
        }
        partial_cost = *(catalogue_address_code + middle*2 + 1) * *(list_address_code + 1);     // calculate the cost of the item for its quantity
        total_cost = total_cost + partial_cost;                                                 // calculate the total cost of all items
        list_address_code = list_address_code + 2;                                              // update the address of the Item_list
        i++;
    }
    return total_cost;
}
*/
