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
addresses `$8000-$FFFF`. A semantic name enters `config/symbols.json` only with
an evidence field. Unknown routines keep generated names until a caller,
consumer, data format, or runtime trace establishes a role.

The same registry contains `memory_symbols`. These names may cover all banks or
an explicit bank subset, allowing chapter-local overlays at the same RAM address
without pretending they share a role. The generator substitutes only direct
memory operands; immediate values remain numeric. Low absolute addresses retain
the ca65 `a:` size override when symbolized. An optional `size` expands a proven
array into ca65 base-plus-offset expressions and overlapping ranges are rejected
within each bank.
