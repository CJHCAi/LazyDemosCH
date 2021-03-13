#ifndef KECCAK_H
#define KECCAK_H

#include <stdint.h>
#include <string.h>

#ifndef KECCAK_ROUNDS
#define KECCAK_ROUNDS 24
#endif

#ifndef ROTL64
#define ROTL64(x, y) (((x) << (y)) | ((x) >> (64 - (y))))
#endif

int keccak(const uint8_t *in, int inlen, uint8_t *md, int mdlen);

void keccakf(uint64_t st[25], int norounds);

#endif

