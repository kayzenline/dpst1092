#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "matchbox.h"

#define BYTE_LENGTH 8


struct packed_matchbox pack_matchbox(char *filename) {
    // TODO: complete this function!
    // You may find the definitions in matchbox.h useful.
    FILE *f = fopen(filename, "rb");
    uint8_t low = (uint8_t)fgetc(f);
    uint8_t high = (uint8_t)fgetc(f);
    uint16_t sequence_length = (uint16_t)((high << 8) | low);

    size_t packed_len = num_packed_bytes(sequence_length);

    uint8_t *packed_bytes = calloc(packed_len, 1);

    for (size_t i = 0; i < sequence_length; i++) {
        int ch = fgetc(f);
        if (ch == '1') {
            size_t byte_idx = i / 8;
            uint8_t mask = 1u << (7 - (i % 8));
            packed_bytes[byte_idx] |= mask;
        }
    }

    struct packed_matchbox matchbox = {
        .sequence_length = sequence_length,
        .packed_bytes = packed_bytes
    };

    fclose(f);
    
    return matchbox;
}
