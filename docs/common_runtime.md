# Common reset, NMI, and bank gateways

All four PRG banks contain the same 473 bytes at `$8098-$8270`. This is the
interrupt-safe runtime copied into every GNROM window: reset, vblank waits,
rendering transitions, OAM clearing, NMI/controller polling, mapper selection,
and score handling. `config/common_runtime.json` records the exact SHA-1 of the
range and ten routine boundaries.

The mapper API separates CHR and PRG selection. `SelectChrBank` converts its
low two input bits to mapper bits 2-3 and falls through to `SelectPrgBank`;
`SelectPrgBank` preserves those CHR bits, waits outside vblank, and calls the
bus-conflict-safe ROM write at `$81BB`.

The following four three-byte jumps are bank-local rather than identical.
Their source labels deliberately stay bank/address-role based because the
gateway can change the visible bank immediately before jumping to the same CPU
address:

| Address | Bank 0 | Bank 1 | Bank 2 | Bank 3 |
| ---: | --- | --- | --- | --- |
| `$8271` | World 1 entry | World 2 entry | World 3 entry | shell entry |
| `$8274` | World 1 NMI work | World 2 NMI work | World 3 NMI work | shell NMI work |
| `$8277` | World 1 demo | World 2 demo | World 3 demo | status screen |
| `$827A` | World 1 audio | World 2 audio | World 3 audio | shell audio |

The NMI calls `$8274`, polls both controllers and the Famicom microphone edge,
then calls `$827A`. Every target now has a semantic source symbol: chapter or
shell main, NMI frame services, demo/status entry, and audio frame service.
`make validate-common-runtime` verifies all copied bytes, the ten shared
service boundaries, 40 bank-qualified service symbols, and both sides of all
16 bank-local jumps.
