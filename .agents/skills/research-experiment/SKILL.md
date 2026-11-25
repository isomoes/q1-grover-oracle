---
name: research-experiment
description: Design, run, reproduce, or interpret bounded computational experiments, including exploratory measurements, benchmarks, ablations, and tests of theoretical predictions. Use a theory-first workflow when the question depends on a model.
---

# Research Experiment

Answer one decision-relevant question with the smallest credible test. A successful run can show no improvement; a failed run may tell us nothing about the hypothesis.

## 1. Start from the request

- **Explore the model:** deliver the abstraction, its limits, and a discriminating observation; stop before protocol design or execution unless requested.
- **Design:** deliver a protocol suited to the question. Do not launch trials or present expected values as measurements.
- **Run or reproduce:** inspect the project instructions, code, environment, relevant prior records, and any supplied baseline. Execute the bounded protocol when feasible. If a prerequisite is missing, identify it and distinguish any completed checks from the blocked comparison.
- **Resume or interpret:** locate the existing experiment and raw outputs first. Resume only unfinished work within its protocol. If only interpretation was requested, do not rerun it.

Use an existing synthesis decision or paper locator as motivation when available; neither is a prerequisite. Do not infer a run request from a reader marking a passage important.

## 2. Choose the starting point

Start every experiment with a concrete question and an observable. What would count as an answer?

| If the question is… | Start with… | Interpret against… |
|---|---|---|
| Does this implementation exhibit a property predicted by a model? | The theory-first steps below | The prediction under its stated assumptions |
| Which variant performs better, what changes when a feature is disabled, or can we reproduce a reported value? | A matched baseline or pinned reference; go directly to the protocol | The measured difference or reproduction tolerance |
| What patterns, bottlenecks, or failure cases occur? | A bounded set of inputs, measurements, and validity checks; go directly to the protocol | The observed range and exceptions; any explanation suggested by them is a new hypothesis |

A measurement needs an operational definition, not necessarily a theory of why it will take a particular value. For an empirical question, do not create a theory note or invent an expected outcome. If exploration later suggests a model, record it separately and test its prediction on fresh cases.

### Theory-first steps (when applicable)

Resolve the [shared workspace root](../research-landscape/references/workspace.md#resolve-the-root) (default `apaper/`). Paths below are relative to that workspace unless stated otherwise. For a model-driven question, read `theory/README.md` and any relevant foundations; in this project consult `theory/foundation.md` and the named Lean declaration for its actual hypotheses. Reuse an existing model by reference. If a new abstraction will be reused, write a short named note in `theory/` and link it from the theory index. A mathematical sketch suffices for a conjecture; call it formally proved only when the corresponding proof has been checked.

1. Translate the concrete question into a statement about objects, allowed operations, assumptions, and an observable. Specify what is fixed, what may vary, and what the abstraction leaves out.
2. Work through a minimal instance or boundary case. Separate what follows from the definitions or a theorem from what is only predicted. If the model already settles the question, report the deduction; a run is useful only for a distinct question such as implementation conformance.
3. State what observation would distinguish the prediction from a plausible alternative. Map the model's inputs, invariant, and observable to concrete experiment inputs, a validity check, and an output field. If the observable has no counterpart in the model or implementation, refine the abstraction or narrow the question before measuring.

For example, this project's fixed-wire Lean circuit model can express gate-family counts, but not elapsed depth. A count theorem on a gate list can supply an expected value for a conformance check. A depth question instead needs a scheduling model and a measured schedule; counting gates cannot answer it.

## 3. Write the protocol before measuring

For every experiment route, use the resolved aPaper workspace: implementations, run scripts, and analysis scripts go in its `code/` directory (default `apaper/code/`); protocols, raw outputs, and interpretations go in its `result/<date>-<short-name>/` directory. Follow the workspace's `code/README.md` and `result/template.md` when present. Record the repository-relative entry point and the exact command with its working directory so someone can repeat the run. The record needs:

1. **Question and scope:** what object is being tested, and what choice depends on the answer?
2. **Cases and contrast:** for exploration, state how cases are selected and what coverage they provide. For comparisons, name the baseline and variant, intended difference, and what must match (inputs, settings, measurement boundary, and budget). For reproduction, state the exact reference version, locator, reported value and acceptable tolerance.
3. **Observable and validity check:** primary metric, units, direction, and a check independent of that metric that can expose a wrong implementation. For noisy outcomes, fix the sampling or paired-seed plan and how uncertainty will be reported. For deterministic counts, use exact comparisons where appropriate.
4. **Budget and stopping rule:** fix an instance range and runtime or trial limit. For exploratory work, say when coverage is sufficient to report observations. For a hypothesis test or comparison, specify how outcomes decide the question. Reserve held-out inputs if the design calls for final evaluation.

If the baseline cannot be matched, narrow the question or record the mismatch. Do not rank incomparable measurements. Date protocol changes made after seeing output and label follow-up observations exploratory.

## 4. Execute and preserve the evidence

Check the baseline and validity controls on a small instance before spending the main budget. Stop on a failed correctness check; do not interpret its performance as evidence. Capture exact commands, input versions or hashes, code revision (and an archived diff or source copy for uncommitted code), dependencies, seeds, exit status and raw output paths. Store attempts separately so a retry cannot overwrite a failure. Mark budget exhaustion or missing data explicitly.

Before interpreting a result, trace at least one reported value back to raw output and verify the comparison used the specified conditions. Record the aggregation command or calculation when the table is not the raw output.

## 5. Answer the original question

Use the interpretation for the chosen starting point above. If a model prediction was tested and disagrees with the observation, use the validity control to distinguish implementation or measurement error from a failed assumption where possible. Record any revised model as a dated follow-up.

Report the observation, its interpretation within scope, its main limitation, and the resulting decision as separate statements. Keep unsuccessful variants. Distinguish **not run**, **invalid** (control failed), **inconclusive** (valid data do not decide), and a **valid negative finding**. Reproducing an external result requires matching the pinned reference within the declared conditions and tolerance; running a new variant is a local measurement.

Link the durable result record from the originating synthesis decision if it resolves or reopens that decision. Use the [shared evidence conventions](../research-landscape/references/workspace.md#freeze-evidence-for-manuscript-claims) when the user requests a manuscript handoff. Do not revise a frozen snapshot in place.

**Example decision rule:** Compare the peak memory of two parsers on the same three fixed files with the same output format. First check both outputs against reference hashes. Favor the new parser only if it uses less peak memory on each file under the prespecified measurement procedure. A hash mismatch invalidates that comparison; a valid result that saves memory on only two files does not support the “all three” claim. Neither outcome establishes behavior on larger files.
