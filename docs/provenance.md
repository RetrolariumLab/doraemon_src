# Provenance

## Exact local reference

The original Japanese `PRG0` dump was inspected locally on 2026-08-31. Complete
hashes are recorded in `assets/manifest.json`. The source build independently
reproduces the full file.

The locally present Chinese image is a 524,304-byte mapper-4 expansion with
262,144-byte PRG and CHR regions. It is ignored by Git and is not treated as an
original game revision.

## Published cartridge data

- NES Cart Database Doraemon profile: board/chip identity and physical CRCs
- NESdev mapper 66 documentation: GNROM bank fields and bus conflicts
- No-Intro naming/revision metadata: original and Revision A separation

The exact local dump confirms mapper 66, vertical mirroring, PRG CRC32
`B00ABE1C`, and CHR CRC32 `761F994E`.

## Map evidence

- Repository: <https://github.com/spiiin/CadEditor>
- Directory: `CadEditor/settings_nes/doraemon`
- License: MIT for CadEditor code
- Role: published map offsets, dimensions, block counts, CHR selection, and the
  fact that enemy editing is not implemented

The repository was inspected at its `master` branch on 2026-08-31. Its configs
use complete-file offsets; this project converts them to bank-qualified CPU
addresses and records the declared world-2 overlap rather than hiding it.

## Toolchain evidence

`tools/disassembly.lock.json` pins Ghidra and GhidraNes archives by version,
size, and SHA-256. Ghidra facts are treated as classification evidence, never as
authority over ROM bytes: the generator checks every emitted instruction byte.
