# Math::Random::Biski64 — agent guide

## Commands

```bash
# Run tests (no build step needed)
perl -Ilib t/basic.t
```

## Repo structure

Single-file module at `lib/Math/Random/Biski64.pm`, one test file `t/basic.t`, no build dependencies beyond `ExtUtils::MakeMaker`. Add new files to `MANIFEST`.

## Architecture

- State: blessed hashref with keys `fast_loop`, `mix`, `loop_mix` (`Biski64.pm:102`)
- 64-bit arithmetic uses `use integer`/`no integer` scoping + `| 0` to force UV (`Biski64.pm:72`). Always follow this pattern for 64-bit ops.
- Seeding via SplitMix64; seed param is an arrayref mutated in-place (`Biski64.pm:65-89`)
- `os_random_bytes` caches `/dev/urandom` FH in `$URANDOM_FH` — reopen only on undef

## Conventions & gotchas

- **`rand_integer` always preferred over raw `next_u64 % range`** — rejection sampling avoids modulo bias. `shuffle_array` uses `rand_integer` for this reason.
- **`shuffle_array` copies `@_` explicitly** (`Biski64.pm:146`) because `@_` elements are aliased to the caller's array; mutating them would modify the original.
- **`$a`/`$b` sort shadowing hazard**: declaring `my $a` at file scope breaks `sort { $a <=> $b }` blocks. Use distinct variable names (e.g., `$rng_a`, `$rng_b`).
- `$VERSION` is in the `.pm` file only (`v0.1.1`). Update it there on release.
- `no warnings 'portable'` is required for 64-bit constant bitwise ops.
- `for_stream` with `$total_streams == 1` simply uses the seed directly (no offset).
