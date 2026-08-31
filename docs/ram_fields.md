# RAM Fields

This registry lists high-confidence shared RAM roles. Addresses are CPU RAM
addresses; array symbols may be indexed by channel, digit, or sprite slot at the
use site. Chapter-local zero-page overlays remain numeric until their lifetime
and ownership are proved.

## Common frame and input state

| Symbol | Address | Role |
| --- | ---: | --- |
| `NmiOamDmaRequest` | `$0014` | Nonzero requests OAM DMA during the next NMI |
| `NmiBusy` | `$0015` | NMI re-entry guard incremented around bank-local frame work |
| `FrameCounter` | `$0016` | Incremented once at the end of every bank-local NMI |
| `MapperSelection` | `$0017` | Combined GNROM PRG/CHR selection consumed by the mapper writer |
| `ChrSelectionBits` | `$0018` | Prepared CHR-bank bits merged into `MapperSelection` |
| `PpuCtrlShadow` | `$0019` | Software shadow written to `PPU_CTRL` |
| `PpuMaskShadow` | `$001A` | Software shadow written to `PPU_MASK` |
| `PpuScrollXShadow` | `$001B` | First value written to `PPU_SCROLL` during frame setup |
| `PpuScrollYShadow` | `$001C` | Second value written to `PPU_SCROLL` during frame setup |
| `Controller2Buttons` | `$001D` | Primary controller-2 serial shift register |
| `Controller2ButtonsAlt` | `$001E` | Secondary controller-2 serial shift register |
| `Controller1Buttons` | `$001F` | Primary controller-1 serial shift register |
| `Controller1ButtonsAlt` | `$0020` | Secondary controller-1 serial shift register |
| `CombinedControllerButtons` | `$0021` | OR of the four serial button bytes after polling |

## Shared rendering and score state

| Symbol | Address | Role |
| --- | ---: | --- |
| `ScoreDigitsCurrent` | `$0290` | Current eight-byte score digit array |
| `ScoreDigitsWorking` | `$0298` | Eight-byte score arithmetic and carry array |
| `OamBuffer` | `$0300` | CPU page copied by OAM DMA and written as four-byte sprite records |

## Bank-local audio driver state

All four PRG banks carry their own driver code but use the same RAM layout.

| Symbol | Address | Role |
| --- | ---: | --- |
| `AudioEffectRequestState` | `$02A0` | Pending effect index; bit 7 marks a consumed request |
| `AudioCurrentEffectPriority` | `$02A1` | Even priority/dispatch index of the active effect |
| `AudioEffectTimers` | `$02A3` | Four per-frame effect countdown bytes |
| `AudioMusicState` | `$02AA` | Music request and active-state byte |
| `AudioMusicControl` | `$02AB` | Music reset/control state shared with transition code |
| `AudioChannelNotes` | `$02AC` | Four current note values |
| `AudioChannelDurations` | `$02B0` | Four channel countdown values |
| `AudioStreamHeaderPointers` | `$02DC` | Eight-byte copy of the selected track header pointers |
| `AudioChannelIndex` | `$02FD` | Current channel index, 0 through 3 |
| `AudioEndedChannelCount` | `$02FE` | Count used to stop music after all four channels end |
| `AudioWorkByte` | `$02FF` | Music interpreter temporary byte |

The semantic operand mapping is machine-readable in `config/symbols.json`.
`src/memory/ram.inc` supplies the ca65 definitions used by generated source.
