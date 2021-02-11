#include <stdio.h>
#include <math.h>

int intHypotenuse(int var1, int var2) {
    int result;
    double a, b, hypotenuse;
    //var1 = 2.0;                       // var1 stored in r5 + r4 (0x40000000 00000000 = 2.0)
    //var2 = 3.0;                       // var2 stored in r7 + r6 (0x40080000 00000000 = 3.0)
    a = (double) var1;                  // convert to double
    b = (double) var2;                  // convert to double
    hypotenuse = hypot(a, b);           // result stored in r1 + r0 (0x400CD82B 446159F3 = 3.60555127546398912485869914235E0)
    result = round(hypotenuse);         // round to integer
    return result;
}
