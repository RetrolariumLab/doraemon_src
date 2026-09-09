# Source 2.0 Draft-History Rewrite

The candidate rewrites unpublished Source 2.0 drafts from local `main` without changing `main` or published references. The original draft tip was `0ebca6543663cbd3f45992ea56805974aa8c6e85`; the first tree-equivalent candidate tip was `cb954bba7f2c99d7f5ce074012c984c3bd656a86`. A direct Git tree comparison between those tips passed before this provenance record was added.

Each candidate commit groups retained files by their final owner. Its author and committer dates use the latest source timestamp represented by that group. Equal timestamps occur where one draft commit was split across several owners; this preserves the original second-level timestamp while keeping both date sequences in parent order. Empty or fully superseded drafts have no candidate commit.

## Retained-reference boundary

The candidate history audit starts after `a992b208ec3ab03b3e4c5100bc83b932e7defcd6` and includes every later candidate commit, introduced blob, and the final tree. Local `main`, remote-tracking references, existing tags, and the original draft branches remain unchanged for owner review.

The published predecessor history retains legacy release metadata that no longer matches the project-owned schema. That published-history cleanup is explicitly deferred for separate owner coordination; it is neither altered nor claimed as candidate evidence by this rewrite.

## Candidate schedule

| Candidate | Scope | Author date | Commit date |
| --- | --- | --- | --- |
| `c5ae4ff` | Define audio request priorities | `2026-09-07T04:33:08+03:00` | `2026-09-07T04:33:08+03:00` |
| `0653c6b` | Pin the supported build toolchain | `2026-09-07T05:39:10+03:00` | `2026-09-07T05:39:10+03:00` |
| `4f7e280` | Group audio evidence around the driver | `2026-09-08T21:26:12+03:00` | `2026-09-08T21:26:12+03:00` |
| `6a25590` | Compose every Studio into one image | `2026-09-08T21:26:12+03:00` | `2026-09-08T21:26:12+03:00` |
| `4662ac0` | Collect shared reconstruction validators | `2026-09-08T21:26:12+03:00` | `2026-09-08T21:26:12+03:00` |
| `88ab381` | Keep generated content outside Git | `2026-09-08T21:26:12+03:00` | `2026-09-08T21:26:12+03:00` |
| `f5e008b` | Exercise both cartridges through runtime scenarios | `2026-09-08T21:26:12+03:00` | `2026-09-08T21:26:12+03:00` |
| `a908cab` | Route project tools through one launcher | `2026-09-08T21:26:12+03:00` | `2026-09-08T21:26:12+03:00` |
| `1dcb6b0` | Complete the Python package boundaries | `2026-09-08T21:26:12+03:00` | `2026-09-08T21:26:12+03:00` |
| `a48e45d` | Give World 1 checks a dedicated package | `2026-09-08T21:26:12+03:00` | `2026-09-08T21:26:12+03:00` |
| `9d0f0a3` | Give World 2 checks a dedicated package | `2026-09-08T21:26:12+03:00` | `2026-09-08T21:26:12+03:00` |
| `ce94a45` | Give every Studio shared workspace services | `2026-09-08T22:00:00+03:00` | `2026-09-08T22:00:00+03:00` |
| `fae9721` | Guard the public project interface | `2026-09-08T22:14:24+03:00` | `2026-09-08T22:14:24+03:00` |
| `338169b` | File debugger evidence under its owner | `2026-09-08T22:18:46+03:00` | `2026-09-08T22:18:46+03:00` |
| `a8f3244` | Describe both official cartridge profiles | `2026-09-08T22:18:46+03:00` | `2026-09-08T22:18:46+03:00` |
| `f9bc265` | Make cartridge graphics directly editable | `2026-09-08T22:22:29+03:00` | `2026-09-08T22:22:29+03:00` |
| `1897add` | Put gameplay objects on editable maps | `2026-09-08T22:57:06+03:00` | `2026-09-08T22:57:06+03:00` |
| `4a8296a` | Seat audio manifests beside Sound Studio | `2026-09-08T23:04:10+03:00` | `2026-09-08T23:04:10+03:00` |
| `c1b8666` | Document the complete Studio workflow | `2026-09-08T23:04:10+03:00` | `2026-09-08T23:04:10+03:00` |
| `ba39ed6` | Bring native music into Sound Studio | `2026-09-08T23:04:10+03:00` | `2026-09-08T23:04:10+03:00` |
| `fe42cf8` | Expose shell text through a fixed-size editor | `2026-09-08T23:09:40+03:00` | `2026-09-08T23:09:40+03:00` |
| `a2b4eeb` | File shell text under its editor owner | `2026-09-08T23:09:40+03:00` | `2026-09-08T23:09:40+03:00` |
| `eb48ef7` | Centralize authoring profiles and world data | `2026-09-08T23:12:10+03:00` | `2026-09-08T23:12:10+03:00` |
| `7a02e2d` | Separate build orchestration from validation | `2026-09-08T23:29:59+03:00` | `2026-09-08T23:29:59+03:00` |
| `ccb1c46` | Share source across cartridge revisions | `2026-09-08T23:29:59+03:00` | `2026-09-08T23:29:59+03:00` |
| `99bad7a` | Isolate reproducible analysis workflows | `2026-09-08T23:29:59+03:00` | `2026-09-08T23:29:59+03:00` |
| `4e26bc8` | Gather World 1 authoring records | `2026-09-08T23:35:05+03:00` | `2026-09-08T23:35:05+03:00` |
| `af4e642` | Explain the editable World 1 systems | `2026-09-08T23:35:05+03:00` | `2026-09-08T23:35:05+03:00` |
| `f39c186` | Collect World 1 runtime evidence | `2026-09-08T23:35:05+03:00` | `2026-09-08T23:35:05+03:00` |
| `96decf8` | Group the cave editing formats | `2026-09-08T23:39:05+03:00` | `2026-09-08T23:39:05+03:00` |
| `f7f04d6` | Collect World 2 runtime evidence | `2026-09-08T23:39:05+03:00` | `2026-09-08T23:39:05+03:00` |
| `166fb84` | Give underwater authoring a clear home | `2026-09-08T23:43:23+03:00` | `2026-09-08T23:43:23+03:00` |
| `430598f` | Explain underwater rooms and entities | `2026-09-08T23:43:23+03:00` | `2026-09-08T23:43:23+03:00` |
| `e2f7580` | Collect World 3 runtime evidence | `2026-09-08T23:43:23+03:00` | `2026-09-08T23:43:23+03:00` |
| `4fb47df` | Collect cross-bank runtime evidence | `2026-09-08T23:47:53+03:00` | `2026-09-08T23:47:53+03:00` |
| `4c672b5` | Refresh authoring and runtime coverage | `2026-09-08T23:47:53+03:00` | `2026-09-08T23:47:53+03:00` |
| `7203395` | Publish a modular Make interface | `2026-09-08T23:47:53+03:00` | `2026-09-08T23:47:53+03:00` |
| `e117192` | Focus the README on supported workflows | `2026-09-08T23:47:53+03:00` | `2026-09-08T23:47:53+03:00` |
| `cabd8b8` | Unify release evidence checks | `2026-09-08T23:47:53+03:00` | `2026-09-08T23:47:53+03:00` |
| `95ce4b3` | Consolidate the canonical source map | `2026-09-08T23:47:53+03:00` | `2026-09-08T23:47:53+03:00` |
| `bcc4357` | Align technical documentation with the new layout | `2026-09-08T23:47:53+03:00` | `2026-09-08T23:47:53+03:00` |
| `be09e11` | Explain cave routes and shooter data | `2026-09-08T23:47:53+03:00` | `2026-09-08T23:47:53+03:00` |
| `268ebdd` | Give World 3 checks a dedicated package | `2026-09-08T23:57:59+03:00` | `2026-09-08T23:57:59+03:00` |
| `11d67d2` | Build a lossless visual level workflow | `2026-09-09T00:06:49+03:00` | `2026-09-09T00:06:49+03:00` |
| `cb954bb` | Keep release metadata project-owned | `2026-09-09T01:47:01+03:00` | `2026-09-09T01:47:01+03:00` |

