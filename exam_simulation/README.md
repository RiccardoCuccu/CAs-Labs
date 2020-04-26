# Exam Simulation
Exam Simulation of the Computer Architectures course of the master degree in Embedded System (Electronic Engineering) of Politecnico di Torino, academic year 2019/2020.<br/>
Tested in Keil uVision5.

## Exam Text
Write a `coprime` subroutine that checks if two positive integers `u` and `v` are coprime. The subroutine receives the two integers in input and returns 1 if they ar coprime, 0 otherwise. You should note that:
- if `u` and `v` are both even, they are not coprime;
- if `u` is even and `v` is odd, they are coprime only if `u/2` and `v` are coprime;
- if `u` and `v` are both odd and `u < v`, then they are coprime if `u` and `(v - u)/2` are coprime.

Therefore, you can use the following pseudocode:
```c
if (u is even AND v is even)
  return 0;
while (u is even)
  u = u / 2;
do {
  while (v is even)
    v = v / 2;
  if (u > v)
    swap u and v;
  v = v - u;
} while (v != 0);
if (u ==1)
  return 1;
else
  return 0;
```
Important: you can not use any operation of division for implementing the pseudocode. In particular, you can check if a number is even by testing if the least significant bit is 0. You can divide a number by 2 with a right shift.
