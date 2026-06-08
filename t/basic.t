use strict;
use warnings;
use Test::More tests => 21;

BEGIN { use_ok 'Math::Random::Biski64' }

# Default RNG is auto-seeded at module load
my $default = Math::Random::Biski64->new();
isa_ok $default, 'Math::Random::Biski64', 'default RNG';
ok defined $default->next_u64, 'default produces a value';

# Deterministic seeding
my $rng = Math::Random::Biski64->new(12345);
isa_ok $rng, 'Math::Random::Biski64', 'new with seed';
my @expected = (
    602457908646571220,
    10831703241751616260,
    9045905474721525462,
    6056737633715403807,
    12343206235777992780,
);
is $rng->next_u64, $expected[0], 'output 1 matches reference';
is $rng->next_u64, $expected[1], 'output 2 matches reference';
is $rng->next_u64, $expected[2], 'output 3 matches reference';
is $rng->next_u64, $expected[3], 'output 4 matches reference';
is $rng->next_u64, $expected[4], 'output 5 matches reference';

# Determinism: same seed → same sequence
my $a = Math::Random::Biski64->new(42);
my $b = Math::Random::Biski64->new(42);
is $a->next_u64, $b->next_u64, 'deterministic across instances';
is $a->next_u64, $b->next_u64, 'deterministic continues';

# Re-seeding
$rng->seed(99);
my $c = Math::Random::Biski64->new(99);
is $rng->next_u64, $c->next_u64, 're-seed works';

# next_u32 returns upper 32 bits
my $r32 = Math::Random::Biski64->new(12345);
my $full = $r32->next_u64;
$r32->seed(12345);
is $r32->next_u32, $full >> 32, 'next_u32 is upper 32 bits';

# next_double is in [0, 1)
my $r_dbl = Math::Random::Biski64->new(777);
my $d = $r_dbl->next_double;
ok $d >= 0 && $d < 1, 'next_double in [0, 1)';
$d = $r_dbl->next_double;
ok $d >= 0 && $d < 1, 'next_double in range (2nd call)';

# Auto-seeded new() produces non-zero outputs
my $r_auto = Math::Random::Biski64->new;
ok $r_auto->next_u64 > 0, 'auto-seeded non-zero';
ok $r_auto->next_u64 > 0, 'auto-seeded non-zero (2nd)';

# for_stream produces deterministic per-stream
my $s0a = Math::Random::Biski64->for_stream(42, 0, 4);
my $s0b = Math::Random::Biski64->for_stream(42, 0, 4);
is $s0a->next_u64, $s0b->next_u64, 'stream deterministic';

# Different streams differ
my $s1 = Math::Random::Biski64->for_stream(42, 1, 4);
my $s2 = Math::Random::Biski64->for_stream(42, 2, 4);
cmp_ok $s0a->next_u64, '!=', $s1->next_u64, 'stream 0 ≠ stream 1';
cmp_ok $s0a->next_u64, '!=', $s2->next_u64, 'stream 0 ≠ stream 2';

# os_random_u64 returns non-zero
my $os = Math::Random::Biski64::os_random_u64();
ok $os > 0, 'os_random_u64 returns non-zero';