## Old-to-new map

The table assigns each retained draft to the candidate owner sharing the largest number of changed paths. Cross-cutting drafts can also contribute to other owner commits; the primary attribution keeps the review map one-to-one while the tree comparison proves the complete result.

| Candidate | Scope | Primary source drafts | Reason |
| --- | --- | --- | --- |
| `c5ae4ff` | Define audio request priorities | `772a401` | Regrouped by final file ownership and responsibility. |
| `0653c6b` | Pin the supported build toolchain | `2713a53` | Regrouped by final file ownership and responsibility. |
| `4f7e280` | Group audio evidence around the driver | `f10c742` | Regrouped by final file ownership and responsibility. |
| `6a25590` | Compose every Studio into one image | `962ba1f` | Regrouped by final file ownership and responsibility. |
| `4662ac0` | Collect shared reconstruction validators | `6f57da9` | Regrouped by final file ownership and responsibility. |
| `88ab381` | Keep generated content outside Git | `4d1f1b8` | Regrouped by final file ownership and responsibility. |
| `f5e008b` | Exercise both cartridges through runtime scenarios | `194728d` | Regrouped by final file ownership and responsibility. |
| `a908cab` | Route project tools through one launcher | `f10c742` | Split from a cross-cutting draft and regrouped under this final owner. |
| `1dcb6b0` | Complete the Python package boundaries | `6f57da9` | Split from a cross-cutting draft and regrouped under this final owner. |
| `a48e45d` | Give World 1 checks a dedicated package | `f10c742` | Split from a cross-cutting draft and regrouped under this final owner. |
| `9d0f0a3` | Give World 2 checks a dedicated package | `f10c742` | Split from a cross-cutting draft and regrouped under this final owner. |
| `ce94a45` | Give every Studio shared workspace services | `41cd184` | Regrouped by final file ownership and responsibility. |
| `fae9721` | Guard the public project interface | `a1c6511` | Regrouped by final file ownership and responsibility. |
| `338169b` | File debugger evidence under its owner | `ac90925` | Regrouped by final file ownership and responsibility. |
| `a8f3244` | Describe both official cartridge profiles | `f5e1285`, `d4b53bd` | Regrouped by final file ownership and responsibility. |
| `f9bc265` | Make cartridge graphics directly editable | `ccdc380`, `fde7ba2` | Regrouped by final file ownership and responsibility. |
| `1897add` | Put gameplay objects on editable maps | `306b07c` | Regrouped by final file ownership and responsibility. |
| `4a8296a` | Seat audio manifests beside Sound Studio | `3b479a3` | Regrouped by final file ownership and responsibility. |
| `c1b8666` | Document the complete Studio workflow | `d17e161` | Regrouped by final file ownership and responsibility. |
| `ba39ed6` | Bring native music into Sound Studio | `09bc42f`, `e74d30a`, `a16ecb3`, `64be0df`, `a4fdb54`, `6adfbfd` | Regrouped by final file ownership and responsibility. |
| `fe42cf8` | Expose shell text through a fixed-size editor | `932b9da` | Regrouped by final file ownership and responsibility. |
| `a2b4eeb` | File shell text under its editor owner | `a91b2d0` | Regrouped by final file ownership and responsibility. |
| `eb48ef7` | Centralize authoring profiles and world data | `745f67c` | Regrouped by final file ownership and responsibility. |
| `7a02e2d` | Separate build orchestration from validation | `8a6b3c8`, `fca96b1` | Regrouped by final file ownership and responsibility. |
| `ccb1c46` | Share source across cartridge revisions | `d86e2d3` | Regrouped by final file ownership and responsibility. |
| `99bad7a` | Isolate reproducible analysis workflows | `051c83f` | Regrouped by final file ownership and responsibility. |
| `4e26bc8` | Gather World 1 authoring records | `732abae` | Regrouped by final file ownership and responsibility. |
| `af4e642` | Explain the editable World 1 systems | `b5d545a` | Regrouped by final file ownership and responsibility. |
| `f39c186` | Collect World 1 runtime evidence | `ebc38c1` | Regrouped by final file ownership and responsibility. |
| `96decf8` | Group the cave editing formats | `66f9c6d` | Regrouped by final file ownership and responsibility. |
| `f7f04d6` | Collect World 2 runtime evidence | `a377397` | Regrouped by final file ownership and responsibility. |
| `166fb84` | Give underwater authoring a clear home | `d348a6b` | Regrouped by final file ownership and responsibility. |
| `430598f` | Explain underwater rooms and entities | `32f983c` | Split from a cross-cutting draft and regrouped under this final owner. |
| `e2f7580` | Collect World 3 runtime evidence | `32f983c` | Regrouped by final file ownership and responsibility. |
| `4fb47df` | Collect cross-bank runtime evidence | `4914f9f` | Regrouped by final file ownership and responsibility. |
| `4c672b5` | Refresh authoring and runtime coverage | `4c724ec` | Regrouped by final file ownership and responsibility. |
| `7203395` | Publish a modular Make interface | `916ea9d`, `ebcc3bc` | Regrouped by final file ownership and responsibility. |
| `e117192` | Focus the README on supported workflows | `9c9d436` | Regrouped by final file ownership and responsibility. |
| `cabd8b8` | Unify release evidence checks | `7d44229` | Regrouped by final file ownership and responsibility. |
| `95ce4b3` | Consolidate the canonical source map | `d86e2d3` | Split from a cross-cutting draft and regrouped under this final owner. |
| `bcc4357` | Align technical documentation with the new layout | `d86e2d3` | Split from a cross-cutting draft and regrouped under this final owner. |
| `be09e11` | Explain cave routes and shooter data | `a377397` | Split from a cross-cutting draft and regrouped under this final owner. |
| `268ebdd` | Give World 3 checks a dedicated package | `3fce54f` | Regrouped by final file ownership and responsibility. |
| `11d67d2` | Build a lossless visual level workflow | `50b49c8`, `a6ed987`, `33a5343`, `97d1d5b`, `7dc0b28`, `5ce9c62`, `e701ef7`, `006f7c4`, `1edb400`, `4f9efc6`, `9ced528`, `ada16b3`, `014f477`, `f6b5a2c`, `4b83b30`, `99a01ca`, `5f2877d` | Regrouped by final file ownership and responsibility. |
| `cb954bb` | Keep release metadata project-owned | `0ebca65`, `227b575`, `e8ea5bd`, `de786a6`, `4ab16f3`, `22a45bc`, `9455b9b`, `390bb2d`, `7a7415f`, `2da9f31`, `0af025d`, `3b12d79`, `d66b830`, `713615c`, `8a124fe`, `99eaf16`, `0bc865a`, `b9bca29`, `3e975be`, `bc2266f`, `febb05e`, `71636dd`, `d876647`, `4b2f634`, `1a15574`, `43eb02e` | Regrouped by final file ownership and responsibility. |

