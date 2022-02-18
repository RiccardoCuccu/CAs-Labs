# Exam of 04.02.2022 - A
Exam of the Computer Architectures course of the master degree in Embedded System (Electronic Engineering) of Politecnico di Torino.<br/>
Tested in EMU8086 version 4.08 and Keil uVision5.<br/>

## Exam Text

### Specification 1

### Specification 2

### Specification 3
Given the 4 x 4 matrix `SOURCE` of words storing only positive data (represented in pure binary on 16 bits), write an 8086 assembly program, which computes the entries of another 4 x 4 matrix `MAPP` of bytes, according to the following very simple rule:<br/>
> If `SOURCE` (i, j) can be represented on 8 bits only, then `MAPP` (i, j) = 1<br/>
> Otherwise MAPP (i, j) = 0

-	The same program should also compute and store to the variable `CROSS` (on 16 bits) the sum of all the elements of `SOURCE` whose corresponding entry in `MAPP` is equal to 1.
-	In your solution, please provide the declaration of `SOURCE`, `MAPP`, and `CROSS` and the code, together with significant comments to the code and instructions.
-	Indeed, the choice is yours about how to store the matrices in the memory.

If you have time, in order to get up to one additional point, please also clearly and shortly respond to the following questions (as "comments in the program"): do we risk an overflow for `CROSS`? Why? Please consider that a wrong response to these optional questions will imply a negative score up to -1.

#### Example
Initial matrix `SOURCE`
```
10		20		100		10000
0		7000		1		2
9000		12345		999		30000
200		210		7		65000
```

Computed `MAPP`
```
1		1		1		0
1		0		1		1
0		0		0		0
1		1		1		0
```

Computed `CROSS`
```
10 + 20 + 100 + 0 + 1 + 2 + 200 + 210 + 7 = 550
```

Click on the following link to open a web page with the 8086 instruction set:<br/>
http://www.jegerlehner.ch/intel/IntelCodeTable.pdf


### Specification 4
In the fixed-point representation, a fixed number of digits is used to represent the fractional part of a number. Example of fixed-point number with 8 fractional digits: 101.10011101. The corresponding decimal value is:

1\*2<sup>2</sup> + 0\*2<sup>1</sup> + 1\*2<sup>0</sup> + 1\*2<sup>-1</sup> + 0\*2<sup>-2</sup> + 0\*2<sup>-3</sup> +1\*2<sup>-4</sup> + 1\*2<sup>-5</sup> +1\*2<sup>-6</sup> + 0\*2<sup>-7</sup> + 1\*2<sup>-8</sup> =<br/>
4 + 0 + 1 + 0.5 + 0 + 0 + 0.0625 + 0.03125 + 0.015625 + 0 + 0.00390625 =<br/>
5.61328125

Write the `restoringSquareRoot` subroutine in ARM assembly language, which returns the square root of a fixed-point number lower than 1. The subroutine receives in input:
-	a 32-bit value X
-	the number of fractional digits k

The subroutine computes the square root Q following the "restoring" algorithm:
```
1. Initialization: r = 2 * X, Q = 0, T = 2^(-1)
2. for i = 1 to k:
3.       if r >= T:
4.             r = r – T
5.             Q = Q + 2^(-i)
6.       T = 2 * Q + 2^[-(i + 1)]
7.       r = 2 * r
8. Return Q
```

#### Example
X = 0.100110, k = 6

The '.' separating integer and fractional digits is shown only for the sake of clarity.
- Initialization: r =  1.001100, Q = 0.000000, T = 0.100000
- Iteration 1: r >= T
  - r = 1.001100 – 0.100000 = 0.101100
  - Q = 0.000000 +  0.100000 =  0.100000
  - T = 1.000000 + 0.010000 = 1.010000
  - r = 2 * 0.101100 = 1.011000
- Iteration 2: r >= T
  - r = 1.011000 – 1.010000 = 0.001000
  - Q = 0.100000 +  0.010000 =  0.110000
  - T = 1.100000 + 0.001000 = 1.101000
  - r = 2 * 0.001000 =  0.010000
- Iteration 3: r < T
	- T = 1.100000 + 0.000100 = 1.100100
	- r = 2 * 0.010000 =  0.100000
- Iteration 4: r < T
	- T = 1.100000 + 0.000010 = 1.100010
	- r = 2 * 0.100000 =  1.000000
- Iteration 5: r < T
	- T = 1.100000 + 0.000001 = 1.100001
	- r = 2 * 1.000000 =  10.000000
- Iteration 6: r >= T
	- r = 10.000000 – 1.100001 = 0.011111
	- Q = 0.110000 + 0.000001 = 0.110001
	- T = 1.100010 + 0.000000 = 1.100010
	- r = 2 * 0.011111 = 0.111110
- The subroutine returns Q = 0110001.

Important notes:
1.	Create a new project with Keil inside the "template" directory and write your code there. The "template" directory contains the subdirectories "led" and "button" that you can add to your project if you need them.
2.	The assembly subroutine must comply with the ARM Architecture Procedure Call Standard (AAPCS) standard (about parameter passing, returned value, callee-saved registers).
3.	Click on the following links to open web pages with the ARM instruction set<br/>
http://www.keil.com/support/man/docs/armasm<br/>
https://developer.arm.com/documentation/ddi0337/e/Introduction/Instruction-set-summary?lang=en
4.	You can convert fixed-point numbers from/to base 2 and 10 at this link:<br/>
https://www.exploringbinary.com/binary-converter/

### Specification 5
Add the following functionalities to the project created in the previous exercise:<br/>
1. The user can specify a binary value through buttons Key1 and Key2. Key1 inserts a new digit equal to 0, while key2 inserts a new digit equal to 1. For example, if the user presses Key2, Key1, Key1, Key2, Key2, Key1, the final value is 100110
2. When the user presses INT0, call the `restoringSquareRoot` subroutine passing:
    - the value introduced before with Key1 and Key2 (e.g., 100110)
    - the number of times Key1 and Key2 were pressed before (e.g., 6)

Then, the lowest 8 bits of the value returned by the `restoringSquareRoot` subroutine are shown through the leds 4-11. Led 11 corresponds to the least significant bit. In the example, the lowest 8 bits of the returned value are 00110001, so the led status is:

led 4 off, led 5 off, led 6 on, led 7 on, led 8 off, led 9 off, led 10 off, led 11 on.

The management of the button bouncing is optional (i.e., not required).
