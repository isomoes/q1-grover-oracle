# Q1 Grover Oracle Research Workspace

Keep the field map, individual-paper reading materials, and later cross-paper synthesis together in `apaper/`. Each project covers one research direction, so there is no topic subdirectory.

## Landscape

- [Evolution graph, route comparisons, and reading recommendations](landscape/report.md)
- [Paper identities, versions, and evidence](landscape/papers.json)
- [Verified bibliography](landscape/references.bib)

The map contains 20 core papers and five routes, searched on 2026-09-27 with preliminary coverage. Its evidence-reading levels describe source inspection, not the user's understanding.

## Paper reading

Interactive reading records now include P01/G01. P03 remains the landscape's recommended first reproduction baseline. Preserve P01–P20 and the G-series aliases already recorded in the map.

Create `papers/<paper-id>/` when reading begins. Paper identities and reading links live in the shared [paper registry](landscape/papers.json). Each paper gets `reading.md` for sources, inspection coverage, progress, and open questions, plus selected notes (`note.md` for P01). Keep original materials in `sources/` and extraction, rendered pages, and scratch calculations in `work/` inside that paper's directory.

Add a linked row here when a reading session starts:

| Paper | Reading record | Saved notes | Next question |
|---|---|---|---|
| P01 / G01 — Grover 1996 | [Progress and sources](papers/P01/reading.md) | [2026-09-15 notes](papers/P01/note.md) | Why does candidate-dependent garbage change the N=4 diffusion example even without measurement? |

## Later synthesis

Create `synthesis/` when a cross-paper comparison or concept note is needed, linking back to paper IDs and evidence locations.

## Workspace conventions

The shared directory and identity rules are in the [research workspace specification](../.agents/skills/research-landscape/references/workspace.md). Use [research-landscape](../.agents/skills/research-landscape/SKILL.md) for breadth and [paper-reading](../.agents/skills/paper-reading/SKILL.md) for interactive depth and selected notes.

The previous `research-landscape/q1-grover-oracle/` outputs were moved into `landscape/`. Paper IDs, bibliography keys, search dates, and scholarly assessments were retained; relative source links were adjusted.
