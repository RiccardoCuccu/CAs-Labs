# Exam of 03.02.2021
Exam of the Computer Architectures course of the master degree in Embedded System (Electronic Engineering) of Politecnico di Torino.<br/>
Tested in EMU8086 version 4.08 and Keil uVision5.<br/>

## Exam Text
Assembly subroutines must comply with the ARM Architecture Procedure Call Standard (AAPCS) standard (about parameter passing, returned value, calleesaved
registers).

### Specification 1
The IEEE-754 SP standard expresses floating-point numbers in 32 bits:

<p align="center">
  <img src="./fig/fp.png" width="100%">
</p>

Bit 31 is 0 if the number is positive, 1 if negative.

Write the `addFPpositiveNumbers` subroutine, which receives in input two 32-bit numbers, considers them as IEEE-754 SP floating point numbers, and returns their sum (in the same format). Bit 31 of the two input numbers is always 0 (i.e., the two numbers are positive).

In details, the subroutine implements the following steps:
1. take the mantissa of the two parameters
2. set the 23rd bit of the mantissa to 1
3. compare the two exponents. If they are equal, the exponent of the result is the same. If they are different:
	- the exponent of the result is the highest one
	- shift right the mantissa of the number with the lower exponent by as many position as the difference between the two exponents.
4. sum the two mantissas: this is the mantissa of the result. If the 24st bit of the mantissa of the result is 1:
	- shift right the mantissa of the result by one position
	- increment the exponent of the result by one.
5. set the 23rd bit of the mantissa of the result to 0.
6. combine the mantissa and the exponent to get the final result.

#### Example
`parameter1 = 0100 0010 0100 1011 0000 0000 0000 0000`<br/>
`parameter2 = 0100 0001 1010 0100 0000 0000 0000 0000`

1. `mantissa1 = 0000 0000 0100 1011 0000 0000 0000 0000`<br/>
   `mantissa2 = 0000 0000 0010 0100 0000 0000 0000 0000`
2. `mantissa1 = 0000 0000 1100 1011 0000 0000 0000 0000`<br/>
   `mantissa2 = 0000 0000 1010 0100 0000 0000 0000 0000`
3. `exponent1 = 1000 0100`<br/>
   `exponent2 = 1000 0011`
	- `exponentResult = 1000 0100`
	- `mantissa2 = 0000 0000 0101 0010 0000 0000 0000 0000`
4. `mantissaResult = 0000 0001 0001 1101 0000 0000 0000 0000`<br/>
	- `mantissaResult = 0000 0000 1000 1110 1000 0000 0000 0000`
	- `exponentResult = 1000 0101`
5. `mantissaResult = 0000 0000 0000 1110 1000 0000 0000 0000`
6. `result = 0100 0010 1000 1110 1000 0000 0000 0000`

### Specification 2
Initialize register `r4` and `r5` with two values expressing floating-point numbers according to the IEEE-754 SP standard.

Configure the `SYSTICK` timer in order to generate an interrupt every 2<sup>20</sup> clock cycles.

Enter in an infinite loop. In the `SYSTICK` timer interrupt handler, sum the content of the `r4` and `r5` registers by calling the `addFPpositiveNumbers` subroutine and then store the result in `r4`.

The `SYSTICK` timer is configured by means of the following registers:
- Control and Status Register: size 32 bits, address `0xE000E010`
- Reload Value Register: size 24 bits, address `0xE000E014`
- Current Value Register: 24 bits, address `0xE000E018`

The meaning of the bits in the Control and Status Register is as follows:
- Bit 16 (read-only): it is read as 1 if the counter reaches 0 since last time this register is read; it is cleared to 0 when read or when the current counter value is cleared
- Bit 2 (read/write): if 1, the processor free running clock is used; if 0, an external reference clock is used
- Bit 1 (read/write): if 1, an interrupt is generated when the timer reaches 0; if 0, the interrupt is not generated
- Bit 0 (read/write): if 1, `SYSTICK` timer is enabled; if 0, `SYSTICK` timer is disabled.

The Reload Value Register stores the value to reload when the timer reaches 0.

The Current Value Register stores the current value of the timer.
Writing any number clears its content.

### Specification 3
Given a 4 x 4 matrix of WORD (i.e. 16 bits single data) `SOURCE` write a 8086 assembly program which rotates the rows of `SOURCE` from up to down by 1<=n<=3 positions and stores the result in the matrix `DESTINATION`, with n given by the user.
The choice is yours about how to store the matrices in the memory.
Please add significant comments to the code and instructions.
If you have time, in order to get one additional point, provide the instructions to extend the program to consider n in the range -80<=n<=+120.

#### Example
Initial matrix `SOURCE`
```
A B C D
E F G H
I J K L
M N O P
```
if n=3 `DESTINATION` becomes
```
E F G H
I J K L
M N O P
A B C D
```
if n=1 `DESTINATION` becomes
```
M N O P
A B C D
E F G H
I J K L
```
