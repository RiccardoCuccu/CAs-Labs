# Exam of 23.06.2021
Exam of the Computer Architectures course of the master degree in Embedded System (Electronic Engineering) of Politecnico di Torino.<br/>
Tested in EMU8086 version 4.08 and Keil uVision5.<br/>

## Exam Text

### Specification 1

### Specification 2

### Specification 3
Given a 5 x 5 matrix of bytes `SOURCE` representing unsigned numbers, write a 8086 assembly program which computes on 16 bits the sum of all cells excluding these on the main diagonal, i.e. upper left-to-lower-right diagonal, minus the sum of all the cells of the same main diagonal.<br/>
Please add significant comments to the code and instructions.<br/>
Friendly advice: before starting to write down the code, think at a possible (very) simple algorithm! The choice of the algorithm highly influences the complexity and length of the code.

#### Example
Initial matrix `SOURCE`
```
1 2 3 4 5
6 7 8 9 0
9 8 7 6 5
4 3 2 1 0
7 7 7 7 7
```
All cells excluding the main diagonal:
```
2 + 3 + 4 + 5 +
6 + 8 + 9 + 0 +
9 + 8 + 6 + 5 +
4 + 3 + 2 + 0 +
7 + 7 + 7 + 7 = 102
```
All cells on the main diagonal:
```
1 +
7 +
7 +
1 +
7 = 23
```
Result (on 16 bits in two's complement) = 102-23 = 79
