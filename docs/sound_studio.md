# Sound Studio

Sound Studio edits the proven fixed-capacity audio data in all four PRG banks.
It covers 26 track headers, 10,016 bytes reached by their channel streams, 202
`SetEnvelopeVolume` commands inside those streams, and all 93 effect-request
routing bytes. The editor uses the same workspace and composition contract for
the original Japanese revision and Revision A because their audio bytes are
identical.

Run the visual editor with:

```text
make sound-content-init PROFILE=original
make sound-studio PROFILE=original
```

Use `PROFILE=rev_a` for Revision A. The ignored workspace contains
`music_streams.json` and `effect_priorities.json`; the tracked files under
`data/audio/` remain the canonical zero-edit source.

## Music and envelopes

The music tab gives all 26 physical headers evidence-backed titles alongside
their four channel pointers, so the underground, Bull Robo, cave boss,
underwater mid-boss, chapter-clear, defeat, title, ending, and game-over music
can be selected directly instead of being hidden behind driver-local numbers.
World 3 track 4 is retained as an alternate mid-boss mix, but is explicitly
described as a physical header with no direct request yet proven in code.

Every event in each contiguous reachable segment is also shown. Notes/events,
duration opcodes, and fixed-width synthesis command operands are editable. A
separate browser lists every `$EF` envelope command and jumps to its physical
stream address.

Edits may not change an event's byte width or class. Command opcodes keep their
semantic role, while channel ends, loops, calls, returns, saves, and track
restarts are locked to the canonical bytes. This keeps all existing pointers
and state-graph boundaries valid within the original banks.

Select any of the 26 track-header rows and press `Play`. Sound Studio renders
the current in-memory document immediately and plays it asynchronously inside
the editor; saving, building a ROM, and opening an emulator are not required.
`Stop` halts playback, `Loop` repeats the generated preview, and the four
channel toggles can solo any combination of Pulse 1, Pulse 2, Triangle, and
Noise.

The scrollable piano roll is produced by the same host interpreter as the
audio. It follows the cartridge's duration events, counted loops, alternate
loop exits, calls/returns, stream saves/restores, track restarts, pitch and duty
commands, volume envelopes, and the four bank-local synthesis tables. The WAV
renderer models both pulse oscillators, triangle, the noise LFSR, nonlinear NES
mixing, and the console output filters. Pulse edges are band-limited for host
playback, while native hardware envelopes make sustained pulse notes decay and
turn zero-volume noise control bytes into their intended short bursts. The
World 2 driver's one-byte table-layout skew is handled separately from the
three otherwise matching banks. Because the player reads `music.document`, an
unsaved fixed-width event edit is visible and audible on the next press of
`Play`.

A zero noise period index has a separate meaning from table entry zero. The
native driver skips the APU register writes, consuming the event duration while
the preceding envelope finishes decaying. The embedded renderer preserves that
hold behavior, which keeps the quiet gaps in the title music silent instead of
aliasing an ultrasonic noise clock into a low hiss.

Original and Revision A contain identical audio bytes, so both profiles use
the same synthesizer tables. Normal `sound-content-rom` and `content-rom`
builds still target the selected source revision.

The separate `check-sound-preview` release test deliberately remains an
independent FCEUX oracle. It exercises one real request in each cartridge audio
bank so changes to the convenient host synthesizer cannot conceal a broken
native playback path; FCEUX is never launched by the visual Sound Studio.
For Revision A, the World 3 request is injected during the proven setup window
before that profile's documented first-frame reset; this proves native bank-2
request delivery without claiming steady World 3 gameplay for the revision.

## Effect requests

Each request byte selects one adjacent init/update handler pair through an even
slot value. The effect tab displays the conservative synthesis role proved in
`config/authoring/audio/audio_effects.json` and exchanges slots between two requests. Requiring
a complete permutation prevents duplicate handlers, missing handlers, odd
indices, and out-of-range dispatch entries.

The effect handlers themselves remain executable source, not editable data.
Sound Studio therefore does not claim speculative in-game names or expose code
immediates as a fake instrument format.

## Headless contract

```text
make sound-content-check PROFILE=original
make sound-content-export PROFILE=original
make sound-content-rom PROFILE=original
make sound-content-roundtrip
make check-sound-studio PROFILE=original
make check-sound-preview PROFILE=original
```

The ROM composer starts from the selected source-built revision, changes only
the sparse audio ranges, and leaves CHR untouched. The round-trip target builds
both official revisions and requires the canonical documents to change zero
ROM bytes.
