# World 3 room rendering

`config/world3_room_rendering.json` fixes eight formerly address-named World 3
room-rendering routines. The exact contract covers 351 executable bytes and
ten direct calls. It also fixes the current-room map pointer, the two
hierarchical row selectors, the zero-through-29 output row, and both 32-byte
palette copies.

Room loading first derives an eight-cell-wide window in the 64x64 large-block
map from the six-bit room index. Thirty output rows then walk the large-block
and small-block hierarchy with independent zero-or-two row selectors. Each
row expands eight map cells into 32 CHR tile bytes and eight attribute bytes,
then queues both transfers at addresses calculated from the output row.

Attribute generation combines the two two-bit palette selectors belonging to
the selected small-block pair. It replaces the appropriate nibble in the
128-byte attribute shadow and writes the complete result to the current
eight-byte transfer row.

The palette-in routine is the inverse room-load half of
`World3_FadePaletteToBlack`. It advances each shadow entry toward the selected
room target, uploads all 32 bytes every three frames, and repeats until the
copies match.

Run:

```text
make validate-world3-room-rendering
```
