# Experiment record

Copy this file to a named experiment directory when beginning an experiment. Keep the fields relevant to the question; this template is not a result.

## Theory model (only for a model-driven question; otherwise omit)

- Concrete question → abstract statement:
- Theory note or declaration and locator; assumptions, scope, and excluded effects:
- Small instance or boundary case; what is proved versus predicted:
- Model input → test input; invariant → validity check; observable → output field:
- Competing prediction or counterexample the measurement could distinguish:

## Protocol (record before running)

- Originating question or synthesis decision:
- Experiment entry point (repository-relative path under `apaper/code/`):
- Cases and selection rationale; baseline and fixed conditions if comparing:
- Primary observable, units, and validity control:
- Instances/seeds, budget, and stopping rule; threshold or tolerance if testing a claim:
- Dated amendments after observing data (if any):

| Field | Value |
|---|---|
| Experiment ID / date | Pending |
| Research question or hypothesis | Pending |
| Cipher / specification / rounds / key and block sizes | Pending |
| Q1 target interface and classical data acquisition | Pending |
| Pair count / transcript generation seed | Pending |
| Baseline citation key / paper version / table | Pending |
| Baseline artifact URL / commit / license | Pending |
| Baseline toolchain / versions | Pending |
| This repository commit / dependency lock / environment | Pending |
| Python / Qiskit / simulator versions | Pending |
| Gate set / decomposition / transpiler passes and seeds / connectivity / scheduling | Pending |
| Resource-accounting implementation / qubit lifetime and reuse model | Pending |
| Ancilla budget / measurements / feed-forward | Pending |
| Gate durations / measurement and feed-forward latency / time units | Pending |
| M assumption / false-key policy / target success probability | Pending |
| Depth cap / parallel processors / partition policy | Pending |
| Reproduction and verification commands, including working directory | Pending |

## Correctness evidence

Record known-answer checks, exhaustive component checks, phase-sensitive checks on small instances, and workspace cleanup. State what is simulated, symbolically checked, or justified mathematically.

## Resource table

| Circuit scope | Width | Full depth | Total gates | T-count | T-depth | D×W |
|---|---|---|---|---|---|---|
| Encryption | Pending | Pending | Pending | Pending | Pending | Pending |
| Phase oracle | Pending | Pending | Pending | Pending | Pending | Pending |
| Grover iteration | Pending | Pending | Pending | Pending | Pending | Pending |
| Complete search | Pending | Pending | Pending | Pending | Pending | Pending |

Record counts by gate family and all classical data, memory, preprocessing, retries, and final verification costs alongside this table. Link raw outputs and document differences from the baseline.

## Width-budget comparison (for scheduling experiments)

Use one row per variant and budget under the same gate and timing model. Include budgets with no schedule found. Give a lower bound only when a proof or certificate covers the stated circuit family and scope.

| Variant / family | Total width budget B | Actual peak width | Phase-oracle full depth | Iteration full depth (achieved) | Iteration lower bound / scope, if known | Limiting operation, wait cause / trace |
|---|---:|---:|---:|---:|---|---|
| Pending | Pending | Pending | Pending | Pending | Pending | Pending |

Name the value or wire involved at the first budget where the schedule changes. Link the neighboring-budget schedules and the matched run with the proposed change disabled. Explain whether the change shortens the complete iteration or only moves work off one critical path.

## Interpretation

For exploration, report the pattern and exceptions within the sampled cases. For comparison or reproduction, report the difference from the baseline or reference. For a model test, compare with the prediction under its assumptions. Separate explanations suggested after the run from claims the run actually tested.

Link each attempt's command, exit status, and raw output; identify the calculation behind the reported comparison. State whether the protocol was completed, blocked, or invalid before interpreting the hypothesis.

State the supported conclusion, uncertainty, failed variants, and remaining checks. Distinguish literature-reported counts from measurements made here.
