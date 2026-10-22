# Naming

Names use `UpperCamelCase`; hardware and RAM aliases describe roles, while
fallback labels carry their bank and the address they had in the original.

```text
Bank2_Func_AFED
Bank1_Label_88A4
World3_Map
Bank3_WriteMapper
```

The bank prefix is mandatory for code because all four physical banks share CPU
addresses `$8000-$FFFF`. A semantic name needs evidence. Unknown routines keep
fallback names until a caller, consumer, data format, or runtime trace
establishes a role. The hex in a fallback label is history, not an address: once
code moves it no longer matches. Rename a fallback label (or make it a `@local`
label) when you work on its routine.

RAM names may cover all banks or one world's bank, allowing chapter-local
overlays at the same RAM address without pretending they share a role
(`src/memory/ram.inc`: `World1...`, `World2...`, `World3...`, `Shell...`). Low
absolute addresses keep the ca65 `a:` size override. A label inside an
instruction is an offset symbol, `Name = * + 1  ; overlapping entry $XXXX`.
