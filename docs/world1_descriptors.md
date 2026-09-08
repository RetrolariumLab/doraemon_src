# World 1 descriptor objects

World 1 map placements whose type byte has bit 7 set use a second object
materialization path. The low nibble selects one of thirteen four-byte records
at `$CC0A-$CC3D` in PRG bank 0. The table is stored record-major:

| Byte | Field | Runtime use |
| ---: | --- | --- |
| 0 | `runtime_type` | Base type written to the entity slot |
| 1 | `metasprite_base` | Initial metasprite; zero selects the dynamic `$7B + $2A` fallback |
| 2 | `render_flags` | Initial renderer flags |
| 3 | `primary_behavior` | Initial primary behavior/state byte |

The exact records are:

| Index | Runtime type | Metasprite | Render flags | Primary behavior |
| ---: | ---: | ---: | ---: | ---: |
| `$00` | `$01` | `$29` | `$01` | `$03` |
| `$01` | `$02` | `$25` | `$01` | `$03` |
| `$02` | `$03` | `$2E` | `$01` | `$03` |
| `$03` | `$04` | `$2D` | `$00` | `$03` |
| `$04` | `$05` | `$2F` | `$01` | `$10` |
| `$05` | `$06` | `$00` | `$01` | `$02` |
| `$06` | `$07` | `$30` | `$01` | `$02` |
| `$07` | `$08` | `$34` | `$01` | `$02` |
| `$08` | `$09` | `$16` | `$01` | `$04` |
| `$09` | `$0A` | `$14` | `$01` | `$20` |
| `$0A` | `$0B` | `$28` | `$01` | `$02` |
| `$0B` | `$0C` | `$17` | `$00` | `$02` |
| `$0C` | `$0D` | `$35` | `$03` | `$02` |

## Placement type encoding

The placement type byte has this descriptor form:

```text
bit 7    select the descriptor-object path
bit 6    OR $80 into the materialized runtime type
bits 4-5 reserved; both are zero in canonical placements
bits 0-3 descriptor index ($00-$0C)
```

The city and underground lists contain 33 descriptor-backed placements; 21
set bit 6. Their combined descriptor-index frequencies are:

| Index | Count | Index | Count |
| ---: | ---: | ---: | ---: |
| `$00` | 9 | `$06` | 4 |
| `$01` | 8 | `$07` | 3 |
| `$03` | 2 | `$08` | 1 |
| `$04` | 1 | `$09` | 1 |
| `$05` | 3 | `$0B` | 1 |

Indexes `$02`, `$0A`, and `$0C` do not occur in the two persistent placement
lists. A separate transient spawn path selects descriptor indexes
`$06,$0A,$0B,$02` through the first four bytes of the table at `$94D4`.
Completing the six-defeat secret uses selector slot `$04`, the adjacent byte at
`$94D8`, which contains descriptor index `$0C`. This accounts for all three
definitions absent from persistent placement lists.

## Collision extents

Five adjacent tables define collision extents for the descriptor runtime-type
domain:

| Address | Entries | Index | Use |
| ---: | ---: | --- | --- |
| `$CC3D` | 14 | runtime type `$00-$0D` | projectile X extent |
| `$CC4A` | 14 | runtime type `$00-$0D` | projectile Y extent |
| `$CC58` | 13 | runtime type minus one | interaction X extent |
| `$CC65` | 13 | runtime type minus one | negative interaction Y extent |
| `$CC72` | 13 | runtime type minus one | positive interaction Y extent |

The storage deliberately overlaps twice. Byte `$CC3D` is both the primary
behavior field of descriptor `$0C` and the index-zero entry of the projectile-X
table. That 14-byte table then ends at `$CC4A`, the same byte at which the
projectile-Y table begins. These are real shared bytes, not disassembly boundary
errors. The lossless authoring encoder requires both views of either byte to
agree and rejects conflicting edits.

`config/authoring/world1/object_placements.json` is the canonical structural
catalog. Run
`make validate-object-placements` to compare the descriptors, selector table,
collision tables, placement encoding, usage counts, and CRCs with the canonical
PRG and to round-trip the editable representation in
`data/world1/object_data.json`. The tool also supports `decode` and `encode`;
encoding applies the sparse object regions to a supplied base PRG so unrelated
bank bytes remain intact. The evidence-backed identity and effect join is
documented in `world1_descriptor_identities.md` and enforced by a separate
release gate.
