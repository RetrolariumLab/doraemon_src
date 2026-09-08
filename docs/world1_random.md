# World 1 pseudorandom generators

PRG bank 0 contains two independent byte-producing pseudorandom routines.
Their RAM ranges, exact machine-code bodies, and every direct `JSR` occurrence
are fixed by `config/reconstruction/world1/world1_random.json` and checked by
`scripts/validation/world1/world1_random.py`.

| Routine | Address | State | Frame mixed | Direct calls |
| --- | ---: | --- | --- | ---: |
| `World1_FrameRandomByte` | `$962F` | `$0052-$0053` (`World1FrameRandomState`) | yes | 7 |
| `World1_RandomByte` | `$964A` | `$0054-$0057` (`World1RandomState`) | no | 18 |

`World1_FrameRandomByte` increments one state byte, decrements the other, and
mixes both with `FrameCounter`. Calls made with the same initial state can
therefore diverge on different frames. `World1_RandomByte` updates its four
state bytes without reading frame timing, so its output is determined by the
previous state alone.

Both ranges are cleared by the normal chapter initialization and explicitly by
the demo-entry path. The adjacent layout does not make them one six-byte
generator: neither routine accesses the other routine's state. The static
callsite totals describe exhaustive bank-wide `JSR` byte-pattern coverage,
not runtime invocation frequency.

Run the focused contract with:

```text
make validate-world1-random
```
