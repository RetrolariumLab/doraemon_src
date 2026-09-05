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
- Known: the complete 229-byte stage-sequence opcode partition, all command
  counts, and its three starting offsets are decoded and losslessly editable in
  `data/world2/stage_sequence.json`.
- Known: the renderer addresses exactly 208 metatiles `$00-$CF`, stored as 208
  palette selectors and 208 four-byte CHR-tile quads. Standard ROM streams
  reference 203 IDs; the complete catalog is losslessly editable in
  `data/world2/metatiles.json`.
- Known: the 26 bytes at `$BEC4-$BEDD` are an MSB-first collision bitmap for
  those 208 metatiles; 100 entries are solid and their flags round-trip with
  the metatile catalog.
- Known: stage tokens `$F9-$FF` can queue background-palette IDs `$01-$07`;
  the canonical 229-byte sequence uses seven commands with IDs `$01-$06`;
  the consumer, nine palette sets, chapter selectors, and upload-code overlap
  are exact and losslessly editable through `data/world2/palettes.json`.
- Known: `$7F` is a terminal sentinel preceded by `stop_scroll`; runtime assigns
  its generic `$00FC` pointer but never calls the compressed-token decoder.

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
- Known: World 3 transient entities use four independent channels per room.
  All twelve 64-byte type/count/delay columns, the delay scheduler, spawn
  budgets, initializer dispatch, and the complete 768-byte lossless authoring
  representation are validated by `config/world3_transient_spawns.json`.
- Known: all sixteen World 3 transient initializer slots are classified by
  structural role. Their room flag, fixed-position, and three formation data
  layouts are losslessly editable and cross-checked against scheduled type
  frequencies and budgets by `config/world3_spawn_initializers.json`.
- Known: all 32 World 3 update-dispatch slots are classified into 17
  structural roles. Type `$04/$05` room flags, held-motion vectors, persistent
  relocation, formation followers, encounter completion, conversion, pushing,
  and player-following paths are validated by
  `config/world3_update_handlers.json`.
- Unknown: character/item identities for World 1 descriptors, individual World
  2 enemy identities and handler-specific meanings, character identities for
  World 3 types, and character-level identities behind the now-exact World 3
  initializer modes. The World 3 behavior bytecode, structural type catalog,
  room placement scheduler, and formation layouts are fully decoded and
  validated.

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
