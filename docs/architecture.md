# Architecture

## Cartridge mapping

Doraemon uses mapper 66 (`HVC-GNROM`). One 32 KiB PRG bank occupies the entire
CPU window `$8000-$FFFF`; one 8 KiB CHR bank occupies PPU `$0000-$1FFF`.
Switching PRG therefore also replaces the interrupt vectors.

Every PRG bank contains the same vector values:

| Vector | Address |
| --- | --- |
| NMI | `$813C` |
| RESET | `$8098` |
| IRQ/BRK | `$8098` |

The common code and vectors are duplicated, not fixed by hardware. Banks 0, 2,
and 3 share 733 identical bytes at the end; banks 2 and 3 share 2,318.

## Bus-conflict-safe switching

At `$81BB`, the active bank executes:

```asm
LDA $17
TAX
LDA $8261,X
STA $8261,X
RTS
```

`$8261-$8270` contains:

```text
00 10 20 30 01 11 21 31 02 12 22 32 03 13 23 33
```

The indexed ROM byte is both the desired latch value and the value visible on
the cartridge data bus, so the write survives the original discrete-board bus
conflict. The compact index orders PRG first and CHR second; the table converts
it to mapper bits `xxPPxxCC`.

The deterministic `boot-title` runtime trace observes the initial switch from
FCEUX's power-on PRG 0 to PRG 3, then a PRG 3 / CHR 3 selection before NMI is
enabled. A hook on the instruction after `STA` fingerprints the newly mapped
bank, independently confirming the selector interpretation. See
`docs/runtime_evidence.md`.

## Bank roles

| Bank | Confirmed landmarks | Working role |
| --- | --- | --- |
| 0 | city/underground maps and shared metatiles | world 1 |
| 1 | stage sequence and 119 compressed screen selectors | world 2 cave shooter |
| 2 | `DORAEMON WORLD3...` build string and underwater map | world 3 |
| 3 | title strings, item names, credits, common presentation | shell/title/ending |

These are evidence-backed roles, not exclusive ownership boundaries. The NMI,
mapper routine, input polling, score helpers, and dispatch table prefix are
duplicated across banks.

Runtime chapter-entry traces establish shell edges to all three gameplay banks:
PRG3 -> PRG0 for the natural World 1 path, PRG3 -> PRG1 for the one-Select
shortcut, and PRG3 -> PRG2 for the two-Select shortcut. Worlds 2 and 3 both make
short PRG3 calls and return to their own banks during initialization. The
detailed selectors and frames are recorded in `docs/runtime_evidence.md`.

## Cross-bank gateways

The 152-byte range `$8000-$8097` is byte-identical in every bank (SHA-1
`96d7be7487db1a145abc7e128c2ab58235345310`). It contains 14 entry stubs:

| Entries | Operation |
| --- | --- |
| `$8000/$800B/$8016` | switch to PRG 0/1/2 and jump through local `$8271` |
| `$8021` | jump through current-bank `$8274` without switching |
| `$8024/$802F/$803A` | switch to PRG 0/1/2 and jump through local `$8277` |
| `$8045` | jump through current-bank `$827A` without switching |
| `$8048` | switch to PRG 3 and jump through bank-3 `$8271` |
| `$8053/$8065` | save selector, call PRG 3 `$8277/$827D`, restore selector |
| `$8077/$8082/$808D` | switch to PRG 3 and jump through `$8280/$8283/$8286` |

`config/bank_gateways.json` records the exact stub bytes and all 31 direct call
sites currently represented as instructions. `make validate-bank-gateways`
checks the four copies, source calls, and possible graph edges. The resulting
static PRG graph is `{0,1,2}->3` plus `3->{0,1,2,3}`; runtime traces exercise
the shell-to-chapter edges and callable shell returns.

## Three gameplay systems

World 1 uses a 64x64 city map plus a 64x25 underground map and two metatile
layers. World 2 follows a stage-command sequence and expands variable-length
streams into sixteen-row screens; its literal, run-length, row-end, and enemy
spawn tokens have no large-block layer. World 3 returns to a 64x64 map with
separate metatile tables. This makes three chapter-specific update/rendering
systems the safest current model.
