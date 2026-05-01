#include <stdio.h>

/* Tell C that print_str exists in assembly */
void print_str(const char *s);

int main(void) {
    print_str("hi");
    return 0;
}