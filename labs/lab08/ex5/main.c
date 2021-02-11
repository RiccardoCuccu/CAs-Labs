#include <stdio.h>

extern int myUADD8(int var1, int var2);

int main(void) {
    int sum;
    int var1 = 0x7A30458D;
    int var2 = 0xC3159EAA;
    sum = myUADD8(var1, var2);
    return sum;
}
