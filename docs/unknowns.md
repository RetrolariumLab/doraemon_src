# Unknowns

## BANK-001 - power-on bank

- Known: every bank contains compatible vectors and reset bytes.
- Unknown: which PRG/CHR state the physical GNROM latch exposes reliably at
  power-on and what assumptions the software makes before its first write.

## BANK-002 - dispatch table roles (resolved)

- Known: every bank has four bank-specific JMP entries at `$8271`, `$8274`,
  `$8277`, and `$827A`.
- Resolved: they are respectively the primary chapter/shell entry, NMI frame
  service, secondary demo/status entry, and audio frame service. All sixteen
  exact targets, their semantic symbols, and the NMI callers are validated by
  `config/common_runtime.json`.

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
  and both dispatch domains are structurally validated. All 20 states now have
  structurally classified update and render handlers, including shared and
  no-op targets. Their exact metasprite index sets, 58-record fixed sprite
  catalog, OAM attributes, and CHR ownership are validated. All 15 direct
  states, three bosses, Robo Ship helper, and Ororon's derived Jura-like
  projectile are joined to an evidence-backed identity catalog. Gangan's
  straight and spiral forms deliberately occupy two states.
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
- Known: all 32 type bases are joined to the complete 188-entry metasprite
  index. Its 130 direct entries, 58 flip aliases, 65 variable-length records,
  eleven palettes, and 64 room selectors are losslessly editable through
  `config/world3_metasprites.json`.
- Known: all 32 World 3 types now have identities independently supported by
  locally rendered graphics/control flow and published enemy, item, or
  progression references. Type `$06` is the punishment-room dorayaki/skull
  swarm: the ROM's 20-treasure warp to room `$12`, 250-spawn schedule,
  damaging skull branch, collectible dorayaki branch, and 20-dorayaki exit
  exactly match two published descriptions. No standalone canonical character
  name is claimed. The three shared behavior IDs with alternate forms, bosses
  and parts, chest contents, puzzle items, drops, and companions are recorded
  in `config/world3_entity_types.json`.
- Known: all thirteen World 1 descriptor identities are joined to their
  placement counts, selector roles, metasprites, interaction handlers, and
  concrete effects. This includes the dynamic three-weapon descriptor,
  microphone-triggered programmer face, and descriptor `$0C` invulnerability
  reward. Deeper helper-specific meanings remain below World 2's resolved
  enemy roster.
  The World 3 behavior
  bytecode, structural type catalog, room placement scheduler, formation
  layouts, metasprites, and palettes are fully decoded and validated.
- Known: eleven instruction-aligned World 3 code islands previously emitted as
  raw bytes are now reconstructed. Their internal control flow and helper/RAM
  conventions are coherent, but no top-level caller is present in the static
  PRG graph, so they remain explicitly classified as dormant; see
  `docs/world3_dormant_code.md`.

## AUDIO-002 - command and stream semantics

- Known: all four banks carry independently validated local drivers. Their
  request limits, effect RTS tables, 17-command dispatch tables, and accepted
  track-ID bounds are recorded in `config/audio_dispatch.json` and
  `config/audio_music.json`; zero is stopped, leaving 8/6/8/4 playable tracks.
- Known: all seventeen music commands now have structural semantics, operand
  widths, 68 exact bank-local targets, and a shared 92-byte channel/loop/call/
  envelope RAM ABI; see `config/audio_music.json`.
- Known: all 26 eight-byte track headers and 10,016 header-reachable stream
  bytes have state-aware boundaries and a lossless authoring round trip; see
  `data/audio/music_streams.json`.
- Known: effects update before music; four channel timers suppress the matching
  music APU write paths while logical stream time continues. Track-start reset
  is the unguarded exception; see `config/audio_arbitration.json`.
- Known: all 93 request IDs map through their priority permutations to 145
  semantic init/update handlers. Their 26 structural roles, timer leases, APU
  channel writes, shared targets, and no-lease exceptions are validated by
  `config/audio_effects.json`.
- Unknown: exact gameplay identities for individual effects and whether
  header-unreachable bytes adjacent to the proven spans contain dormant music
  material or unrelated tables. These are non-blocking for Source 1.0: the
  active driver, structural effect roles, APU arbitration, reachable streams,
  and their lossless authoring contract are complete without inferred names or
  claims about unreachable data.

The byte-level source classification pins the header-unreachable spans exactly:
Bank 0 `$EE34-$EFFA` and `$FCBF-$FFF9`, Bank 1 `$B11B-$B2E2` and
`$B8E2-$B8FF`, Bank 2 `$C92C-$CAF2`, and Bank 3 `$A30F-$A4D4` and
`$ADBC-$B1BB`. They total 3,701 bytes and cannot silently become claimed
music data without updating the release audit.

## SOURCE-BYTES-001 - inline and dormant directive bytes

- Known: the canonical listing emits 47,789 bytes as 6502 instructions and
  83,283 bytes through data directives. All directive bytes are partitioned by
  `config/source_classification.json`.
- Known: 66,180 bytes belong to the original typed-range registry, another
  7,469 bytes are tied to exact semantic table contracts, 24 bytes are the
  proven common local-dispatch JMP encodings, and 3,910 bytes are verified
  `$FF` bank fill.
- Unknown: 1,999 remaining directive bytes are small inline or post-return
  islands whose active consumer or executable status is not proved. They are
  registered by exact bank/address ranges rather than decoded speculatively.
  None is a registered direct or indirect entry point, and the release gate
  prevents an unclassified byte from being added.

This category deliberately includes instruction-shaped sequences after
`RTS`/`JMP`. Some may be dormant 6502 routines or overlapping encodings; a
future evidence-backed entry point can promote such a range to instructions.
Source 1.0 claims preservation and explicit uncertainty, not reachability that
the static graph and eight runtime scenarios do not demonstrate.

## TEXT-001 - post-credit presentation data

- Known: the active ending loop reads 380 fixed 32-byte rows from
  `$BDBC-$ED3B` and exits when its source pointer reaches `$ED3C`.
- Known: `$ED3C-$F9BB` contains text-like and graphics-like presentation bytes
  and is now isolated as typed data rather than attributed to active credits.
- Unknown: whether another dormant or currently untraced path consumes this
  3,200-byte region and what its exact screen format is.

## Out-of-scope reference: Revision A

- Known: CHR is unchanged; PRG and payload CRCs differ.
- Source Reconstruction 1.0 scope: Revision A is not a required source profile;
  its changed ranges and behavioral fixes do not block the original PRG0
  reconstruction or release audit.
