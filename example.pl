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
for (1 .. 5) {
    push(@samples, $rng->next_double());
}
printf("Normal samples: %s\n", join ', ', @samples);
