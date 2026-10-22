# Bank 3 shell runtime

PRG Bank 3 owns the title/attract shell, game-over and ending presentation,
the two chapter-completion interstitials, and common shell PPU/OAM helpers in sixteen named routines.

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

Eight Bank 3-private RAM fields belong to them: chapter-select index/latch,
ending credit source pointer, and the transition completion/motion/origin/settle
state.
