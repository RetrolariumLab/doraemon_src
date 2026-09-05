# Music driver ABI

Every PRG bank contains a local four-channel music driver with the same stream
command grammar and RAM ABI. The copies are not assumed byte-identical: their
ROM tables, accepted track counts, and embedded absolute addresses differ.

| Bank | Driver | Tracks | Update | Command table |
| ---: | --- | ---: | ---: | ---: |
| 0 | World 1 | 9 | `$E9FD` | `$EB3C` |
| 1 | World 2 | 7 | `$ACE4` | `$AE23` |
| 2 | World 3 | 9 | `$C4F5` | `$C634` |
| 3 | Shell | 5 | `$9ED8` | `$A017` |

Each frame decrements four channel durations. An expired duration enters the
stream interpreter; otherwise the tonal channels can advance their signed
volume-envelope step. Stream cursors are four little-endian pointers at
`$002F-$0036`. Bytes below `$EF` are note/rest events, while `$EF-$FF` dispatch
through a target-minus-one `PHA`/`PHA`/`RTS` table.

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
| `$F0` | 1 | Load an extended note value |
| `$EF` | 1 | Set base volume and envelope mode |

The names describe direct state mutations and control flow; they do not claim
musical intent. `config/audio_music.json` joins every opcode to all four exact
dispatch targets and their semantic source labels.

## State and validation

The complete symbolic state covered by this slice spans 92 bytes across 23
fields: notes/durations, base and current envelope volumes, signed envelope
steps, fixed-pitch state, counted-loop pointers and counters, header and call
return pointers, tonal offsets/control, noise state, and interpreter indices.
`docs/ram_fields.md` lists each address.

The three global tonal pitch offsets at `$0046-$0048` deliberately remain an
overlay: gameplay code reuses those bytes for World 1 metasprite coordinates
and the World 2 stream pointer. Treating one role as globally canonical would
make other bank-local code misleading.

`make validate-audio-music` verifies the grammar, shared RAM symbols, track
limits, all 68 command targets, and 980 bytes of envelope, note/rest, and stream
position helpers. Lossless decoding of track headers/streams, reachability of
every stream, APU arbitration with effects, and individual effect identities
remain separate audio work before Source 1.0.
