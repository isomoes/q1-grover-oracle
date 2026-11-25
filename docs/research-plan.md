# Research plan: Q1 Grover oracle circuits

Initialized 2026-09-10 from survey direction D1 and entries A04, A10, A11, A16, A17, and A22. The [annotated references](reference.md) use G01–G09; the [research landscape](../apaper/landscape/report.md) uses P01–P09 for the same papers and P10 onward for additional work.

## Research question and objective

**Decision, 2026-11-23:** As the number of available logical qubits decreases, which operations in a complete AES-128 Grover iteration must wait or be recomputed? Can we predict where parallel execution stops being possible, and construct a shallower iteration at the same width?

This question matters for concrete security estimates. [NIST's PQC evaluation criteria, §4.A.5](https://csrc.nist.gov/CSRC/media/Projects/Post-Quantum-Cryptography/documents/call-for-proposals-final-dec-2016.pdf) use key search on a 128-bit-key block cipher such as AES-128 as the Category 1 reference. Grover's query count does not price an iteration. In [P03, §3.5, Eqs. (8)–(10)](https://eprint.iacr.org/2019/1146), a shorter iteration can reduce the number of processors needed to meet a deadline.

Let $B$ be the **total peak logical-qubit budget on one processor**, including key, data, flags and ancillas. Fix a family $\mathcal F$ of scheduled implementations that evaluate the public cipher on the classical transcript; synthesis has no access to the generating key. For fixed gate and timing assumptions, minimize the depth over implementations satisfying the oracle contract:

$$
d^*_{\mathcal F}(B)=\min_{\sigma\in\mathcal F:\;W_{\mathrm{peak}}(\sigma)\le B} D_{\mathrm{full}}(\sigma).
$$

Here $D_{\mathrm{full}}$ is the scheduled depth of **one complete phase oracle followed by the key-register diffuser**. A feasible schedule gives an upper bound. The first deliverable is a baseline width–depth table with a trace explaining what sets the depth at each budget. The choice of optimization method follows that diagnosis. No baseline frontier or depth bound has yet been established here.

## Model and oracle contract

For a public block cipher E, collect r distinct classical plaintext/ciphertext pairs (P_i, C_i) from one fixed secret key. The key-search predicate is

```text
f(K) = AND over i = 1,...,r of [E_K(P_i) = C_i].
```

The complete phase oracle must implement

```text
|K>|0_workspace> -> (-1)^f(K) |K>|0_workspace>.
```

All temporary round keys, cipher states, and comparison flags must be cleaned up. The key register must be preserved coherently. A circuit for encryption alone is an intermediate component of this contract.

The primary comparison uses the same **two distinct classical plaintext/ciphertext pairs** (`r=2`) for one target key, local quantum evaluation of the public algorithm, and no QRAM. Single-pair runs can check published estimates but are a different predicate. Record any later use of quantum-accessible memory or changed interfaces explicitly. Q1 concerns access to the secret-key target, not a ban on local superposition evaluation.

Let N = 2^k and let M be the number of keys satisfying the entire predicate. For 0 < M < N and ideal Grover iterations, theta = asin(sqrt(M/N)) and success after j iterations is sin²((2j+1)theta). The familiar approximately (pi/4)sqrt(N/M) iteration count assumes M is known and the usual small-M regime. M = 0, M = N, unknown M, and repeated runs need their own treatment.

Matching the transcript is distinct from identifying the original secret key. Under an ideal-cipher approximation, the expected number of extra matching keys is approximately (2^k-1)2^(-nr), for block size n and independent-pair approximation. This guides pair selection; it does not prove uniqueness for a concrete cipher. Record false-key checks and their cost. See G01–G03 for the search and AES resource-estimation foundations.

## Initial implementation scope

Start with AES-128 and fixed classical pairs. Implement and validate the components in this order: classical reference encryption; reversible S-box and linear layer; coherent key schedule; full encryption and inverse; equality checks and their conjunction; phase marking and cleanup; key-register diffuser.

Pin the cipher specification, bit ordering, gate semantics, compiler, decomposition rules, and dependency versions before reporting results. Use the Python + Qiskit environment selected below, and record the original toolchain separately when reproducing a baseline artifact.

Use known-answer tests for classical and reversible encryption. Exhaustively check small components and use small toy instances to check the entire phase oracle, including relative phases and zeroed workspace. A truth-table match alone cannot validate phase-sensitive substitutions. Full AES state-vector simulation is not a required or plausible baseline strategy.

## Implementation environment

**Decision, 2026-11-11: use Python + Qiskit as the primary quantum circuit implementation environment.** Python hosts circuit generation, scheduling/optimization algorithms, experiment orchestration, and result analysis.

**Refinement, 2026-11-23: a project-owned circuit IR in Python is the source of truth for circuits and resources; Qiskit is a validation backend.** The IR records gates, qubit allocation/release, measurements, classically controlled operations, and quantum and measurement-to-correction dependencies. A single scheduler over the IR derives full depth, T-depth, and peak width under explicit gate and latency assumptions. Qiskit does not model qubit lifetimes (`num_qubits` counts wires) or measurement/feed-forward latency (`QuantumCircuit.depth()` counts gate layers), so its native metrics are not reported as results.

Validation uses two IR backends: a classical bit-level simulator for basis-state functional checks of reversible circuits, including known-answer tests and workspace restoration on the complete AES oracle; and Qiskit export with a selected simulator for phase-sensitive checks on small instances, including measurement-dependent corrections. The detailed implementation and validation conventions are in [apaper/code/README.md](../apaper/code/README.md).

Use Q# author artifacts to reproduce published baselines and cross-check the Python + Qiskit implementations. Pin the original artifact and toolchain first (G03's estimates come from the classic QDK trace simulator, whose cost model differs from the modern QDK resource estimator), then explain any differences introduced by porting. Python, Qiskit, and simulator versions will be selected and locked when the executable environment is initialized; this decision records the stack, not a completed installation or reproduction.

## Baselines and proposed experiments

First reproduce the resource point the authors actually report. Record any port or extension to the two-pair iteration separately. For comparisons, fix the transcript, success target, diffuser, topology, gate decomposition, timing and permitted ancillas. Keep strictly unitary and measurement-assisted results in separate tables; in the latter, fix the measurement-to-correction latency within each comparison. Replacing a measurement-assisted step with a unitary circuit produces an adaptation that must be costed again.

| Source | Role | Evidence needed |
|---|---|---|
| [P03 / G03, Jaques et al.](../apaper/papers/P03/reading.md), corrected 2023-06-07 | Reproduction anchor | Pin the author artifact and classic QDK. Start with Table 9, AES-128, `r=2`, in-place MixColumn, the row minimizing depth squared times width. It includes comparison; account for the diffuser separately. The correction applies to AES, not LowMC. |
| [P14, Jang et al.](https://cic.iacr.org/p/2/1/25), 2025 version | Low-depth competitor | Identify the applicable architecture and table, reproduce or document its gates and schedule, then cost the complete iteration. Use scheduled full depth rather than substituting Toffoli depth. |
| [P06 / G06, Liao and Luo](../apaper/papers/P06/reading.md), revised 2025-11-27 | Low-width competitor | Appendix G/Table 10 costs single-pair evaluation and cleanup using a measurement-assisted decomposition; it omits ciphertext comparison. Use its circuit to build and cost the two-pair predicate, phase mark, restoration and common diffuser. |
| [P15, Abdolmaleki and Gu](https://eprint.iacr.org/2026/568) | Direct comparator if cleanup is the bottleneck | Test whether removing and selectively restoring local uncomputation already explains the gain. Its Appendix B AES width excludes comparison and marking. |

### Bottleneck study

1. **Measure the baseline frontier.** Select budgets spanning the narrowest validated implementation through the wide, low-depth design before tuning a new method. For each architecture and budget, record the actual peak width, oracle and iteration depths, and a gate-level critical-path trace in the [experiment record](../apaper/result/template.md). Mark budgets where no schedule was found; call a budget infeasible only with evidence. If a baseline cannot be reproduced, record the gap and qualify any comparison.
2. **Identify the transition.** Find an operation that starts later at a tighter budget. Record what it waits for: an input, a shared wire, a clean ancilla, or a measurement result. For suspected recomputation, identify the value, why its earlier copy was released, and whether recomputing it delays the end of the iteration. Reschedule the same component templates with more workspace and check neighboring budgets. Counting cleanup gates alone cannot distinguish a bottleneck from work hidden beneath another operation.
3. **Model the observed cause.** Use the smallest window preserving the dependency and its entry/exit registers. If shared round keys appear responsible, start with two rounds and two data paths, freezing the S-box and linear-layer templates. Use exact search or a dependency/capacity bound to predict a budget at which an operation must serialize or a value must be recomputed; state the allowed moves. [Linear relations and reversible pebbling](../apaper/synthesis/algebra-aware-cleanup-2026-11-23.md) are one candidate model for this case; compare against existing XOR/pebbling methods (P29). If the trace points instead to a linear or nonlinear layer, use G04 or G05 to model that dependency.
4. **Test the prediction and integrate.** For the shared-key hypothesis, let both variants use in-place updates, direct XOR into the destination, and cached or recomputed words. Enable just the extra linear cleanup rule in one variant. Expand both schedules to gates in the IR, charging for source-word lifetimes, shared-wire conflicts, fanout and restoration. Check the predicted transition at neighboring budgets and verify the phase and cleanup on small instances. Repeat the ablation on ten-round AES-128 with comparison, marking, uncomputation and diffusion. If the gain disappears against the in-place control or after integration, record why and return to the measured bottleneck.

After the unitary scheduling study, test measurement-assisted cleanup (G07) under explicit feedback latencies if it affects the limiting path. Bounded component synthesis (G09, preprint) and a second cipher (G08) are follow-ups once the AES mechanism is understood.

## Resource accounting

Record each of the following separately for encryption, the phase oracle, one Grover iteration, and the complete search:

| Quantity | Definition or reporting rule |
|---|---|
| Logical width W | Peak live logical qubits, including key, data, flags, and ancillas |
| Full depth D | Scheduled depth with an explicit gate/decomposition/connectivity model |
| Gate counts | Total gates and counts by family; preserve NCT and Clifford+T as separate views |
| T-count and T-depth | State whether T-dagger is counted and how measurements/feed-forward enter depth |
| D×W | Compute from the same circuit instance and scheduling model |
| Classical data and memory | Pair count, storage, preprocessing and data-loading costs |
| Grover repetitions | M assumptions, iteration count, success probability, retries and final verification |
| Parallel search | Number of processors, partition policy, per-processor width, aggregate work and depth limit |

For a unitary compute–mark–uncompute construction, gate counts decompose as 2C_compute + C_mark; compute includes the predicate workspace needed by the chosen construction. One iteration additionally includes the diffuser. This identity must not be reused unchanged for measurement-assisted uncomputation. Depth and peak width require an actual schedule.

Translate a frontier point with iteration depth $d$ and **actual** peak width $w$ into search cost at fixed success probability. With a unique target and no binding deadline, single-processor qubit-cycles scale with $dw$ at fixed key size. In P03's equal-partition approximation, when a fixed total depth cap requires multiple processors, their number scales with $d^2$ and aggregate qubit-cycles with $d^2w$. For concrete estimates use feasible integer partitions, iteration counts and the stated verification policy. These are scenario-dependent consequences of a circuit improvement, not alternative definitions of full depth.

The first release reports logical resources. A later physical estimate must name an error-correction scheme, error rates, clock assumptions, state factories, and a failure budget. Logical D×W is not a physical runtime estimate.

## Completion criteria for the first research result

For a flagship cryptology submission (CRYPTO, EUROCRYPT or ASIACRYPT), pursue either of two claims:

- **Best known under stated constraints.** A new construction lowers the full-iteration depth against the strongest matched baselines at a justified budget or over a budget range. Use an ablation and the gate trace to show which formerly serial work is avoided, then quantify the effect on the fixed-success search estimate. Refresh the comparison before claiming a record.
- **Optimal or near-optimal in a stated model.** Give a lower bound $L(B)$ that applies to every implementation in a family covering relevant competing designs, and an attainable depth $U(B)$ in the same family. Report the gap in $L(B)\le d^*_{\mathcal F}(B)\le U(B)$. Equality certifies optimality only in that family. An exact two-round result does not bound a ten-round iteration without a proof accounting for overlap across windows.

For either claim, publish independent correctness evidence, the schedules and any bound certificates, one command per experiment, locked dependencies, raw counts, and a machine-readable frontier including regressions. Distinguish author-reported, reproduced and newly constructed points. A missing baseline or a local saving that vanishes in the complete iteration is a result to document, not evidence of a depth record.
