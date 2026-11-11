# Q1 Grover Oracle: Agent Guide

Research on complete Grover key-search oracle optimization in the Q1 model,
starting with AES-128. See the [project overview](README.md) for scope and status.

## Project navigation

Read the linked documents when relevant to the task; do not load everything upfront.

| Location | Purpose / entry point |
| --- | --- |
| `docs/` | [Research plan, model, and resource accounting](docs/research-plan.md); [annotated references](docs/reference.md); [bibliography](docs/references.bib). |
| `apaper/` | Literature and reading workspace. Start with its [index](apaper/README.md) for the directory layout and current reading records. |
| `apaper/landscape/` | [Field map and comparisons](apaper/landscape/report.md), [shared paper registry](apaper/landscape/papers.json), and bibliography. |
| `apaper/papers/` | Per-paper reading records and selected notes, organized by stable paper ID. |
| `apaper/sources/` | Shared original papers and supporting sources. |
| `theory/` | [Theoretical development and Lean 4 formalization](theory/README.md). |
| `code/` | [Circuit implementations and experiment code](code/README.md). |
| `result/` | Experiment records and artifacts; use the [experiment template](result/template.md). |
| `.agents/skills/` | Local skill instructions and supporting guides. |
| `opencode.json` | [Project agent configuration](opencode.json). |

## Shared conventions

- Keep this guide in English; follow the user's language for discussion and notes.
- Before organizing literature outputs, read the [workspace rules](.agents/skills/research-landscape/references/workspace.md).
- Before updating reading records, read the [record conventions](.agents/skills/paper-reading/references/records.md).
- Preserve existing paper IDs, citation keys, source versions, and user-selected notes. Keep navigation current in the workspace index.
- Follow the research plan for oracle correctness and matched resource comparisons; distinguish literature claims from results reproduced here.
- Inspect `git status --short` before editing and preserve unrelated work. Keep this file as a navigation guide; put detailed rules and progress in the linked documents.
