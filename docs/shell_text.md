# Shell text and presentation data

The fixed presentation text used by the original Japanese PRG0 image resides
in bank 3. `config/authoring/text/shell_text.json` pins the consumers, exact ranges, checksums,
and the lossless representation in `data/shell/text.json`.

## Formats

| Range | Size | Format |
| --- | ---: | --- |
| `$8A7F-$8A87` | 9 | game-over text; tile `$00` is a blank |
| `$9248-$9383` | 316 | 13 address/count/payload PPU records plus a zero terminator |
| `$9384-$9783` | 1,024 | 32-by-32 ending-opening nametable |
| `$B1BC-$BDBB` | 3,072 | three complete 1 KiB chapter-help nametables |
| `$BDBC-$ED3B` | 12,160 | 380 fixed 32-byte ending-credit rows |
| `$ED3C-$F9BB` | 3,200 | typed but not yet consumer-classified presentation data |

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

## Authoring contract

`data/shell/text.json` exposes all five proven regions in fixed-size form:
title text and raw PPU payloads, the game-over line, the ending nametable,
chapter-help item names with lossless raw gaps, and every credits row. Edits
must preserve each physical span's size.

Run `make validate-shell-text` to check code signatures, range CRCs, record and
row geometry, canonical decode, and byte-exact re-encoding. To create a patched
PRG for research:

```text
python -B scripts/run.py validation.reconstruction.shell_text encode \
  --base-prg assets/generated/prg/doraemon.prg \
  --manifest config/authoring/text/shell_text.json \
  --input data/shell/text.json \
  --output build/doraemon-text-edit.prg
```
