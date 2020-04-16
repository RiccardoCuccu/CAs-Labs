# CAs Lab 06
Laboratory 06 of the course Computer Architectures at Politecnico di Torino, academic year 2019/2020.<br/>
Tested with Keil µVision.

## Exercise 1
- Cortex-M4 instruction set contains the following instruction:<br/>
`UADD8 <Rd>, <Rn>, <Rm>`
- `UADD8` sums corresponding bytes of `Rn` and `Rm`, storing the result in `Rd`.
- Example:<br/>
`Rn` = 0x 7A 30 45 8D<br/>
`Rm` = 0x C3 15 9E AA<br/>
`Rd` = 0x 3D 45 E3 37
- Please note the absence of carry between bytes in `Rd`.
- `UADD8` is not present in Cortex-M3 instruction set.
- Write instructions for Cortex-M3 equivalent to `UADD8 r4, r0, r1`.

## Exercise 2
- Cortex-M4 instruction set contains the following instruction:<br/>
`USAD8 <Rd>, <Rn>, <Rm>`
- Each byte of `Rn` and `Rm` is a pure binary number.
- `USAD8` calculates the absolute value of the difference between each byte in `Rn` and `Rm`.
- After that, `USAD8` sums the four absolute values, storing the result in in `Rd`.
- Example:<br/>
`Rn` = 0x 7A 30 45 8D<br/>
`Rm` = 0x C3 15 9E AA<br/>
1. | 0x8D - 0xAA| = 0x1D<br/>
2. | 0x45 - 0x9E | = 0x59<br/>
3. | 0x30 - 0x15 | = 0x1B<br/>
4. | 0x7A – 0xC3 | = 0x49<br/><br/>
`Rd` = 0x1D + 0x59 + 0x1B + 0x49 = 0xDA
- Note: the value in `Rd` can be on more than 8 bit
- `USAD8` is not present in Cortex-M3 instruction set.
- Write instructions for Cortex-M3 equivalent to `USAD8 r5, r0, r1`.

## Exercise 3
- Cortex-M4 instruction set contains the following instruction:<br/>
`SMUAD <Rd>, <Rn>, <Rm>`<br/>
`SMUSD <Rd>, <Rn>, <Rm>`<br/>
- Both instructions multiply the lower halfword of `Rn` times the lower halfword of `Rm`, and the higher halfword of `Rn` times the higher halfword of `Rm`.
- Halfwords are considered in two’s complement.
- `SMUAD` sums the two products and stores the result in `Rd`.
- `SMUSD` subtracts the product of high halfwords from the product of low halfwords, storing the result in `Rd`.
Example:<br/>
`Rn` = 0x7A30 458D<br/>
`Rm` = 0xC315 9EAA<br/>
0x458D * 0x9EAA = 0xE58E35A2<br/>
0x7A30 * 0xC315 = 0xE2EC95F0<br/>
With `SMUAD`, `Rd` = 0xC87ACB92<br/>
With `SMUSD`, `Rd` = 0x02A19FB2<br/>
- `SMUAD` and `SMUSD` are not present in Cortex-M3 instruction set.
- Write instructions for Cortex-M3 equivalent to `SMUAD r6, r0, r1` and `SMUSD r7, r0, r1`.
- The sign of halfwords has to be extended before multiplication.
- Example in pure binary:<br/>
0x458D = 17805<br/>
0x9EAA = 40618<br/>
0x458D * 0x9EAA = 0x2B1B35A2 = 723.203.490<br/>
- In two’s complement:<br/>
0x9EAA = -24918<br/>
0x458D * 0x9EAA = 0xE58235A2 = -443.664.990<br/>

## Exercise 4
- Create a new project selecting a board with Cortex-M4 core, for instance NXP LPC4072.
Write instructions:<br/>
`UADD8 r4, r0, r1`<br/>
`USAD8 r5, r0, r1`<br/>
`SMUAD r6, r0, r1`<br/>
`SMUSD r7, r0, r1`<br/>
- Verify that results are coherent with the ones obtained in the previous exercises.
