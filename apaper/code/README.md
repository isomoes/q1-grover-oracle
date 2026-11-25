# Experiment Code

Circuit implementations, experiment scripts, and resource-analysis code.

## Implementation environment

**Decision, 2026-11-11: Python + Qiskit is the primary environment for quantum circuit implementation.**
**Refinement, 2026-11-23: a project-owned circuit IR is the source of truth for circuits and resources; Qiskit is a validation backend** (see the [research plan](../../docs/research-plan.md#implementation-environment)).

| Component | Responsibility |
|---|---|
| Python | Host language: circuit generation, optimization and scheduling algorithms, parameter sweeps, and result analysis |
| Project circuit IR | Source of truth: gates, qubit `alloc`/`free`, measurements, classically controlled operations, and quantum and measurement-to-correction dependency edges |
| Scheduler and resource accounting | Single schedule over the IR: full depth, T-depth, peak width, gate-family counts, and measurement/feed-forward costs under stated latency assumptions |
| Classical reversible simulator | Basis-state functional checks of NCT circuits: component truth tables, AES known-answer tests on the complete oracle, and workspace restoration |
| Qiskit (export backend) | Phase-sensitive validation on small instances with a selected simulator, including measurement-dependent corrections via dynamic circuits |
| Q# author artifacts | Published-baseline reproduction (pinned classic QDK toolchain) and cross-checks against the IR implementation |
| Qualtran (optional) | Independent cross-check of T-count and qubit counts for exported components |

This stack supports the project's focus on changing cleanup schedules and tracing their effects on complete-oracle resources. Cleanup schedules and qubit lifetimes are represented directly in the IR rather than reconstructed from a fixed-wire circuit. Keep circuit construction and resource-accounting assumptions explicit so competing implementations can use the same model.

The stack is selected; executable setup and dependency versions are pending. At initialization, pin the Python, Qiskit, simulator, and other dependency versions in a reproducible environment. Record compiler/transpiler settings, decomposition rules, and random seeds with each experiment.

## Resource-accounting conventions

Follow the [research plan](../../docs/research-plan.md#resource-accounting), with these implementation requirements:

- Report resources computed from the IR schedule only. Do not report Qiskit's `num_qubits` (wire count) or `QuantumCircuit.depth()` (gate layers, no latency) as width or depth results.
- Track logical qubit lifetimes and the actual reuse schedule through explicit `alloc`/`free` in the IR.
- Compute full depth, T-depth, and peak width from a consistent circuit and schedule. Gate-layer depth alone does not represent elapsed time with measurement and classical feedback delays.
- Make the NCT and Clifford+T decompositions explicit in the IR, including the chosen Toffoli and temporary-AND implementations. Export to Qiskit without optimizing transpiler passes, so the simulated circuit is the counted circuit; record any pass that is applied.
- Preserve both quantum dependencies and measurement-to-correction dependencies. Include the assumed measurement and feed-forward latencies in scheduling experiments.
- Report encryption, the complete phase oracle, the Grover iteration, and the full search separately. Keep the gate-level outputs and resource tables available for independent inspection.

## Baseline reproduction and validation

1. Start with P03/G03's corrected AES implementation and pin its author artifact and original Q# toolchain. Establish reproduced counts or an explained reproduction gap before using it as a numerical baseline.
2. Cross-check a reversible S-box and a small compute–mark–uncompute oracle between the baseline and the IR implementation, matching bit ordering and gate decompositions.
3. Verify component outputs and restored workspace with the classical reversible simulator; use Qiskit export on small quantum instances to check relative phases. For measurement-assisted cleanup, also check the outcome-dependent corrections.
4. Extend to AES known-answer checks on the complete oracle with the classical reversible simulator, and to complete-oracle resource accounting from the IR schedule. Keep functional checks, phase-sensitive checks, and resource estimation identifiable in experiment records.

Full AES state-vector simulation is not the validation strategy. Basis-state classical simulation covers full-size functional correctness; phase correctness is checked on components and small instances, following the [research plan](../../docs/research-plan.md#initial-implementation-scope).

## Experiment records

Keep implementations, run scripts, and analysis scripts under `apaper/code/`. Store each run's protocol, raw outputs, and interpretation in [result/](../result/). In the [experiment record](../result/template.md), identify the `apaper/code/` entry point and give the exact command and working directory.
