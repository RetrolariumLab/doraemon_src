# Naming

Names use `UpperCamelCase`; hardware and RAM aliases describe roles, while
generated fallback labels retain bank and address.

```text
Bank2_Func_AFED
Bank1_Label_88A4
World3_Map
Bank3_WriteMapper
```

The bank prefix is mandatory for code because all four physical banks share CPU
addresses `$8000-$FFFF`. A semantic name enters `config/reconstruction/symbols.json` only with
an evidence field. Unknown routines keep generated names until a caller,
consumer, data format, or runtime trace establishes a role.

The same registry contains `memory_symbols`. These names may cover all banks or
an explicit bank subset, allowing chapter-local overlays at the same RAM address
without pretending they share a role. The generator substitutes only direct
memory operands; immediate values remain numeric. Low absolute addresses retain
the ca65 `a:` size override when symbolized. An optional `size` expands a proven
array into ca65 base-plus-offset expressions and overlapping ranges are rejected
within each bank.

`config/reconstruction/label_renames.json` is the sole old-to-new label
registry. Its baseline is the accepted preservation predecessor. Source 2.0
does not rename any inherited global or memory symbol at the same bank and
address, so the current mapping is intentionally empty; newly proven symbols
are additions to `symbols.json`, not renames. The release audit compares the
two registries and rejects an omitted, invented, duplicated, or stale mapping.
