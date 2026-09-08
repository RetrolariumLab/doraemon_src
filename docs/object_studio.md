# Object Studio

Object Studio owns the fixed-capacity gameplay object data for all three
chapters. Its profile workspace, visual editor, validation, deterministic
export, and ROM composer form one supported Source 2.0 authoring surface.

Initialize and validate an ignored workspace with:

```bash
make object-content-init PROFILE=original
make object-content-check PROFILE=original
make object-content-init PROFILE=rev_a
make object-content-check PROFILE=rev_a
```

The workspace contains ten typed object documents. World 1 contributes the two
placement lists, descriptors and collision extents, nine underground room
profiles, and three directional weapon profiles. World 2 contributes 21 enemy
state records and seven inventory spawn screens. World 3 contributes its
persistent object/type catalog, 16 behavior streams, 64 four-channel transient
spawn schedules, four initializer-data regions, and three update-handler data
regions.

World 2's 738 physical enemy spawn tokens remain inside the same compressed
screen document used by Level Studio. Object Studio initializes and consumes
that shared document instead of creating a conflicting copy. A map-cell edit
and a spawn-token edit therefore always reach the ROM through one encoder and
one fixed 16,669-byte region.

The ten object documents cover 3,130 mutually disjoint PRG bytes. Validation
re-runs their native encoders, updates their coverage metadata, rejects wrong
record counts or value domains, and checks that no artifact writes over
another. Files are saved atomically and each editable document has independent
undo and redo history.

Open the visual editor with:

```bash
make object-studio PROFILE=original
```

The same coordinate-bearing placements are also overlaid in Level Studio for
map-context editing. There, World 1 and World 3 records support drag-and-drop,
World 2 embedded spawn tokens can move between atlas cells, and every exposed
type selector still passes through the Object Studio encoders documented here.

The Typed object data tab exposes every scalar in all ten documents through a
searchable hierarchy. Structural fields such as IDs, addresses, sizes, schema
names, and checksums are visibly locked. Content values are edited one atomic
operation at a time and accepted only if the native lossless encoder can
rebuild the fixed format; invalid edits roll back immediately. The overview
plots World 1 placements and World 3 persistent or transient room occupancy.

The World 2 embedded spawns tab shows all 119 logical selector screens as a
cell grid. Existing spawn cells are marked in red and can select any physical
enemy state `$00-$0E`. An edit preserves the cell's spawn role, propagates to
identical alias views, and repacks the full compressed stream within its
original capacity. Background cells remain the responsibility of Level Studio.

Use these deterministic workflows:

```bash
make object-content-export PROFILE=original
make object-content-rom PROFILE=original
make object-content-roundtrip
```

The composer accepts only the expected 128 KiB PRG + 32 KiB CHR Mapper 66
shape. It applies object data to a source-built revision image and never writes
to a reference ROM. The round-trip target proves that all canonical object
documents and the shared World 2 screen stream reproduce both official ROMs
with zero changed bytes.
