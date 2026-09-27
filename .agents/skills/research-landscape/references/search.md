# aPaper Search and Supplementary Evidence

## Discover the Interfaces

In the current environment, use tool discovery to look up `apaper-mcp`, then call the exact returned paths. Other hosts may expose MCP tools directly. Follow the actual tool definitions; do not invent cited-by search or citation-graph interfaces.

In environments supporting Code Mode, first obtain signatures with `search({namespace: "apaper-mcp", limit: 20})`, then call tools through `tools["apaper-mcp"]`. Discovery is valid only within that runtime.

The following tools were available when this skill was written; use live discovery as the authority for parameters:

| Tool | Common parameters | Purpose and limitations |
|---|---|---|
| `search_google_scholar_papers` | `query, max_results, year_low, year_high` | Cross-disciplinary entry point, early representatives, and follow-up work; ranking does not prove importance, and rate limits may apply |
| `search_arxiv_papers` | `query, max_results, date_from, date_to, categories, sort_by` | Preprints and recent advances; verify date formats and sort values against the interface |
| `search_dblp_papers` | `query, max_results, year_from, year_to, venue_filter, include_bibtex` | Computer-science publication metadata and BibTeX; does not cover all disciplines |
| `search_iacr_papers` | `query, max_results, fetch_details, year_min, year_max` | Cryptology ePrint papers, version updates, and paper status |
| `search_cnki_papers` | `query, page_num, page_size` | Chinese scholarly literature; assess full-text access separately from search availability |
| `download_arxiv_paper` | `paper_id, save_path` | Download selected full texts |
| `download_iacr_paper` | `paper_id, save_path` | Download selected full texts |
| `download_cnki_paper` | `href, save_path` | Download accessible full texts through existing institutional egress |

Return values may take the form `{result: string}`. Inspect the string's actual content or error before parsing; do not assume it contains a successful JSON response. Download tools may return paths on the MCP server. Confirm that the current environment can access those paths before treating files as read.

## Query Strategy

- Start with 10–20 results per query to orient the search. If important results are missing, adjust synonyms, authors, titles, or branch terminology rather than mechanically increasing result counts.
- Use exact-title searches to confirm identity and broad synonym queries to discover omissions; neither replaces the other.
- Scholar results may point to publishers, author repositories, PubMed, or other field-specific sources. Use available web tools for follow-up when needed, noting that this evidence was not supplied directly by aPaper.
- When no citation API is available, trace backward through accessible surveys and original-paper references, then search titles plus method names for follow-up work. Do not claim a complete forward-citation traversal.
- The past 24 months define an update window, not an exclusion rule for older leading work. Year-level filters provide only coarse screening; check actual public release dates against the exact cutoff.
- Existing local paper lists are seed evidence, not verified facts or substitutes for fresh searches. Preserve their local provenance and record the current verification status.

## Stopping, Fallbacks, and Cost

In the first pass, prioritize verifying core nodes and competing work that could affect conclusions rather than downloading every candidate. Roughly 2–4 representative surveys or overviews are enough to begin; a field need not have a survey.

Record a search failure once, then switch sources rather than retrying indefinitely. Limited coverage can still support a clearly labeled preliminary map, but "not found" must not become "does not exist," and available results must not become "complete SOTA as of today."

Distinguish an upstream index failure from MCP authentication failure. If multiple aPaper tools return the same authentication error (for example, `Invalid username/password`), stop trying additional aPaper endpoints and report that the connection requires authentication repair. Do not ask the user to paste credentials into chat. Supplementary public sources can support a preliminary map, but record them as supplementary retrieval and do not claim aPaper retrieval succeeded.
