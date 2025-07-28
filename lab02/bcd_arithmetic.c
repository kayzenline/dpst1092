// Author: JIAWEN LIN
// Date: 21/05/2025
// z5647814
// Subtract, Multiply and Divide 2 Arbitrary Length BCD Values

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <ctype.h>
#include <string.h>

//
// Store an arbitray length Binary Coded Decimal number
// bcd points to an array of size n_bcd
// each array element contains 1 decimal digit
//

typedef struct big_bcd {
    unsigned char *bcd;
    int n_bcd;
} big_bcd_t;


void bcd_print(big_bcd_t *number);
void bcd_free(big_bcd_t *number);
big_bcd_t *bcd_from_string(char *string);

big_bcd_t *expression(char ***tokens);
big_bcd_t *term(char ***tokens);

int main(int argc, char *argv[]) {
    char **tokens = argv + 1;

    // tokens points in turn to each of the elements of argv
    // as the expression is evaluated.

    if (*tokens) {
        big_bcd_t *result = expression(&tokens);
        bcd_print(result);
        printf("\n");
        bcd_free(result);
    }

    return 0;
}


// DO NOT CHANGE THE CODE ABOVE HERE


big_bcd_t *bcd_add(big_bcd_t *x, big_bcd_t *y) {
    // PUT YOUR CODE HERE
    int max_len;
    if(x->n_bcd > y->n_bcd) {
        max_len = x->n_bcd;
    } else {
        max_len = y->n_bcd;
    }

    big_bcd_t *result = malloc(sizeof(struct big_bcd));
    if (result == NULL) {
        perror("malloc failed");
        exit(1);
    }

    result->bcd = malloc((max_len + 1) * sizeof(unsigned char));
    if (result->bcd == NULL) {
        perror("malloc failed");
        exit(1);
    }

    result->n_bcd = max_len;
    int carry = 0;

    for(int i = 0; i < max_len; i++) {
        int digit_x;
        int digit_y;

        if (i < x->n_bcd) {
            digit_x = x->bcd[i];

        } else {
            digit_x = 0;
        }

        if (i < y->n_bcd) {
            digit_y = y->bcd[i];
        } else {
            digit_y = 0;
        }
        
        int sum = digit_x + digit_y + carry;
        result->bcd[i] = sum % 10;
        carry = sum / 10;
    }

    if(carry != 0) {
        result->bcd[result->n_bcd] = carry;
        result->n_bcd += 1;
    }
    return result;
}



big_bcd_t *bcd_subtract(big_bcd_t *x, big_bcd_t *y) {
    // PUT YOUR CODE HERE
    big_bcd_t *result = malloc(sizeof(struct big_bcd));
    if (result == NULL) {
        perror("malloc failed");
        exit(1);
    }

    result->bcd = malloc(x->n_bcd * sizeof(unsigned char));
    if (result->bcd == NULL) {
        perror("malloc failed");
        exit(1);
    }

    result->n_bcd = x->n_bcd;

    int borrow = 0;

    for (int i = 0; i < x->n_bcd; i++) {
        int digit_x;
        int digit_y;

        if (i < x->n_bcd) {
            digit_x = x->bcd[i];
        } else {
            digit_x = 0;
        }

        if (i < y->n_bcd) {
            digit_y = y->bcd[i];
        } else {
            digit_y = 0;
        }

        int diff = digit_x - digit_y - borrow;

        if (diff < 0) {
            diff = diff + 10;
            borrow = 1;
        } else {
            borrow = 0;
        }

        result->bcd[i] = diff;
    }
    int new_length = result->n_bcd;
    while (new_length > 1 && result->bcd[new_length - 1] == 0) {
        new_length = new_length - 1;
    }
    result->n_bcd = new_length;

    return result;
}

big_bcd_t *bcd_multiply(big_bcd_t *x, big_bcd_t *y) {
    int max_result_length = x->n_bcd + y->n_bcd;

    big_bcd_t *result = malloc(sizeof(struct big_bcd));
    if (result == NULL) {
        perror("malloc failed");
        exit(1);
    }

    result->bcd = calloc(max_result_length, sizeof(unsigned char));
    if (result->bcd == NULL) {
        perror("malloc failed");
        exit(1);
    }

    result->n_bcd = max_result_length;

    for (int i = 0; i < y->n_bcd; i++) {
        int digit_y = y->bcd[i];
        int carry = 0;

        for (int j = 0; j < x->n_bcd; j++) {
            int digit_x = x->bcd[j];

            int product = digit_x * digit_y + result->bcd[i + j] + carry;

            result->bcd[i + j] = product % 10;
            carry = product / 10;
        }

        if (carry > 0) {
            result->bcd[i + x->n_bcd] += carry;
        }
    }

    int new_length = result->n_bcd;
    while (new_length > 1 && result->bcd[new_length - 1] == 0) {
        new_length = new_length - 1;
    }
    result->n_bcd = new_length;

    return result;
}

