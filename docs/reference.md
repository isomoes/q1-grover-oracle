# References: Q1 Grover oracle optimization

Curated on **2026-09-10**, starting from the [parent survey](https://github.com/isomoes/paper-plan/blob/23c2b0707c7f9d5c19ed243f119208344dc5307a/docs/research-pq-symmetric/survey.md), whose literature cutoff is 2026-09-08. This is a focused reading list, not a citation-count ranking or exhaustive review. It prioritizes established algorithmic foundations and directly relevant work in EUROCRYPT, ASIACRYPT, PQCrypto, Quantum, and IEEE QCE. G09 is a separately labeled preprint.

[BibTeX entries](references.bib) use the citation keys shown below. Metadata and abstracts were checked where stated; no paper's proofs, circuits, or numerical tables have been independently reproduced for this initialization. Parent-survey A identifiers preserve provenance. Where a revised ePrint is cited, its date matters independently of the conference year.

## Reading order

Read **G01 → G02 → G03** for search and full-oracle accounting, **G04 → G05 → G06** for AES optimization, then **G07** for compute/uncompute techniques and **G08** for a second implementation case. Evaluate **G09** after establishing a reproducible baseline.

## Core papers

### G01. Grover's search algorithm

Lov K. Grover. **A Fast Quantum Mechanical Algorithm for Database Search.** STOC 1996, pp. 212–219.

Sources: [author preprint](https://arxiv.org/abs/quant-ph/9605043), [ACM DOI](https://doi.org/10.1145/237814.237866). Citation key: `Grover1996Search`.

The foundation for unstructured quantum key search. Use it to distinguish iteration/query complexity from the gate cost of implementing a cipher predicate. For this project, marked keys are those satisfying the entire classical transcript, so the number of solutions and final key verification must be specified. The author preprint was accessed; the ACM landing-page request failed during this check.

### G02. Early AES resource baseline

Markus Grassl, Brandon Langenberg, Martin Roetteler, and Rainer Steinwandt. **Applying Grover's Algorithm to AES: Quantum Resource Estimates.** PQCrypto 2016, pp. 29–43.

Sources: [Springer publication](https://link.springer.com/chapter/10.1007/978-3-319-29360-8_3), [author preprint](https://arxiv.org/abs/1512.04965). Citation key: `GrasslLRS2016AES`.

A foundational Clifford+T resource analysis for AES-128/192/256 key search using classical plaintext/ciphertext pairs. Use it as a historical width, gate-count, and depth baseline. Its preprint appeared in 2015; the formal publication is 2016. Compare with later corrected and optimized circuits under consistent assumptions. Authors, venue, pages, and DOI were checked against Springer.

### G03. Complete Grover oracles and depth restrictions — parent A04

Samuel Jaques, Michael Naehrig, Martin Roetteler, and Fernando Virdia. **Implementing Grover Oracles for Quantum Key Search on AES and LowMC.** EUROCRYPT 2020, Part II, pp. 280–310.

Sources: [ePrint 2019/1146](https://eprint.iacr.org/2019/1146), [publication DOI](https://doi.org/10.1007/978-3-030-45724-2_10). Citation key: `JaquesNRV2020Grover`.

The main reproduction starting point: complete Q# oracle implementations and estimates under depth restrictions, including depth-times-width costs. The official ePrint page states that the **2023-06-07 revision corrects AES estimates affected by Q# bugs; LowMC estimates were not revised**. Pin the paper and artifact revisions before comparing numbers. The revision warning and publication identity were rechecked on IACR.

### G04. AES linear layers and pipeline structure — parent A17

Haotian Shi and Xiutao Feng. **Quantum Circuits of AES with a Low-Depth Linear Layer and a New Structure.** ASIACRYPT 2024, Part VIII, pp. 358–395.

Sources: [ePrint 2024/381](https://eprint.iacr.org/2024/381), [Springer publication](https://link.springer.com/chapter/10.1007/978-981-96-0944-4_12). Citation key: `ShiFeng2024AESCircuits`.

Study CNOT synthesis for linear layers and the interaction between cipher structure, depth, and ancillas. Distinguish encryption-oracle improvements from the full key-search phase oracle. IACR's 2024-10-06 revision and ASIACRYPT identity were rechecked; pages and DOI follow the parent survey's publisher verification. The conference year is 2024, while Springer's citation copyright year is 2025.

### G05. Nonlinear components with low T-depth or width — parent A10

Zhenyu Huang, Fuxin Zhang, and Dongdai Lin. **Constructing Quantum Implementations with the Minimal T-depth or Minimal Width and Their Applications.** EUROCRYPT 2025; revised ePrint 2025/212.

Source: [official ePrint and publication label](https://eprint.iacr.org/2025/212). Citation key: `HuangZL2025Minimal`.

Provides constructions for Boolean functions and field inversion, with AES S-box and SHA3 applications. Read the low-T-depth and low-width constructions as different resource tradeoffs. Any minimality statement is relative to the paper's specified setting. IACR identifies the 2025-03-04 version as a major revision of a EUROCRYPT 2025 paper. The bibliography cites that ePrint version; unverified formal page/DOI fields are omitted.

### G06. Joint AES synthesis for low D×W — parent A11

Haoyu Liao and Qingbin Luo. **Quantum Circuit Synthesis for AES with Low DW-Cost.** ASIACRYPT 2025; revised ePrint 2025/1494.

Sources: [official ePrint](https://eprint.iacr.org/2025/1494), [Springer publication](https://link.springer.com/chapter/10.1007/978-981-95-5096-8_15). Citation key: `LiaoLuo2025DW`.

Directly relevant to coordinating in-place S-boxes, round functions, and key expansion. The **2025-11-27 revision adds Clifford+T estimates for AES-128 encryption and Grover oracles**. Compare complete circuits using the same gate model; reported percentage savings do not transfer automatically between cost models. IACR's venue and revision were rechecked. The BibTeX entry identifies the revised ePrint rather than mixing proceedings and revision metadata.

### G07. Temporary logical-AND and uncomputation

Craig Gidney. **Halving the Cost of Quantum Addition.** Quantum 2, article 74, 2018.

Sources: [journal publication](https://doi.org/10.22331/q-2018-06-18-74), [author preprint](https://arxiv.org/abs/1709.06648). Citation key: `Gidney2018Addition`.

A useful source for temporary logical-AND constructions and compute/uncompute cost asymmetry, including applications to Grover oracles. Check ancilla and measurement conditions before adopting the technique; the resulting resource model can differ from a strictly unitary circuit. Journal metadata and abstract were checked directly. This is a component technique, not an AES attack-cost result.

### G08. Another complete key-search implementation — parent A22

Simone Perriello, Alessandro Barenghi, and Gerardo Pelosi. **A Quantum Circuit to Execute a Key-Recovery Attack Against the DES and 3DES Block Ciphers.** IEEE QCE 2024, pp. 1–12.

Sources: [publication DOI](https://doi.org/10.1109/QCE60285.2024.00011), [authors' artifact](https://github.com/paper-codes/2024-QCE), [IEEE accepted-paper list](https://qce.quantum.ieee.org/2024/wp-content/uploads/sites/8/2024/08/QCE24-Accepted-Technical-Papers-by-Track-QALG-QSYS-QAPP-QPHO-QNET-QTEM-QML.pdf). Citation key: `PerrielloBP2024DES`.

A cross-cipher implementation reference for complete key recovery and reproducibility. Its role is methodological; it does not define the initial AES baseline. Metadata follows the parent survey's 2026-09-09 check of IEEE, DBLP, and the author artifact. The parent audit could not access the IEEE DOI landing page. The artifact has not been run here.

## Preprint to evaluate

### G09. Bounded SMT circuit synthesis — parent A16

Youbo Guo, Fengrong Zhang, Lei Liao, Yongzhuang Wei, Baocang Wang, and Xiaogang Zhou. **Novel SMT Encoding for Quantum Circuit Optimization.** Cryptology ePrint Archive, 2026/1815.

Source: [official preprint](https://eprint.iacr.org/2026/1815). Citation key: `GuoZLWWZ2026SMT`.

**Preprint; formal acceptance unverified.** Received 2026-08-27 and approved 2026-08-28 in the checked record. A candidate source for small S-box and linear-layer synthesis experiments. Independently validate witnesses and optimality bounds within the stated gate set, ancilla restrictions, and objective. NCT gate optimality does not establish a Clifford+T or full-oracle optimum.

## Citation maintenance

Retain exact author lists and publication identities; distinguish conference year from later online/copyright dates. Record any later revision and the specific theorem/table used by an experiment. Add numerical comparisons only after checking the same gate set, workspace semantics, pair count, and success-probability target. Do not treat this curated selection as evidence that a proposed optimization is novel.
