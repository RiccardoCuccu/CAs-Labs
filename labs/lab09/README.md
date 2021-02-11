# CAs Lab 09
Laboratory 09 of the Computer Architectures course of the master degree in Embedded System (Electronic Engineering) of Politecnico di Torino, academic year 2019/2020.<br/>
Tested in Keil uVision5.

## Exercise 1
Add to led.h file the prototype:
`void led4and11_On(void);`<br/>
Add to ‘led’ group the file funct_led.c<br/>
Implement in funct_led.c the function `led4and11_On(void)`, powering on the LEDs 4 and 11 acting on the FIOSET register.<br/>
Note: the state (on/off) of the other LEDs must not be modified.<br/>
Test the function calling it from the main.

## Exercise 2
Add to led.h file the prototype:
`void led4_Off(void);`<br/>
Implement in funct_led.c the function `led4_Off(void)`, switching off LED 4 acting on FIOCLR register.<br/>
Note: the state (on/off) of the other LEDs must not be modified.<br/>
Test the function calling it from the main.<br/>

## Exercise 3
Add to led.h file the prototype:
`void ledEvenOn_OddOf(void);`<br/>
Implement in funct_led.c the function `ledEvenOn_OddOf(void)`, powering on the LEDs with even index number and powering off odd ones, acting on FIOPIN register.<br/>
Test the function calling it from the main.

## Exercise 4
Add to led.h file the prototype:
`void LED_On(unsigned int num);`<br/>
Implement in funct_led.c the function void `LED_On(unsigned int num)` powering on the LED corresponding to the parameter passed:
- num = 0 -> led 4
- num = 1 -> led 5
- num = 7 -> led 11

Test the function calling it from the main.

## Exercise 5
Add to led.h file the prototype:
`void LED_Off(unsigned int num);`<br/>
Implement in funct_led.c the function void `LED_Off(unsigned int num)` powering off the LED corresponding to the parameter passed:
- num = 0 -> led 4
- num = 1 -> led 5
- num = 7 -> led 11

Test the function calling it from the main.
