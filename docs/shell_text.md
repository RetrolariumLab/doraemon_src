# Shell text and presentation data

The fixed presentation text used by the original Japanese PRG0 image resides
in bank 3.

## Formats

| Range | Size | Format |
| --- | ---: | --- |
| `$8A7F-$8A87` | 9 | game-over text; tile `$00` is a blank |
| `$9248-$9383` | 316 | 13 PPU records plus a zero terminator (below) |
| `$9384-$9783` | 1,024 | ending-opening nametable: 32x30 tiles, then 64 attribute bytes |
| `$B1BC-$BDBB` | 3,072 | three complete 1 KiB chapter-help nametables |
| `$BDBC-$ED3B` | 12,160 | 380 fixed 32-byte ending-credit rows |
| `$ED3C-$F9BB` | 3,200 | typed but not yet consumer-classified presentation data |

`Shell_UploadPpuCommandStream` reads each title record as the PPU address
(high byte first, then low), a byte count and that many bytes, written with
the PPU address advancing by one. A count of `$00` copies 256 bytes. A high
address byte of `$00` ends the stream, so no record can target PPU
`$0000-$00FF`.

The title stream contains eight graphics records followed by five editable text
records: the start prompt, high score, score, Hudson copyright, and licence
line. In title text, `$00` is a blank and `$5B` renders a period.

Each chapter-help screen remains lossless raw nametable data around fixed-width
editable item-name spans. This exposes 26 strings without pretending that the
surrounding tiles are text. The active ending credits are stored as ASCII-like
source rows. The row uploader maps source space, period, and ampersand bytes to
tiles `$7F`, `$5B`, and `$5F` before queueing each row.

The ending loop initializes the source pointer to `$BDBC` and stops at the
exclusive pointer `$ED3C`, proving that the following 3,200 bytes are not part
of the active scrolling credits. Their visual content suggests presentation
data, but no consumer is claimed until a static or runtime path is found.

## Editing

The Studio edits all five regions as `text` (`doraemon.shell-text.v1`) in
fixed-size form: title text and raw PPU payloads, the game-over line, the
ending nametable, chapter-help item names with their raw gaps, and every
credits row. An edit keeps each region's size.
