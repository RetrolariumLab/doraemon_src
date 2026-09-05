# World 2 conditional stage branches

World 2 checks 17 special screen IDs once per frame in the routine at
`$A6BC-$A70E`. A branch can fire only while the compressed-screen renderer is
on row 13 and the branch cooldown is zero. A successful branch decrements the
zero cooldown to `$FF`; subsequent calls count it down for 255 frames.

## Conditions

Four parallel 17-byte tables at `$A70F-$A752` define the trigger screen,
destination stage offset, condition, and optional fixed return offset.

| Code | Condition |
| ---: | --- |
| 0 | always |
| 1 | player Y is below `$50` |
| 2 | player X is at least `$A0` |
| 3 | player Y is at least `$A0` |

The canonical table has 4 unconditional entries, 5 upper-Y entries, 1
right-side X entry, and 7 lower-Y entries. Five branches override the return
offset. The other twelve save the current stage-sequence offset dynamically.

The destination is stored as `destination - 1` because the stage decoder
increments `World2StageSequenceOffset` before fetching its next byte. An `$F7`
stage command restores `World2SavedStageSequenceOffset`; decoder control flow
then increments that saved value before its next fetch.

## Lossless authoring

`data/world2/stage_branches.json` gives every branch a row-oriented record while
preserving the four physical ROM columns. `null` in `return_offset_override`
represents the ROM byte zero and therefore means “save the current offset.”

Run `make validate-world2-stage-branches` to verify the routine signature,
table CRCs, coordinate-condition contract, stage-offset bounds, and complete
68-byte authoring round trip. The script also provides `decode` and `encode`
subcommands for controlled edits.
