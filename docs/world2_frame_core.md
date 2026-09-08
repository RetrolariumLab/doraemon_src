# World 2 frame core

`config/reconstruction/world2/world2_frame_core.json` fixes fifteen routines at the center of the
World 2 frame and stage lifecycle. The slice covers the wait/render path,
chapter exit, boss-to-stage advance, transition delay, sprite/metatile clears,
audio reset, initial health lookup, initial stage upload, delayed scrolling and
music activation, and the microphone-item attack.

Two entry points intentionally fall through: the wait wrapper enters the full
render pass, and the completion-effect prefix enters the shared transition
delay. Their exact non-overlapping prefixes are recorded separately.

Ten new Bank 1 RAM names replace raw addresses in the main path: scrolling and
sprite-flicker state, player damage/death state, stage-start and shared sequence
timers, chapter/stage completion flags, and the microphone hold/one-shot pair.
The contract pins 370 executable bytes and all 23 direct JSR/JMP callers.

Run:

```text
make validate-world2-frame-core
```
