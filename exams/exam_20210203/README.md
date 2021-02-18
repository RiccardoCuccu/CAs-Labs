# Exam of 03.02.2021
Exam of the Computer Architectures course of the master degree in Embedded System (Electronic Engineering) of Politecnico di Torino.<br/>
Tested in Keil uVision5.<br/>

## Exam Text

### Specification 1 (? points)

### Specification 2 (? points)

### Specification 3 (? points)

### Specification 4 (? points)
Given a 4 x 4 matrix of WORD (i.e. 16 bits single data) `SOURCE` write a 8086 assembly program which rotates the rows of `SOURCE` from up to down by 1<=n<=3 positions and stores the result in the matrix `DESTINATION`, with n given by the user.
The choice is yours about how to store the matrices in the memory.
Please add significant comments to the code and instructions.
If you have time, in order to get one additional point, provide the instructions to extend the program to consider n in the range -80<=n<=+120.

#### Example:
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

### Specification 5 (9 points)

Click on the following links to open web pages with the ARM instruction set<br/>
http://www.keil.com/support/man/docs/armasm<br/>
https://developer.arm.com/documentation/ddi0337/e/introduction/instruction-set-summary?lang=en<br/>
*Note*: Assembly subroutines must comply with the ARM Architecture Procedure Call Standard (AAPCS) standard (about parameter passing, returned value, calleesaved
registers).

The IEEE-754 SP standard expresses floating-point numbers in 32 bits:

<p align="center">
  <img src="./fig/fp.png" width="100%">
</p>

Bit 31 is 0 if the number is positive, 1 if negative.

Write the `addFPpositiveNumbers` subroutine, which receives in input two 32-bit numbers, considers them as IEEE-754 SP floating point numbers, and returns their
sum (in the same format). Bit 31 of the two input numbers is always 0 (i.e., the two numbers are positive).

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
