# P03 — Implementing Grover oracles for quantum key search on AES and LowMC

## What the paper does

The paper studies quantum key search under a circuit-depth restriction, designs lower-depth AES and LowMC circuits, and provides Q# implementations of their full Grover oracles with automated resource estimates. The authors report lower attack costs in gate-count and depth-times-width models. This summary is supported by S01's abstract; it is not an independent reproduction.

Shared identity: [P03 / G03 in the registry](../../landscape/papers.json), citation key `JaquesNRV2020Grover`; [landscape entry](../../landscape/report.md). The reading session uses the corrected ePrint dated **2023-06-07**, associated with the EUROCRYPT 2020 paper. Active full-text source: **S02**, the [locally retained corrected paper](../../sources/iacr_2019_1146_corrected_2023-06-07.pdf); contribution summary checked using S01. The correction revises AES estimates for Q# issues; LowMC estimates were not revised.

## Reader's questions

None yet. On 2026-09-28, the reader selected P03 for this reading session.

## Selected notes

None selected yet.

<a id="sources"></a>
## Source inventory and inspection coverage

<a id="s01"></a>
### S01 — IACR ePrint primary record and abstract

- Role: target.
- Origin: https://eprint.iacr.org/2019/1146.
- Version: corrected ePrint, 2023-06-07; initial submission 2019-10-03; publication EUROCRYPT 2020. Dates and DOI checked against the primary record.
- Access: remote, checked 2026-09-28. No retained local copy.
- Inspection level: abstract and metadata. Inspected: abstract, correction note, publication metadata, and revision-history summary.
- Supports the contribution summary and version distinction above. Full-text passages have not been newly inspected in this session.

<a id="s02"></a>
### S02 — Corrected ePrint PDF

- Role: target.
- Origin: https://eprint.iacr.org/2019/1146.pdf; downloaded via aPaper on 2026-09-28.
- Version: corrected ePrint, 2023-06-07, identified by the primary record and an exact match to the previously recorded full-text checksum.
- Local copy: [iacr_2019_1146_corrected_2023-06-07.pdf](../../sources/iacr_2019_1146_corrected_2023-06-07.pdf).
- Access: local; PDF signature and file existence verified; 567,820 bytes.
- SHA256: `e1b693ed4e5ec428258fc324f969ca565f7e53f460992fcb68a9f61ca36af4b8`. Compared against all existing shared PDFs; no byte-identical duplicate found.
- Inspection: no new full-text inspection during download. Historical selected-section coverage is recorded below.

### Inherited landscape evidence

The existing registry records selected full-text inspection of the introduction, §3.3, §6, and Table 9 in the corrected ePrint, including the omitted diffuser in §6.2 attack costing. That historical coverage is preserved, not treated as new inspection or reader understanding. The earlier inspected copy's checksum matches the now-retained S02 file.

## Artifact inspection

Inherited registry context: [microsoft/grover-blocks at fe65e0b29f6c3c3be02ca839259b91f2e71233bc](https://github.com/microsoft/grover-blocks/tree/fe65e0b29f6c3c3be02ca839259b91f2e71233bc), dated 2023-06-05. Prior inspection covered project metadata only (`aes/cswrapper.csproj` and `INSTALL.md`); no code execution or table reproduction. No artifact inspection was added in this session.
