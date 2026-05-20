# Golden Test Plan Template

Use this template when writing `*-test-plan.md`.

The test plan converts the approved spec into executable test intent. It must be short, traceable, and focused on golden behavior.

## Required Header

```markdown
# [Topic] Golden Test Plan

Status: draft | approved | stale | superseded
Last Updated: YYYY-MM-DD HH:mm
Profile: generic | python-golden | cpu-preprocess | parser | validator | rule-engine | other
Derived From:
- [approved spec.md]
- [user-provided test case path or description]
```

## Required Sections

### 1. Purpose

- Behavior validated by this plan
- In-scope golden implementation
- Out-of-scope implementation details outside the golden

### 2. User-Provided Test Cases

Record the user examples as anchors.

| Case ID | Source | Input Summary | Expected Output/Error | Notes |
|---------|--------|---------------|-----------------------|-------|

Do not rewrite expected behavior silently. If normalization is needed, explain it in the next section.

### 3. Normalized Canonical Cases

Convert user examples into executable-test-ready cases.

| Case ID | Normalized Input | Expected Result | Covered Spec Rules | Normalization Notes |
|---------|------------------|-----------------|--------------------|---------------------|

### 4. Rule Coverage Matrix

Map important spec rules to tests.

| Spec Rule | Test Case(s) | Category | Covered? | Gap or Rationale |
|-----------|--------------|----------|----------|------------------|

Categories should normally include:

- P0 contract
- P1 core behavior
- P2 boundary/conflict/default behavior when P2 was run or critical-only
- regression or must-not-break behavior

Every output-changing rule should be covered or have an explicit rationale.

### 5. Agent-Expanded Cases

Add only high-value cases derived from the spec.

| Case ID | Category | Scenario | Expected Result | Source Rule |
|---------|----------|----------|-----------------|-------------|

Prefer a few strong cases over broad low-value coverage.

### 6. Expected-Output Comparison Strategy

Define how test assertions check `golden.py` outputs against expected outputs:

- exact vs tolerant numeric comparison
- field order and deterministic sorting
- dtype, shape, precision, or unit expectations when applicable
- error/result representation
- ignored fields, if any

This only validates the generated golden against expected results from the approved spec and test cases.

### 7. Executable Test Mapping

- Expected test file path: `docs/business-specs/YYYY-MM-DD-<topic>-test.py` or project-appropriate path
- Expected golden path: `golden.py` or project-appropriate path
- Test command: `pytest [path]`
- Coverage command, if tooling exists
- Optional case file path, if useful: `docs/business-specs/YYYY-MM-DD-<topic>-cases.json`
- Optional test harness path, if useful: `golden_test_harness.py`

Map cases to test functions:

| Case ID | Test Function | Notes |
|---------|---------------|-------|

### 8. Open Test Gaps

List only gaps that remain after spec approval:

| Gap | Why It Remains | Risk | Blocking? |
|-----|----------------|------|-----------|

If a gap changes expected golden behavior for a critical rule, return to the spec stage instead of approving the test plan.
If P2 was skipped, record that boundary coverage is intentionally limited and ensure skipped P2 gaps do not affect approved canonical tests.

## Rules

- Derive expected behavior from `*-spec.md`, not upstream working artifacts.
- Encode user-provided cases first.
- Keep the plan concise.
- Do not duplicate the whole spec.
- Do not generate a separate harness unless it reduces test complexity or improves stability.
- A harness must not introduce business rules that are absent from the spec.
- Do not start coding until this plan is approved.
- If expected behavior can only be learned from upstream artifacts, repair `*-spec.md` before finalizing this plan.
