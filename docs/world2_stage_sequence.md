# World 2 stage sequence

World 2 advances through a 229-byte one-byte instruction stream at
`$BDDF-$BEC3`. Three starts at `$8B38` select offsets 0, 37, and 92. The runtime
increments `World2StageSequenceOffset` before reading, so initialization stores
the selected start minus one.

## Instruction set

| Raw token | Command | Effect |
| --- | --- | --- |
| `$00-$EF` | `select_screen` | Select screen ID `token & $7F` |
| `$F0-$F6` | `set_pending_direction` | Store `token & 3` as the pending direction and force sequence advance after the current rows |
| `$F7` | `restore_saved_offset` | Replace the sequence offset with the saved branch/return offset |
| `$F8` | `stop_scroll` | Clear the scrolling-active byte and continue decoding |
| `$F9-$FF` | `set_background_palette` | Queue background-palette ID `token & 7`, save it for restoration, and continue decoding |

The decoder at `$838B-$83BD` proves this partition directly. Direction tokens
`$F3-$F6` are legal aliases by control flow even though only `$F0-$F2` occur in
the canonical sequence.

## Canonical shape

The stream contains 146 screen selections and 83 control commands:

| Command | Count |
| --- | ---: |
| screen selection | 146 |
| pending direction | 62 |
| restore saved offset | 10 |
| stop scroll | 4 |
| set background palette | 7 |

No screen token has bit 7 set. The 120 distinct screen IDs comprise the 119 ROM
screen selectors `$00-$76` plus terminal sentinel `$7F`. At offsets 132-133,
`$F8,$7F` clears the scrolling-active byte and selects the sentinel. Although
the generic selector computes pointer `$00FC`, the stopped state prevents any
compressed-token read; the controlled runtime scenario validates both facts.

The next byte, `$7B` at `$BEC4`, belongs to a 26-byte metatile collision bitmap.
The collision lookup at `$9377` independently proves the bytecode boundary by
indexing `$BEC4 + (metatile_id >> 3)`.

The palette consumer at `$8747` clears the pending request after copying one
16-byte set to PPU palette RAM. Canonical stage commands use IDs `$01-$06`;
the decoder also accepts ID `$07`. `$B4` retains
the most recent ID so the frame loop can restore it after a stage transition.
The palette catalog and exact selector relationships are documented in
`docs/world2_palettes.md`.

## Lossless authoring

`data/world2/stage_sequence.json` records every byte with its offset, raw token,
decoded command, and command-specific fields. Raw and semantic fields must
agree, so stale edits are rejected. The file also owns the three start-offset
bytes, for 232 losslessly covered bytes in total.

Run `make validate-world2-stage-sequence` to prove the decoder signatures,
opcode partition, command counts, start offsets, CRCs, and authoring round trip.
The `decode` and `encode` subcommands in `scripts/world2_stage_sequence.py`
regenerate the JSON or apply edited bytes to a supplied base PRG.
