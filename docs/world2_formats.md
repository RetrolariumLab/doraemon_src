# World 2 Data and Rendering Formats

This chapter joins the inventory, compressed-screen, stage-sequence, branch, metatile, metasprite, and palette formats used by World 2. The `config/authoring/world2/` manifests and checked-in `data/world2/` documents remain the canonical schemas and editable representations.

## Contents

- Inventory and companion state
- Compressed screens and conditional stage flow
- Metatiles, metasprites, and palettes
- Lossless authoring boundaries

## World 2 inventory and companions

World 2 keeps seven fixed inventory slots in three parallel zero-page arrays:
state at `$7C-$82`, X at `$83-$89`, and Y at `$8A-$90`. The slots cover both
rescued companions and carried items, so the source uses the neutral inventory
name until each fixed index is identified independently.

### Runtime states

| Value | Name | Evidence |
| ---: | --- | --- |
| 0 | absent | update and render routines return immediately |
| 1 | entering | slot moves in from a screen edge |
| 2 | homing to player | X and Y approach their target every frame |
| 3 | active | companion/item behavior and attacks are enabled |
| 4 | knocked loose | damage changes an active slot to this detached state |

The aggregate updater at `$8BAC` calls handlers for all seven fixed slots.
After the damage counter reaches its threshold, `$8C04` searches active slots
0-5 backwards and changes one to state 4. Slot 6 is deliberately outside that
drop scan.

### Spawn screens

The seven-byte table at `$A6B5` contains screen IDs `$14,$1A,$1F,$47,$45,$6D,$74`.
The routine at `$A65E` searches it backwards before trying to activate a free
inventory slot at X `$78`, Y `$F0`. The table identifies eligible screens; it
does not map table index directly to inventory index.

`data/world2/inventory_spawn_screens.json` is the lossless editable view. Run
`make validate-world2-inventory` to verify its round trip, the zero-page pool
layout, all five state transitions, and the code signatures tying them together.

## World 2 metasprites

World 2 uses a fixed 16-by-16 metasprite format for the player, enemies,
projectiles, effects, and large composite enemies. The renderer at `$A35B`
selects one of 58 records and emits four ordinary NES OAM entries in a
two-by-two arrangement.

### Three-table format

Each metasprite index selects parallel data:

| Range | Entries | Meaning |
| --- | ---: | --- |
| `$A3DC-$A4C3` | 58 × 4 | top-left, top-right, bottom-left, bottom-right CHR tiles |
| `$A4C4-$A4FD` | 58 | palette in bits 0-1 and OAM-attribute base in bits 2-5 |
| `$A526-$A549` | 36 | per-piece priority and horizontal/vertical flip bits |

The descriptor's attribute base is a multiple of four. The renderer adds the
piece number, reads the corresponding OAM attribute, and then ORs in the
two-bit palette. Horizontal reflection XORs the tile and attribute indexes
with three and toggles the OAM horizontal-flip bit. Tile zero suppresses the
OAM append, which accounts for four empty pieces in the canonical catalog.

The catalog contains 118 distinct CHR tile numbers. Its descriptors select all
four sprite palettes with histogram 11, 22, 10, and 15. World 2 explicitly
selects CHR bank 1 and configures 8-by-8 sprites from pattern table `$0000`.

### Enemy-state references

The 20 ordinary enemy states directly select 45 of the 58 metasprite indexes.
`config/authoring/world2/world2_metasprites.json` records each exact
state-to-index set,
including the six-index composite renderers for states `$12` and `$13` and
the invisible states `$09` and `$11`.

The remaining thirteen indexes are not unused globally. Most participate in
the `$70-$7A` enemy defeat/effect path or sit between the grouped composite
frames. The contract therefore calls them only *not directly selected by the
ordinary enemy-state render handlers*.

### Shared storage

Two boundaries deliberately have more than one interpretation:

- descriptor 57 at `$A4FD` is also state zero of the enemy attack-period
  table;
- OAM attributes 34 and 35 at `$A548-$A549` are also the unused state-zero
  prefix immediately before the active render dispatch at `$A54A`.

Both views are checked against the enemy-state and object-dispatch contracts.
The source keeps labels at each semantic boundary, so the overlap remains
visible in the assembled representation.

### Lossless authoring and rendering

