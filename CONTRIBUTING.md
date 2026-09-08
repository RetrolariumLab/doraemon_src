# Contributing

Keep every change evidence-backed and preserve the matching build.

## Source and naming

1. Use `UpperCamelCase` symbols and bank-qualified names whenever the same CPU
   address can identify different bytes in another GNROM bank.
2. Record evidence for semantic labels in `config/reconstruction/symbols.json` and update the
   owning documentation.
3. Keep uncertain bytes as data. Do not promote them to code only because a
   linear sweep happens to decode them.
4. Preserve address order inside each `src/banks/bank_N.asm` file.
5. Follow the formatting enforced by `make lint`; `make format` may only make
   deterministic safe formatting changes and runs lint afterward.

Generated bank sources are changed through `make disassemble`; change the
symbol registry, typed ranges, or analysis pipeline instead of hand-editing
machine-generated formatting.

## Tests and gates

- Run `make quality-check` for documentation or isolated tooling changes.
- Run `make check` for source, symbol, or data-boundary changes.
- Run `make source-check` for changes to release contracts or evidence.
- Only a clean committed `tag-ready` tree may run `make source-1-audit` as a
  pre-tag release gate.

## Private data

Do not commit ROMs, extracted PRG/CHR files, emulator states, runtime captures,
screenshots, or build output. Original inputs belong only in ignored paths and
must match `assets/manifest.json`. Do not add personal filenames to the shared
`.gitignore` unless the pattern protects the whole project.

## Commit messages

Write an English, result-oriented title without a trailing period. After one
blank line, write two or three substantive paragraphs: what changed, which
boundary it affects, why the decision was made, and which evidence or checks
preserve compatibility. Keep one coherent architectural or release task per
commit.

Every commit prepared with Codex ends, after a blank line, with exactly:

```text
Co-Authored-By: Codex <noreply@openai.com>
```

The final release commit is titled `Complete Source Reconstruction X.Y` only
after the complete pre-tag gate passes. Its body covers the full delta since the
predecessor, identity/runtime evidence, aggregate result, and included/excluded
scope. Never amend or rewrite published commits or tags. Draft-history rewrite
requires the separate owner-approval process documented in
`docs/release_contract.md`.
