# World 1 descriptor identities

The thirteen descriptor records at `$CC0A` represent two portals and eleven
collectible or hidden objects. Their identities are fixed by joining the exact
descriptor fields with placement frequency, the five selector slots at
`$94D4-$94D8`, direct metasprites, the type `$03-$0D` interaction dispatch,
and each handler's concrete state change.

| Descriptor | Runtime type | Identity | Placement / selector | Decisive local effect |
| ---: | ---: | --- | --- | --- |
| `$00` | `$01` | Manhole | 9 placements | A-button portal type 1 |
| `$01` | `$02` | Anywhere Door | 8 placements | A-button portal type 2 |
| `$02` | `$03` | Stopwatch | selector 3 | freeze flag plus `$F0` timer |
| `$03` | `$04` | Genki Candy | 2 placements | expands the health meter |
| `$04` | `$05` | 1UP | 1 placement | increments lives |
| `$05` | `$06` | weapon upgrade | 3 placements | increments weapon level |
| `$06` | `$07` | Dorayaki | 4 placements, selector 0 | refills health |
| `$07` | `$08` | Rapid-Fire Drink | 3 placements | increments shot limit |
| `$08` | `$09` | Flash Light / Small Light | 1 placement | sets World 2 carry-forward flag |
| `$09` | `$0A` | programmer's face | 1 hidden placement | microphone plus projectile gate |
| `$0A` | `$0B` | Gold Bar | selector 1 | awards encoded score `$31` |
| `$0B` | `$0C` | Diamond | 1 placement, selector 2 | awards encoded score `$32` |
| `$0C` | `$0D` | invulnerability | secret selector 4 | sets `World1InvulnerabilityTimer` to `$FF` |

Descriptor `$05` deliberately stores metasprite zero. Materialization replaces
it with `World1WeaponLevel` plus `$2A`, selecting metasprites `$2A-$2C`
for the Shock Gun, Air Gun, and Power Fan. It is therefore a single dynamic
weapon-upgrade descriptor rather than three descriptor records.

The first four selector slots are random post-defeat rewards. Slot 4 is reached
only after the six-defeat sequence and contains descriptor `$0C`; this is the
published temporary-invulnerability reward. Descriptor `$09` is different: its
hidden type `$8A` can be damaged only while the controller-2 microphone flag is
active, matching the published programmer-face secret.

## Evidence and validation

[StrategyWiki's item catalog](https://strategywiki.org/wiki/Doraemon/Items)
provides item names, images, and effects, while its
[World 1 guide](https://strategywiki.org/wiki/Doraemon/World_1) documents the
portal and progression context. The independent
[GameFAQs walkthrough](https://gamefaqs.gamespot.com/nes/578343-doraemon/faqs/48568)
records placements, scores, and effects; its
[secret list](https://gamefaqs.gamespot.com/nes/578343-doraemon/cheats/)
documents both special rewards. Every mapping additionally requires local ROM
evidence; external names alone do not choose a descriptor.

`make validate-world1-descriptor-identities` checks all thirteen descriptor
fields, placement counts, selector slots, direct and dynamic metasprites,
eleven dispatch targets, thirteen effect signatures, and evidence provenance.
It is part of `make release-check`.
