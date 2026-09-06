# Reconstruction inventory

This inventory measures semantic progress independently from physical source
layout. Moving bytes into a `worldN/` module does not count as naming them.
`config/reconstruction_inventory.json` pins the current snapshot, and
`scripts/reconstruction_inventory.py` recalculates it from tracked source and
evidence manifests. Any change requires an intentional snapshot update.

## Current snapshot

| Bank | Global labels | Semantic labels | Neutral routines | Neutral locals | Semantic indirect entries |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 1,010 | 188 | 134 | 688 | 48 / 84 |
| 1 | 879 | 163 | 157 | 559 | 60 / 97 |
| 2 | 1,090 | 226 | 181 | 683 | 65 / 106 |
| 3 | 357 | 61 | 93 | 203 | 25 / 67 |
| Total | 3,336 | 638 | 565 | 2,133 | 198 / 354 |

The previous aggregate observation of roughly 82% neutral definitions mixed
565 probable routine entries with 2,133 local branch labels. Source 1.0 gives
priority to the former and to the 156 indirect entries that still lack an
evidence-backed semantic symbol. Local labels are renamed only when that
materially clarifies a routine contract.

The symbol registry currently contains 518 evidence-backed code symbols and
110 operand/table symbols. RAM coverage contains 276 unique aliases: 79 shared
symbols plus 93 Bank 0, 39 Bank 1, and 65 Bank 2 scoped symbols. Bank 3 has the
shared 79-symbol view; chapter-specific shell state remains a visible gap.

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
