# Contributing

The project reconstructs the Japanese release; it must keep building byte for
byte. For each change:

```bash
make format
make test
```

Data is edited in Retrolarium Studio
([`docs/retrolarium.md`](docs/retrolarium.md)).

## Source and naming

1. Use `UpperCamelCase` symbols and bank-qualified names whenever the same CPU
   address can identify different bytes in another GNROM bank
   ([`docs/naming.md`](docs/naming.md)).
2. Give semantic names only with evidence, and update the owning document.
3. Keep uncertain bytes as data. Do not promote them to code only because a
   linear sweep happens to decode them.
4. Preserve address order inside each bank's include map in `src/banks/`.
5. Write ROM addresses as labels, never as numbers: code that names `$9004`
   breaks as soon as anything before it moves.

## Private data

Do not commit ROMs, extracted PRG/CHR files, emulator states, screenshots, or
build output. Original inputs belong only in ignored paths and must match
`assets/manifest.json`.

## Commit messages

Write an English, result-oriented title without a trailing period. After one
blank line, write two or three paragraphs: what changed, which boundary it
affects, and which checks passed. Keep one coherent task per commit.

`make hooks` installs Git hooks that check commits and pushes for words that
must not be published and run `make lint` before each commit.
