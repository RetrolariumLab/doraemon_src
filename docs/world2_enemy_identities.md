# World 2 enemy identities

World 2 uses states `$01-$0F` for enemies embedded in compressed screen
streams and states `$10-$14` for boss encounters and their helpers. Joining the
property tables, handler graph, rendered CHR, boss controller, and published
Japanese roster resolves every state except that state `$10` has no standalone
published name: it is the Jura-like projectile emitted by Ororon Iwa.

## State catalog

| State | Identity | Lifecycle | HP | Score | Metasprites | Decisive local evidence |
| ---: | --- | --- | ---: | ---: | --- | --- |
| `$01` | アンコドリ / Ankodori | screen spawn | 1 | 10 | 0-1 | bird CHR; straight left drift |
| `$02` | タッコン / Takkon | screen spawn | 1 | 20 | 2-3 | octopus CHR; four-kill item rule |
| `$03` | ミドロン / Midron | screen spawn | 1 | 30 | 4-6 | amoeba CHR; axis-selected charge |
| `$04` | テンコウモリ / Tenkoumori | screen spawn | 1 | 100 | 7-8 | winged-skull CHR; wave; Centaurus helper |
| `$05` | ゼンマイウオ / Zenmaiuo | screen spawn | 1 | 1,000 | 9-11 | fish CHR; rising/falling phase motion |
| `$06` | グリンコ / Gurinko | screen spawn | 1 | 50 | 12-13 | green flying CHR; vertical wave |
| `$07` | ボルッカ / Borukka | screen spawn | 8 | 300 | 14-15 | volcano CHR; stationary radial shooter |
| `$08` | ガンガン / Gangan, straight | screen spawn | 2 | 500 | 17-18 | rock CHR; straight scrolling motion |
| `$09` | ブラン / Buran | screen spawn | 32 | 2,000 | none | background vine remains invisible to OAM; shoots |
| `$0A` | トッシン / Tosshin | screen spawn | 3 | 500 | 36-37 | side-facing CHR; right-angle attack cycle |
| `$0B` | キョン / Kyon | screen spawn | 8 | 500 | 32-35 | frog CHR; axis-selected motion table |
| `$0C` | ジョキ / Joki | screen spawn | 4 | 1,000 | 38-39 | shares Midron's charge handler; higher durability |
| `$0D` | ポッタ / Potta | screen spawn | 2 | 100 | 30-31 | droplet CHR; delayed vertical wave |
| `$0E` | ジュラ / Jura | screen spawn | 32 | 100 | 23-25 | shuriken CHR; orbit motion |
| `$0F` | ガンガン / Gangan, spiral | screen spawn | 8 | 1,000 | 17-18 | same rock CHR as `$08`; falling orbit |
| `$10` | Ororon Jura projectile | internal | 1 | 0 | 23-25 | spawned only by Ororon; shares Jura graphics |
| `$11` | オロロン岩 / Ororon Iwa | boss | 32 | 10,000 | none | first boss-table state; background presentation |
| `$12` | ビッグロボシップ / Big Robo Ship | boss | 32 | 10,000 | 40-42, 44-46 | second boss; three-part composite |
| `$13` | ケンタウルス / Centaurus | boss | 32 | 10,000 | 48-50, 52-54 | third boss; three-part composite |
| `$14` | ロボシップ / Robo Ship | internal | 1 | 500 | 56-57 | spawned only by Big Robo Ship |

The two Gangan records are intentional. The Japanese description distinguishes
straight and spiral movement, while the ROM makes states `$08` and `$0F` share
the same two metasprites but assigns separate motion handlers and durability.

## Boss controller

The controller at `$97C5` indexes all encounter data by the World 2 area:

| Area | Trigger screen | Boss state | Initial X/Y | Identity |
| ---: | ---: | ---: | --- | --- |
| 0 | `$11` | `$11` | `$DC/$98` | Ororon Iwa |
| 1 | `$40` | `$12` | `$78/$50` | Big Robo Ship |
| 2 | `$67` | `$13` | `$B4/$64` | Centaurus |

The same routine proves the helper relationships. Area 0 creates state `$10`,
area 1 creates `$14`, and area 2 creates ordinary state `$04`. These match the
published descriptions of Ororon's Jura-like shots, Big Robo Ship's Robo Ships,
and Centaurus's Tenkoumori.

## Scores and the Takkon rule

The reward table does not store binary point values. The high nibble selects
one of seven decimal score digits and the low nibble is added to it; the visible
point value is therefore `low * 10^(6-high)`. For example, `$51`, `$43`, and
`$21` encode 10, 300, and 10,000 points. The carry loop beginning at `$81C9`
is included in the validation contract.

At `$99A7`, the defeat path compares the state with `$02`, increments a
dedicated streak byte, and creates an item after the fourth consecutive match.
Any other defeated state clears the streak. This state-specific rule is strong
independent evidence for Takkon's state assignment.

## Evidence policy and validation

The [Japanese WikiWiki guide](https://wikiwiki.jp/neskouryaku1/%E3%83%89%E3%83%A9%E3%81%88%E3%82%82%E3%82%93)
provides the canonical enemy names and behavior descriptions. The
[GameFAQs guide](https://gamefaqs.gamespot.com/nes/578343-doraemon/faqs/48568)
independently lists World 2 durability, scores, and boss order, although its
English visual labels are not treated as canonical names. A separate
[Japanese roster](https://note.com/dandy_chimp6035/n/nf40eba9843d5) corroborates
the name inventory. Published names alone never select a state: every mapping
also requires local ROM evidence from graphics, behavior, properties, or boss
control flow.

`make validate-world2-enemy-identities` checks all 20 property and metasprite
joins, lifecycle domains, decimal score decoding, the four boss tables, three
helper-spawn signatures, the four-Takkon rule, the 14-name/15-state direct
roster, and evidence provenance. It is part of `make release-check`.
