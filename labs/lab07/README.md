# CAs Lab 07
Laboratory 07 of the Computer Architectures course of the master degree in Embedded System (Electronic Engineering) of Politecnico di Torino, academic year 2019/2020.<br/>
Tested in Keil uVision5.

## Write a program in ARM assembly language in order to multiply two matrices whose elements are signed numbers expressed on a word.
- First matrix has `N` rows and `M` columns.
- Second matrix has `M` rows and `P` columns.
- The result is a matrix with `N` rows and `P` columns.
- All martrices are made by signed numbers expressed with one word.
- `N`, `M`, `P` are constants defined with `EQU`.<br/>

### Declaration of matrices
The first two matrices are defined as constant in a `READONLY` memory area.
The third matrix has to be allocated in a `DATA READWRITE` area.

### Overflow handling
Intermediate sums have to be calculated on two words and at the end of a row\*column multiplication, check the most significant word of the partial sum.<br/>
In case of overflow, it is required to store as result the maximum number (positive or negative, depending on the overflow) expressable on a single word.

### Overflow conditions
If one of the following conditions is true, the result is not representable on a word
- The most significant word is different from `0` or from `0xFFFFFFFF`.
- The most significant word is equal to `0` or `0xFFFFFFFF`, but the most significant bit of the least significant word is different from the bits of the most significant word.
