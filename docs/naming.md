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
