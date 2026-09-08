# World 1 map PPU streaming

World 1 converts newly exposed map edges into two fixed packet families. Camera
motion builds the packet in CPU RAM; `World1_DrainMapPpuUpdates` consumes it
during NMI, or synchronously while the initial viewport is prefilled with
rendering disabled.

## Packet geometry

| Edge | Queue code | Tile bytes | PPU increment | Attribute bytes |
| --- | ---: | ---: | ---: | ---: |
| vertical column | 1 | 30 | 32 | 8 |
| horizontal row | 2 | 33 | 1 | 9 |

Each packet family has a flags byte. Bit 0 marks its tile address/data as
pending, and bit 1 marks its attribute address/data. Producers can therefore
prepare the two halves on different 8-pixel camera phases. The consumer clears
only the half it writes and preserves the other bit.

The 30-tile column uses `PPUCTRL` increment 32. If it crosses the vertical
nametable boundary, the consumer changes the destination nametable and
continues the remaining bytes. Its eight attributes are written one at a time
with an address stride of 8. The 33-tile row and nine-byte attribute row use
increment 1 and split at horizontal nametable boundaries.

## RAM layout

| Range | Symbol | Role |
| --- | --- | --- |
| `$0230` | `World1ColumnUpdateFlags` | column tile/attribute pending bits |
| `$0231-$0232` | `World1ColumnTilePpuAddress` | little-endian tile destination |
| `$0233-$0250` | `World1ColumnTileData` | 30 decoded CHR-tile indexes |
| `$0253-$0254` | `World1ColumnAttributePpuAddress` | little-endian attribute destination |
| `$0255-$025C` | `World1ColumnAttributeData` | 8 packed attribute bytes |
| `$025E` | `World1ColumnAddressScratch` | column wrap-count calculation |
| `$025F` | `World1EdgeUpdateQueue` | two packed 4-bit edge codes |
| `$0260` | `World1RowUpdateFlags` | row tile/attribute pending bits |
| `$0261-$0262` | `World1RowTilePpuAddress` | little-endian tile destination |
| `$0263-$0283` | `World1RowTileData` | 33 decoded CHR-tile indexes |
| `$0284-$0285` | `World1RowAttributePpuAddress` | little-endian attribute destination |
| `$0286-$028E` | `World1RowAttributeData` | 9 packed attribute bytes |

`$0251-$0252` and `$025D` are gaps and are not claimed by the packet ABI.

## Queue and routines

`World1EdgeUpdateQueue` holds at most two nibbles. A camera edge shifts the old
low nibble into the high nibble and writes 1 for a column or 2 for a row. The
consumer removes one code and dispatches to the matching packet family.

The six validated entry points are:

- `World1_BuildColumnTileUpdate` at `$A4C6`;
- `World1_BuildColumnAttributeUpdate` at `$A50A`;
- `World1_BuildRowTileUpdate` at `$A5CF`;
- `World1_BuildRowAttributeUpdate` at `$A60B`;
- `World1_PrefillMapViewport` at `$A7DB`;
- `World1_DrainMapPpuUpdates` at `$A87E`.

`config/reconstruction/world1/world1_ppu_streaming.json` pins all 1,013 routine bytes, the complete
20-call graph, both packet layouts, queue capacity, and 92 owned RAM bytes.
Run the focused contract with:

```text
make validate-world1-ppu-streaming
```
