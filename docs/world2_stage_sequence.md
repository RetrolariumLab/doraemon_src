# World 2 stage sequence

World 2 advances through a 255-byte one-byte instruction stream at
`$BDDF-$BEDD`. Three starts at `$8B38` select offsets 0, 37, and 92. The runtime
increments `World2StageSequenceOffset` before reading, so initialization stores
the selected start minus one.

## Instruction set

| Raw token | Command | Effect |
| --- | --- | --- |
| `$00-$EF` | `select_screen` | Select screen ID `token & $7F` |
| `$F0-$F6` | `set_pending_direction` | Store `token & 3` as the pending direction and force sequence advance after the current rows |
| `$F7` | `restore_saved_offset` | Replace the sequence offset with the saved branch/return offset |
| `$F8` | `stop_scroll` | Clear the scrolling-active byte and continue decoding |
| `$F9-$FF` | `set_event_code` | Store `token & 7` in both event-code fields and continue decoding |

The decoder at `$838B-$83BD` proves this partition directly. Direction tokens
`$F3-$F6` are legal aliases by control flow even though only `$F0-$F2` occur in
the canonical sequence.

## Canonical shape

The stream contains 167 screen selections and 88 control commands:

| Command | Count |
| --- | ---: |
| screen selection | 167 |
| pending direction | 63 |
| restore saved offset | 10 |
| stop scroll | 5 |
| set event code | 10 |

Nine screen tokens have bit 7 set. Masking that bit produces 121 distinct
screen IDs, comprising the 119 standard ROM selectors plus dynamic IDs `$7B`
and `$7F`.

## Lossless authoring

`data/world2/stage_sequence.json` records every byte with its offset, raw token,
decoded command, and command-specific fields. Raw and semantic fields must
agree, so stale edits are rejected. The file also owns the three start-offset
bytes, for 258 losslessly covered bytes in total.

Run `make validate-world2-stage-sequence` to prove the decoder signatures,
opcode partition, command counts, start offsets, CRCs, and authoring round trip.
The `decode` and `encode` subcommands in `scripts/world2_stage_sequence.py`
regenerate the JSON or apply edited bytes to a supplied base PRG.
