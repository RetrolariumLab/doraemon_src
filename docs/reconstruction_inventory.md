# Reconstruction inventory

This inventory measures semantic progress independently from physical source
layout. Moving bytes into a `worldN/` module does not count as naming them.
`config/reconstruction_inventory.json` pins the current snapshot, and
`scripts/reconstruction_inventory.py` recalculates it from tracked source and
evidence manifests. Any change requires an intentional snapshot update.

## Current snapshot

| Bank | Global labels | Semantic labels | Neutral routines | Neutral locals | Semantic indirect entries |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 1,011 | 256 | 70 | 685 | 84 / 84 |
| 1 | 879 | 229 | 91 | 559 | 97 / 97 |
| 2 | 1,090 | 294 | 113 | 683 | 106 / 106 |
| 3 | 357 | 134 | 20 | 203 | 67 / 67 |
| Total | 3,337 | 913 | 294 | 2,130 | 354 / 354 |

The neutral population now separates 294 probable routine entries from 2,130
local branch labels. The common runtime naming pass removed 88 neutral routine
names by proving copied reset/NMI/mapper services, cross-bank gateways, and
bank-local dispatches. A second pass named all 19 previously neutral non-audio
dispatch entries in World 2 streaming and the World 3 player state machine. The
audio-effect pass then assigned all remaining 137 indirect entries to exact
request pairs, structural synthesis roles, timer leases, and APU channels.
Every one of the 354 registered indirect entries now has an evidence-backed
semantic symbol. It also names the sixteen bank-local effect helpers, including
the previously local-only World 1 indexed-tonal entry at `$E6C1`. Source 1.0
now additionally has runtime-backed names for all four gameplay loops: World 1
city `$82C1`, World 1 underground `$CE55`, World 2 `$8959`, and World 3
`$838E`. All sixteen bank gateway targets, the three bank-local NMI targets
that were still neutral, and the frame waits used by these top-level paths are
also named and checked. Source 1.0 gives priority to the remaining directly
reached core routines.
Local labels are renamed only when that materially clarifies a routine contract.

The symbol registry currently contains 793 evidence-backed code symbols and
110 operand/table symbols. RAM coverage contains 280 unique aliases: 83 shared
symbols plus 93 Bank 0, 39 Bank 1, and 65 Bank 2 scoped symbols. Bank 3 has the
shared 83-symbol view; chapter-specific shell state remains a visible gap.

Typed PRG ranges cover 46,015 bytes in 51 non-overlapping regions. The increase
comes from exact header-reachable music streams, not blanket classification of
the surrounding modules:

| Bank | Typed bytes | Ranges |
| ---: | ---: | ---: |
| 0 | 11,388 | 10 |
| 1 | 19,954 | 18 |
| 2 | 12,373 | 20 |
| 3 | 2,300 | 3 |

Four sections still contain explicit `Unknown:` claims: `BANK-001`,
`BANK-002`, `WORLD-DATA-002`, and `AUDIO-002`. Long sections containing only
resolved `Known:` evidence do not inflate that count.

## Priority rule

Naming work proceeds through common boot/NMI/score paths, four main loops,
audio drivers, and every indirect-dispatch target before cosmetic local-label
cleanup. Inventory counts are descriptive evidence, not a standalone release
percentage: routine importance and subsystem completeness are not uniform.

Run:

```text
make reconstruction-inventory
```
