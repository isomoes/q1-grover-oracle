# Reading Records and Selected Notes

Use these as compact templates, not quotas. Generated prose follows the user's language; filenames, JSON keys, and enumerated values remain as specified. Never fill templates with invented facts. Use `null` or an explicit unresolved statement when information is unknown.

## Shared Registry: landscape/papers.json

Use the matching object in the shared registry's `papers` array. Keep identity, aliases, citation metadata, versions, routes, `read_level`, a brief scope summary, and key landscape evidence on that object. Add only a reading-record link when a reading session starts. Detailed source inventories, inspected sections, active source, artifact records, and reading context belong in `reading.md`. Do not create a per-paper metadata file or copy the reading record into the registry. Existing metadata is inherited context until checked.

The following is a partial registry entry showing the reading link, not a replacement for the full paper schema in `../../research-landscape/references/output.md`:

```json
{
  "id": "P03",
  "aliases": [],
  "identity_source": "https://example.org/primary-record",
  "reading": {
    "record_path": "../papers/P03/reading.md"
  }
}
```

This is a structural example, not an actual P03 record. Replace its values using real evidence.

- The registry's `id` is the only paper ID; do not add duplicate `paper_id` or `landscape_id` fields. `identity_source` points to a checked bibliographic record/local origin, or is `null` if unknown. Populate citation fields from verified evidence.
- `reading.record_path` is relative to the directory containing `papers.json`. Paths inside `reading.md` are relative to that Markdown file. Keep `reading` limited to this link; use source anchors in the Markdown record when detailed inspection evidence needs a cross-reference.

Without a landscape report, initialize the same shared registry in the registry-only form described in `../../research-landscape/references/output.md`. A later landscape extends it in place. Reuse existing BibTeX keys; do not maintain a second bibliography inside a paper folder.

## Synchronize a Newly Selected Paper with an Existing Landscape

Apply this automatically when a paper becomes a reading target, including a previously standalone record resumed in a workspace that now has a landscape. Merely consulting a supporting source does not make it a new reading target. Respect an explicit request not to modify the landscape; keep progress in Markdown and state any deferred registry update rather than creating another metadata store. Without a landscape report, use the shared registry-only workflow; a full landscape search is not a prerequisite for reading.

Read the existing map files and `../../research-landscape/references/output.md` before editing. Use the sibling skill's verification, comparison, and graph evidence standards for any assessment changes. Update the resolved map location, including legacy layouts, rather than creating a second map.

1. **Resolve identity first.** Check identifiers, titles, authors, aliases, and versions across the registry and reading folders. Reuse the existing ID and BibTeX key for the same work; a new revision is not a new node. For a genuinely new work, reuse its standalone reading ID or allocate the next unused workspace-wide ID. Preserve existing IDs and user annotations.
2. **Update `papers.json`.** Add the paper with verified citation metadata, versions, actual `read_level`, and key landscape evidence with exact locators. Explain in `selection_reason` that it was selected for reading and how it relates to the research question. Assign only supported routes and roles; leave unresolved arrays empty and explain the gap rather than inventing a milestone or leader designation. Keep the scope summary brief and link to `reading.md` for the detailed inspection record.
3. **Update `references.bib`.** Reuse or add one verified citation entry, with the key stored in the shared registry entry. Use a minimal entry when metadata is incomplete; do not invent publication details.
4. **Update `report.md`.** Add a concise paper entry with its ID, contribution or reading question, evidence level, route relevance or unresolved placement, and a relative link to its reading record. A supplementary “Papers added during reading” section is sufficient when the paper is not yet part of the core graph. Update affected route tables, comparisons, and graph nodes or edges only when evidence warrants them; do not force every reading target into the core graph.
5. **Preserve scope and coverage.** Record the dated incremental addition and remaining gaps in the report or coverage limitations. Keep the original search date and cutoff unless a real scope/search update occurs; a single-paper lookup is not a refreshed field-wide search. Identify out-of-scope or post-cutoff reading additions separately, without using them to revise historical rankings or silently broadening the map.
6. **Link both directions.** Set the entry's `reading.record_path` and link back to the registry from `reading.md`, naming the paper ID. Keep the checked identity source in the registry and the detailed source inventory in `reading.md`. Update the workspace README's reading index and relevant report links. Further reading changes registry evidence only when it adds or corrects a landscape-relevant claim; routine progress stays in the reading record.
7. **Validate and report.** Run `python3 <research-landscape-skill-dir>/scripts/validate.py <resolved-landscape-dir>` after edits, then check reading links and source/version consistency. Fix structural mistakes; if incomplete metadata or unresolved roles prevent validation, record the precise gap instead of fabricating values to pass. Briefly tell the user which paper was added and where. If identity cannot yet be resolved, record the pending synchronization in `reading.md` and complete it when the missing evidence becomes available.

## reading.md: Minimal Reader-Led Record

Keep three things easy to find: what the paper does, questions raised or adopted by the reader, and links to insights they selected for notes. Retain source provenance below them. Do not generate questions to fill the record, require a next step, or maintain a comprehension checklist. A bare paper selection can leave the question section empty. Record factual verification caveats with their sources, not as tasks assigned to the reader.

