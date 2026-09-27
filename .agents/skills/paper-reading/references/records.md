# Reading Records and Selected Notes

Use these as compact templates, not quotas. Generated prose follows the user's language; filenames, JSON keys, and enumerated values remain as specified. Never fill templates with invented facts. Use `null` or an explicit unresolved statement when information is unknown.

## paper.json

Create this when a paper-reading session starts. Paths in this file are relative to its containing paper directory. Metadata from a landscape is inherited context until checked; a source entry's coverage describes only actual inspection, not presumed access.

```json
{
  "schema_version": 1,
  "paper_id": "P03",
  "landscape_id": "P03",
  "title": "Original title from the verified record",
  "aliases": [],
  "bibtex_key": null,
  "identity_source": "../../landscape/papers.json",
  "active_source_id": "S01",
  "sources": [
    {
      "id": "S01",
      "role": "target",
      "title": "Source title",
      "url": "https://example.org/primary-record",
      "local_path": null,
      "version": null,
      "version_date": null,
      "accessed_on": null,
      "access": "unavailable",
      "inspection_level": "none",
      "inspected_sections": [],
      "purpose": "Target paper for the selected question",
      "notes": "Full text not yet retrieved"
    }
  ],
  "artifacts": []
}
```

This is a structural example, not an actual P03 record. Replace its values using real evidence.

- `landscape_id` equals `paper_id` when the paper is in the project's map; otherwise use `null`. `identity_source` points to the map or a checked bibliographic record/local origin, or is `null` if unknown. The title is required; unresolved identity should be stated rather than silently guessed.
- Source IDs such as S01 are stable and paper-local. `active_source_id` identifies the target version currently being read, or is `null` when unresolved. Do not repurpose an old source ID for a revised version.
- `role`: `target`, `appendix`, `erratum`, `prerequisite`, `baseline`, `follow_up`, `explanation`, or `code`.
- `access`: `local`, `remote`, or `unavailable`. Local access requires an existing `local_path`; remote access can have no local copy. A known URL alone does not establish successful remote access.
- `inspection_level`: `none`, `metadata`, `abstract`, or `full_text`. For `full_text`, `inspected_sections` specifies exactly what was read; only list the entire text if actually read. For code, use the separate artifact coverage below rather than equating it to paper full-text inspection.
- `version` may identify an arXiv revision, an ePrint revision date, a publication, or a code commit; use `null` if unknown. `version_date` and `accessed_on` are actual known dates, not inferred publication days. An optional `sha256` helps distinguish mutable downloaded files but does not prove a publication date.
- Each artifact entry records `source_id`, `commit` (or `null`), `inspected_paths`, `execution` (`not_run` / `ran` / `reproduced`), and `result`. For a run, also retain its command, conditions, and log path under `work/`; use `reproduced` only with the specific matched result and comparison evidence.

For a new paper without a map, add verified `authors`, `year`, `doi`, and `urls` as available so a later landscape can reuse the identity. Do not create a parallel bibliography for existing mapped papers; reuse its BibTeX key.

## reading.md: Continuity, Not a Transcript

```markdown
# Pxx — Original paper title

## Goal and context
- User's question and research-route connection, if known.
- Background assumed for the current explanation.
- Active source ID and exact version; link to paper.json and source.

## Progress
| Unit / source locator | What was explained or checked | Remaining gap |
|---|---|---|

## Working understanding
Concise explanations needed to resume, with source IDs and locators.
Label author claims, assistant reconstructions, checks, and user interpretations.
Link saved notes rather than duplicating their full contents.

## Open questions
Give each question a stable Q01-style ID; record resolution and evidence when answered.

## Next step
One precise reading or reasoning step, including the passage or missing source.

## Session checkpoints
- YYYY-MM-DD: What was actually discussed/inspected; what the user explicitly confirmed, if any.
```

Keep the current state succinct. Add a short checkpoint at a meaningful pause, rather than a log entry for every sentence. A useful stage label may be `orienting`, `reading`, `blocked`, or `paused`; none asserts mastery. Preserve resolved questions when they explain why an interpretation changed.

## notes.md: User-Selected Knowledge

Create on the first save request; do not pre-populate “important” notes on behalf of the user. Use explicit anchors so note links survive changes to headings or output language.

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

1. Every local source path and README/reading/note link resolves from its containing file.
2. Paper, source, question, and note IDs are unique in their defined scope and every reference resolves.
3. Source versions are consistent with locators; unavailable sources have no invented inspection coverage.
4. Explicitly selected content is saved with status, significance, conditions, and evidence or a stated evidence gap.
5. Open questions and a precise next step remain visible; no unsupported mastery or reproduction claim was added.
6. Existing user annotations and stable IDs survive updates.

These checks validate continuity and traceability, not the scientific truth of a paper.
