# CAs Lab 05
Laboratory 05 of the Computer Architectures course of the master degree in Embedded System (Electronic Engineering) of Politecnico di Torino, academic year 2019/2020.<br/>
Tested in Keil uVision5.

## Exercise 1
Write a program in ARM assembly language executing this tasks:
- Rename register `r1` to `single_value`, `r2` to `double_value`, `r3` to `triple_value`, `r4` to `quadruple_value` e `r5` to `quintuple_value`.
- Assign some value to `single_value`.
- Assign to `double_value` = `single_value` *2 (by only using `MOV` and sum).
- Assign to `triple_value` = `single_value` *3 (by only using `MOV` and sum).
- Assign to `quadruple_value` = `single_value` * 4 (by only using `MOV` and sum).
- Assign to `quintuple_value` = `single_value` * 5 (by only using `MOV` and sum).

### Suggestions
- Exploit Inline Barrel Shifter with `MOV`
- For the sum, `Rd` = `Rn1` + `Rn2` use: `ADD Rd, Rn1, Rn2`

## Exercise 2
Write a program in ARM assembly language executing this tasks:
- Allocate 26 byte into a memory area `DATA READWRITE`, without initializing them.
- Initialize `r0` and `r1` to 1.
- Assign to registers `r2-r12` the elements of Fibonacci sequence.
For example: `r2` = `r1` + `r0`, `r3` = `r2` + `r1`, etc.
- Assign to `r14` the address of the first byte of memory area allocated before.
- Using pre indexed addressing, save the least significant byte of registers `r0-r12`, incrementing `r14` at each assingment.
- Using post indexed addressing mode, save the least significant byte of registers `r12-r0` (reverse order), incrementing `r14` at each assignment.
- At the end, check that the content of the memory is the following:
01 01 02 03 05 08 0D 15 22 37 59 90 E9 E9 90 59 37 22 15 0D 08 05 03 02 01 01

## Exercise 3
Write a program in ARM assembly language executing this tasks:
- Define the following constants in the code area
`myConstants DCW 57721, 56649, 15328, 60606, 51209, 8240, 24310, 42159`.
- Allocate 16 byte (4 word) in a data area.
- Considering the constants into couples, write in the 4 word the sum of the 4 couples of constants.
