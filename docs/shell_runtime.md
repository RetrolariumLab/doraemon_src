# Bank 3 shell runtime

PRG Bank 3 owns the title/attract shell, game-over and ending presentation,
the two chapter-completion interstitials, and common shell PPU/OAM helpers.
`config/reconstruction/common/shell_runtime.json` pins the sixteen formerly neutral routine entries
that complete the bank's routine-level naming pass.

The names are based on observable contracts rather than location alone:

- the title input poll waits on the NMI-owned frame counter, returns the merged
  controller state, and edge-detects Select while rotating a modulo-three
  chapter index;
- the attract exit path tests A/B, stops music, clears the nametables, and
  reconstructs the title score display before returning to Start polling;
- the transition controller advances a four-phase animation, updates its
  origin, selects destination-specific sprite records, and finally enters the
  requested chapter;
- the relative OAM decoder consumes four-byte records until a zero slot byte,
  with the first byte selecting both OAM offset and low attribute bits;
- the shell clear helper fills both nametables with tile `$7F` and zeros both
  attribute tables, while the OAM helper writes offscreen Y `$F0` to every
  four-byte entry;
- the ending helper copies the fixed 128-byte cast layout into the upper half
  of OAM before the credits row streamer begins.

The contract validates each routine's exact PRG span and CRC32, its semantic
entry in `config/reconstruction/symbols.json`, and the complete set of direct JSR/JMP callers
reported by the current Bank 3 Ghidra facts. It also fixes eight Bank 3-private
RAM fields: chapter-select index/latch, ending credit source pointer, and the
transition completion/motion/origin/settle state.

Run:

```text
make validate-shell-runtime
```
