# Foundation: Q1 Grover key search on AES-128

The first proof target is a clean phase oracle for a fixed classical transcript.
This gives AES circuit development a precise correctness contract before gate
counts or attack-success estimates are attached to an implementation.

## 1. Cipher and classical data

Let the key space be $\mathcal K=\{0,1\}^{128}$ and the block space be
$\mathcal B=\{0,1\}^{128}$. A public block cipher is a family of permutations
$E_K:\mathcal B\to\mathcal B$, with inverse $D_K$ satisfying

$$
D_K(E_K(P))=P,\qquad E_K(D_K(C))=C.
$$

`BlockCipher` stores these functions and inverse laws. The AES specialization
uses `BitVec 128` for both spaces. A value of `AES128.CipherModel` currently
provides only this interface; conformance to AES requires a concrete definition
and proofs against [FIPS 197-upd1, May 9, 2023](https://doi.org/10.6028/NIST.FIPS.197-upd1).
The byte-to-state mapping and key-schedule representation belong to that next
definition.

Fix one secret key $K_\star$ and collect

$$
T=((P_1,C_1),\ldots,(P_r,C_r)),\qquad C_i=E_{K_\star}(P_i).
$$

The initial experiment requires $r\geq1$ and distinct plaintexts. `Q1Data`
records these two conditions; `Transcript.Matches cipher data secret` records
consistency with a particular secret. `Transcript.collect` describes classical
data generation from a fixed key, and `Q1Data.ofCollect` packages collected data
with both conditions (`Q1Data.ofCollect_matches` gives consistency).

The quantum search receives the public cipher and the classical transcript.
Candidate-key evaluation of $E_K$ is local quantum computation. The secret-key
target supplies classical data, and the model assumes no QRAM. This static
interface expresses the intended Q1 setting; a query-counted security game is
a separate formalization task.

## 2. Marked keys and the recovery objective

Define the matching predicate and marked-key set by

$$
f_T(K)=\bigwedge_{i=1}^{r}[E_K(P_i)=C_i],\qquad
\mathcal M_T=\{K\in\mathcal K:f_T(K)=1\}.
$$

Write $N=|\mathcal K|=2^{128}$ and $M=|\mathcal M_T|$. Consistency gives
$K_\star\in\mathcal M_T$, hence $M\geq1$. It does not give $M=1$.
Original-key recovery follows from transcript matching only under the additional
condition $\mathcal M_T=\{K_\star\}$.

The current Lean library proves:

| Result | Lean declaration |
| --- | --- |
| The executable predicate accepts exactly the keys matching every pair | `Transcript.predicate_eq_true` |
| The generating secret is marked | `Transcript.secret_is_marked` |
| Appending pairs intersects the matching conditions | `Transcript.matches_append` |
| Additional data cannot introduce new matching keys | `Transcript.matches_of_append` |
| Matching identifies the secret under explicit uniqueness | `Transcript.marked_iff_eq_secret` |
| An empty transcript accepts every key | `Transcript.predicate_nil` |
| $\mathcal M_T$ is exactly the matching keys | `Transcript.mem_markedKeys` |
| Consistency gives $1\le M\le N$; for AES, $N=2^{128}$ | `Transcript.markedCount_pos`, `AES128.markedCount_bounds`, `AES128.card_key` |
| Uniqueness is $\mathcal M_T=\{K_\star\}$, equivalently $M=1$ with $K_\star$ marked | `Transcript.uniqueKey_iff_markedKeys`, `Transcript.uniqueKey_iff_markedCount` |

The empty case remains available in the generic predicate and is excluded by
`Q1Data`. The toy cipher in `Q1GroverTest/Examples.lean` has two distinct keys that agree on
every plaintext. Its `toy_not_unique` theorem demonstrates that even complete
plaintext coverage does not imply key uniqueness for an abstract keyed
permutation. It makes no claim about AES key collisions.

For concrete AES data, uniqueness needs its own evidence or assumption. Any
ideal-cipher estimate for extra matching keys must be labeled as a probabilistic
approximation, as required by the [research plan](../docs/research-plan.md).

## 3. Complete phase-oracle contract

Let $\mathcal W$ describe the entire workspace and let $0_{\mathcal W}$ be its
initialized basis state. It includes cipher states, temporary round keys,
comparison flags, conjunction ancillas, and other scratch space. The required
action is

$$
O_T|K\rangle|0_{\mathcal W}\rangle
=(-1)^{f_T(K)}|K\rangle|0_{\mathcal W}\rangle.
$$

Let $U$ be a phase-free permutation of the complete computational basis
$\mathcal K\times\mathcal W$. Let $m:\mathcal K\times\mathcal W\to\{0,1\}$
read the marking condition and suppose

$$
m\bigl(U(K,0_{\mathcal W})\bigr)=f_T(K)\quad\text{for every }K.
$$

Define $Z_m|x\rangle=(-1)^{m(x)}|x\rangle$. The compute–mark–uncompute
construction $O_T=U^{-1}Z_mU$ then satisfies the required action: $U$ computes a
basis label, $Z_m$ changes its sign, and $U^{-1}$ restores the original label.
Intermediate garbage is allowed. The inverse here is the inverse of the
**entire predicate computation**, including comparisons and key scheduling.

Lean states this at two levels. The abstract level, `PredicateComputation`, exposes exactly these obligations:

- `zero`: the initialized workspace;
- `compute`: forward/backward basis maps with both inverse laws;
- `flag`: the marking condition on the computed basis label;
- `computes`: its equality to the intended predicate on every clean input.

`PredicateComputation.clean_oracle` proves both cleanup and the sign relation
$b\mapsto b\mathbin{\oplus}f_T(K)$ for either initial sign $b$. This level is
deliberately permissive. Because $U$ is any bijection and $m$ any Boolean
function, the choice $U=\mathrm{id}$, $m(K,w)=f_T(K)$ satisfies it with no
workspace (`Examples.abstract_contract_permissive`). It fixes the semantics of
compute–mark–uncompute, not the work an implementation performs.

The implementation level, `CircuitOracle`, removes that freedom. $U$ is a gate
list `compute` of NCT and $Z$ gates on $128+w$ wires; the key occupies wires
$0,\ldots,127$ and the workspace starts at $0$ (`cleanInput`). $Z_m$ is a single
$Z$ on one designated wire `flag`. The only obligation is `computes`: after
`compute` on a clean input, the flag wire holds $f_T(K)$. The complete oracle is
the gate list `compute ++ [Z flag] ++ compute.inverse`, where the inverse is the
reversed list (each gate is an involution). `CircuitOracle.clean_oracle` proves
full key and workspace restoration with the sign relation. The proof does not
require `compute` to be phase-free, since any $Z$ gates inside it are cancelled
by their copies in the inverse. `Circuit.toReversible` gives the basis permutation
of a circuit as an abstract `Reversible`, and `Circuit.run_of_phaseFree` shows that
a $Z$-free circuit acts as that permutation with the sign unchanged. In
`SignedBasis`, the Boolean `negative` records the coefficient $(-1)^b$; it is
semantic information and contributes no physical qubit. The toy examples
check marked and unmarked signs, composition with an existing minus sign, and
cleanup after both a flag and a scratch bit become nonzero.

Both Lean results use signed-basis semantics. Its complex-linear extension,
unitarity, and action on arbitrary superpositions are subsequent proof targets.
Relative-phase circuit substitutions also need phase-aware refinement proofs.
The current `Reversible` interface specifically models phase-free permutations,
and the gate layer has fixed wires with no measurement. The [theory README](README.md#scope-relative-to-the-circuit-ir)
lists what the project circuit IR models beyond this fragment and the planned extension.

`flagComputation` supplies the ideal XOR specification
$(K,b)\mapsto(K,b\oplus f_T(K))$. Its existence proves no implementation cost.
Likewise, implementing `flag` as a phase mark has a cost unless an appropriate
physical flag and its marking gate have already been constructed.

## 4. From the oracle to a Grover attack

The next mathematical layer starts in the uniform key state

$$
|s\rangle=\frac{1}{\sqrt N}\sum_{K\in\mathcal K}|K\rangle,
\qquad D=2|s\rangle\langle s|-I,\qquad G=DO_T.
$$

Here $O_T$ denotes the induced key-register operation on clean workspace, and
$D$ acts on the key register. The attack prepares $|s\rangle$, applies $G^j$,
measures a candidate key, and verifies it classically. Clean workspace allows
successive iterations to use the same key-only description.

For $0<M<N$, define $\theta=\arcsin\sqrt{M/N}$. The ideal success probability
for obtaining **a matching key** is

$$
\Pr[f_T(K_{\mathrm{out}})=1]=\sin^2((2j+1)\theta).
$$

This is the standard Grover target statement, recorded in the research plan
and [reference G01](../docs/reference.md); it is not yet proved in this Lean
library. The approximation $j\approx(\pi/4)\sqrt{N/M}$ assumes known $M$ in
the small-$M$ regime. Unknown $M$, iteration rounding, retries, and any
additional verification data need explicit treatment in the attack model.
For $M=0$ no key can pass; for $M=N$ every measured key matches the transcript.
Neither boundary case uses the two-dimensional marked/unmarked decomposition.

The proof order is finite complex-state semantics, linear lifting of the oracle,
the diffuser, the invariant marked/unmarked subspace, and then its rotation and
measurement probabilities. Original-secret success must additionally use the
uniqueness condition or analyze ambiguity among matching keys.

## 5. Resource interface

For a unitary compute–mark–uncompute circuit, additive gate costs obey

$$
C(O_T)=C(U)+C(Z_m)+C(U^{-1}).
$$

Under an inverse-symmetric gate-cost convention this becomes
$2C(U)+C(Z_m)$. For gate-family counts on the Lean gate syntax this is proved:
`CircuitOracle.count_circuit` gives $C_g(O_T)=2C_g(U)+[g=Z]$ for
$g\in\{X,\mathrm{CNOT},\mathrm{Toffoli},Z\}$, on the same gate list as the
correctness theorem (`AES128.count_oracle` for the AES contract). One Grover iteration also includes $C(D)$; a complete search
also includes preparation, repetitions, verification, and classical data costs.
This identity is an accounting rule, not a measured AES estimate.

The wire count $128+w$ is an upper bound on width only. Width with reuse, and
depth, require an actual circuit schedule and ancilla lifetimes, which the IR provides.
Measurement-assisted uncomputation requires its own semantics and accounting.
The immediate implementation objective is therefore to supply a concrete AES
predicate circuit satisfying the proved contract, then attach the matched
resource measurements required by the research plan.
