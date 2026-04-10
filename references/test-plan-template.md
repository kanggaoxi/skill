# Test Plan Template

Use this template when writing `*-test-plan.md`.

The test plan is the human-readable test baseline. It is approved before executable tests are treated as final.
It must be derivable from `*-spec.md` alone.

## Required Header

```markdown
# [Topic] Test Plan

Status: draft | approved | stale | superseded
Last Updated: YYYY-MM-DD HH:mm
Derived From:
- [approved spec.md]
```

## Required Sections

### 1. Purpose

- What behavior this test plan validates
- Which implementation slice it covers

### 2. User-Provided Canonical Examples

For each example include:

- name
- input
- expected output or expected error
- why it matters

### 3. Agent-Expanded Coverage Matrix

Group tests by behavior:

- normal path
- boundary values
- invalid input
- conflict or precedence rules
- duplicate handling
- explicit error behavior

Use a concise table:

| Test ID | Category | Scenario | Expected Result | Source Rule |
|---------|----------|----------|-----------------|-------------|

### 4. Must-Not-Break Behaviors

- Rules the user considers critical
- Behaviors that must remain stable during implementation iteration

### 5. Executable Test Mapping

- Which cases will become executable tests
- Expected test file path
- Expected CLI command
- Expected coverage command

### 6. Open Questions or Deferrals

- Only items that must be resolved before coding
- If critical, return to clarification rather than silently carrying them forward

## Rules

- Keep the plan concise
- Use canonical answers, not raw conversation dumps
- Ensure important spec rules map to explicit tests
- If expected behavior can only be learned from `*-understanding.md`, `*-global-flow.md`, `*-submodule-design.md`, or `*-boundary-rules.md`, stop and repair `*-spec.md` before finalizing the test plan
- Do not start coding until this plan is approved