`data/world2/metasprites.json` exposes all 58 tile quads and descriptors plus
all 36 OAM attribute bytes. The three physical ranges cover 326 unique bytes
with combined CRC32 `512433b5` and round-trip without loss.

Run `make validate-world2-metasprites` for the full data, overlap, CHR, palette,
enemy-reference, renderer-signature, and authoring checks. A research contact
sheet can be generated without adding ROM-derived graphics to Git:

```text
python -B scripts/run.py validation.world2.world2_metasprites render \
  --prg assets/generated/prg/doraemon.prg \
  --chr assets/generated/chr/doraemon.chr \
  --manifest config/authoring/world2/world2_metasprites.json \
  --palette-authoring data/world2/palettes.json \
  --palette-record 7 \
  --output build/world2_metasprites.png
```

## World 2 metatiles

World 2 screen literals are not CHR tile indexes. The renderer expands every
`$00-$CF` literal into one 2x2 CHR-tile metatile and merges a two-bit palette
selector into the nametable attribute cache.

### Exact runtime layout

| Region | Address | Size |
| --- | ---: | ---: |
| unindexed CadEditor prefix | `$B9CE` | 1 byte |
| palette selectors | `$B9CF-$BA9E` | 208 bytes |
| 2x2 CHR-tile quads | `$BA9F-$BDDE` | 208x4 bytes |
| stage sequence | `$BDDF-$BEC3` | 229 bytes |
| collision bitmap | `$BEC4-$BEDD` | 26 bytes / 208 bits |
| next region: screen pointers | `$BEDE` | - |

The four tile bytes are top-left, top-right, bottom-left, and bottom-right.
Routine `$84FC` uses the high two bits of the metatile ID to select bases
`$BA9F`, `$BB9F`, `$BC9F`, or `$BD9F`; the low six bits become a four-byte
offset. This addresses exactly 208 records because screen literals stop at
`$CF`. The last record ends at `$BDDE`, immediately before stage bytecode.

The collision routine at `$9377` converts a world coordinate to one of the 256
cells in the current `$0400` screen buffer. It splits the resulting metatile ID
into `id >> 3` and an MSB-first mask `$80 >> (id & 7)`, then tests the byte at
`$BEC4`. A set bit is treated as solid by movement and projectile callers. The
canonical bitmap marks 100 of 208 metatiles solid.

The byte `$FF` at `$B9CE` is the first byte of CadEditor's declared attribute
view, but the renderer indexes from `$B9CF`. It is preserved losslessly and
explicitly classified as unindexed; no gameplay meaning is inferred.

All 208 palette values are in `$00-$03`. Their canonical counts are 123, 20,
28, and 37. The standard ROM screen streams reference 203 metatile IDs. Five
records (`$27`, `$38`, `$44`, `$51`, and `$79`) are not referenced by those
streams. `$7F` is a stopped terminal sentinel and does not add another stream.

### Lossless authoring

`data/world2/metatiles.json` stores the prefix and 208 row-oriented records.
Each record contains its palette, four CHR indexes, solid flag, and whether a
standard ROM stream references the ID. Decode it with:

```text
python scripts/run.py validation.world2.world2_metatiles decode --prg assets/generated/prg/doraemon.prg --manifest config/authoring/world2/world2_metatiles.json --screen-authoring data/world2/compressed_screens.json --output data/world2/metatiles.json
```

An edited catalog can be applied to a base PRG:

```text
python scripts/run.py validation.world2.world2_metatiles encode --input data/world2/metatiles.json --base-prg assets/generated/prg/doraemon.prg --output build/world2_metatiles.prg
```

`make validate-world2-metatiles` locks all four data CRCs, the complete
124-byte renderer signature, table boundaries, palette domain and histogram,
screen cross-references, collision lookup and bit order, authoring metadata,
and the 1,067-byte round trip.

## World 2 palettes

World 2 stores nine distinct 16-byte NES palette sets at `$87A1-$8830`.
Routine `$8751` uploads a background set to PPU `$3F00`; routine `$8784`
continues at `$3F10` with a sprite set during chapter initialization.

### Lookup relationships

Background IDs are indexed from `$8791`, exactly sixteen bytes before the
tracked data. Therefore ID 1 selects record 0 at `$87A1`, ID 2 selects record 1,
and so on. The decoder accepts `$F9-$FF` as IDs 1-7, while the canonical
229-byte stage sequence contains seven requests using IDs 1-6. Each request
stores the ID in both the pending byte at `$009D` and saved selector `$00B4`.

