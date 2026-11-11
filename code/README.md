# Experiment Code

Circuit implementations, experiment scripts, and resource-analysis code.

## Implementation environment

**Decision, 2026-11-11: Python + Qiskit is the primary environment for quantum circuit implementation.**

| Component | Responsibility |
|---|---|
| Python | Circuit generation, optimization and scheduling algorithms, parameter sweeps, and result analysis |
| Qiskit | Circuit representation, gate-level construction, controlled decomposition, and small-instance validation with a selected simulator |
| Project resource-accounting layer | Ancilla allocation/release and reuse, dependency tracking, scheduled depth, peak width, gate-family counts, and measurement/feed-forward costs |
| Q# author artifacts | Published-baseline reproduction and cross-checks against the Python + Qiskit implementation |

This stack supports the project's focus on changing cleanup schedules and tracing their effects on complete-oracle resources. Keep circuit construction and resource-accounting assumptions explicit so competing implementations can use the same model.

The stack is selected; executable setup and dependency versions are pending. At initialization, pin the Python, Qiskit, simulator, and other dependency versions in a reproducible environment. Record compiler/transpiler settings, decomposition rules, and random seeds with each experiment.

## Resource-accounting conventions

Follow the [research plan](../docs/research-plan.md#resource-accounting), with these implementation requirements:

- Track logical qubit lifetimes and the actual reuse schedule. Qiskit's `num_qubits` counts circuit wires; it does not by itself establish a lifetime-optimized peak width.
- Compute full depth, T-depth, and peak width from a consistent circuit and schedule. Gate-layer depth alone does not represent elapsed time with measurement and classical feedback delays.
- Make the NCT and Clifford+T decompositions explicit, including the chosen Toffoli and temporary-AND implementations. Record the transpilation passes that affect the counted circuit.
- Preserve both quantum dependencies and measurement-to-correction dependencies. Include the assumed measurement and feed-forward latencies in scheduling experiments.
- Report encryption, the complete phase oracle, the Grover iteration, and the full search separately. Keep the gate-level outputs and resource tables available for independent inspection.

## Baseline reproduction and validation

1. Start with P03/G03's corrected AES implementation and pin its author artifact and original Q# toolchain. Establish reproduced counts or an explained reproduction gap before using it as a numerical baseline.
2. Cross-check a reversible S-box and a small compute–mark–uncompute oracle between the baseline and the Python + Qiskit implementation, matching bit ordering and gate decompositions.
3. Verify component outputs and restored workspace; use small quantum instances to check relative phases. For measurement-assisted cleanup, also check the outcome-dependent corrections.
4. Extend to AES known-answer checks and complete-oracle resource accounting using validated components. Keep functional checks, phase-sensitive checks, and resource estimation identifiable in experiment records.

Full AES state-vector simulation is not the validation strategy; follow the component and small-instance approach in the [research plan](../docs/research-plan.md#initial-implementation-scope).

## Experiment records

Keep experiment records in [result/](../result/), using its
[template](../result/template.md) to document commands and results.
