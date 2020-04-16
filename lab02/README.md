# CAs Lab 02
Laboratory 02 of the course Computer Architectures at Politecnico di Torino, academic year 2019/2020.<br/>
Tested with EMU8086 version 4.08.

## Write a program in 8086 assembly for multiplying two matrices whose elements are signed numbers expressed with one byte
- First matrix has `N` rows and `M` columns.
- Second matrix has `M` rows and `P` columns.
- The result is a matrix with `N` rows and `P` columns. The matrix contains sign numbers expressed with one word.
- `N`, `M`, `P` are constants defined with `EQU`.<br/>

### Overflow management
Overflow must be monitored.
- If the result after the overflow is positive, it must be replaced with the minimum negative number representable in one word (-32768).
- If the result after the overflow is negative, it must be replaced with the maximum positive number representable in one word (32767).
