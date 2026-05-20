---
name: business-spec-to-golden
description: "Turn unreliable design documents and a few test cases into a clarified, reviewed spec, executable tests, and a test-validated golden program. Use when source docs may be incomplete, misleading, domain-heavy, or inconsistent, and clarification must be prioritized by implementation impact."
---

# Business Spec to Golden Program

Use this skill when the user has a rough design document plus a few test cases and wants a detailed implementation spec, executable tests, and a golden program. A golden program is the standard implementation for the clarified spec. The workflow validates `golden.py` against manually provided and agent-expanded expected-output test cases.

The core problem is not only code generation. The agent must avoid being misled by low-quality source documents, ask fewer but higher-impact questions, and convert uncertain requirements into an implementation-ready spec.

## Default Outcome

Produce, in order:

1. `*-understanding.md`
2. `*-p0-questions.md`, `*-p1-questions.md`, `*-p2-questions.md`
3. `*-global-flow.md`, `*-submodule-design.md`, optional `*-boundary-rules.md`
4. `*-spec.md`
5. `*-spec-review.md`
6. `*-test-plan.md`
7. `*-test.py`
8. `golden.py`

Default path: `docs/business-specs/YYYY-MM-DD-<topic>-*`

Default implementation profile: Python golden with `pytest`. Use another language only if the user or repository clearly requires it.

## Operating Principles

- **Evidence first**: Treat source documents as evidence, not truth. Separate source facts, user test facts, user confirmations, agent inferences, assumptions, and contradictions.
- **Golden impact first**: Ask only questions that can change outputs, test assertions, model/input contracts, externally visible behavior, or rejection/default behavior.
- **Layered convergence**: Keep P0/P1/P2. Generate questions stage by stage; answers in one layer may resolve, obsolete, merge, or rewrite later-layer candidates.
- **Optional P2**: P2 is a developer-controlled risk pass. Ask whether to enter it; if skipped, carry unresolved P2 items as explicit assumptions or risks in the spec.
- **Low interruption**: Do not use single-question-by-default clarification. Ask a small batch of high-impact questions with recommended assumptions when possible.
- **No hidden assumptions**: Low-impact uncertainty may be carried as an explicit assumption. Blocking uncertainty must be asked before the dependent artifact is approved.
- **Standalone spec**: `*-spec.md` is the downstream source of truth. A new session given only the spec must be able to design tests and implement the golden program.
- **TDD gate**: Do not implement `golden.py` until the spec is reviewed, the test plan is approved, and executable tests exist.

## Stage Order

1. Source Review
2. Understanding
3. P0 Question Budget and Baseline
4. P1 Question Budget and Baseline
5. P2 Decision: run, partial run, or skip
6. Spec
7. Isolated Spec Review
8. User Spec Approval
9. Test Plan
10. Executable Tests
11. Golden Program

If a later answer changes an approved upstream contract, mark dependent artifacts `stale` before continuing.

## Stage 1: Understanding

Write `*-understanding.md` as a correction-friendly working model.

Include:

1. `Status`
2. `Source Documents and Test Cases`
3. `Current Scope Proposal`
4. `Evidence Map`
   - Source document facts
   - User-provided test facts
   - User-confirmed facts
   - Agent inferences
   - Explicit assumptions
5. `Trust and Conflict Notes`
   - suspicious source claims
   - source/test conflicts
   - missing information likely to affect the golden
6. `Candidate Processing Stages or Modules`
7. `Known System Inputs and Outputs`
8. `P0 Candidates`

Rules:

- Keep it short enough for the user to correct.
- Do not present inferred behavior as confirmed fact.
- Prefer user-provided tests over ambiguous source prose when they conflict, but record the conflict.
- Do not start P1 until P0 has a reviewed baseline.

## P0/P1/P2 Semantics

Classify by implementation impact, not by topic.

### P0: Golden Scope and System Contract

P0 questions can change the whole task shape:

- in-scope processing slice
- system-level inputs and outputs
- what the golden must prove
- authoritative test cases
- source sections known to be unreliable
- external contracts, model-input contracts, or caller-visible behavior
- major processing stages or module boundaries

Exit artifact: `*-global-flow.md`

### P1: Core Normal-Path Behavior

P1 questions refine confirmed structure:

- field extraction and mapping
- calculations, conversions, normalization, filtering, aggregation, ordering, ranking, or windowing
- core rule precedence
- normal-path module responsibilities
- expected output construction

