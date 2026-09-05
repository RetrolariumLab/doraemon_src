# Reconstruction inventory

This inventory measures semantic progress independently from physical source
layout. Moving bytes into a `worldN/` module does not count as naming them.
`config/reconstruction_inventory.json` pins the current snapshot, and
`scripts/reconstruction_inventory.py` recalculates it from tracked source and
evidence manifests. Any change requires an intentional snapshot update.

## Current snapshot

| Bank | Global labels | Semantic labels | Neutral routines | Neutral locals | Semantic indirect entries |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 1,009 | 186 | 134 | 689 | 48 / 84 |
| 1 | 877 | 161 | 157 | 559 | 60 / 97 |
| 2 | 1,088 | 224 | 181 | 683 | 65 / 106 |
| 3 | 355 | 59 | 93 | 203 | 25 / 67 |
| Total | 3,329 | 630 | 565 | 2,134 | 198 / 354 |

The previous aggregate observation of roughly 82% neutral definitions mixed
565 probable routine entries with 2,134 local branch labels. Source 1.0 gives
priority to the former and to the 156 indirect entries that still lack an
evidence-backed semantic symbol. Local labels are renamed only when that
materially clarifies a routine contract.

The symbol registry currently contains 514 evidence-backed code symbols and
106 operand/table symbols. RAM coverage contains 276 unique aliases: 79 shared
symbols plus 93 Bank 0, 39 Bank 1, and 65 Bank 2 scoped symbols. Bank 3 has the
shared 79-symbol view; chapter-specific shell state remains a visible gap.

Typed PRG ranges cover 35,792 bytes in 46 non-overlapping regions:

| Bank | Typed bytes | Ranges |
| ---: | ---: | ---: |
| 0 | 8,120 | 9 |
| 1 | 18,213 | 16 |
| 2 | 9,437 | 19 |
| 3 | 22 | 2 |

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
