# CAs Lab 10
Laboratory 10 of the Computer Architectures course of the master degree in Embedded System (Electronic Engineering) of Politecnico di Torino, academic year 2019/2020.<br/>
Tested in Keil uVision5.

## Exercise 1
In the `main`, before entering the endless loop, power on LED 8 using `LED_On`.<br/>
By pressing button KEY1, power off the current LED and power on the LED on the left (when arrived to LED 4, jump to LED 11).<br/>
By pressing button KEY2, power off the current LED and power on the LED on the right (when arrived to LED 11, jump to LED 4).<br/>
By pressing button INT0, get back to original configuration, with LED 8 on.

### What LED is on?
To know which LED is on you can:
- Read content of `LPC_GPIO2->FIOPIN`
- Read content of `LPC_GPIO2->FIOSET`
- Define a global variable in funct_led.c: `unsigned int led_value;`

`led_value` stores the on LED.<br/>
In the other files you can access the variable declaring: `extern unsigned int led_value;`

### Button bouncing
A single push of the button can trigger more than one interrupt request.<br/>
In ex.1, the LED powered on could be the two slots on the left (or right) w.r.t. the powered off one.<br/>
A de-bouncing mechanism has to be implemented in software to serve the first interrupt request and ignore the possible request coming right after it.

## Exercise 2
Implement a slot machine with 3 rolling wheels.<br/>
Every wheel can show one of the two symbols:
| **Wheel** | **Symbol 1** | **Symbol 2** |
|:-----:|:--------:|:--------:|
|   1   | led 4 on | led 5 on |
|   2   | led 6 on | led 7 on |
|   3   | led 8 on | led 9 on |

### Implementation
KEY1 button begins a new game and controls the first wheel:
- Powers off all the LEDs
- Powers on one of the LEDs 4 and 5 (randomly).

KEY2 button controls the second wheel:
- Powers on one of the LEDs 6 and 7 (randomly).

INT0 button controls the third wheel and states the possible win:
- Powers on one of the LEDs 8 and 9 (randomly).
- Depending on the outcome of the game, powers on LED 10 or 11.

### Outcome of the game
The player wins if all 3 symbols are the same:
- All wheels show symbol 1, or
- All wheels show symbol 2.

At the end of the game (after INT0 has been pressed), win is displayed by powering on LED 11.<br/>
If symbols are not all the same, the player loses an LED 10 is powered on.

### Random number generation
LEDs 4-9 have to be powered on randomly.<br/>
A simple way to obtain random numbers is by measuring the elapsed time between the push of two keys (incrementing a variable).