int bcd_compare(big_bcd_t *a, big_bcd_t *b) {
    if (a->n_bcd > b->n_bcd) {
        return 1;
    } else if (a->n_bcd < b->n_bcd) {
        return -1;
    }

    for (int i = a->n_bcd - 1; i >= 0; i--) {
        if (a->bcd[i] > b->bcd[i]) return 1;
        if (a->bcd[i] < b->bcd[i]) return -1;
    }
    return 0;
}

big_bcd_t *bcd_clone(big_bcd_t *src) {
    big_bcd_t *copy = malloc(sizeof(struct big_bcd));
    copy->n_bcd = src->n_bcd;
    copy->bcd = malloc(copy->n_bcd * sizeof(unsigned char));
    for (int i = 0; i < copy->n_bcd; i++) {
        copy->bcd[i] = src->bcd[i];
    }
    return copy;
}

big_bcd_t *bcd_divide(big_bcd_t *x, big_bcd_t *y) {
    if (y->n_bcd == 1 && y->bcd[0] == 1) {
    return bcd_clone(x);
    }
    big_bcd_t *quotient = malloc(sizeof(struct big_bcd));
    quotient->n_bcd = 1;
    quotient->bcd = malloc(sizeof(unsigned char));
    quotient->bcd[0] = 0;

    int is_zero = 1;
    for (int i = 0; i < y->n_bcd; i++) {
        if (y->bcd[i] != 0) {
            is_zero = 0;
            break;
        }
    }
    if (is_zero) {
        fprintf(stderr, "Error: divide by zero\n");
        exit(1);
    }

    big_bcd_t *temp = bcd_clone(x);

    while (bcd_compare(temp, y) >= 0) {
        big_bcd_t *new_temp = bcd_subtract(temp, y);
        bcd_free(temp);
        temp = new_temp;

        big_bcd_t *one = bcd_from_string("1");
        big_bcd_t *new_quotient = bcd_add(quotient, one);
        bcd_free(quotient);
        bcd_free(one);
        quotient = new_quotient;
    }

    bcd_free(temp);
    return quotient;
}



// DO NOT CHANGE THE CODE BELOW HERE


// print a big_bcd_t number
void bcd_print(big_bcd_t *number) {
    // if you get an error here your bcd_arithmetic is returning an invalid big_bcd_t
    assert(number->n_bcd > 0);
    for (int i = number->n_bcd - 1; i >= 0; i--) {
        putchar(number->bcd[i] + '0');
    }
}


// DO NOT CHANGE THE CODE BELOW HERE

// free storage for big_bcd_t number
void bcd_free(big_bcd_t *number) {
    // if you get an error here your bcd_arithmetic is returning an invalid big_bcd_t
    // or it is calling free for the numbers it is given
    free(number->bcd);
    free(number);
}

// convert a string to a big_bcd_t number
big_bcd_t *bcd_from_string(char *string) {
    big_bcd_t *number = malloc(sizeof *number);
    assert(number);

    int n_digits = strlen(string);
    assert(n_digits);
    number->n_bcd = n_digits;

    number->bcd = malloc(n_digits * sizeof number->bcd[0]);
    assert(number->bcd);

    for (int i = 0; i < n_digits; i++) {
        int digit = string[n_digits - i - 1];
        assert(isdigit(digit));
        number->bcd[i] = digit - '0';
    }

    return number;
}


// simple recursive descent evaluator for  big_bcd_t expressions
big_bcd_t *expression(char ***tokens) {

    big_bcd_t *left = term(tokens);
    assert(left);

    if (!**tokens|| (***tokens != '+' && ***tokens != '-')) {
        return left;
    }

    char *operator = **tokens;
    (*tokens)++;

    big_bcd_t *right = expression(tokens);
    assert(right);

    big_bcd_t *result;
    if (operator[0] == '+') {
        result = bcd_add(left, right);
    } else {
        assert(operator[0] == '-');
        result = bcd_subtract(left, right);
    }
    assert(result);

    bcd_free(left);
    bcd_free(right);
    return result;
}


// evaluate a term of a big_bcd_t expression
big_bcd_t *term(char ***tokens) {

    big_bcd_t *left = bcd_from_string(**tokens);
    assert(left);
    (*tokens)++;

    if (!**tokens || (***tokens != '*' && ***tokens != '/')) {
        return left;
    }

    char *operator = **tokens;
    (*tokens)++;

    big_bcd_t *right = term(tokens);
    assert(right);

    big_bcd_t *result;
    if (operator[0] == '*') {
        result = bcd_multiply(left, right);
    } else {
        result = bcd_divide(left, right);
    }
    assert(result);

    bcd_free(left);
    bcd_free(right);
    return result;
}
