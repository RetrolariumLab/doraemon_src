# Music driver ABI

Every PRG bank contains a local four-channel music driver with the same stream
command grammar and RAM ABI. The copies are not assumed byte-identical: their
ROM tables, playable track counts, and embedded absolute addresses differ.

| Bank | Driver | Track IDs | Count | Header table | Update |
| ---: | --- | --- | ---: | ---: | ---: |
| 0 | World 1 | 1-8 | 8 | `$EFFB` | `$E9FD` |
| 1 | World 2 | 1-6 | 6 | `$B2E3` | `$ACE4` |
| 2 | World 3 | 1-8 | 8 | `$CAF3` | `$C4F5` |
| 3 | Shell | 1-4 | 4 | `$A4D6` | `$9ED8` |

Track ID zero means stopped. The compare operands `$09`, `$07`, `$09`, and
`$05` are exclusive upper bounds, not playable-track counts. Each nonzero ID
selects one eight-byte header containing four little-endian channel pointers.

Each frame decrements four channel durations. An expired duration enters the
stream interpreter; otherwise the tonal channels can advance their signed
volume-envelope step. Stream cursors are four little-endian pointers at
`$002F-$0036`. Bytes `$80-$EE` replace the channel's seven-bit duration code
and continue decoding. Bytes `$00-$7F` then emit a tonal/noise event (`$00`
takes the rest path) and reload its countdown. Bytes `$EF-$FF` dispatch through
a target-minus-one `PHA`/`PHA`/`RTS` table.

## Command grammar

| Byte | Operands | Structural role |
| ---: | ---: | --- |
| `$FF` | 0 | End the active channel |
| `$FE` | 0 | Restore the saved stream position |
| `$FD` | 1 | Begin a counted loop |
| `$FC` | 0 | Advance or repeat the counted loop |
| `$FB` | 1 | Select a saved post-loop exit by iteration |
| `$FA` | 1 | Enable a fixed pitch |
| `$F9` | 0 | Disable fixed pitch and resume note pitch |
| `$F8` | 1 | Set pulse duty-cycle bits |
| `$F7` | 0 | Save the current stream position |
| `$F6` | 2 | Call an absolute stream address |
| `$F5` | 1 | Set all three tonal pitch offsets |
| `$F4` | 1 | Set the current tonal-channel pitch offset |
| `$F3` | 0 | Return from a stream call |
| `$F2` | 0 | Reset high-timer length bits |
| `$F1` | 0 | Select the current track's channel stream |
| `$F0` | 1 | Load an extended duration code |
| `$EF` | 1 | Set base volume and envelope mode |

The names describe direct state mutations and control flow; they do not claim
musical intent. `config/audio_music.json` joins every opcode to all four exact
dispatch targets and their semantic source labels.

## State and validation

The complete symbolic state covered by this slice spans 92 bytes across 23
fields: duration codes/countdowns, base and current envelope volumes, signed
envelope steps, fixed-pitch state, counted-loop pointers and counters, header
and call-return pointers, tonal offsets/control, noise state, and interpreter
indices.
`docs/ram_fields.md` lists each address.

The three global tonal pitch offsets at `$0046-$0048` deliberately remain an
overlay: gameplay code reuses those bytes for World 1 metasprite coordinates
and the World 2 stream pointer. Treating one role as globally canonical would
make other bank-local code misleading.

`make validate-audio-music` verifies the grammar, shared RAM symbols, track-ID
limits, header-table loads, all 68 command targets, and 980 bytes of envelope,
duration/event, and stream-position helpers.

## Reachable streams

`data/audio/music_streams.json` is a lossless editable representation of all
26 track headers and every byte reached from their 104 channel entries. The
static interpreter models counted loops, saved-position loops, channel-start
jumps, and the single-level call/return slot. It classifies 8,929 unique events
covering 10,016 stream bytes plus 208 header bytes.

The reachable spans are `$F03B-$FCBE` in bank 0, `$B313-$B8E1` and
`$B900-$B9CE` in bank 1, `$CB33-$D66A` in bank 2, and `$A4F6-$ADBB` in bank 3.
Bank 1 deliberately shares its `$B9CE` `EndChannel` byte with the unindexed
World 2 metatile-attribute prefix. The authoring format records this byte once
as an audio event while the physical source retains its adjacent data owner.

`make validate-audio-streams` re-decodes the PRG state graph and checks exact
document equality plus a 10,224-byte sparse-payload round trip. Exact effect
identities and classification of data outside the header-reachable spans remain
open for Source 1.0. Effect-versus-music APU ownership is separately proven in
`docs/audio_arbitration.md`.
