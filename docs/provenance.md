# Provenance

## Exact local reference

The original Japanese `PRG0` dump was inspected locally on 2026-08-31, and the
Revision A image was added for Source Reconstruction 2.0. Complete hashes are
recorded in `assets/manifest.json` and `config/revision_profiles.json`. The
source builds independently reproduce both full files.

The locally present Chinese image is a 524,304-byte mapper-4 expansion with
262,144-byte PRG and CHR regions. It is ignored by Git and is not treated as an
original game revision.

## Published cartridge data

- NES Cart Database Doraemon profiles: board/chip identity, revision, and
  physical CRCs: <https://nescartdb.com/profile/view/1493/doraemon>
- NESdev mapper 66 documentation: GNROM bank fields and bus conflicts
- No-Intro naming/revision metadata: original and Revision A separation

The exact local dumps confirm mapper 66, vertical mirroring, original PRG CRC32
`B00ABE1C`, Revision A PRG CRC32 `FE90D6EB`, and shared CHR CRC32 `761F994E`.

## Map evidence

- Repository: <https://github.com/spiiin/CadEditor>
- Directory: `CadEditor/settings_nes/doraemon`
- License: MIT for CadEditor code
- Role: published map offsets, dimensions, block counts, CHR selection, and the
  fact that enemy editing is not implemented

The repository was inspected at its `master` branch on 2026-08-31. Its configs
use complete-file offsets; this project converts them to bank-qualified CPU
addresses and records the declared world-2 overlap rather than hiding it.

## Gameplay-control evidence

- Japanese control description:
  <https://dege.blog/2020/09/10/%E3%80%8C%E3%83%89%E3%83%A9%E3%81%88%E3%82%82%E3%82%93%E3%80%8D%E3%83%95%E3%82%A1%E3%83%9F%E3%82%B3%E3%83%B3%E3%82%B2%E3%83%BC%E3%83%A0%E7%B4%B9%E4%BB%8B%E7%AC%AC9%E5%9B%9E%E7%9B%AE/>
- Role: identifies A as the city door/manhole action and A as jump in the
  side-view mode.

The published control description is used only to choose deterministic input.
The semantic claims come from the exact ROM: the trace observes the game's
controller byte, accepted manhole branch, and side-view initializer.

## World 3 identity evidence

- StrategyWiki enemy sprites and descriptions:
  <https://strategywiki.org/wiki/Doraemon/Enemies>
- StrategyWiki item sprites and descriptions:
  <https://strategywiki.org/wiki/Doraemon/Items>
- Japanese enemy and character names:
  <https://wikiwiki.jp/neskouryaku1/%E3%83%89%E3%83%A9%E3%81%88%E3%82%82%E3%82%93>
- Japanese World 3 progression and boss guide:
  <https://fc-doraemon.kouryaku.red/entry8.html>
- World 3 punishment-room trigger and escape condition:
  <https://w.atwiki.jp/famicomall/pages/176.html>
- Independent punishment-room skull/dorayaki description:
  <https://w.atwiki.jp/gcmatome/pages/3438.html>

These sources supply names and independent sprite/gameplay descriptions. They
are not used to infer binary layouts. Each identity in
`config/authoring/world3/world3_entity_types.json` must also agree with locally rendered CHR,
metasprite selection, dispatch behavior, formation data, or type conversion.
Type `$06` has no standalone published character name, so its descriptive
symbol remains structural in wording. Its role is nevertheless confirmed:
both guides identify a forced punishment room filled with skulls and dorayaki,
while the ROM ties the 20-treasure trigger, room `$12`, type `$06` schedule,
two graphics, damaging/collectible collision split, and 20-dorayaki exit into
one closed path.

## Toolchain evidence

`tools/disassembly.lock.json` pins Ghidra and GhidraNes archives by version,
size, and SHA-256. Ghidra facts are treated as classification evidence, never as
authority over ROM bytes: the generator checks every emitted instruction byte.

`config/toolchain.json` is the release toolchain contract. It pins the bundled
ca65 and ld65 executables by upstream revision, size, version output, and
SHA-256, and pins the external FCEUX automation executable by its source commit,
size, and SHA-256. `make verify-build-toolchain` runs before assembler/linker
use, while `make verify-runtime-toolchain` runs before any release trace. The
supported release host is Windows 11 x86-64 with PowerShell, GNU Make 4.4.1,
and Python 3.14.6.
