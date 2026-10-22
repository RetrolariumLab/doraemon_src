# Audio System

This chapter joins the music-driver ABI, effect-request ABI, and APU arbitration
rules because they share one frame service and hardware ownership boundary.

## Contents

- Effect and music APU arbitration
- Effect request dispatch
- Music commands, state, and reachable streams

## Effect and music APU arbitration

Every bank-local audio frame service updates sound effects before music. The
effect dispatcher first decrements four countdowns at `$02A3-$02A6`, ordered
as pulse 1, pulse 2, triangle, and noise. A newly accepted effect may then
reload one or more countdowns and write the corresponding APU registers.

Music still advances its durations and stream state while an effect owns a
channel. Its volume-envelope, tonal-event, and noise-event APU write paths
test the matching effect countdown and skip the physical write while that
countdown is nonzero. Thus the timer is an APU ownership lease, not a pause of
the logical music interpreter.

Track initialization is the deliberate exception. `Audio_ResetChannels` and
its three world-local copies initialize all four APU channels without testing
the effect timers, so a new track can overwrite an effect on its first frame.
Subsequent music writes return to the timer-guarded paths.

`$02A2` rejects an equal-priority retrigger while an effect is active; stop and
reset paths clear it. `$02A7-$02A9` are effect-private work bytes whose more
specific meanings vary by handler, so their names remain structural.

## Audio effect request ABI

The four bank-local effect drivers map a request ID through an even priority
byte to one adjacent `init`/`update` pair in a target-minus-one RTS dispatch
table. The stored priority is therefore both an arbitration rank and the byte
offset of the pair. World 1, World 3, and the shell expose 26 requests; World 2
uses a 15-request subset with its own permutation.

Each role records its handler pair, effect-timer leases, APU channels actually
written, and directly observed synthesis behavior. These names deliberately
describe register and state transitions rather than unproved in-game sound
identities.

The distinction between timer leases and APU writes matters. The
`pulse1_tone_triangle_lease` role writes pulse 1 while reserving the triangle
timer slot. The late pulse-1 alternators and three shell composites write APU
registers without acquiring any timer lease, so music can overwrite those
channels in the same arbitration model. Reset request zero clears every timer
instead of acquiring a lease.

Several request roles share one update entry, such as the generic timed stop or
the parameterized pulse-2 pitch sequence.

Exact gameplay identities for the effects remain intentionally open until
runtime call-site/audio evidence supports them.

## Music driver ABI

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

An event's meaning depends on the channel. On pulse 1, pulse 2 and the
triangle, `$01-$7F` is a pitch: the driver adds the channel's fixed base
offset, the tonal offset of `$F5` and the channel's own offset of `$F4`, then
reads the little-endian timer value at twice that index in its period table;
the high byte is ORed with the length bits (`$F2`). On the noise channel the
high nibble selects a four-byte record of `$400C-$400F` values in the noise
table (zero is silent) and the low nibble `n` is how many times the hit plays,
each for one duration, before the stream is read again; `n = 0` plays it 256
times. `$00` is a rest everywhere. While a sound effect holds a channel
(`AudioEffectTimers`), the event keeps its time but writes no register.

### Command grammar

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
musical intent.

### State and validation

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

### Reachable streams

The static interpreter models counted loops, saved-position loops, channel-start
jumps, and the single-level call/return slot. It classifies 8,929 unique events
covering 10,016 stream bytes plus 208 header bytes.

The reachable spans are `$F03B-$FCBE` in bank 0, `$B313-$B8E1` and
`$B900-$B9CE` in bank 1, `$CB33-$D66A` in bank 2, and `$A4F6-$ADBB` in bank 3.
Bank 1 deliberately shares its `$B9CE` `EndChannel` byte with the unindexed
World 2 metatile-attribute prefix. The authoring format records this byte once
as an audio event while the physical source retains its adjacent data owner.

Exact in-game effect names and classification of data outside the
header-reachable spans remain explicit non-blocking unknowns; no musical intent
is inferred from the structural driver evidence. Effect-versus-music APU
ownership is separately proven in `docs/audio_system.md`.
