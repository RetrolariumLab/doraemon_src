# World 3 object catalog

World 3's static object data uses two independent structure-of-arrays layouts
in PRG bank 2. The lossless authoring file
`data/world3/object_catalog.json` presents both as row-oriented records while
preserving their exact physical addresses.

## Persistent registry

The 65 bytes at `$D96B-$D9AB` are five consecutive thirteen-byte columns:

| Column | ROM range | Record field |
| --- | --- | --- |
| room | `$D96B-$D977` | owning room ID |
| type | `$D978-$D984` | initial persistent type |
| X | `$D985-$D991` | saved horizontal position |
| Y | `$D992-$D99E` | saved vertical position |
| state | `$D99F-$D9AB` | initial persistence/materialization state |

The authoring encoder transposes thirteen records back into these columns. It
does not apply the runtime shuffles: the JSON represents the canonical initial
ROM order, while `config/authoring/world3/world3_object_data.json` independently validates the
two shuffle multisets and fixed final slot.

## Entity type properties

Each of the 32 records has five byte-valued properties. Encoding transposes the
records into the contiguous property columns at `$8EB5-$8F54`:

| Property | ROM range |
| --- | --- |
| hit points | `$8EB5-$8ED4` |
| base metasprite | `$8ED5-$8EF4` |
| render flags | `$8EF5-$8F14` |
| contact damage | `$8F15-$8F34` |
| score reward code | `$8F35-$8F54` |

The catalog covers 225 unique ROM bytes: 65 registry bytes and 160 property
bytes. Behavior scripts remain in `data/world3/behavior_streams.json`; dispatch
pointers and lifecycle domains remain independently checked by the structural
manifests.

## Commands

`make validate-world3-object-catalog` verifies the manifests and lossless JSON
against the canonical PRG. `scripts/validation/world3/world3_object_catalog.py decode` regenerates
the JSON, while `encode` applies edited catalog regions to a supplied base PRG
without changing unrelated bytes.
