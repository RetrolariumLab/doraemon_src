# World 2 Runtime

This chapter joins the player, projectile, sprite, screen, stage, and enemy contracts that cooperate in the World 2 gameplay loop. Machine-readable routine ranges and state relationships remain authoritative in `config/reconstruction/world2/` and `config/authoring/world2/`.

## Contents

- Enemy lifecycle, identities, and state records
- Frame and stage control
- Player and projectile systems
- Screen and sprite services

## World 2 enemy handlers

World 2 dispatches its enemies by runtime state through two RTS-minus-one
tables in PRG bank 1. `config/reconstruction/world2/world2_enemy_handlers.json` records every active
state-to-handler edge and gives each target a behavior-derived structural name.
It deliberately does not assign character identities that sprite or external
evidence has not established.

### Lifecycle domains

States `$01-$0F` are created directly by normalized `$D0-$DE` screen tokens.
States `$10-$14` occur only through internal behavior and collision
transitions. State zero is inactive and has no render slot.

| Domain | States | Count |
| --- | --- | ---: |
| direct spawn | `$01-$0F` | 15 |
| internal | `$10-$14` | 5 |

The 20 active states resolve to 19 unique update targets and 18 unique render
targets. The sharing is meaningful:

- states `$03` and `$0C` use the same axis-selected chase update;
- states `$08` and `$0F` use the same reflected render path;
- states `$0E` and `$10` use the same phase-selected render path;
- state `$11` sends both update and render to the same one-byte `RTS`;
- state `$09` also has a one-byte invisible render path;
- update slot zero points at `$A0B9`, which is active render code for state
  `$14`; it is retained as an exact shared-storage edge, not an active update.

### Validation

`make validate-world2-enemy-handlers` checks the lifecycle partition against
`config/authoring/world2/world2_enemy_states.json`, both exact dispatch
mappings and their ROM
bytes against `config/reconstruction/common/object_dispatch.json`, and every handler symbol against
`config/reconstruction/symbols.json`. The target is part of `make release-check`.

The original structural names described only observable motion, timing,
projectile, and rendering behavior. The canonical identities are now resolved
by joining this graph with metasprites, property tables, boss control flow, and
published Japanese names; see `docs/world2_runtime.md`.

## World 2 enemy identities

World 2 uses states `$01-$0F` for enemies embedded in compressed screen
streams and states `$10-$14` for boss encounters and their helpers. Joining the
property tables, handler graph, rendered CHR, boss controller, and published
Japanese roster resolves every state except that state `$10` has no standalone
published name: it is the Jura-like projectile emitted by Ororon Iwa.

### State catalog

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

### Boss controller

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

### Scores and the Takkon rule

The reward table does not store binary point values. The high nibble selects
one of seven decimal score digits and the low nibble is added to it; the visible
point value is therefore `low * 10^(6-high)`. For example, `$51`, `$43`, and
`$21` encode 10, 300, and 10,000 points. The carry loop beginning at `$81C9`
is included in the validation contract.

At `$99A7`, the defeat path compares the state with `$02`, increments a
dedicated streak byte, and creates an item after the fourth consecutive match.
Any other defeated state clears the streak. This state-specific rule is strong
independent evidence for Takkon's state assignment.

### Evidence policy and validation

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

## World 2 enemy states

World 2 embeds enemy spawn tokens in its compressed screen streams. Although
the decoder reserves `$D0-$EE`, the canonical physical token pool uses only
`$D0-$DE`.

### Token normalization

Spawned tokens are initially stored unchanged, so their high bit keeps them on
the delayed materialization path. At `$9A32`, the runtime converts a token with:

```text
state = ((token & $1F) ^ $10) + 1
```

This maps `$D0-$DE` one-to-one onto states `$01-$0F`. The shared compressed pool
contains 685 physical spawn bytes; overlapping selector views encounter them
738 times. `config/authoring/world2/world2_enemy_states.json` fixes the
frequency of every token.

### Runtime domain

The ordinary enemy domain is `$01-$14`. States `$01-$0F` come directly from
screen tokens, while `$10-$14` are internal states reached by behavior and
collision transitions. State zero is the inactive pool value.

Rendering has 20 reachable RTS-minus-one slots for `$01-$14`. Updating has 21
slots for `$00-$14`; its state-zero entry supplies the inactive path. The render
view at `$A54A-$A571` and update view at `$A570-$A599` share two bytes. The final
update byte at `$A599` is also the unused state-zero entry of the reward table.

### State properties

| Table | Range | Entries | Runtime use |
| --- | --- | ---: | --- |
| attack period | `$A4FD-$A511` | 21 | threshold for spawning an enemy projectile |
| damage threshold | `$A511-$A525` | 21 | hits required before defeat handling |
| score reward code | `$A599-$A5AD` | 21 | code passed to the score updater on defeat |

The attack-period and damage tables share `$A511`. All three use a state-zero
entry even though active collision/update paths index nonzero states.

`data/world2/enemy_states.json` joins the three columns into 21 row-oriented
state records. Its encoder writes 62 unique ROM bytes: the three 21-byte views
minus their shared `$A511` byte. Matching overlap values are required; a
conflicting edit is rejected. The reward state-zero byte at `$A599` remains
explicit because it is also the final byte of the update dispatch table.