## Post-rewrite verification updates

Commit `d8d3f93` closes the formatter-exclusion and public-command orchestration review gaps without replacing an earlier draft. Later generated-state verification re-ran `make split` against the 163,856-byte original reference image with SHA-256 `6ed579c9c98a1f2db52fd3d2488a491953073e8ace1e3c1dc5884669cecca274` and decoded all 24 ROM-owned authoring documents. Every tracked document matched the fresh canonical decode.

The only data delta was local and ignored: `content/workspace/original/levels/world1.json` and `world3.json` each contained 14 edited rows from level testing. The verified workspace root was removed and both profile workspaces were recreated through `make content-init`; all six regenerated level documents then matched their canonical SHA-256 values. A clean rebuild produced 163,856 byte-identical ROM bytes for both `original` and `rev_a`. This follow-up records new verification work and therefore has no old-draft mapping.

The workstation-interaction follow-up adds new validation work rather than replacing an earlier draft. It retains the two-profile headless checks and adds a disposable Windows run that opens all five real Studio windows, drives each supported save/build/preview action, and verifies cancelled and confirmed unsaved-close behavior. The isolated run does not modify the restored canonical profile workspaces.

## Superseded drafts

These drafts have no retained tree effect. They were empty release markers or changes fully superseded before the original draft tip: `84752ce`, `df16293`, `9368eb4`, `0cce7e9`, `a5ec9b9`, `277ef42`, `54ad72a`, `fc52036`, `a02dd6c`, `ec76a34`, `55c97cc`, `68260a4`, `68d07a8`.
