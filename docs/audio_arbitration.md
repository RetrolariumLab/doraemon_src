# Effect and music APU arbitration

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

`make validate-audio-arbitration` verifies all four effect-before-music frame
paths, their common timer tick, twelve music-write guards, the unguarded reset
prefix, seven shared RAM fields, and the semantic source symbols.