Run `make validate-world2-enemy-states` to verify token frequencies in the
lossless screen authoring data, the normalization machine-code signature,
runtime-state partition, property bytes and CRCs, both dispatch tables, and all
three shared-storage relationships. The same target round-trips the editable
state records. `config/reconstruction/world2/world2_enemy_handlers.json` additionally validates all
20 state-to-update and state-to-render edges and assigns behavior-derived
structural names; see `docs/world2_runtime.md`. Individual enemy
identities remain unnamed until sprite and behavior evidence supports them.

## World 2 final routines

`config/reconstruction/world2/world2_final_routines.json` fixes the last thirteen address-named
routine entries in Bank 1. It covers 796 executable bytes, 19 direct calls or
tail jumps, and nineteen Bank 1-private RAM symbols covering 26 bytes.

The contract joins four remaining areas:

- packed pending-enemy activation and collision against all player attacks;
- world-scroll translation and rendering of enemy projectiles;
- enemy metasprite dispatch, quadrant composition, and OAM emission;
- terminal chapter completion plus the health/lives/score HUD.

The scroll direction and its vertical/horizontal transition delays are now
named from the NMI screen-service paths and the matching enemy/projectile
translation gates. The HUD's eight-byte health-tile workspace and the enemy
metasprite/projectile-aim workspaces are also explicit. Scratch locations with
unrelated lifetimes remain numeric.

After this pass Bank 1 has no `Bank1_Func_XXXX` definitions. Local branch
labels remain address-qualified unless their meaning materially clarifies a
routine contract.

Run:

```text
make validate-world2-final-routines
```

## World 2 frame core

`config/reconstruction/world2/world2_frame_core.json` fixes fifteen routines at the center of the
World 2 frame and stage lifecycle. The slice covers the wait/render path,
chapter exit, boss-to-stage advance, transition delay, sprite/metatile clears,
audio reset, initial health lookup, initial stage upload, delayed scrolling and
music activation, and the microphone-item attack.

Two entry points intentionally fall through: the wait wrapper enters the full
render pass, and the completion-effect prefix enters the shared transition
delay. Their exact non-overlapping prefixes are recorded separately.

Ten new Bank 1 RAM names replace raw addresses in the main path: scrolling and
sprite-flicker state, player damage/death state, stage-start and shared sequence
timers, chapter/stage completion flags, and the microphone hold/one-shot pair.
The contract pins 370 executable bytes and all 23 direct JSR/JMP callers.

Run:

```text
make validate-world2-frame-core
```

## World 2 player systems

`config/reconstruction/world2/world2_player_systems.json` fixes thirteen routines covering player
movement and firing, the position-history ring, and all seven fixed inventory
slot update paths. The inventory routines distinguish the shared slots 2-6
state machine from the history-following slot 0 and slot 1 paths and their
detached-state motion.

Nine Bank 1 RAM names cover movement speed, history position, fire repeat and
companion phases, projectile direction, inventory-drop hit count, the player
damage effect, and the fire-press counter. The contract pins 750 executable
bytes and all thirteen direct callers.

Run:

```text
make validate-world2-player-systems
```

## World 2 projectile runtime

`config/reconstruction/world2/world2_projectile_runtime.json` fixes the World 2 player-projectile
motion helpers, player hazard scan, and both inventory-owned attacks. It pins
17 routines, 768 executable bytes, 23 direct calls or tail jumps, and nine
Bank 1-private zero-page fields.

Inventory slot 0 emits one independently animated projectile from the
companion position. Inventory slot 2 owns a separate axis-aligned attack whose
phase controls both reach and multi-sprite rendering. The normal player weapon
uses seven parallel projectile records and four two-axis composition helpers.

The hazard scan deliberately records a contact request rather than applying
damage itself. The player update consumes that request later, after inventory
and damage-effect state have been updated.

Run:

```text
make validate-world2-projectile-runtime
```

## World 2 screen core

`config/reconstruction/world2/world2_screen_core.json` fixes the World 2 NMI PPU commit, RTS-based
screen-service dispatch, transition-row setup, PPU-address helper, and initial
nametable clear. It pins 115 executable bytes, nine direct callers, and the
World 2 scroll pair plus scrolling-enable state.

Address `$8286` is also named as a post-switch World 3 transition entry. In
physical Bank 1 it overlaps the immediate operand inside the NMI PPU commit;
after the mapper write, execution at that CPU address resolves in Bank 3. It is
therefore gateway evidence, not a second overlapping Bank 1 routine contract.

Run:

```text
make validate-world2-screen-core
```

## World 2 sprite runtime

`config/reconstruction/world2/world2_sprite_runtime.json` fixes the World 2 player and inventory
renderer from the slot 2 attack-segment helpers through the final OAM writer.
It pins 27 routines, 864 executable bytes, 54 direct calls or tail jumps, and
nine Bank 1-private RAM symbols covering 103 bytes.

The renderer has three layers:

- player projectiles and both inventory-owned attacks use fixed OAM regions;
- the player, damage effect, and all seven inventory slots are composed from
  two-sprite rows or fixed sprite layouts;
- every path converges on a four-byte Y/tile/attributes/X staging record and
  the OAM writer at `$96C8`.

Inventory slots 0 and 1 read the 48-entry player-position history ring when
active, at delays of 47 and 23 samples respectively. The renderer writes the
resolved historical positions back into each slot before composing its
metasprite. Multi-purpose arithmetic and collision scratch bytes remain
numeric because their lifetime is not a stable renderer ABI.

Run:

```text
make validate-world2-sprite-runtime
```