The pending request consumer at `$8747` uploads the selected set and clears the
request. A negative request, used by the transition loop, instead selects
`$0073 & 3`; ID 0 deliberately starts at `$8791`, overlapping the tail of the
palette-upload code. The complete `$8747-$87A0` signature is pinned so that
this code/data overlap cannot be normalized away accidentally.

Chapter initialization uses two three-byte tables:

| Chapter | Background ID | Sprite offset | Sprite record |
| ---: | ---: | ---: | ---: |
| 0 | 1 | `$10` | 6 |
| 1 | 4 | `$20` | 7 |
| 2 | 5 | `$30` | 8 |

Sprite offsets are added to `$87F1`; the resulting addresses are `$8801`,
`$8811`, and `$8821`. All 144 palette bytes are valid `$00-$3F` NES colors,
all nine sets are distinct, and every set begins with universal color `$0F`.

### Lossless authoring

`data/world2/palettes.json` stores nine ordered color arrays and the three
chapter selector pairs. Decode the canonical data with:

```text
python scripts/run.py validation.world2.world2_palettes decode --prg assets/generated/prg/doraemon.prg --manifest config/authoring/world2/world2_palettes.json --stage-authoring data/world2/stage_sequence.json --output data/world2/palettes.json
```

Apply an edited catalog to a base PRG with:

```text
python scripts/run.py validation.world2.world2_palettes encode --input data/world2/palettes.json --base-prg assets/generated/prg/doraemon.prg --output build/world2_palettes.prg
```

`make validate-world2-palettes` verifies data CRCs, both code signatures,
chapter lookup arithmetic, the seven stage palette commands, NES color limits,
and the complete 150-byte authoring round trip.

## World 2 conditional stage branches

World 2 checks 17 special screen IDs once per frame in the routine at
`$A6BC-$A70E`. A branch can fire only while the compressed-screen renderer is
on row 13 and the branch cooldown is zero. A successful branch decrements the
zero cooldown to `$FF`; subsequent calls count it down for 255 frames.

### Conditions

Four parallel 17-byte tables at `$A70F-$A752` define the trigger screen,
destination stage offset, condition, and optional fixed return offset.

| Code | Condition |
| ---: | --- |
| 0 | always |
| 1 | player Y is below `$50` |
| 2 | player X is at least `$A0` |
| 3 | player Y is at least `$A0` |

The canonical table has 4 unconditional entries, 5 upper-Y entries, 1
right-side X entry, and 7 lower-Y entries. Five branches override the return
offset. The other twelve save the current stage-sequence offset dynamically.

The destination is stored as `destination - 1` because the stage decoder
increments `World2StageSequenceOffset` before fetching its next byte. An `$F7`
stage command restores `World2SavedStageSequenceOffset`; decoder control flow
then increments that saved value before its next fetch.

### Lossless authoring

`data/world2/stage_branches.json` gives every branch a row-oriented record while
preserving the four physical ROM columns. `null` in `return_offset_override`
represents the ROM byte zero and therefore means “save the current offset.”

Run `make validate-world2-stage-branches` to verify the routine signature,
table CRCs, coordinate-condition contract, stage-offset bounds, and complete
68-byte authoring round trip. The script also provides `decode` and `encode`
subcommands for controlled edits.

## World 2 stage sequence

World 2 advances through a 229-byte one-byte instruction stream at
`$BDDF-$BEC3`. Three starts at `$8B38` select offsets 0, 37, and 92. The runtime
increments `World2StageSequenceOffset` before reading, so initialization stores
the selected start minus one.

### Instruction set

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

### Canonical shape

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
`docs/world2_formats.md`.

### Lossless authoring

`data/world2/stage_sequence.json` records every byte with its offset, raw token,
decoded command, and command-specific fields. Raw and semantic fields must
agree, so stale edits are rejected. The file also owns the three start-offset
bytes, for 232 losslessly covered bytes in total.

Run `make validate-world2-stage-sequence` to prove the decoder signatures,
opcode partition, command counts, start offsets, CRCs, and authoring round trip.
The `decode` and `encode` subcommands in `scripts/validation/world2/world2_stage_sequence.py`
regenerate the JSON or apply edited bytes to a supplied base PRG.

