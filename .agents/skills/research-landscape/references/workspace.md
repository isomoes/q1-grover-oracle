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
├── README.md                      # Navigation, paper-reading index, next steps
├── landscape/
│   ├── report.md                  # Breadth: routes, graph, comparisons
│   ├── papers.json                # Map identities, versions, evidence
│   ├── references.bib
│   └── work/                      # Search logs and map-only scratch material
├── papers/
│   └── P03/                       # Stable paper ID, not a mutable title
│       ├── paper.json             # Identity, source inventory, inspection coverage
│       ├── reading.md             # Goal, explanations, progress, open questions
│       ├── notes.md               # User-selected knowledge; created on first save
│       ├── sources/               # Original paper versions and supporting materials
│       └── work/                  # Extracted text, page images, scratch derivations
└── synthesis/                     # Optional cross-paper comparisons and concepts
```

Create directories and files as needed, not an empty folder tree for every candidate paper. All retained task intermediates stay under the same workspace root: paper-specific work under `papers/<id>/work/`, map-specific work under `landscape/work/`. When a tool requires temporary storage elsewhere, copy useful outputs back and record the retained path; do not leave durable notes pointing at transient files or remote-only download paths.

Within `sources/`, keep version-distinct filenames (for example, `paper-2023-06-07.pdf`); use a short descriptive filename when the date is unknown. Do not invent dates. Record source IDs, URLs, versions, and actual local paths in `paper.json`. External code repositories may be linked by pinned commit instead of copied in full. Track locally inspected code files and whether anything was run.

## Identity and Ownership

- Paper IDs are unique within the project's workspace, not globally. Reuse IDs, aliases, and BibTeX keys from `landscape/papers.json`. Before allocating a new `Pxx` ID, inspect both the map and existing `papers/` records; use the next unused integer, with at least two digits. Never renumber existing papers.
- Resolve duplicate titles and revisions using verified identifiers and authors. Revisions of the same work share a paper folder, but source versions and evidence locators remain distinct. Give independent follow-up work its own ID.
- A paper can be read without a landscape. Record its identity in `paper.json`, set `landscape_id` to `null`, and create a minimal workspace README. Do not manufacture map routes or a bibliography to satisfy a template. If a later map includes that work, reuse its ID and verified citation identity.
- The landscape remains the record of field-level assessments. The per-paper files hold detailed inspection coverage and reading state. Update map reading levels/evidence when justified, preserving uninspected scope; do not silently turn a selected-section reading into a complete audit or a saved note into a new lineage/leading-result claim.
- `reading.md` records what was discussed and what remains open. `notes.md` records what the user asked to retain. Neither implies that the user has mastered the content. User opinions and assistant hypotheses are not paper findings.
- Preserve user-authored text and note IDs. Amend a mistaken saved claim with a dated correction and supporting evidence instead of erasing its history. Keep speculative ideas labeled even when the user asks to save them.

## Navigation and Extension

Maintain one README entry for each paper actually started, linking its reading record and any saved notes, with a short next question. Link the landscape report from the same index. Do not mark every map paper as deeply read merely because metadata exists.

Use relative paths from the containing Markdown or JSON file. For references to another project, include its workspace path with the paper ID. Add `synthesis/` only when a cross-paper task needs it, and link conclusions back to per-paper sources and note IDs. Future experiments can live in the project's existing experiment area and be linked rather than duplicated.

During migration, run the landscape validator against the directory containing the three map files, check local links, and compare IDs and bibliography keys before and after. Verify structural continuity separately from scientific correctness.
