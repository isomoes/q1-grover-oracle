# Search and screening log

**Search date/cutoff:** 2026-09-27. **Recent window:** 2024-09-27–2026-09-27. **Coverage:** preliminary.

This log records discovery, source checking and screening for [report.md](report.md). It is a curated search record, not a raw export of every search-result payload. Result counts mean tool-returned records, not unique papers or total indexed matches. Unknown counts are stated explicitly. Optional parameters not retained in the working record are not reconstructed as facts.

## 1. Existing material versus new evidence

Local seeds read: `README.md`, `docs/research-plan.md`, `docs/reference.md` and `docs/references.bib`. They supplied the Q1 contract, AES-128-first scope, proposed experiments and G01–G09 paper aliases. P01–P09 preserve those identities; P10–P20 expand the core map. Existing metadata was a starting point, not independent new verification.

New checks included primary IACR/arXiv records and publication labels, backward references in P03/P06/P14/P15, selected full text, and author-artifact metadata. New findings include the P06 comparison omission and depth convention, P15's component boundary, P14's long version history, missing architectural competitors, the P03 resource-fix commit/toolchain discrepancy, and P20's September 2026 release. No experiments were run.

## 2. aPaper discovery

Tools were discovered before use. All queries below ran on **2026-09-27**. IACR used `search_iacr_papers`; Scholar used `search_google_scholar_papers`; arXiv used `search_arxiv_papers`; DBLP used `search_dblp_papers`, all through aPaper MCP. `max` below denotes `max_results`. Historical queries had no recent-date lower bound.

| Round | Source | Exact query | Retained parameters | Returned count / outcome | Screening use |
|---|---|---|---|---|---|
| Orientation | Scholar | `AES quantum Grover oracle resource estimates survey` | max=15 | 0 | No survey retrieved; not absence evidence |
| Orientation | IACR | `reversible AES quantum circuit optimization` | max=15 | 2 | Initial relevant circuit candidates; expanded beyond narrow wording |
| Orientation | DBLP | `AES quantum` | max=20; include_bibtex=true | Failed: `Expecting value: line 1 column 1 (char 0)` | No DBLP records/BibTeX obtained in this run |
| Orientation retry | Scholar | `quantum AES circuit` | max=15 | 0 | Switched to primary records and supplementary web search |
| Recent branches | IACR | `AES quantum` | max=20; year_min=2024; year_max=2026 | 20 | Modern AES candidate pool; versions/status checked separately |
| Recent branches | arXiv | `all:AES AND (all:Grover OR all:quantum)` | max=15; date_from=2024-09-27; date_to=2026-09-27; sort_by=submittedDate | 0 | Known relevant records subsequently found by direct/supplementary retrieval |
| Historical | IACR | `AES quantum` | max=20; year_max=2023 | 20 | Historical AES synthesis and scheduling candidates |
| Frontier | IACR | `quantum circuit` | max=15; year_min=2026; year_max=2026 | 0 | Contradicted by later verified 2026 records; filter coverage unreliable |
| Attack accounting | IACR | `Grover depth parallel` | max=10 | 7 | Depth-limited/parallel-search context; no separate global ranking inferred |
| Targeted follow-up | IACR | `Low-Depth Construction of Grover Oracles` | max=5 | 1 | P15; selected for full-text boundary check |
| Frontier retry | IACR | `AES` | max=15; year_min=2026; year_max=2026 | 0 | No absence conclusion drawn |
| Cleanup | IACR | `uncomputation Grover` | max=10; year_min=2024; year_max=2026 | 2 | Cleanup/oracle transformation expansion |
| Linear scheduling | IACR | `CNOT linear depth` | max=10; year_min=2024; year_max=2026 | 2 | Included out-of-range ePrint 2023/617; reinforced filter concern |

The search tools' year/date filters and zero-result responses were not treated as reliable completeness guarantees. Primary landing-page histories govern the recorded paper dates. No CNKI search was needed for this scope.

## 3. Supplementary discovery and backward tracing

The following exact queries used the available web-search integration on **2026-09-27**. Returned counts were not retained (**unknown** for every row). These queries supplemented failed/sparse aPaper sources; search snippets were not used alone to establish leading numerical results.

