# Deep-Reading Techniques and Source Triage

## Read to Answer a Question

Use the reader's question to determine what to inspect. A paper ID alone authorizes resolving the paper and a brief account of what it does, not choosing questions or beginning a lesson. For a requested overview, inspect the relevant abstract/introduction/results at that scope. For a specific question, inspect the methods/proof/evidence needed to answer it. An old assistant-selected next step does not establish the reader's interest.

Explain necessary prerequisites within the answer. Use the simplest useful level, then return to the paper's exact notation and assumptions. Avoid replacing a difficult step with “it is obvious.” If evidence is missing, state the gap without turning it into an unsolicited reading assignment.

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

For scratch computations, keep generated files and logs in Git-ignored `work/`. Record durable inputs, assumptions, commands or derivations, and observed results in `reading.md`, selected notes, or synthesis; link scratch outputs only as optional local aids. A numerical check is not a substitute for the paper's proof. An artifact run is not table reproduction unless settings and results were matched.

## Results and Comparisons

Read captions, footnotes, variants, and baseline provenance before using a table. Identify the cost or measurement boundary: a subroutine, one iteration, an entire run, or a deployed system. Compare like with like; when normalization is needed, record the transformation and assumptions rather than silently adjusting numbers.

For the Q1 Grover-oracle topic, useful checks include the classical-query/local-quantum distinction; fixed-key versus superposed-candidate-key computation; encryption versus predicate versus phase oracle versus full iteration; comparison, marking, diffuser, and workspace cleanup; plaintext/ciphertext pair count; success probability; gate set; width versus T-depth versus full depth; and unitary versus measurement-assisted operations. These are topic-specific examples, not required sections for unrelated papers.

## Respond to the Reader's Understanding

When the reader offers an interpretation, preserve what is correct and explain any precise gap against the source. Attribute their wording separately from the assistant's reconstruction. If they ask to save it, make the note useful for reconstructing the reasoning later.

Do not request a paraphrase, assign an exercise, test comprehension, or append a next question by default. Those activities belong only in explicitly requested practice or guided reading. Answering well does not require steering the reader's next move.
