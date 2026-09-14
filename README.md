# Q1 Grover Oracle Optimization

Research on optimizing quantum circuits for complete Grover key-search oracles against symmetric ciphers in the **Q1 model**.

Q1 allows local quantum computation while queries to the target's secret-key encryption interface remain classical. A reversible implementation of the public cipher with a candidate key in superposition is therefore part of the local attack computation.

This repository starts from direction **D1** of the [post-quantum symmetric cryptography survey](https://github.com/isomoes/paper-plan/blob/23c2b0707c7f9d5c19ed243f119208344dc5307a/docs/research-pq-symmetric/survey.md). Its initial target is AES-128; AES-192/256 and a second primitive are follow-up comparisons after the baseline is reproducible.

## Research question

Can jointly optimizing nonlinear layers, linear layers, key scheduling, comparison, and uncomputation lower the cost of a complete Grover iteration under the same width, depth, gate-set, and success-probability constraints?

The intended result is a reproducible comparison of complete attack oracles and their depth/width tradeoffs. Candidate improvements include ancilla reuse, reversible scheduling, linear-layer synthesis, and compatible compute/uncompute constructions. These are research hypotheses; novelty and improvements remain to be established.

## Start here

- [Research plan and model](docs/research-plan.md)
- [Annotated paper references and reading order](docs/reference.md)
- [Papers we have read (issue #1)](https://github.com/isomoes/q1-grover-oracle/issues/1)
- [BibTeX bibliography](docs/references.bib)
- [Experiment record template](experiments/template.md)

## Initial milestones

- [ ] Pin the corrected AES baseline from Jaques et al. and its implementation revision.
- [ ] Reproduce an AES-128 encryption circuit, then its complete phase oracle and diffuser.
- [ ] Validate encryption, phase marking, and workspace cleanup independently.
- [ ] Compare optimization variants at matched resource constraints.
- [ ] Release commands, pinned dependencies, circuits, and measured result tables.

**Status:** research scaffold. This initial commit contains the plan, references, and experiment protocol. Circuit implementations and benchmark results are pending.

The companion project, [Quantum Symmetric Distinguishers](https://github.com/isomoes/quantum-symmetric-distinguishers), studies structural distinguishers and the assumptions needed to turn them into attacks.

## License

Original repository material is available under the [MIT License](LICENSE). Linked papers and third-party artifacts retain their own licenses.
