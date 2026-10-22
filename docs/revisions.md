# Revisions

The source builds one image, the original Japanese release
`Doraemon (J) (PRG0) [!].nes` (PRG CRC32 `B00ABE1C`, CHR CRC32 `761F994E`;
`assets/manifest.json` has its hashes). The ROM stays outside version control.

## The image called Revision A

Another image circulates as `Doraemon (Japan) (Rev A).nes` (SHA-1 `20c5e40a...`,
payload CRC32 `336093EF`). Releases 1.0 to 3.1 built it too; 3.2 drops it
because it looks like a damaged dump, not a revision:

- its header and CHR are the original's, and only 50 PRG bytes differ, all in
  World 3 code in bank 2 (`$AB3B-$AB60` and `$AF40-$AF5F`);
- 49 of the 50 only set bits (`$C6` to `$FF`, `$3D` to `$3F`), on alternate
  bytes in the first window and on every byte of the second, which reads `$FF`
  throughout: the pattern of a failing chip, not of a patch;
- in the 1.0-3.0 traces it resets to the shell in the frame it enters World 3,
  while the original plays World 3 through the ending.

The source keeps only the original bytes. Should a cartridge database confirm
the image as a real release, tag 3.1 has the source that built it.
