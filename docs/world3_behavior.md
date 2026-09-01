# World 3 behavior bytecode

Entity types `$00-$0F` select one of sixteen streams through the pointer table
at bank 2 `$D9AC`. The interpreter at `$9A3B` uses the high nibble as the
command and retains the low nibble as an inline parameter. Stream-local jump
operands are absolute eight-bit offsets from the selected stream base.

## Commands

| High nibble | Size | Operation |
| --- | ---: | --- |
| `$0n` | 1 | Move horizontally by `n`, using the current horizontal direction |
| `$1n` | 1 | Move horizontally by `n`, reversing the direction interpretation |
| `$2n` | 1 | Move vertically by `n`, using the current vertical direction |
| `$3n` | 1 | Move vertically by `n`, reversing the direction interpretation |
| `$4n aa` | 2 | Jump to stream offset `aa`; `n` is ignored |
| `$5n tt` | 2 | Wait for the `tt` countdown; `n` is ignored |
| `$6n` | 1 | Set the packed execution-rate counter to `n` |
| `$7n` | 1 | Set or randomize direction flags, then continue in the same frame |
| `$80 cc` | 2 | Load loop count `cc` and save the following offset as the loop body |
| `$81-$8F` | 1 | Decrement the loop count and return to the saved body while nonzero |
| `$9n xx yy` | 3 | Add direction-adjusted X/Y deltas; `n` is ignored |
| `$An xx yy` | 3 | Set absolute X/Y and clear the activation timer; `n` is ignored |
| `$Bn` | 1 | Write `n` to the two-step metasprite variant field |
| `$C0 pp aa` | 3 | Branch to `aa` when random value is at least threshold `pp` |
| `$C1 aa` | 2 | Branch to `aa` when entity X is at least player X |
| `$C2 aa` | 2 | Branch to `aa` when entity Y is at least player Y |
| `$C3-$CF pp aa` | 3 | Same random-threshold form as `$C0` |
| `$Dn vv` | 2 | Set the follow-anchor flag to `vv`; `n` is ignored |
| `$En` | 1 | Toggle the one-step metasprite variant; `n` is ignored |
| `$F0` | 1 | Stop interpreting without deactivating the entity |
| `$F1-$FF` | 1 | Stop and deactivate the entity unless its active state is four |

Direction command parameters `$70` and `$71` randomize the horizontal and
vertical flags respectively. `$78` clears both; `$79` sets horizontal; `$7A`
sets vertical. Other observed/default parameters set both flags.

Movement commands `$0n-$3n` perform collision probes before applying their
delta. Reaching the chapter bounds or a blocked tile flips the relevant
direction flag; horizontal motion also toggles the two-step metasprite variant.

## Static control-flow proof

The sixteen streams occupy `$D9CC-$DDF1` and range from one to 248 bytes, so
all local offsets fit in one byte. Recursive decoding starts at offset zero,
follows `$4n` jumps and both successors of `$Cn` branches, and classifies every
opcode and operand byte. The canonical payload yields:

- 532 decoded instructions;
- 1,062 covered bytes with no gaps or overlaps;
- 42 conditional branches;
- 12 stop instructions;
- no branch or jump into an operand or outside its stream.

Commands `$1n` and `$5n` are implemented by the interpreter but absent from
the reachable canonical streams. `config/world3_behavior.json` records the
complete per-stream CRC, instruction count, branch count, terminator count,
and aggregate opcode histogram.

## Lossless authoring format

`data/world3/behavior_streams.json` stores every stream as editable instruction
records with explicit offsets, opcodes, semantic command names, and operands.
The checked-in document round-trips to the exact 1,062 ROM bytes.

Decode the canonical PRG:

```text
python scripts/world3_behavior.py decode --prg assets/generated/prg/doraemon.prg --manifest config/world3_behavior.json --output data/world3/behavior_streams.json
```

Encode an edited document to a raw stream payload:

```text
python scripts/world3_behavior.py encode --input data/world3/behavior_streams.json --output build/world3_behavior.bin
```

The encoder rejects wrong operand counts, overlaps, uncovered bytes, stale
command names, invalid control-flow targets, and instruction boundaries that
change after encoding. `make validate-world3-behavior` verifies the checked-in
authoring document against the canonical PRG.
