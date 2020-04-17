/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           led.h
** Last modified Date:  2019-12-05
** Last Version:        V1.00
** Descriptions:        Prototypes of functions included in lib_led.c
** Correlated files:    lib_led.c
**--------------------------------------------------------------------------------------------------------       
*********************************************************************************************************/

/* lib_led */
void LED_init(void);
void LED_deinit(void);
void all_LED_on(void);
void all_LED_off(void);
void LED_On (unsigned int num);
void LED_Off (unsigned int num);