```markdown
# Pxx — Original paper title

## What the paper does
One short source-supported paragraph about its problem, approach, and contribution.
Paper ID, active source ID, and exact version; link to the shared registry and source.

## Reader's questions
Only questions the reader actually raised or explicitly adopted. If none, say so briefly.
For each, retain its wording or faithful paraphrase, a stable Q01-style ID when useful,
and a concise answer/status with source locators. Attribute assistant explanations.
Do not reuse retired IDs from earlier assistant-generated questions.

## Selected notes
Link existing notes and stable note IDs. If none have been selected, say so.
Preserve the reader's own phrasing with attribution; do not label assistant prose as their understanding.

## Session context (optional)
Only details needed to resume the reader's actual request: e.g., their chosen passage,
an unfinished answer, or a next step they explicitly requested. Omit if unnecessary.

<a id="sources"></a>
## Source inventory and inspection coverage

<a id="s01"></a>
### S01 — Source title
- Role: target / appendix / erratum / prerequisite / baseline / follow_up / explanation / code.
- Origin: source URL or local origin; local copy if available, relative to this file.
- Version and known version date; access date; optional checksum.
- Access: local / remote / unavailable. Inspection level: none / metadata / abstract / full_text.
- Inspected sections: exact passages, figures, equations, tables, or pages actually checked.
- Purpose and limitations: why used, version differences, remaining gaps.

## Artifact inspection and local aids
When relevant: source ID, pinned commit, inspected paths, execution status
(not_run / ran / reproduced), commands, conditions, and observed results.
Link ignored logs/extractions as optional local aids.
```

Keep the current state succinct; source inspection is not a measure of reader progress. Preserve resolved reader questions when they explain why an interpretation changed. When cleaning legacy records, remove assistant-invented questions and reading plans from active sections. Preserve user-selected notes and source inventories; mark historical material of uncertain question provenance as historical rather than silently treating it as the reader's current agenda.

Source IDs such as S01 are stable and paper-local; qualify cross-paper references as `P03/S01`. Name the active source near the paper summary, and do not repurpose an old ID for a revised version. Source inventory entries describe actual inspection, not presumed access. `local` requires an existing file; a URL alone does not establish `remote` access. For `full_text`, list only passages actually read; code inspection is distinct from paper inspection. Record unknown versions/dates explicitly, and do not infer publication dates from file metadata or checksums.

Keep artifact commands, conditions, and result evidence in this record or linked durable notes. Use `reproduced` only for a specifically matched result; ignored logs are optional aids. Recheck local availability when resuming on another machine without erasing historical inspection records.

## notes.md: User-Selected Knowledge

Create on the first save request; do not pre-populate “important” notes on behalf of the user. Use explicit anchors so note links survive changes to headings or output language. The template below lists useful fields, not mandatory headings: a short insight with the reader's interpretation, relevant qualifications, and a source citation can be enough. Omit empty motivation and open-issue sections rather than inventing content.

```markdown
# Pxx — Selected notes

<a id="n01"></a>
## N01 — Short, specific insight

- Saved: YYYY-MM-DD. Selection: the user's request or importance signal, faithfully paraphrased.
- Status: author_claim / source_supported / independently_checked / hypothesis / open_question.

### Insight
State the useful idea in plain language, then the necessary technical detail.
Attribute the user's own interpretation separately when present.

### Why it matters
Connect to the user's question or a future judgment they need to make.

### Conditions and limits
Assumptions, scope, exclusions, and what the insight does not establish.

### Evidence
- [Pxx/S01, exact version](source URL or relative local path), section/equation/table/page.
  Explain what this passage supports. Label assistant derivations separately.

### Open issues and connections
Remaining uncertainty and links to related notes, questions, or papers, if any.
```

Use the next unused Nxx ID within the paper. Link with `notes.md#n01`; across papers, qualify the paper path (and workspace path for another project) as needed. A note can contain multiple claims with different statuses; label those claims individually instead of giving the whole note an unjustifiably strong status.

`source_supported` means the checked source supports the stated interpretation under the recorded conditions, not that an empirical result was independently reproduced. `independently_checked` needs a retained derivation or execution result and its limited scope. A hypothesis or open question still needs its originating passage, user statement, or context; if no paper evidence exists, say so instead of manufacturing a locator.

For corrections, append a dated amendment identifying the old statement, replacement, and evidence, and mark the earlier claim superseded. Preserve the note ID and user-authored wording with attribution. Update dependent working understanding and linked synthesis if necessary.

## Final File Review

Check that:

1. Local sources marked available and README/reading/note links resolve from their containing files. Ignored scratch paths are clearly optional; durable reasoning does not depend on their presence in a fresh checkout.
2. Paper, source, question, and note IDs are unique in their defined scope and every reference resolves.
3. Source versions are consistent with locators; unavailable sources have no invented inspection coverage.
4. Explicitly selected content is saved with status, significance, conditions, and evidence or a stated evidence gap.
5. Recorded questions and any next step came from the reader or were explicitly adopted by them; no invented agenda or unsupported mastery/reproduction claim was added. Empty question sections are valid.
6. Existing user annotations and stable IDs survive updates.
7. The registry holds each paper's identity, concise landscape evidence, and reading link; detailed sources and inspection coverage are in `reading.md`. With a landscape report, its paper entry and BibTeX key agree with the registry, or a specific pending synchronization gap is recorded. Map edits have been structurally validated without treating validation as evidence of scientific correctness.
8. Both paper and landscape `work/` directories are Git-ignored; durable notes, source provenance, and reproduction commands are retained outside them.

These checks validate continuity and traceability, not the scientific truth of a paper.