Exit artifact: `*-submodule-design.md`

### P2: Boundary, Conflict, and Default Behavior

P2 questions cover observable edge behavior:

- missing or empty inputs
- invalid or out-of-range values
- duplicate, delayed, conflicting, or inconsistent records/messages
- default values and fill behavior
- rejection/error behavior
- source/test contradictions not already resolved

P2 is optional because it can become the most time-consuming layer and often matters mainly when diagnosing rare failures.

Before entering P2, ask the developer to choose one:

- run full P2 for stronger boundary coverage
- run only critical P2 items that can change known test outputs or model/input contracts
- skip P2 for now and record unresolved boundary behavior as explicit assumptions/risks

Default recommendation: run only critical P2 items when the golden will be used immediately as a reference, and skip full P2 unless the developer is investigating difficult edge cases.

Exit artifact when P2 is run: `*-boundary-rules.md`

If P2 is skipped:

- still create or update `*-p2-questions.md` with skipped candidates marked `deferred`
- do not create `*-boundary-rules.md` unless useful as a short skipped-risk summary
- fold skipped P2 assumptions and risks into `*-spec.md`
- ensure the spec readiness check says whether skipped P2 could affect untested edge behavior

## Question Budget

Do not expose a full question dump to the user.

For each P layer:

1. Build a candidate pool in the layer file.
2. Rank candidates by golden impact:
   - `critical`: blocks the next baseline or can change expected outputs/tests
   - `important`: affects meaningful behavior but can proceed with a visible assumption
   - `deferred`: low impact, implementation-internal, or not needed for the current golden
3. Ask only the smallest useful batch:
   - P0: normally 1-3 questions
   - P1: normally 1-5 questions
   - P2: only after developer opts in; normally critical items only
4. For each asked question, include:
   - why it matters for the golden
   - the evidence or conflict that triggered it
   - a recommended assumption if one is defensible
5. After an answer, reconcile the whole layer before asking more.

Reconciliation means:

- mark answered items with a canonical decision
- mark covered items `resolved-by`
- mark no-longer-relevant items `obsolete`
- merge duplicate questions
- downgrade low-impact items to explicit assumptions
- add newly revealed candidates only in the current or a later layer

The user should normally confirm a layer baseline summary, not every ledger row.

## Layer File Shape

Use `references/artifact-header-template.md` for stage artifacts.

For each `*-pN-questions.md`, use a compact table:

```markdown
| ID | Impact | Status | Question or Assumption | Triggering Evidence | Recommended Default | Decision |
|----|--------|--------|------------------------|---------------------|---------------------|----------|
```

Allowed status values:

- `candidate`
- `asked`
- `answered`
- `confirmed`
- `assumption`
- `resolved-by`
- `obsolete`
- `deferred`

## Baseline Artifacts

### `*-global-flow.md`

Summarize approved P0 decisions:

1. In-scope slice
2. System-level input contract
3. System-level output contract
4. Golden success target
5. Processing stages or module list
6. Main execution flow
7. Explicit assumptions and deferrals

### `*-submodule-design.md`

Summarize approved P1 decisions by stage/module:

1. Responsibility
2. Business inputs and outputs
3. Normal-path transform rules
4. Ordering and precedence
5. Agent-designed internals, if any

### `*-boundary-rules.md`

Summarize approved P2 decisions as a decision matrix:

| Case | Condition | Expected Behavior | Output/Error | Source |
|------|-----------|-------------------|--------------|--------|

Keep only observable boundary behavior. Do not expand into implementation style questions.

## Profile Guidance

Keep the workflow general. Use profile-specific checks only when they match the task.

### Python Golden Profile

Default unless overridden:

- produce `golden.py`
- produce `*-test.py`
- use `pytest`
- prefer a pure-function entrypoint
- keep implementation deterministic and self-contained
- do not use network, wall-clock time, randomness, or environment-specific dependencies

### CPU Preprocessing Profile

Use when the task is CPU-side preprocessing before model inference.

Ensure the spec covers applicable items:

- input messages, records, or files
- field names, meanings, units, ranges, and required/optional status
- cross-message association, ordering, windowing, aggregation, filtering, and ranking
- normalization, scaling, default fill, dtype, shape, precision, and model-input order
- behavior for missing messages, missing fields, duplicates, stale data, invalid values, and conflicts

