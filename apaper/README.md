# Q1 Grover Oracle Research Workspace

Keep the field map, individual-paper reading materials, and later cross-paper synthesis together in `apaper/`. Each project covers one research direction, so there is no topic subdirectory.

## Landscape

- [Evolution graph, route comparisons, and reading recommendations](landscape/report.md)
- [Paper identities, versions, and evidence](landscape/papers.json)
- [Verified bibliography](landscape/references.bib)

The map contains 20 core papers and five routes, searched on 2026-09-27 with preliminary coverage. Its evidence-reading levels describe source inspection, not the user's understanding.

## Paper reading

Interactive reading records cover P01/G01, P02/G02, and P03/G03. P03 remains the landscape's recommended first reproduction baseline. Preserve P01–P20 and the G-series aliases already recorded in the map.

Create `papers/<paper-id>/` when reading begins. Keep paper identity, versions, routes, key evidence, and the reading-record link in the shared [paper registry](landscape/papers.json). Each paper's `reading.md` briefly records what it does, questions actually raised or adopted by the reader, selected-note links, and source inspection coverage. Create `notes.md` when the reader selects something for retention. The reader chooses the direction; a paper ID alone does not start a lesson or an assistant-generated question list. Keep original papers and supporting materials together in the shared [sources folder](sources/), using distinct filenames for different versions. Check existing identifiers, versions, and SHA256 checksums before adding a copy; multiple records can link to the same file. Keep local extraction, rendered pages, and scratch calculations in Git-ignored `papers/<paper-id>/work/`.

| Paper | Reading record | Saved notes | Reader-led status |
|---|---|---|---|
| P01 / G01 — Grover 1996 | [Summary, questions, and sources](papers/P01/reading.md) | [2026-09-15 notes](papers/P01/note.md) | Existing notes retained; awaiting the reader's chosen question |
| P02 / G02 — Applying Grover's algorithm to AES | [Summary, questions, and sources; arXiv v1](papers/P02/reading.md) | [N01: reversible AES](papers/P02/notes.md#n01); [N02: in-place LUP tradeoffs](papers/P02/notes.md#n02); [N03: permutation-group S-box synthesis](papers/P02/notes.md#n03) | Q06–Q19 explanations recorded; latest: accumulated quantum-gate operations versus current silicon integration scale |
| P03 / G03 — Implementing Grover oracles for quantum key search on AES and LowMC | [Summary, questions, and sources; corrected 2023 ePrint](papers/P03/reading.md) | None selected | Reading started 2026-09-28; primary record and abstract checked; corrected PDF downloaded and checksum verified; awaiting the reader's chosen question |

## Later synthesis

Create `synthesis/` when a cross-paper comparison or concept note is needed, linking back to paper IDs and evidence locations.

## Workspace conventions

The shared directory and identity rules are in the [research workspace specification](../.agents/skills/research-landscape/references/workspace.md). Use [research-landscape](../.agents/skills/research-landscape/SKILL.md) for breadth and [paper-reading](../.agents/skills/paper-reading/SKILL.md) for interactive depth and selected notes.

The previous `research-landscape/q1-grover-oracle/` outputs were moved into `landscape/`. Paper IDs, bibliography keys, search dates, and scholarly assessments were retained; relative source links were adjusted.

2026-09-28: Moved the four original source files from P01/P02 into the shared `sources/` folder and rebased reading, note, and registry links. SHA256 checks found no byte-identical duplicates; all four file checksums were preserved. Source IDs and version-specific inspection records remain in each paper's `reading.md`.
