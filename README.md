## Name

Math::Random::Biski64 - Fast 64-bit PRNG with guaranteed minimum 2^64 period

## Synopsis

```perl
use Math::Random::Biski64;

my $rng = Math::Random::Biski64->new(12345);

my $u64   = $rng->next_u64;
my $u32   = $rng->next_u32;
my $float = $rng->next_double;
```

## Description

This module implements the Biski64 algorithm, a fast and robust non-cryptographic
64-bit pseudo-random number generator. It uses a 64-bit Weyl sequence to guarantee
a minimum period of 2^64, and is designed for applications where speed and
statistical quality are important.

## Methods

### New($Seed?)

Create a new generator. If `$seed` is provided, the generator is seeded via
`seed`. Otherwise, call `seed` before generating numbers.

### Seed($Seed)

Initialize the generator from a 64-bit seed using SplitMix64 to expand the
seed into the full internal state, followed by a 16-iteration warm-up.

### Next\_u64

Returns the next 64-bit random integer.

### Next\_u32

Returns the next 32-bit random integer (upper 32 bits of the next\_u64 output).

### Next\_Double

Returns a random double in \[0, 1) by dividing next\_u64 by 2^64.

### For\_Stream($Seed, $Stream\_Index, $Total\_Streams)

Creates a generator for use in a parallel stream setup. `$seed` is the base
seed for all streams. `$stream_index` is the index of this stream (0-based).
`$total_streams` is the total number of streams.

## Algorithm

The Biski64 state consists of three 64-bit integers: `fast_loop`, `mix`,
and `loop_mix`. On each call:

```
output = mix + loop_mix
loop_mix = fast_loop ^ mix
mix = rotl(mix, 16) + rotl(loop_mix, 40)
fast_loop += 0x9999999999999999
```

## See Also

[https://github.com/danielcota/biski64](https://github.com/danielcota/biski64)

## License

MIT
