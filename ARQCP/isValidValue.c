#include <stdio.h>

int isValid(int number, int lower, int upper) {
    return (number >= lower) && (number <= upper);
}

int isValidChar(char number, int lower, int upper) {	
    return (number >= lower) && (number <= upper);
}
