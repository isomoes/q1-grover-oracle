# Theory

Foundations for a Q1 Grover key-search attack on AES-128, with a Lean 4 library
for the transcript predicate and the clean phase-oracle contract.

Start with [the mathematical model and proof roadmap](foundation.md). The
[research plan](../docs/research-plan.md) defines the experiment and resource
accounting requirements.

## Build

With [elan](https://github.com/leanprover/elan) available, run from this directory:

```sh
lake build
```

The project pins Lean **4.31.0** and uses its bundled `Std` library. The default
build checks all proofs and examples; warnings are treated as errors. The
current proofs contain no `sorry` or project-defined axioms.

## Modules

| File | Content |
| --- | --- |
| [Q1Grover/Model.lean](Q1Grover/Model.lean) | Public block-cipher interface, fixed classical data, matching predicate, secret-key acceptance, transcript extension, and conditional uniqueness |
| [Q1Grover/Oracle.lean](Q1Grover/Oracle.lean) | Signed-basis semantics, reversible computation, and compute–mark–uncompute correctness with full workspace cleanup |
| [Q1Grover/AES128.lean](Q1Grover/AES128.lean) | 128-bit key/block types and the AES-sized specialization of the oracle contract |
| [Q1Grover/Examples.lean](Q1Grover/Examples.lean) | Toy checks for ambiguous keys, relative signs, and cleanup of temporary garbage |

The central result is `PredicateComputation.clean_oracle`: any phase-free
reversible computation satisfying the predicate interface yields the required
signed-basis oracle. `AES128.CipherModel` is currently an abstract interface;
concrete AES conformance and Grover's success probability remain proof targets.

## Next milestones

1. Define AES-128 from **FIPS 197-upd1**, fixing byte/state layout and key expansion;
   check known-answer vectors and prove its permutation properties.
2. Give reversible AES and comparison circuits semantics, then discharge
   `PredicateComputation.computes` and the inverse laws for their entire workspace.
3. Add finite complex-state semantics, lift the signed-basis theorem, and prove
   the diffuser and Grover rotation/success formula.
4. Connect verified circuits to the experiment code's logical resource counts.
