# Golden-Oriented Spec Template

Use this template when writing `*-spec.md`.

The spec is the downstream source of truth for test planning and golden implementation. It must be complete enough that a new session can implement the golden from this file alone.

## Required Header

```markdown
# [Topic] Golden-Oriented Spec

Status: draft | approved | stale | superseded
Last Updated: YYYY-MM-DD HH:mm
Profile: generic | python-golden | cpu-preprocess | parser | validator | rule-engine | other
Derived From:
- [source design document path]
- [user-provided test case path or description]
- [approved P0/P1 baseline artifacts]
- [approved P2 baseline artifact, or note that P2 was skipped/deferred]
```

## Required Sections

### 1. Objective and Scope

- What the golden program must prove
- In-scope processing slice
- Explicit out-of-scope behavior
- Success criteria for the generated golden

### 2. Evidence and Trust Notes

Summarize only evidence that matters for golden behavior.

| Rule or Fact | Source | Trust Level | Notes |
|--------------|--------|-------------|-------|
| | source-doc / user-test / user-confirmed / agent-inferred / assumption | high / medium / low / conflict | |

Rules:

- User-confirmed facts and user-provided test cases usually outrank ambiguous source prose.
- Agent inferences must be labeled as inferences.
- Conflicts must name both sides and the chosen resolution or blocking question.

### 3. P0 Baseline: System Contract

- System-level inputs
- System-level outputs
- External caller/model/input contract
- Main processing stages or modules
- Authoritative examples or tests
- P0 assumptions and deferrals that do not block code generation

### 4. P1 Baseline: Core Processing Rules

List normal-path behavior as implementable rules.

Use a compact table when possible:

| Rule ID | Condition/Input | Processing Rule | Output Effect | Source |
|---------|-----------------|-----------------|---------------|--------|

Cover applicable behavior:

- extraction and mapping
- calculations and conversions
- filtering, aggregation, ordering, ranking, windowing
- rule precedence and tie-breaking
- normal-path output construction

### 5. P2 Baseline: Boundary, Conflict, and Default Rules

State whether P2 was `full`, `critical-only`, or `skipped`.

Use a decision table:

| Case | Condition | Expected Behavior | Output/Error | Source |
|------|-----------|-------------------|--------------|--------|

Cover only observable behavior:

- missing or empty input
- invalid or out-of-range values
- duplicate or conflicting data
- default and fill values
- rejection/error behavior
- source/test contradictions that affect output

If P2 was skipped, list deferred boundary risks instead of inventing behavior:

| Deferred P2 Item | Why Deferred | Assumed Behavior For Golden | Risk |
|------------------|--------------|-----------------------------|------|

### 6. Input Contract

Define the input format clearly enough to write tests.

For each input item, include:

- name and business meaning
- structure/type
- required or optional
- unit, value range, precision, or enum values when applicable
- relationship to other inputs
- missing/invalid behavior or a pointer to the P2 rule

### 7. Output Contract

Define the output format clearly enough to compare results.

Include:

- structure/type
- field names, order, dtype, shape, unit, precision, or tolerance when applicable
- deterministic ordering rules
- default/fill behavior
- error/result representation

### 8. Canonical Examples

Include user-provided examples first, then any agent-normalized examples.

Each example must include:

- name
- input
- expected output or error
- rules covered
- whether the example came from the user, source doc, or agent expansion

### 9. Implementation Freedom

List choices the golden implementer may decide without changing visible behavior:

- helper functions
- internal normalized structures
- file layout
- variable names
- non-observable implementation details

Do not put business rules in this section.

### 10. Profile-Specific Requirements

Use only applicable profile checks.

#### Python Golden

- entrypoint name and signature, if fixed
- expected file: `golden.py`
- expected tests: `*-test.py`
- framework: `pytest`
- deterministic behavior requirements

#### CPU Preprocess

When applicable, specify:

- input messages/records/files
- field extraction rules
- units, normalization, scaling, and precision
- cross-record association, sorting, ranking, aggregation, and windowing
- model-input order, dtype, shape, and fill values
- behavior for missing messages/fields, duplicates, stale values, and conflicts

### 11. Open Assumptions

Only non-blocking assumptions may remain.

| Assumption | Why Non-Blocking | Risk If Wrong | How To Detect |
|------------|------------------|---------------|---------------|

If an assumption can change expected golden output for known tests or core acceptance behavior, it is blocking and must be resolved before approval.

### 12. Standalone Readiness Check

State `yes` or `no`:

- A new session given only this file can write the test plan.
- A new session given only this file can implement `golden.py`.
- Every critical rule has an evidence source or explicit assumption.
- No critical behavior exists only in upstream artifacts.
- No unresolved ambiguity would change visible output or test assertions.
- Skipped P2 items, if any, are explicitly listed and do not affect approved canonical tests.

## Prohibited Content

- `TODO`
- `TBD`
- unresolved contradictions
- hidden assumptions presented as facts
- "same as upstream document" as normative content
- implementation-only detail disguised as business clarification

## Quality Bar

The spec is ready only if:

- two engineers would produce the same visible behavior
- important source/test conflicts are resolved or explicitly contained
- user-provided tests are represented as canonical examples
- P0/P1 baselines and any run P2 baseline are folded into the spec
- skipped P2 risks are explicit instead of silently resolved
- the golden can be implemented without reopening earlier stage artifacts
