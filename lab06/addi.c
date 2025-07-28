// generate the encoded binary for an addi instruction, including opcode and operands
// JIAWEN LIN(z5647814) 16/06/2025
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "addi.h"
//001000ssssstttttIIIIIIIIIIIIIIII
// return the encoded binary MIPS for addi $t,$s, i
uint32_t addi(int t, int s, int i) {
    uint32_t opcode = 8 << 26;//Operation Code 
    uint32_t rs = s << 21;//Source register
    uint32_t rt = t << 16;//Destination reg
    uint32_t imm = i & 0xFFFF;//Immediate value
    return opcode|rs|rt|imm; // REPLACE WITH YOUR CODE
}
