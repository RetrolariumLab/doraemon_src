# World 2 compressed screens

World 2 does not store the 60 fixed 16x15 screens exposed by CadEditor. Runtime
uses a 255-byte stage sequence at `$BDDF`, a standard 119-entry pointer table at
`$BEDE`, and compressed screen bytes beginning at `$BFCC`.

The stage sequence is a separate one-byte instruction stream rather than a flat
list of screen IDs. Its complete command contract and editable representation
are documented in `docs/world2_stage_sequence.md`.

## Token format

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

## Shared stream storage

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

Selectors `$7B` and `$7F` are exceptional dynamic screens. Indexing the
overlapping 128-slot pointer view yields WRAM addresses `$0515` and `$00FC`;
they are not part of the 119 standard ROM screen views.

## Lossless authoring format

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
python scripts/world2_streaming.py decode --prg assets/generated/prg/doraemon.prg --manifest config/world2_streaming.json --code-entries config/prg_code_entries.txt --output data/world2/compressed_screens.json
```

Encode an edited document:

```text
python scripts/world2_streaming.py encode --input data/world2/compressed_screens.json --output build/world2_screens.bin
```

The output is the contiguous 238-byte standard pointer table followed by the
16,431-byte compressed region. Literal values can be edited directly. Changes
that alter token sizes require consistent offsets, pointers, and row metadata;
the encoder rejects gaps, overlaps, invalid token ranges, bad aliases, and row
views that no longer decode as declared.

`make validate-world2-streaming` also compares the checked-in authoring payload
and its CRC with the canonical PRG.
