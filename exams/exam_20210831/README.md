# Exam of 31.08.2021
Exam of the Computer Architectures course of the master degree in Embedded System (Electronic Engineering) of Politecnico di Torino.<br/>
Tested in EMU8086 version 4.08 and Keil uVision5.<br/>

## Exam Text

### Specification 1

### Specification 2

### Specification 3
Given a 8 x 5 matrix of bytes `SOURCE` representing unsigned numbers, write a 8086 assembly program which computes on 16 bits (two's complement) the addition of all cells with indexes (i,j) where i+j is an even value, minus all the cells whose i+j is an odd value. Please consider that i ranges from 0 to 7 and j ranges from 0 to 4.<br/>
Please add significant comments to the code and instructions.<br/>
Friendly advice: before starting to write down the code, think at a possible (very) simple algorithm! The
choice of the algorithm highly influences the complexity and length of the code.

#### Example
Initial matrix `SOURCE`
```
1 2 3 4 5
6 7 8 9 0
9 8 7 6 5
4 3 2 1 0
7 7 7 7 7
3 5 7 9 0
8 7 6 5 4
9 9 9 3 2
```
The cells with i+j even are added up:
```
1 + 3 + 5 + 7 + 9 + 9 + 7 + 5 + 3 + 1 + 7 + 7 + 7 + 5 + 9 + 8 + 6 + 4 + 9 + 3 = 115
```
While the cells with i+j odd are subtracted:
```
- 2 - 4 - 6 - 8 - 0 - 8 - 6 - 4 - 2 - 0 - 7 - 7 - 3 - 7 - 0 - 7 - 5 - 9 - 9 - 2 = - 96
```
The result will be clearly on 16 bits in two's complement:
```
115 - 96 = 19
```
