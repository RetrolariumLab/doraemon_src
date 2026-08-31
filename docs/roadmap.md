# Roadmap

## Completed initial preservation pass

- exact original-revision identity and ignored private assets;
- four-bank GNROM linker and byte-identical ca65 build;
- deterministic per-bank static-analysis pipeline;
- bank-qualified symbols and typed CadEditor map ranges;
- map-region validation and initial hardware/RAM documentation.

## Next reverse-engineering pass

- capture mapper writes and establish the complete bank transition graph;
- identify `chapter_init`, frame dispatch, object update, collision, rendering,
  and exit paths independently for all three worlds;
- trace the title-screen A+B/Select shortcut into worlds 2 and 3;
- recover enemies, items, NPCs, doors, manholes, bosses, and trigger formats;
- isolate common sound code and music/data ownership by bank;
- split generated listings into evidence-backed modules.

## Authoring pass

- lossless map/block decode and encode tools;
- collision and object schemas with round-trip tests;
- CHR/palette/metasprite/text authoring formats;
- Revision A alignment and a separate byte-identical build profile.
