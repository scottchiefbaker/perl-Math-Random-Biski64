## Name

Math::Random::Biski64 - Fast 64-bit PRNG with guaranteed minimum 2^64 period

## Synopsis

```perl
use Math::Random::Biski64;

# Use the auto-seeded default generator
my $rng1 = Math::Random::Biski64->new();
my $num  = $rng->next_u64;

# Or create your own with a specific 64bit seed
my $rng2 = Math::Random::Biski64->new(12345);
my $num  = $rng2->next_u32;
```

## Description

This module implements the Biski64 algorithm, a fast and robust non-cryptographic
64-bit pseudo-random number generator. It uses a 64-bit Weyl sequence to guarantee
a minimum period of 2^64, and is designed for applications where speed and
statistical quality are important.

On module load, a default generator is automatically seeded from the OS
random source (`/dev/urandom` on Unix, `RtlGenRandom` on Windows).

## Methods

### new($seed?)

Create a new generator. If `$seed` is provided, the generator is seeded via
`seed`. Otherwise, the generator is seeded from the OS random source.

### seed($seed)

Initialize the generator from a 64-bit seed using SplitMix64 to expand the
seed into the full internal state, followed by a 16-iteration warm-up.

### next\_u64

Returns the next 64-bit random integer.

### next\_u32

Returns the next 32-bit random integer (upper 32 bits of the next\_u64 output).

### next\_double

Returns a random double in \[0, 1).

### Rand\_Integer($Min, $Max)

Returns an unbiased random integer in the inclusive range `$min` to
`$max`. Uses rejection sampling to eliminate modulo bias: if the raw
64-bit value exceeds the largest multiple of the range that fits in 2^64,
it is rejected and a new value is drawn.

Returns `$min` unchanged if `$min` >= `$max`.

## Algorithm

The Biski64 state consists of three 64-bit integers: `fast_loop`, `mix`,
and `loop_mix`. On each call:

```
output     = mix + loop_mix
loop_mix   = fast_loop ^ mix
mix        = rotl(mix, 16) + rotl(loop_mix, 40)
fast_loop += 0x9999999999999999
```

## See Also

[https://github.com/danielcota/biski64](https://github.com/danielcota/biski64)

## License

MIT