| Exact query | Purpose / candidates checked |
|---|---|
| `AES quantum circuits 2026 Grover oracle optimization` | Frontier and missing AES architectures |
| `"Reducing the Cost" "AES" "Quantum" Langenberg` | P10 preprint/publication identity |
| `"Improved Quantum Circuits for AES" Liu 2023` | P13 and its ASIACRYPT record |
| `"Zou" "Quantum Circuits" "AES" 2020` | P11 and its CryptoDB record |
| `"de Brugière" "depth" "CNOT" greedy` | P17, named as P04's method antecedent |
| `"Reducing the depth of linear reversible quantum circuits" arxiv` | P17 journal year versus later repository deposit |
| `"AES" "quantum circuit" "2026" "Grover" optimization September` | Latest AES/tool candidates, including follow-up source checks |
| `"AES" "S-box" "2026" "T-depth"` | Chen et al. publication/version watchlist |
| `"Grover oracle" "uncomputation" "2025" "2026"` | P15 and related cleanup candidates |
| `"Rise of conditionally clean ancillae"` | P19 primary record, open HTML and journal identity |

Backward tracing used P03's introduction/§4, P06's Tables 4/10 and bibliography, [P14's publication references](https://cic.iacr.org/p/2/1/25), and P15 Appendix B. This supplied historical and architectural candidates beyond the original G01–G09 list. Direct retrieval of known arXiv records, publisher pages and author repositories provided a second independent source family beyond IACR search.

## 4. Primary-record verification and reading level

Full authors, identifiers, version dates, URLs and claim-level locators are in [papers.json](papers.json). Each core paper has at least one primary source. Unknown exact first-public dates remain null; received and approved dates are distinguished where known.

| Papers | Primary source checked | Reading/verification outcome |
|---|---|---|
| P01, P02, P18 | arXiv quant-ph/9605043, 1512.04965, quant-ph/9605034 | Abstracts, version histories and journal/conference references; upload order is not invention priority |
| P03 | IACR 2019/1146; corrected PDF | Selected introduction, §3.3, §6 and Table 9; 2023-06-07 correction retained |
| P04, P05, P09, P10, P12, P16, P20 | IACR 2024/381, 2025/212, 2026/1815, 2019/854, 2022/620, 2025/1915, 2026/2191 | Abstracts/metadata/history; no theorem or circuit audit |
| P06 | IACR 2025/1494; revised PDF | Selected Table 4, footnote 3, Appendices F–H and references; confirmed omitted comparison, measurement-aware depth convention and fixed-key Appendix H |
| P07 | arXiv 1709.06648v3 open HTML | Full-text HTML, especially Figures 3 and 5; four-T compute/zero-T measurement-assisted cleanup and compatibility limits |
| P08 | Author repository `paper-codes/2024-QCE` | Metadata/README only, including citation and different QRAM assumptions |
| P11 | IACR CryptoDB pubkey 30716 | ASIACRYPT 2020 identity, DOI, authors and abstract |
| P13 | IACR 2023/1417; CryptoDB pubkey 33484 | Abstract, date, publication and explicit P12 antecedent |
| P14 | IACR 2022/683; CIC `/p/2/1/25` | Abstract, history, DOI, publication identity and references; no original resource-table audit |
| P15 | IACR 2026/568; full-version PDF | Selected §1.1, §3.2, §4 and Appendix B; component boundary and arithmetic/depth caveats |
| P17 | arXiv 2201.06380 | Abstract and 2021 IEEE journal identity; 2022 arXiv deposit merged into same paper |
| P19 | arXiv 2407.17966v2 open HTML; journal metadata | Selected §1–5.2/Table 1 and §6.3 heading; measurement-based clean-ancilla cleanup distinguished from borrowed-state restoration |

### Essential PDF downloads

Used aPaper `download_iacr_paper` with paper IDs `2019/1146`, `2025/1494`, `2026/568` and `save_path=/tmp/opencode/q1-landscape-papers`. Read selected passages from local text extractions. These temporary files are not committed; hashes permit identification of the checked bytes even if the current ePrint PDF changes.

| ID | Local PDF basename | SHA-256 |
|---|---|---|
| P03 | `iacr_2019_1146.pdf` | `e1b693ed4e5ec428258fc324f969ca565f7e53f460992fcb68a9f61ca36af4b8` |
| P06 | `iacr_2025_1494.pdf` | `744c4f2c73716d0f6d8aabf8781003dbdb5f6e01944029ef0a638271f962e4e9` |
| P15 | `iacr_2026_568.pdf` | `aaac64b6da50304375202220302fd65f6f2551795d551a07c8efa42a2ee0e1bb` |

### Artifact inspection, separately from reproduction

- **P03:** public GitHub commit metadata, remote ref check, repository tree, README/installation notes and pinned `aes/cswrapper.csproj`. Resource-fix merge `fe65e0b29f6c3c3be02ca839259b91f2e71233bc`, dated 2023-06-05. Project metadata pins Quantum SDK/Standard 0.27.244707, net6.0 and FileHelpers 3.4.1; installation notes are older. Source algorithms were not audited, installation not tested, tables not reproduced.
- **P06:** `lhyGovinda/AES-with-In-Place-S-Boxes` README describes two S-box correctness/resource implementations. No source audit or execution; no end-to-end artifact inferred from the repository title.
- **P08:** `paper-codes/2024-QCE` README describes S-box tests and attack metric generation. No source audit or execution.
- **P20:** paper abstract only. Qarton code not inspected.

## 5. Screening decisions and retained competitors

Core selection balanced historical search/AES foundations, route-defining methods, directly relevant architecture competitors, recent work and reproducibility. Twenty papers are a reading-load choice, not a claim that other papers are unimportant. Preprints are labeled; no universal leader was selected.

| Candidate or category | Decision and reason |
|---|---|
| Chen/Cai/Gao/Lin, IACR 2025/454, arXiv 2503.06097, DOI 10.1007/s11128-026-05083-7 | Retained watchlist. arXiv v2 2025-08-01 and QIP 2026 publication metadata checked. Springer main page failed; SpringerProfessional publisher metadata was accessible. Abstract wording changed; the 102,800 T-depth×width claim needs oracle-boundary verification. Could change the frontier; not ranked against P06 |
| IACR 2025/1664, large-S-box MILP | Retained watchlist. U+CX-transpiled depth is not the project's normalized Clifford+T metric; full interface and end-to-end costs unverified |
| IACR 2026/1446, LLM-assisted optimization | Retained watchlist. Preprint revised 2026-08-06; retrieved material chiefly concerns lightweight-cipher implementations, not a verified complete AES record |
| ADOQ and newer multi-controlled-gate decompositions | Retained unresolved discovery leads. Dedicated identity/version/cost-model verification required; not fabricated into core cards |
| IACR 2023/617 | Returned outside the requested recent-year range. Not included solely to fill the linear route; full relevance/identity verification not completed |
| Alternative arithmetic/linear synthesis foundations and generic pebbling | Outside this compact AES-focused core; expand if these methods become the proposed contribution. P07/P17 are scoped anchors, not universal origin claims |
| Fixed-key encryption/Simon interfaces | Relevant context, but excluded from the Q1 candidate-key cost ranking. Specifically P04's separate encryption-oracle claim and P06 Appendix H |
| QRAM-dependent 3DES meet-in-the-middle | Separate from the QRAM-free baseline; P08 retained only as a carefully labeled portability/accounting reference |
| Physical error-correction/factory costs | Outside initial logical-resource scope; no physical runtime inferred from logical depth×width |
| Earlier versions of P03/P06/P14/P19 and journal/preprint duplicates | Merged into their paper node. Corrected/revised claims not backdated to original releases |

## 6. Evidence review and stopping rule

All five routes have historical anchors, turning points and recent candidates, but the final expansion still found important work (notably P20 and frontier watchlist items). Search saturation therefore **was not reached**. The report is preliminary, and recent search filters need independent rechecking.

Key manual checks: P03 Table 9 row and correction scope; P06 footnote 3 and Appendix G/H boundaries; P15 Appendix B exclusions and arithmetic typo; P14 revision chronology; P19 equality versus LessThanConst; distinct gate/measurement models; no unsupported improvement edges or global-best claims. Numerical rows are transcriptions, not reproduced experiments.

Required structural check:

```sh
python3 .agents/skills/research-landscape/scripts/validate.py research-landscape/q1-grover-oracle
```

**Validation outcome:** PASS. Additional consistency checks confirmed 20 unique paper IDs/BibTeX keys, five routes, 20 graph edges matching the JSON, an exact embedded graph, valid local Markdown links, no trailing whitespace and the cited resource products. The three PDF hashes were rechecked against the downloaded bytes. `git diff --check` passed.

**Graph preview:** rendered `graph.mmd` to `/tmp/opencode/q1-landscape-graph.png` with Mermaid CLI and local Chromium, then visually inspected all five groups, node labels and edge labels. Rendering succeeded with `--size 3000`; the initial invocation's older `-w` option was unsupported and was replaced after checking CLI help. The editable Mermaid source remains the delivered graph; the PNG is a temporary verification artifact.

The validator checks structure and cross-file references, not scholarly truth. Outstanding scholarly questions are listed in report §8.
