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

## Bank roles

| Bank | Confirmed landmarks | Working role |
| --- | --- | --- |
| 0 | city/underground maps and shared metatiles | world 1 |
| 1 | 60 direct small-block screens | world 2 cave shooter |
| 2 | `DORAEMON WORLD3...` build string and underwater map | world 3 |
| 3 | title strings, item names, credits, common presentation | shell/title/ending |

These are evidence-backed roles, not exclusive ownership boundaries. The NMI,
mapper routine, input polling, score helpers, and dispatch table prefix are
duplicated across banks.

## Three gameplay systems

World 1 uses a 64x64 city map plus a 64x25 underground map and two metatile
layers. World 2 uses 60 independent 16x15 screens and no large-block layer.
World 3 returns to a 64x64 map with separate metatile tables. This makes three
chapter-specific update/rendering systems the safest current model.
