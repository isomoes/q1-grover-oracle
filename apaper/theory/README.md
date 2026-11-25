# Theory

Foundations for a Q1 Grover key-search attack on AES-128. This is a Lean 4 library
covering the transcript predicate, a gate-level phase-oracle contract, and gate counts.

Start with [the mathematical model and proof roadmap](foundation.md). The
[research plan](../../docs/research-plan.md) defines the experiment and resource
accounting requirements.

## From a research question to an experiment

When a question depends on a theoretical prediction, use the [experiment skill](../../.agents/skills/research-experiment/SKILL.md) to identify the smallest model that expresses it. Keep reusable abstractions here; cite the definition or theorem in the [experiment record](../result/template.md) and identify the output that tests its prediction. Empirical comparisons, reproductions, and exploratory measurements can start directly from a protocol. An observation on one instance is not a proof for all instances.

## Build

With [elan](https://github.com/leanprover/elan) available, run from this directory:

```sh
lake exe cache get   # first time: fetch prebuilt Mathlib
lake build
```

The project pins Lean **4.31.0** and Mathlib **v4.31.0**. Mathlib was added now because
the next layer needs it anyway (complex amplitudes, finite sums, `arcsin`/`sin` for the
Grover success formula). It already supplies `Finset`/`Fintype`, used to count marked keys.

The default build covers the library `Q1Grover` and the test library `Q1GroverTest`.
Warnings are treated as errors. The proofs contain no `sorry` or project-defined axioms.
`Q1GroverTest/Axioms.lean` checks during the build that the main results depend only on
Lean's standard axioms (`propext`, `Classical.choice`, `Quot.sound`); a new axiom
dependency breaks the build.

## Modules

| File | Content |
| --- | --- |
| [Q1Grover/Model.lean](Q1Grover/Model.lean) | Block-cipher interface, transcript predicate, secret acceptance, transcript extension, `Q1Data.ofCollect`, marked-key set $\mathcal M_T$ and count $M$, and uniqueness ⇔ $M=1$ |
| [Q1Grover/Oracle.lean](Q1Grover/Oracle.lean) | Signed-basis semantics, abstract reversible computation, and the abstract compute–mark–uncompute contract `PredicateComputation` |
| [Q1Grover/Circuit.lean](Q1Grover/Circuit.lean) | NCT+`Z` gate syntax on `BitVec n`, its semantics, inverse, gate-family counts, and the implementation contract `CircuitOracle` |
| [Q1Grover/AES128.lean](Q1Grover/AES128.lean) | 128-bit key/block types, $N=2^{128}$, bounds on $M$, and the AES-sized `Implementation` contract |
| [Q1GroverTest/Examples.lean](Q1GroverTest/Examples.lean) | Toy transcript ambiguity, relative signs, abstract cleanup, and a witness that the abstract contract is permissive |
| [Q1GroverTest/Circuit.lean](Q1GroverTest/Circuit.lean) | A gate-level oracle with intermediate garbage: cleanup, signs, and gate counts |
| [Q1GroverTest/Axioms.lean](Q1GroverTest/Axioms.lean) | Axiom audit enforced by `#guard_msgs` |

The library has two layers:

- **`PredicateComputation`** (abstract). It states the semantic shape of
  compute–mark–uncompute, and `clean_oracle` follows from the inverse law. It doesn't
  constrain implementations: `flag` may evaluate the predicate itself
  (`Examples.abstract_contract_permissive`).
- **`CircuitOracle`** (implementation contract). It is the one concrete AES circuits must
  discharge. The computation is a gate list, and the mark is a single `Z` on one wire.
  `CircuitOracle.clean_oracle` proves full key and workspace restoration with sign
  $b\mapsto b\oplus f_T(K)$. `CircuitOracle.count_circuit` proves
  $C_g(O_T)=2C_g(U)+[g=Z]$ for each gate family $g$. Both refer to the same gate list.
  `Circuit.toReversible` connects the circuit layer to the abstract one.

`AES128.CipherModel` is still an abstract interface. AES conformance and Grover's success
probability remain proof targets.

## Scope relative to the circuit IR

The project circuit IR in `apaper/code/` is the source of truth for resources. The Lean gate
layer is a deliberately smaller fragment of it: fixed wires, NCT and `Z` gates only. It
doesn't yet model the following, though the project's cleanup-schedule work depends on
them:

- qubit `alloc`/`free` and ancilla lifetimes, and therefore width beyond the wire count;
- measurements and classically controlled corrections, such as measurement-based
  uncomputation of temporary ANDs;
- relative-phase gate substitutions, T gates, and depth or scheduling.

Planned extension, in order:

1. Add `alloc`/`free` as wire-in-zero assertions. A circuit is well formed when each
   freed wire is provably `0` on every reachable basis state; that is a cleanup
   obligation checked per freed wire.
2. Add measurement and feed-forward with a semantics that keeps the classical outcome.
   Prove that measurement-based uncomputation is equal in effect to coherent
   uncomputation on the relevant inputs.
3. Export from the IR to the Lean `Circuit` syntax, so the circuit that was verified is
   the one that was counted.

## AES definition: conventions for milestone 1

- **Bit order.** Wire `i` is bit `i` of `BitVec n` (`getLsbD i`). Key wires are
  `0…127` and workspace wires follow (`cleanInput`). Fix the FIPS 197 byte → state →
  bit map once, record it here, and match the IR's ordering (see `apaper/code/README.md`).
  A mismatch here is the most likely source of a silent error.
- **Known-answer tests.** `decide` on 128-bit values over ten rounds is likely too slow
  in the kernel. Prefer `bv_decide`, or `rfl`/`decide` on definitions that reduce through
  `Nat` arithmetic. `native_decide` adds the `Lean.ofReduceBool` axiom. If it is used,
  confine it to the test library and update the axiom audit and this README.

## Next milestones

1. Define AES-128 from **FIPS 197-upd1**, fixing byte/state layout and key expansion.
   Check known-answer vectors and prove its permutation properties.
2. Build AES and comparison circuits as `Circuit` values and discharge
   `CircuitOracle.computes`, which yields `AES128.Implementation`.
3. Extend the circuit layer with `alloc`/`free` and measurements (see above).
4. Add finite complex-state semantics, lift the signed-basis theorem, and prove the
   diffuser and the Grover rotation/success formula.
5. Cross-check `Circuit.count` against the IR's gate-family counts on the same circuits.
