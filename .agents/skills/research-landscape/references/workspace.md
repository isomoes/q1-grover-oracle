# Shared Research Workspace

This is the common storage contract for `research-landscape` and `paper-reading`. Keep both skill directories together when installing them. Skill instructions belong under `.agents/skills/`; research outputs belong in the user's workspace, not inside skill directories.

## Resolve the Root

1. Honor the user's explicit workspace. Reuse an existing workspace root when the supplied file is inside its `landscape/` or `papers/` directory.
2. Otherwise use `apaper/`, relative to the project root. One project covers one research direction, so do not add a topic/slug layer or ask the user to choose one. Inspect existing outputs before creating the workspace.
3. In an older `research-landscape/<topic-slug>/` or `research/<topic-slug>/` layout, read the existing files first. On a requested migration, move the landscape deliverables to `apaper/landscape/` and existing reading records, sources, intermediates, and synthesis to the corresponding directories under `apaper/`. Fix inbound and outbound relative links (including JSON source URLs), and preserve IDs and user edits. Do not merge conflicting destination files blindly.
4. If migration is not requested, reuse the legacy root: keep map files in their existing location (at the root or in `landscape/`) and use `papers/` directly under that root. Record this layout in the workspace README and use actual paths in links. Do not create a duplicate map in the new default location.

## Layout

```text
apaper/
├── README.md                      # Navigation and reader-led paper-reading index
├── landscape/
│   ├── report.md                  # Breadth: routes, graph, comparisons
│   ├── papers.json                # Identities, versions, routes, key evidence, reading links
│   ├── references.bib
│   └── work/                      # Local search logs and scratch material; Git-ignored
├── papers/
│   └── P03/                       # Stable paper ID, not a mutable title
│       ├── reading.md             # Sources, inspected sections, context, progress, questions
│       ├── notes.md               # User-selected knowledge; created on first save
│       ├── sources/               # Original paper versions and supporting materials
│       └── work/                  # Local extractions, page images, scratch; Git-ignored
└── synthesis/                     # Optional cross-paper comparisons and concepts
```

Create directories and files as needed, not an empty folder tree for every candidate paper. All retained task intermediates stay under the same workspace root: paper-specific work under `papers/<id>/work/`, map-specific work under `landscape/work/`. When a tool requires temporary storage elsewhere, copy useful outputs back and record the retained path; do not leave durable notes pointing at transient files or remote-only download paths.

Keep both `work/` locations out of version control. For the default layout, add `/apaper/papers/*/work/` and `/apaper/landscape/work/` to the repository's `.gitignore`; adapt these paths for explicit or legacy roots. If scratch files are already tracked, remove only those files from the Git index while preserving local copies. Durable conclusions, derivations, and reproduction commands belong in reading notes or synthesis; ignored files may be linked as optional local aids, but must not be the only evidence needed to understand a tracked conclusion. A fresh checkout need not contain these caches.

Within `sources/`, keep version-distinct filenames (for example, `paper-2023-06-07.pdf`); use a short descriptive filename when the date is unknown. Do not invent dates. Record source IDs, URLs, versions, actual local paths, and detailed inspection coverage in `reading.md`, using `../../paper-reading/references/records.md`. Paths in that record are relative to its paper folder. Registry paths are relative to the directory containing `papers.json`, including `reading.record_path` (for example, `../papers/P03/reading.md`). External code repositories may be linked by pinned commit instead of copied in full. Record locally inspected code files and whether anything was run in the reading record.

## Identity and Ownership

- Paper IDs are unique within the project's workspace, not globally. Reuse IDs, aliases, and BibTeX keys from `landscape/papers.json`. Before allocating a new `Pxx` ID, inspect both the map and existing `papers/` records; use the next unused integer, with at least two digits. Never renumber existing papers.
- Resolve duplicate titles and revisions using verified identifiers and authors. Revisions of the same work share a paper folder, but source versions and evidence locators remain distinct. Give independent follow-up work its own ID.
- `landscape/papers.json` is the single paper registry for both skills. Do not create per-paper `paper.json` files or duplicate identity fields in reading records. A paper can be read without a landscape report: initialize a minimal registry using `output.md` and a workspace README, with no invented routes or search coverage. A later landscape expands that same registry and reuses its IDs.
- When a landscape exists, selecting an unregistered paper for reading also triggers an incremental update to its registry, bibliography, and report. Follow `../../paper-reading/references/records.md`, reuse the same paper ID, and link the reading record to the map. Registration does not imply core-graph membership or a verified field-level role; preserve the map's scope and cutoff when recording supplementary reading additions.
- The registry holds identity, versions, routes, concise field-level evidence, and a reading-record link. `reading.md` holds detailed source inventories, inspected sections, artifact records, context, and progress; `notes.md` holds selected knowledge. Update registry reading levels/evidence when justified, preserving uninspected scope; do not silently turn a selected-section reading into a complete audit or a saved note into a new lineage/leading-result claim. Keep its `reading` object limited to `record_path` and preserve that link during landscape updates.
- `reading.md` briefly records what the paper does, reader-raised or reader-adopted questions, and source coverage. `notes.md` records what the user asked to retain. Neither implies that the user has mastered the content. User opinions and assistant hypotheses are not paper findings. Assistant-generated questions and reading plans are not the reader's agenda.
- Preserve user-authored text and note IDs. Amend a mistaken saved claim with a dated correction and supporting evidence instead of erasing its history. Keep speculative ideas labeled even when the user asks to save them.

For legacy per-paper `paper.json` files, merge verified identity fields into the matching registry entry and move source inventories, active source IDs, and artifact records into `reading.md`. If those details were already placed in the registry's `reading` object, move them to Markdown and retain only `record_path`. Rebase local paths from their old containing file to the Markdown file; preserve source IDs, versions, coverage, and user annotations. Resolve conflicts from evidence rather than overwriting either record blindly. Update inbound links and remove redundant fields/files only after verifying that all unique information has been retained.

## Navigation and Extension

Maintain one README entry for each paper actually started, linking its reading record and any saved notes, with a brief status. Include a next question only when the reader raised or explicitly adopted it; no next question is required. Link the landscape report from the same index. Do not mark every map paper as deeply read merely because metadata exists.

Use relative paths from the containing Markdown or JSON file. For references to another project, include its workspace path with the paper ID. Add `synthesis/` only when a cross-paper task needs it, and link conclusions back to per-paper sources and note IDs. Future experiments can live in the project's existing experiment area and be linked rather than duplicated.

During migration, check local links and compare IDs, source inventories, and bibliography keys before and after. If all three map deliverables exist, run the landscape validator against their directory; for a registry-only workspace, use the checks in `output.md`. Verify structural continuity separately from scientific correctness.
