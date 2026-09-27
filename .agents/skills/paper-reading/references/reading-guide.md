# Deep-Reading Techniques and Source Triage

## Read to Answer a Question

Use the user's question to choose a path through the paper. An initial pass may inspect the abstract, introduction, contribution list, main result, figures, limitations, and conclusion to identify the technical core. This is orientation, not a completed deep reading. Then inspect the methods/proof/evidence relevant to the selected question.

Teach missing prerequisites just in time. Explain a concept at the simplest useful level, then return to the paper's exact notation and assumptions. Avoid replacing a difficult step with “it is obvious” or hiding it in a polished summary. If a step remains unresolved, identify the smallest missing link.

## Choose Related Resources Deliberately

| Need | First resource to inspect | What to retain |
|---|---|---|
| Undefined prerequisite or borrowed lemma | Cited primary paper or a reliable textbook | Definition/statement, assumptions, mapping of notation |
| Missing proof or implementation detail | Appendix, supplement, official artifact | Exact lemma, algorithm, file/function, version |
| Result differs across versions | Revision history, erratum, corrected text | Which result changed and which notes it affects |
| Baseline or improvement claim | Original baseline and comparison footnotes | Matching conditions, accounting boundary, checked values |
| Intuition remains difficult | Author talk, lecture notes, worked example | Explanatory role; distinguish from primary evidence |
| Apparent limitation or contradiction | Later analysis plus original passage | Competing interpretations and unresolved evidence |

Do not expand into a full citation survey. Give a newly found paper its own reading record only if it becomes a substantive reading target; otherwise retain a source entry explaining its supporting role. Keep paper-local source IDs distinct from landscape-wide source IDs: use qualified references such as `P03/S02` across files.

## Equations and Proofs

1. State the exact proposition, quantifiers, domains, and assumptions.
2. Define each new symbol, including units, normalization, and indices.
3. Identify the dependency of each major step: definition, algebraic identity, cited lemma, approximation, probabilistic event, or empirical observation.
4. Reconstruct omitted steps explicitly, marking them as a reconstruction until checked against the source. Do not ascribe your derivation to the authors.
5. Work a small case or check limiting behavior when it tests the reasoning. A small case is a sanity check, not a proof of the general result.
6. Separate existence, construction, efficiency, and optimality claims. State where a lower bound or counterexample would be needed.

Inspect rendered pages when extraction damages subscripts, signs, matrices, figures, or equation ordering. Record both printed and viewer page numbers when they differ; prefer stable section and equation labels over uncertain page numbers.

## Algorithms and Implementations

Explain inputs, outputs, invariants, state changes, and failure conditions. Map pseudocode to named files/functions at a recorded commit only after inspection. Code availability, reading a README, inspecting implementation, executing a command, and reproducing a published result are separate levels of evidence. Do not claim the stronger level based on the weaker one.

For scratch computations, record the inputs, assumptions, command or derivation, and observed result in `work/`, linking from `reading.md`. A numerical check is not a substitute for the paper's proof. An artifact run is not table reproduction unless settings and results were matched.

## Results and Comparisons

Read captions, footnotes, variants, and baseline provenance before using a table. Identify the cost or measurement boundary: a subroutine, one iteration, an entire run, or a deployed system. Compare like with like; when normalization is needed, record the transformation and assumptions rather than silently adjusting numbers.

For the Q1 Grover-oracle topic, useful checks include the classical-query/local-quantum distinction; fixed-key versus superposed-candidate-key computation; encryption versus predicate versus phase oracle versus full iteration; comparison, marking, diffuser, and workspace cleanup; plaintext/ciphertext pair count; success probability; gate set; width versus T-depth versus full depth; and unitary versus measurement-assisted operations. These are topic-specific examples, not required sections for unrelated papers.

## From Understanding to Judgment

Use one focused exercise when helpful:

- “Which assumption would this alternative violate?”
- “Can you explain why this term appears without rereading the formula?”
- “Does this table support the whole-system claim, or only the measured component?”
- “What additional evidence would turn this candidate explanation into a supported conclusion?”

If the user's paraphrase is partially correct, preserve the correct part and explain the precise gap. Record their demonstrated reasoning only when observed, and unresolved confusion without judgment. Saved notes should help the user reconstruct an argument later, not merely memorize a conclusion.
