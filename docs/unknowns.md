# Unknowns

## BANK-001 - power-on bank

- Known: every bank contains compatible vectors and reset bytes.
- Unknown: which PRG/CHR state the physical GNROM latch exposes reliably at
  power-on and what assumptions the software makes before its first write.

## BANK-002 - dispatch table roles

- Known: four bank-specific JMP entries begin at `$8271`.
- Unknown: exact init/frame/render/transition meanings for each entry.

## W2-DATA-001 - block-table overlap

- Known: CadEditor requests 1,024 bytes at file `$BAAF`; screens begin at
  `$BDFC`, producing a 179-byte overlap.
- Known: runtime code does not use CadEditor's 60-screen fixed-size model. It
  reads a stage sequence at `$BDDF`, a pointer table at `$BEDE`, and compressed
  streams at `$BFCC`; the editor overlap is therefore a configuration
  approximation.
- Known: all 119 standard selector views, their three aliases, shared-stream
  overlaps, and all 16,431 token/operand bytes are losslessly decoded and
  round-trippable through `data/world2/compressed_screens.json`.
- Unknown: the true used small-block count and exact stage-command semantics
  above `$EF`.

## WORLD-DATA-002 - attribute properties

- Known: World 1 and World 3 use complete contiguous map -> big block -> small
  block -> CHR-index hierarchies, now validated and losslessly round-trippable.
- Known: bits 0-1 of each attribute byte select one of four palettes; CadEditor
  preserves bits 2-7 independently.
- Known: bits 2-7 are zero in every canonical World 1 and World 3 attribute.
- Unknown: whether the engine reserves those upper bits for runtime properties
  or they are simply unused in Doraemon. Collision semantics are not inferred.

## OBJ-001 - chapter object formats

- Known: CadEditor disables enemy editing for all four configurations.
- Known: World 1 city and underground placements are three-byte X/Y/type
  records, including their terminators, persistent IDs, type split, and sorted
  city tail; `config/object_placements.json` validates both lists.
- Known: the World 1 high-bit path uses thirteen four-byte descriptors. Their
  four fields, placement encoding and usage, transient selectors, and five
  collision-extent tables are exact; see `docs/world1_descriptors.md`.
- Known: World 2 enemy spawns are embedded in compressed screen streams; 685
  physical `$D0-$DE` bytes appear as 738 selector-view occurrences and map
  exactly to runtime states `$01-$0F`. States `$10-$14`, three property tables,
  and both dispatch domains are structurally validated.
- Known: World 3 begins with thirteen persistent objects stored as five
  parallel ROM arrays; the exact initial fields, two randomized type groups,
  fixed type slot, and sixteen low-type behavior pointers are validated by
  `config/world3_object_data.json`.
- Known: all 32 World 3 type IDs are partitioned into four lifecycle domains;
  their five property tables, three dispatch views, and the `$10-$13` and
  `$1C-$1E` type transformations are validated by
  `config/world3_entity_types.json`.
- Unknown: character/item identities for World 1 descriptors, individual World
  2 enemy identities and handler-specific meanings, character identities for
  World 3 types, and remaining
  transient World 3 enemy/projectile placement rules. The World 3 behavior
  bytecode and structural type catalog are fully decoded and validated.

## AUDIO-002 - command and stream semantics

- Known: all four banks carry independently validated local drivers. Their
  request limits, effect RTS tables, 17-command dispatch tables, and accepted
  track counts are recorded in `config/audio_dispatch.json`.
- Unknown: semantic names for individual effects, music commands, track headers,
  and stream fields beyond their proven control-flow roles.

## REV-001 - Revision A

- Known: CHR is unchanged; PRG and payload CRCs differ.
- Unknown: exact changed ranges and behavioral fixes until a matching Rev A dump
  is supplied and aligned.
