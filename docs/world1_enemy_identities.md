# World 1 enemy identities

World 1 uses runtime states `$01-$0C` for ordinary map placements, `$0D` as an
unreferenced dispatch state, and `$0E-$0F` for the scripted Bull Robo battle.
Joining placement types, property tables, metasprites, movement handlers, and
published enemy lists resolves all ten ordinary identities and both mode
variants. State `$0D` remains deliberately structural because no writer or
placement has been found.

## State catalog

| State | Identity | Context | Stored health | Score | Base metasprite |
| ---: | --- | --- | ---: | ---: | ---: |
| `$01` | ユーボウ / Yuubou | city | 2 | 200 | `$64` |
| `$02` | スネラー / Suneraa | city | 1 | 200 | `$5C` |
| `$03` | メカノッソ / Mekanosso | city | 2 | 500 | `$56` |
| `$04` | ゴズラ / Gozura | city movement | 4 | 100 | `$60` |
| `$05` | ナーメ / Naame | city movement | 1 | 200 | `$58` |
| `$06` | コブーン / Kobuun | city | 1 | 50 | `$4C` |
| `$07` | ネズミ / Nezumi | underground | 2 | 800 | `$54` |
| `$08` | ドバック / Dobakku | underground | 1 | 50 | `$70` |
| `$09` | ヘリメダ / Herimeda | underground | 2 | 1,000 | `$6C` |
| `$0A` | ギラーミン / Giraamin | underground | 4 | 50 | `$3E` |
| `$0B` | ゴズラ / Gozura | underground movement | 4 | 50 | `$60` |
| `$0C` | ナーメ / Naame | underground movement | 1 | 50 | `$58` |
| `$0D` | dormant state | no proven writer | n/a | 10,000 | n/a |
| `$0E` | ブルロボ / Bull Robo | scripted boss state | script | 50 | script |
| `$0F` | ブルロボ / Bull Robo | scripted boss state | script | 50 | script |

The repeated Gozura and Naame records are intentional. States `$04/$0B` share
metasprite base `$60`, and states `$05/$0C` share base `$58`, but each pair has
separate city and underground physics handlers. The stored health byte is an
internal damage threshold, so it must not be read as a published “number of
shots” without also accounting for the comparison order in the damage path.

## Six-defeat secret

The six bytes at `$94D9` are `$06,$06,$05,$04,$01,$06`. The defeat routine at
`$9462` compares the low six bits of the defeated runtime state against this
table and resets progress on a mismatch. Completing the sequence sets selector
index `$04`; the adjacent fifth selector byte at `$94D8` is `$0C`, so the
spawned reward is descriptor `$0C`, whose handler enables invulnerability.
After joining state identities, the exact sequence is:

`Kobuun, Kobuun, Naame, Gozura, Yuubou, Kobuun`.

This ROM-resident sequence independently anchors four otherwise visually
derived assignments: Kobuun `$06`, Naame `$05`, Gozura `$04`, and Yuubou `$01`.

## Evidence policy and validation

The [Japanese WikiWiki guide](https://wikiwiki.jp/neskouryaku1/%E3%83%89%E3%83%A9%E3%81%88%E3%82%82%E3%82%93)
provides Japanese names and behavior descriptions. The
[GameFAQs guide](https://gamefaqs.gamespot.com/nes/578343-doraemon/faqs/48568)
independently records scores, durability, visual labels, and the six-enemy
secret. [StrategyWiki's image set](https://strategywiki.org/wiki/Category:Doraemon_images)
provides another visual reference. Published names alone never select a state:
each confirmed mapping also requires local ROM evidence from metasprites,
properties, placement context, behavior, or the secret table.

`make validate-world1-enemy-identities` checks the 15-state lifecycle join,
metasprite bases, stored health and score codes, the exact direct-enemy roster,
the secret bytes and semantic order, its checker signature, and evidence
provenance. It is part of `make release-check`.
