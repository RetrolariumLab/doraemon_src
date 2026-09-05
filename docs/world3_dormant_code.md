# World 3 dormant code islands

Bank 2 contains several instruction-aligned islands that are not reached by
the current static call graph. They are reconstructed as code because each is
a complete legal 6502 control-flow unit bounded by existing routines, uses the
same RAM and helper conventions as neighboring live code, and terminates or
falls through coherently. `Dormant` in every public label records the missing
reachability evidence; it does not claim that the retail game executes the
routine.

| Range | Label | Structural evidence |
| --- | --- | --- |
| `$864D-$866B` | `World3_DormantUpdateState55ForRoomBands` | Alternating room-number bands conditionally write `$14` to `$0055`, then return. |
| `$9A35-$9A3A` | `World3_DormantDeactivateEntity` | Clears the current slot's state at `$0600,X` and returns. |
| `$9DCE-$9DE4` | `World3_DormantFaceType03TowardPlayer` | For type `$03`, selects metasprite offset zero or two from relative player X, then returns. The live renderer calls the one-byte RTS stub immediately before it at `$9DCD`. |
| `$9F9F-$9FD6` | `World3_DormantProbeEntityLowerEdge` | Two-column terrain probe using the neighboring collision helpers, with the same saved-X and carry-result convention as the live probes around it. |
| `$B1C2-$B1F0` | `World3_DormantUpdateControllerRepeat` | Calls its internal `$B1D1` lane helper for both controller-1 serial bytes; held input repeats after eight frames and then every four frames. |
| `$B32D-$B339` | `World3_DormantQueuePpuBlockFromParameters` | Converts X/Y parameters to a PPU address, restores source-pointer and length parameters, and falls through into the live block queue writer at `$B33A`. |
| `$B371-$B39C` | `World3_DormantQueuePpuByteFromParameters` | Converts X/Y parameters and appends one address/length/data record to the PPU queue. |
| `$B39D-$B3F2` | `World3_DormantQueueAttributeFromParameters` | Computes the attribute address and quadrant, replaces its two palette bits in the RAM shadow, and queues the resulting byte. |

The final helper uses three four-byte tables at `$B3F3-$B3FE`. The first table
is not dormant: the live `$B2FD` attribute-fill path also indexes its expanded
palette values. The other two hold the clear and select masks for the four
attribute quadrants.

No absolute `JSR`, `JMP`, or table pointer to the top-level dormant entries is
present in the canonical PRG0 image. This remains a static conclusion: a later
trace, computed jump, or self-modifying call-site discovery can promote an
entry from dormant without changing its reconstructed bytes.