## World 2 compressed screens

World 2 does not store the 60 fixed 16x15 screens exposed by CadEditor. Runtime
uses a 229-byte stage sequence at `$BDDF-$BEC3`, a standard 119-entry pointer table at
`$BEDE`, and compressed screen bytes beginning at `$BFCC`.

Literal cells index the exact 208-record 2x2 CHR-tile catalog documented in
`docs/world2_formats.md`.

The stage sequence is a separate one-byte instruction stream rather than a flat
list of screen IDs. Its complete command contract and editable representation
are documented in `docs/world2_formats.md`.

### Token format

Each selected stream expands sixteen rows. A row stops once the output width
reaches at least fifteen cells; a final run is not clipped and can extend the
row to 22 cells.

| Token | Encoded bytes | Operation |
| --- | ---: | --- |
| literal | `$00-$CF` | Emit one screen cell |
| enemy | `$D0-$EE` | Spawn an enemy with this state and emit an empty cell |
| row end | `$EF` | Set the row width to sixteen immediately |
| reserved | `$F0` | Invalid; absent from all standard screens |
| run | `$F1-$FF vv` | Emit literal `vv` `(token & $0F) + 1` times |

The RLE extra copy is intentional: the counted store loop falls through to the
decoder's shared one-cell literal store.

Across all 119 selector views, runtime encounters 738 enemy tokens, 3,623 RLE
tokens, and 107 explicit row endings. Those counts include shared data read by
more than one selector.

### Shared stream storage

The first 119 pointers contain 116 distinct addresses. Three selector aliases
are exact:

| Selector | Alias of | Address |
| ---: | ---: | ---: |
| 50 | 0 | `$BFCC` |
| 117 | 91 | `$F2B4` |
| 118 | 101 | `$F7C2` |

Distinct pointers are not independent allocation boundaries. Sixty-five
decoded screens continue beyond the next distinct pointer, so adjacent views
share suffixes and row data. At most three screen views cover the same byte.

Despite this overlap, global tokenization is unambiguous. All 16,431 bytes from
`$BFCC` through `$FFFA` are covered exactly once as a token or RLE operand, with
no token/operand conflicts:

| Unique token kind | Count |
| --- | ---: |
| literal | 8,877 |
| enemy spawn | 685 |
| row end | 103 |
| RLE | 3,383 |
| total | 13,048 |

The final RLE token is stored at `$FFF9` and consumes `$FFFA`, the low byte of
the bank's NMI vector, as its repeated literal. The vector remains valid while
also serving as compressed data.

Selector `$7F` is a terminal sentinel rather than a compressed screen. The
preceding `$F8` command stops scrolling; the selector routine still indexes the
overlapping pointer view and stores `$00FC`, but deterministic runtime evidence
observes no call to the token decoder afterward. Bytes `$BEC4-$BEDD` are a
separate metatile collision bitmap, so their leading `$7B` byte is not a stage
selector at all.

### Lossless authoring format

`data/world2/compressed_screens.json` represents shared storage once rather
than duplicating overlapping screens. It contains:

- all 119 selector pointers and their alias relationships;
- sixteen row boundaries and decoded widths per selector;
- one global pool of 13,048 literal, spawn, row-end, and RLE tokens.

Token records use compact forms such as `0000:L:25`, `0010:S:D4`, `0020:E`,
and `0030:R:F6:00`. Offsets are relative to `$BFCC`. Row records use
`start-end:width`, with an exclusive end offset.

Decode the canonical data:

```text
python scripts/run.py validation.world2.world2_streaming decode --prg assets/generated/prg/doraemon.prg --manifest config/authoring/world2/world2_streaming.json --code-entries config/reconstruction/prg_code_entries.txt --output data/world2/compressed_screens.json
```

Encode an edited document:

```text
python scripts/run.py validation.world2.world2_streaming encode --input data/world2/compressed_screens.json --output build/world2_screens.bin
```

The output is the contiguous 238-byte standard pointer table followed by the
16,431-byte compressed region. Literal values can be edited directly. Changes
that alter token sizes require consistent offsets, pointers, and row metadata;
the encoder rejects gaps, overlaps, invalid token ranges, bad aliases, and row
views that no longer decode as declared.

`make validate-world2-streaming` also compares the checked-in authoring payload
and its CRC with the canonical PRG.
