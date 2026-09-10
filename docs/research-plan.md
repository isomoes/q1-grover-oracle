# Research plan: Q1 Grover oracle circuits

Initialized 2026-09-10 from survey direction D1 and entries A04, A10, A11, A16, A17, and A22. Paper identifiers below resolve in [reference.md](reference.md).

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

The initial setting is one target key, classical known-plaintext data, local quantum evaluation of the public algorithm, and no QRAM assumption. Record any later use of quantum-accessible memory or changed interfaces explicitly. Q1 concerns access to the secret-key target, not a ban on local superposition evaluation.

Let N = 2^k and let M be the number of keys satisfying the entire predicate. For 0 < M < N and ideal Grover iterations, theta = asin(sqrt(M/N)) and success after j iterations is sin²((2j+1)theta). The familiar approximately (pi/4)sqrt(N/M) iteration count assumes M is known and the usual small-M regime. M = 0, M = N, unknown M, and repeated runs need their own treatment.

Matching the transcript is distinct from identifying the original secret key. Under an ideal-cipher approximation, the expected number of extra matching keys is approximately (2^k-1)2^(-nr), for block size n and independent-pair approximation. This guides pair selection; it does not prove uniqueness for a concrete cipher. Record false-key checks and their cost. See G01–G03 for the search and AES resource-estimation foundations.

## Initial implementation scope

Start with AES-128 and fixed classical pairs. Implement and validate the components in this order: classical reference encryption; reversible S-box and linear layer; coherent key schedule; full encryption and inverse; equality checks and their conjunction; phase marking and cleanup; key-register diffuser.

Pin the cipher specification, bit ordering, gate semantics, compiler, decomposition rules, and dependency versions before reporting results. Select the implementation framework after examining the baseline artifact and its reproducibility requirements.

Use known-answer tests for classical and reversible encryption. Exhaustively check small components and use small toy instances to check the entire phase oracle, including relative phases and zeroed workspace. A truth-table match alone cannot validate phase-sensitive substitutions. Full AES state-vector simulation is not a required or plausible baseline strategy.

## Baselines and proposed experiments

| Experiment | Baseline or source | Controlled change | Required evidence |
|---|---|---|---|
| Baseline reproduction | G03 corrected AES estimates | No optimization | Exact paper/artifact revision, reproduced counts, explained differences |
| Linear-layer scheduling | G04 | CNOT synthesis and scheduling | Same map, ancilla budget, connectivity assumptions |
| Nonlinear-layer tradeoffs | G05 | Low T-depth versus low width | Distinct circuit variants and complete-oracle measurements |
| Joint key/round scheduling | G06 | Key schedule, S-boxes, ancilla lifetimes | End-to-end cleanup and matched pair count |
| Compute/uncompute alternatives | G07 | Temporary logical-AND where its preconditions hold | Phase correctness, measurement/feed-forward accounting |
| Cross-cipher portability | G08 | A separately specified second primitive | Consistent accounting; no claim that DES is a deployment target |
| Small exact-synthesis experiments | G09, preprint | Bounded NCT synthesis problems | Independent verification and the stated optimization domain |

G03's 2023-06-07 revision corrects AES estimates affected by Q# bugs; its LowMC estimates were not revised. G06's 2025-11-27 revision adds Clifford+T encryption/Grover-oracle estimates. Preserve these version distinctions in every comparison.

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

The first release reports logical resources. A later physical estimate must name an error-correction scheme, error rates, clock assumptions, state factories, and a failure budget. Logical D×W is not a physical runtime estimate.

## Completion criteria for the first research result

1. Reproduce a published baseline or publish a precise, explained reproduction gap.
2. Validate candidate circuits independently, including coherent phase behavior and cleanup.
3. Compare against relevant published baselines at identical model constraints.
4. Publish both improvements and regressions across the resource tradeoff frontier.
5. Provide one command per experiment, locked dependencies, raw counts, and a machine-readable table.

A smaller S-box alone does not establish a cheaper attack. A publication claim needs an end-to-end result and a fresh comparison with related work.
