# World 3 entity runtime

`config/world3_entity_runtime.json` fixes ten formerly address-named World 3
entity-lifecycle helpers. The exact contract covers 545 executable bytes,
17 direct calls or tail jumps, and seven already established Bank 2-private
RAM fields. A 64-entry room table now names the horizontal clamp policy used
for persistent objects during room load.

The persistent-object path consumes the Passing Hoop flag carried from World
2, finds its type `$19` registry record, and materializes it at the player in
room zero. Room loading applies one of two safe horizontal clamps to mid-height
persistent objects in the eight paired edge rooms. During transitions, an
enabled Holding Bag can move one other persistent record into the target room
only while fewer than two persistent objects already occupy it.

The combat lifecycle now exposes the type `$04` skull split. A successful hit
allocates a free entity slot, copies the source runtime record with randomized
four-pixel offsets, and halves the behavior selector in both source and clone.
The stopwatch helper owns its full 240-frame lifetime, emits an effect every
eight frames, and releases the audio/entity freeze when it expires.

Both coordinate samplers have exact ranges: X is `$20-$CF` and Y is
`$30-$AF`. The combined spawn-position selector rejects all four terrain-edge
probes and candidates closer than 24 pixels to the player on both axes. The
Passing Hoop boundary helper separately probes tile `$26` at the left and right
room edges, then converts the matching pixel coordinate into an eight-row PPU
opening using the shared blank-barrier row.

Run:

```text
make validate-world3-entity-runtime
```
