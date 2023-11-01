#include<stdio.h>
#include<string.h>

int main() {
    int a=3;
    float f;
    int x=1;
    a = x * 3 + 5;
    if(x>a) {
        printf("Hi!");
        a = x * 3 + 100;
        if(x>a) {
            printf("Hi!");
            a = x * 3 + 100;
        }
        else {
            x = a * 3 + 100;
        }
    }
    else {
        x = a * 3 + 100;
    }
    for (int i=1000; a>i; --i) {
        a = a + x;
    }
}