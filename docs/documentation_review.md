# Documentation Corpus Review

The Source 2.0 documentation was reviewed as one reader-facing corpus. The
review followed the paths from `README.md` and [the documentation
index](index.md) through release identity, build verification, architecture,
source layout, authoring, runtime evidence, and provenance. Machine-readable
contracts remain authoritative for addresses, byte ranges, hashes, and
capacities; the prose explains how those facts fit together.

## Consolidated chapters

The former chapter evidence used 54 short `world1_*`, `world2_*`, `world3_*`,
and `audio_*` files. Most were 17 to 100 lines long and divided one subsystem
story by individual validator rather than reader task. Their content is now
preserved in seven chapters:

| Chapter | Consolidated responsibility |
| --- | --- |
| [World 1 runtime](world1_runtime.md) | camera, player, entity, enemy, frame, and random-number behavior |
| [World 1 formats](world1_formats.md) | objects, maps, streaming, sprites, palettes, rooms, and weapons |
| [World 2 runtime](world2_runtime.md) | frame, stage, player, projectile, sprite, screen, and enemy behavior |
| [World 2 formats](world2_formats.md) | inventory, compressed screens, stage flow, metatiles, sprites, and palettes |
| [World 3 runtime](world3_runtime.md) | frame, room, player, entity, formation, transition, rendering, and queue behavior |
| [World 3 formats](world3_formats.md) | behavior bytecode, entity types, object records, spawns, handlers, sprites, and palettes |
| [Audio system](audio_system.md) | music ABI, effect requests, and shared APU arbitration |

The world chapters remain paired because runtime reconstruction and editable
data formats have different readers and evidence owners. [Sound
Studio](sound_studio.md) also remains separate from the audio-system chapter:
it documents a user workflow, while the audio chapter documents cartridge
behavior and binary formats.

## Retained independent documents

The five `source_*` documents form the only remaining prefix group of three or
more files. They are not interchangeable fragments: one records the draft
rewrite, one classifies source bytes, one maps physical layout, and two define
the independently accepted 1.0 and 2.0 release boundaries. Their exact paths
and rationale are checked through `config/documentation_corpus.json`.

Studio guides remain separate because each application has its own users,
workspace, actions, and lifecycle. Architecture, subsystem, RAM, runtime,
verification, unknown, and provenance documents likewise retain distinct
reader tasks. The address-ordered RAM evidence ledger is the only document
over the ordinary 600-line guideline; keeping its single machine-backed table
together is recorded as an explicit size exception.

## Navigation and consistency

The documentation index now names every public guide and groups it by reader
task. References formerly aimed at validator-sized chapter fragments now lead
to the relevant consolidated chapter. No format claims, evidence, or canonical
data were discarded, and this review does not change any tracked data document,
reference ROM, or ignored canonical workspace.

The release audit inventories Markdown paths and line counts, requires a reason
for every oversized document, and requires a reviewed disposition for every
filename-prefix group containing at least three documents. Repository lint
continues to validate local Markdown links. These checks keep later additions
from recreating an unreviewed fragment cluster.
