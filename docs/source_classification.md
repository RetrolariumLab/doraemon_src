# PRG source classification

`config/source_classification.json` is the byte-level ownership contract for
the four canonical 32 KiB PRG banks. It is evaluated from the current ca65
listing rather than raw Ghidra facts, so copied common code and every source
directive are measured exactly as assembled.

The audit distinguishes:

- `instruction`: bytes emitted by ca65 instruction statements;
- `base-typed`: ranges already forced to data by `prg_data_ranges.txt`;
- `typed-data`: additional fixed tables tied to semantic contracts;
- `encoded-code`: understood instruction bytes intentionally emitted through
  `.byte` because of layout or overlap constraints;
- `padding`: verified constant fill;
- `registered-unknown`: exact ranges whose deeper role is not claimed.

Current ownership is complete:

| Class | Bytes |
| --- | ---: |
| Instructions | 47,789 |
| Base typed ranges | 66,180 |
| Supplemental typed data | 7,469 |
| Encoded code | 24 |
| Padding | 3,910 |
| Registered unknown | 5,700 |
| Total PRG | 131,072 |

The 5,700 unknown bytes consist of 3,701 audio-adjacent bytes under
`AUDIO-002` and 1,999 inline/dormant bytes under `SOURCE-BYTES-001`. This is
a classification boundary, not a claim that those bytes are irrelevant.

Run:

```text
make validate-source-classification
```

The validator rebuild dependency produces a fresh listing, rejects overlap,
rejects any directive byte without an owner, rejects classifications placed on
instruction bytes, verifies evidence and unknown registry links, checks both
padding ranges against the PRG asset, and pins per-bank metrics.
