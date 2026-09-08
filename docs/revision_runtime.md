# Official revision runtime matrix

Source Reconstruction 2.0 runs the same eight architecture scenarios directly
against each source-built official image. Traces and screenshots are generated
under `build/runtime/profiles/<profile>/`; they remain ignored local evidence.

```text
make runtime-revision-matrix
```

The runner checks each ROM's profile-specific SHA-1 before FCEUX starts. The
validator then applies the shared checks or the explicit per-profile override
stored with that scenario. An override cannot silently affect the other
profile.

## Observed matrix

| Scenario | Original | Revision A |
| --- | --- | --- |
| boot/title | shell steady | shell steady |
| World 1 city | frame loop steady | frame loop steady |
| World 1 underground | frame loop steady | frame loop steady |
| World 2 cave | frame loop steady | frame loop steady |
| World 2 terminal | `$7F` terminal path | `$7F` terminal path |
| World 3 underwater | frame loop steady | entry, changed helper, first frame, reset |
| chapter transition | World 2 to World 3 | World 2 to World 3 entry |
| ending credits | completion and credits loops | repeats the independent World 3 reset observation |

## Revision A World 3 boundary

Both independent Revision A World 3 traces observe this ordered sequence:

1. Bank 2 main entry at `$828E`;
2. the changed encounter helper at `$AB53`;
3. the first Bank 2 frame-loop entry at `$838E`;
4. the reset entry at `$8098` during that frame;
5. a stable return to Bank 3 with mapper selector `$0F`.

The reset occurs 16 frames after the changed helper probe. This temporally ties
the divergence to the changed Bank 2 path without claiming which undocumented
instruction or side effect is its final cause. The fixed-time ending memory
patch cannot run before this reset, so Revision A does not claim an ending
trace. The original profile continues to provide the complete ending evidence.

This is an accepted-image behavior record, not an attempt to repair or normalize
Revision A. Both source profiles remain byte-identical to their references.