### Telecom or Domain-Heavy Source Documents

When source docs use domain terminology, abbreviations, or local jargon:

- capture unknown terms in the evidence map
- infer only when tests or surrounding text support the inference
- ask about terms only when misunderstanding them could change golden outputs
- do not let official-looking source prose override confirmed tests without recording the conflict

## Spec

Write `*-spec.md` using `references/spec-template.md`.

The spec must:

- restate every golden-relevant rule from upstream artifacts
- identify rule sources and trust levels
- distinguish confirmed facts from assumptions
- contain no unresolved critical ambiguity
- contain no `TODO`, `TBD`, or placeholder normative content
- be sufficient for test planning and `golden.py` generation without reopening upstream files

## Spec Review

After writing `*-spec.md`:

1. Review it against `references/spec-document-reviewer-prompt.md`.
2. Write `*-spec-review.md` using `references/spec-review-template.md`.
3. Fix blocking issues before showing the spec for user approval.
4. Stop after 3 review/fix rounds and surface unresolved blockers.

Rules:

- Do not move to tests unless `*-spec-review.md` says the spec is ready for user review and the user approves `*-spec.md`.
- Treat blocking review issues as hard gates.
- If the review cannot run, mark it `Review Blocked`.

## Test Plan

Write `*-test-plan.md` using `references/test-plan-template.md` after spec approval.

The test plan must:

- start from user-provided test cases
- map important spec rules to executable tests or explicit non-test rationale
- separate canonical examples from agent-expanded coverage
- define how `golden.py` outputs are compared with expected outputs
- include the test file path and commands

Require user approval before coding.

## Optional Test Harness

Do not generate a separate harness by default.

Simple tasks should produce only:

- `golden.py`
- `*-test.py`

Generate a lightweight test harness only when it reduces test complexity or improves stability, such as:

- many test cases
- complex nested outputs, arrays, or tensor-like structures
- floating tolerance, dtype, shape, field-order, or ignored-field comparison rules
- external JSON/YAML/CSV case files
- weak-model execution where separating test loading/assertion logic from business logic reduces mistakes

Optional harness files may include:

- `*-cases.json`
- `golden_test_harness.py`

Harness rules:

- It validates `golden.py` against expected outputs only.
- It must not introduce business rules not present in `*-spec.md`.
- For skipped P2 cases, mark them as untested, unsupported, or expected-error according to the approved spec; do not silently invent behavior.

## Executable Tests

After test-plan approval:

1. Write `*-test.py` unless another language is explicitly required.
2. Encode user-provided cases first.
3. Add the highest-value P0/P1 coverage, plus P2 coverage only when P2 was run or marked critical-only.
4. Provide the exact `pytest` command and coverage command when available.

If a test expectation requires reopening upstream artifacts, stop and repair `*-spec.md`.

## Golden Program

Only after executable tests exist:

1. make a short code plan
2. implement `golden.py`
3. run tests until green
4. run coverage if the project has coverage tooling
5. report unresolved assumptions and comparison limits

Coverage target:

- default at least 80% line coverage when coverage tooling exists
- prefer 90% or higher for pure business logic
- coverage never replaces explicit tests for critical spec rules

## Error Recovery

| Violation | Recovery |
|-----------|----------|
| Asked too many questions | Keep only the highest-impact batch active; move the rest to candidates or assumptions |
| Asked implementation-style questions | Downgrade to agent-designed internals unless visible behavior changes |
| P1/P2 question reveals a P0 contract change | Mark downstream artifacts `stale` and return to P0 |
| Source doc conflicts with user tests | Record the conflict and ask only if it changes golden outputs |
| Spec depends on upstream-only facts | Fold the facts into `*-spec.md` before review |
| Test plan depends on non-spec facts | Repair `*-spec.md` first |
| Code started before tests | Stop coding, write/approve tests, then resume |

## Completion Checklist

Before declaring success, ensure the latest approved baseline is reflected in:

1. `*-understanding.md`
2. `*-p0-questions.md`
3. `*-global-flow.md`
4. `*-p1-questions.md`
5. `*-submodule-design.md`
6. `*-p2-questions.md` if P2 was considered
7. `*-boundary-rules.md` if P2 was run, or skipped P2 risks folded into `*-spec.md`
8. `*-spec.md`
9. `*-spec-review.md`
10. `*-test-plan.md`
11. `*-test.py`
12. `golden.py`
