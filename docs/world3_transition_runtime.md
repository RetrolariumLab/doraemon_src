# World 3 transition runtime

`config/reconstruction/world3/world3_transition_runtime.json` fixes the final five address-named
World 3 routines. The exact contract covers 374 executable bytes, twelve
direct calls or tail jumps, and ten Bank 2-private RAM fields. It also names
the two blank completion-wipe sources, the eight-record debug OAM image, and
the room `$3F` marker blink counter.

After the final formation delay expires, the completion sequence resets the
player state and runs an eight-frame inward wipe. Each step queues one blank
row from the top and bottom and one blank column from the left and right. The
player is held at the center, non-type-`$1F` entities are cleared, and surviving
type-`$1F` actors have their metasprite variant reset. The sequence then waits
for music completion, delays another `$5A` frames, and enters the common ending
gateway.

Before that transition begins, room `$3F` conditionally renders metasprite
`$AC` at the fixed `$70,$74` position under a bit-four blink cadence. The
counter now has explicit Bank 2 ownership without assigning an unsupported
character identity to the marker.

Eight impossible-state paths tail-call a common diagnostic halt. The incoming
code is converted to a tile in the `$30-$37` range, placed at the screen center,
submitted for OAM DMA, and followed by an intentional infinite loop.

The controller-two `$C0` debug hook has a separate sprite-test setup path. It
disables rendering, uploads the final-room palette, clears both nametables and
attribute tables, copies eight fixed OAM records to page `$03`, restarts music
track seven, and returns to the debug input handshake.

Run:

```text
make validate-world3-transition-runtime
```
