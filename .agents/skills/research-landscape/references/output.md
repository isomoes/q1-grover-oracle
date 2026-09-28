# Output Conventions

Read `workspace.md` for the shared project-workspace layout, legacy migration, paper identities, and handoff to deep reading. The three files below belong in `apaper/landscape/` by default, without a topic subdirectory. Maintain `apaper/README.md` as the shared navigation entry point; retained map intermediates belong in Git-ignored `apaper/landscape/work/`. Keep durable coverage statements and evidence in the tracked outputs.

Use the user's preferred language, or the conversation language when none is specified, for generated prose, headings, graph labels, and explanatory JSON values. The English examples in this specification illustrate structure rather than impose an output language. Keep filenames, JSON keys, IDs, and enumerated values as specified for tool compatibility. Preserve original paper titles and bibliographic metadata for citation accuracy, adding translations into the output language when helpful.

## report.md

Adjust length to the content and include:
1. **Core evolution graph**: Embed the graph directly in a fenced `mermaid` code block, with a legend distinguishing roles, documented lineage/use, comparisons, and thematic relationships.
2. **Route comparison table**: Route / problem addressed / early and key papers / methods / conditions / strengths / limitations / recent papers / conditionally leading representatives.
3. **Core paper cards**: ID, original title, authors, public release and publication years, versions, sources, role justification, reading level, contributions, and evidence locations. Tables may be used for concision.
4. **Newest and best**: List these separately. Leading-result assessments must specify metrics, comparators, and conditions. For numerical results, include units, versions, and original tables/sections. If evidence is insufficient, provide candidates and gaps.

Use the JSON paper IDs for graph nodes. Double-quote labels and escape quotation marks, parentheses, and other Mermaid special characters. Every paper node must exist in the JSON; route IDs may be used for group names. Draw solid lines for evidence-supported lineage in major routes; do not invent edges to make the graph connected.

## papers.json

Use UTF-8 JSON. The following illustrates the structure; populate actual outputs with real data, not example placeholders.

This is the single paper registry used by both skills, even before a landscape report exists. Keep it focused on identity, versions, routes, key evidence, and brief reading-level/scope summaries. Each paper may have `aliases`, `identity_source`, and `reading: {"record_path": "../papers/P03/reading.md"}`. Detailed source inventories, inspected sections, active source, artifact records, and reading context belong in that Markdown record; use `../../paper-reading/references/records.md` for its format. Preserve reading links during landscape updates. Registry paths are relative to the directory containing `papers.json`. Do not create separate per-paper metadata files or merge the full reading context into this registry.

```json
{
  "topic": "Research area",
  "searched_on": "YYYY-MM-DD",
  "cutoff_date": "YYYY-MM-DD",
  "coverage": {"status": "preliminary", "sources": ["arXiv", "DBLP"], "limitations": ["Full texts for one branch remain unverified"]},
  "papers": [{
    "id": "P01", "title": "Verified title", "authors": ["Author"],
    "year": 2020, "first_public_date": null,
    "publication_status": "peer_reviewed", "venue": null,
    "doi": null, "urls": ["https://primary-source.example/paper"],
    "bibtex_key": "Author2020Title", "routes": ["R01"],
    "roles": ["foundation", "milestone"],
    "versions": [{"label": "Version actually checked", "date": null, "url": "https://primary-source.example/paper", "note": "Revision date unknown"}],
    "read_level": "abstract",
    "selection_reason": "Why this paper is key to the route and how strongly the evidence supports that assessment",
    "evidence": [{"claim": "Paper contribution", "url": "https://primary-source.example/paper", "locator": "Abstract", "support": "Methodological contribution explicitly stated by the authors"}]
  }],
  "routes": [{
    "id": "R01", "name": "Research route", "question": "What problem does this route address?",
    "foundation_ids": ["P01"], "milestone_ids": ["P01"], "recent_ids": [],
    "leaders": [{"paper_ids": ["P01"], "status": "candidate", "criterion": "Metric or theorem scope", "conditions": "Task and conditions", "reason": "Selection rationale and evidence gaps", "evidence": []}]
  }],
  "edges": [{
    "source": "P01", "target": "P02", "type": "related",
    "basis": "analyst", "explanation": "Related themes without verified direct lineage", "evidence": []
  }],
  "comparisons": [{
    "route_id": "R01", "paper_ids": ["P01"], "task": "Explicit evaluation target",
    "metric": "Target metric", "direction": "minimize", "conditions": "Comparable conditions",
    "values": [], "verdict": "Insufficient evidence; candidates only", "evidence": []
  }]
}
```

- `coverage.status`: `preliminary` / `scoped`; the latter does not imply exhaustive coverage.
- `publication_status`: `peer_reviewed` / `preprint` / `accepted` / `unknown`. Choose based on verified status.
- `roles`: `foundation` / `milestone` / `recent` / `leader` / `baseline` / `survey`; multiple roles are allowed.
- `read_level`: `metadata` / `abstract` / `full_text`.
- `leaders.status`: `supported` / `candidate` / `undetermined`. When the assessment is undetermined, `paper_ids` may be empty, but explain the gaps rather than omitting the route's assessment.
- Edges `source → target`: `extends` means the target extends the source; `uses` means the target uses the source; `improves` means the target improves on the source under specified conditions. All three require `basis: documented` and evidence. `compares` means the target compares against the source and also requires documentary evidence. `related` denotes a thematic relationship without directional causal meaning, uses `basis: analyst`, and is drawn as a dashed line.
- Each `evidence` item contains `claim, url, locator, support`. Make `support` a faithful summary; use quotation marks only for direct quotations and do not fabricate original wording. Full-text locators may be `Table 3 / §4.2`; label abstract evidence `Abstract`.
- When `comparisons.values` contains numerical results, each item includes `paper_id, value, unit, variant, evidence`. Do not place values from different conditions side by side and rank them unconditionally. If reliable values are unavailable, leave the array empty and explain the conclusion in prose.
- Use `null` for unknown dates; do not invent exact days. A future cutoff expresses the requested scope only; the coverage statement must specify the actual search date.

### Registry-Only Initialization for Reading

When no landscape exists, create `papers.json` with the same top-level fields: the known project `topic`, `searched_on: null` until a search is actually performed, the user's `cutoff_date` or `null`, `coverage.status: preliminary`, and coverage sources/limitations describing only actual work. Add the selected paper to `papers`; initialize `routes`, `edges`, and `comparisons` as empty arrays. Keep unknown paper metadata `null` or empty and unsupported roles/routes empty. A `bibtex_key` may remain `null` until a bibliography entry is created. Add `reading.record_path` when reading begins.

Do not fabricate a report, graph, bibliography, or field-wide search merely to start reading. This registry-only workspace is not a delivered landscape: check JSON structure, unique IDs, source references, and reading links directly. The full landscape validator requires all three deliverables and route assessments; run it once those exist. Expand this same registry when a landscape is later requested.

## references.bib

Assign one BibTeX key to each core paper, preferring source-provided entries. When metadata is incomplete, use a minimal valid entry with a URL. Choose one citation identity for preprint and published versions, preserving version notes in JSON rather than mixing years and page numbers from different versions.
