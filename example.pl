#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use Math::Random::Biski64;

my $rng  = Math::Random::Biski64->new();

# --- Shuffle an array (Fisher-Yates) ---
my @deck = 1..52;
for my $i (reverse 1 .. $#deck) {
    my $j = $rng->next_u64 % ($i + 1);
    @deck[$i, $j] = @deck[$j, $i];
}
printf "Shuffled deck (top 5): %s\n", join ', ', @deck[0..4];

# --- Roll dice ---
my $roll = ($rng->next_u64 % 6) + 1;
printf "Dice roll: %d\n", $roll;

# --- Generate normally-distributed numbers (Box-Muller) ---
my @samples;
while (@samples < 6) {
    my $u1 = $rng->next_double;
    my $u2 = $rng->next_double;
    next if $u1 == 0;
    my $r = sqrt(-2 * log($u1));
    push @samples, sprintf '%.4f', $r * cos(6.28318530717959 * $u2);
    push @samples, sprintf '%.4f', $r * sin(6.28318530717959 * $u2);
}
printf "Normal samples: %s\n", join ', ', @samples[0..5];

# --- Parallel stream demo ---
my $base_seed = 12345;
my @streams = map { Math::Random::Biski64->for_stream($base_seed, $_, 4) } 0..3;
printf "Parallel stream first values:\n";
printf "  Stream %d: %u\n", $_, $streams[$_]->next_u64 for 0..3;
