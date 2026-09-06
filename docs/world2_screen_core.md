# World 2 screen core

`config/world2_screen_core.json` fixes the World 2 NMI PPU commit, RTS-based
screen-service dispatch, transition-row setup, PPU-address helper, and initial
nametable clear. It pins 115 executable bytes, nine direct callers, and the
World 2 scroll pair plus scrolling-enable state.

Address `$8286` is also named as a post-switch World 3 transition entry. In
physical Bank 1 it overlaps the immediate operand inside the NMI PPU commit;
after the mapper write, execution at that CPU address resolves in Bank 3. It is
therefore gateway evidence, not a second overlapping Bank 1 routine contract.

Run:

```text
make validate-world2-screen-core
```
