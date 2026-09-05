# World 3 transient spawn schedules

World 3 stores its ordinary room-driven transient entities in twelve contiguous
64-byte columns at bank 2 `$D66B-$D96A`. Each room has four independent
channels. A channel record consists of an entity type, a successful-spawn
budget, and a delay value; a zero count disables that channel even when its
type or delay bytes are nonzero.

| Physical columns | CPU range | Meaning |
| --- | --- | --- |
| type 0-3 | `$D66B-$D76A` | type passed to the 16-entry spawn initializer table |
| count 0-3 | `$D76B-$D86A` | number of successful allocations before completion |
| delay 0-3 | `$D86B-$D96A` | initial and recurring delay |

The complete region is 768 bytes with CRC32 `019b7efd`. It ends immediately
before the persistent room-object registry at `$D96B`.

## Runtime scheduling

`World3_ClearEntityStorage` clears
`World3TransientSpawnScheduleLoaded` during room materialization. On the next
frame, `World3_UpdateTransientSpawns` indexes every ROM column by the current
room, copies the twelve values to zero page, saves each delay as its reload
value, and clears the four completion flags.

All four channels are then visited each frame. A nonzero delay uses a
modulo-four phase counter, so its countdown changes once per four scheduler
calls. When the countdown reaches zero, it is reloaded before allocation is
attempted. If no active-entity slot is free, the budget is not consumed and a
nonzero-delay channel waits through the newly reloaded interval. A zero-delay
channel bypasses the prescaler and retries every frame.

The four phase counters are deliberately not cleared by the room-load path.
They retain their cadence across rooms. The manifest pins this detail with the
actual scheduler instruction signatures.

After a successful allocation the routine:

1. clears one slot across all 22 parallel active-entity fields;
2. sets its activation timer to 30, state to 2, and X/Y to `$FF`;
3. copies the scheduled type and its type-derived hit points and metasprite;
4. calls the type-indexed initializer at `$8F6C`;
5. decrements the channel budget and marks it complete after the last spawn.

All canonical scheduled types are `$00-$0C`, within the initializer table's
16-entry `$00-$0F` domain. Type zero is a real entity type; only a zero count
means an inactive room/channel pair.

## Canonical schedule

The original ROM activates 132 room/channel pairs across 62 of 64 rooms. Their
per-channel active counts are 54, 6, 27, and 45, with cumulative spawn budgets
of 874, 66, 132, and 45. Three active channel-zero records use delay zero. The
large budgets, including 100 and 250, are byte values and are preserved without
interpreting them as a different encoding.

`data/world3/transient_spawns.json` presents all 64 rooms as row-oriented
records while encoding back to the original twelve-column layout. Run
`make validate-world3-transient-spawns` to check table CRCs and domains,
contiguity, scheduler signatures, timing, initializer capacity, metrics, and
the complete lossless round trip. The tool also provides `decode` and `encode`
subcommands for controlled edits.
