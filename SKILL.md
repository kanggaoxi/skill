---
name: business-spec-to-golden
description: "Turn rough business requirements into a clarified, reviewed implementation design spec and a test-validated golden program. Enforce a file-first workflow with a working-model understanding doc, staged P0/P1/P2 ledgers, approval gates, isolated spec review, and test-driven delivery."
---

# Business Spec to Design Spec and Golden Program

Turn a rough requirement document into:

1. `*-understanding.md`
2. `*-p0-questions.md`, `*-p1-questions.md`, `*-p2-questions.md`
3. `*-global-flow.md`, `*-submodule-design.md`, `*-boundary-rules.md`
4. `*-design.md` plus `*-spec-review.md`
5. `*-test-plan.md` and executable tests
6. `golden.js` or `golden.py`

## Hard Gates

- **Stage Order**: Source Review → Understanding → P0 → P1 → P2 → Design Doc → Spec Review → User Review → Test Plan → Executable Tests → Golden Program.
- **File-First**: Read the current stage file before acting. Update it after each answer, correction, or approval.
- **Single Question**: Ask exactly one business question at a time.
- **Business Only**: Clarification is about business meaning, scope, contracts, flow, examples, priorities, and failure behavior. Do not ask engineering choices.
- **No Silent Assumptions**: Missing business rules must be clarified or recorded as explicit assumptions for confirmation.
- **Approval Gates**: Require user approval after `*-understanding.md`, `*-global-flow.md`, `*-submodule-design.md`, `*-boundary-rules.md`, `*-design.md`, `*-test-plan.md`, and final delivery.
- **TDD Gate**: Start coding only after the test plan is approved and the executable test file exists.
- **Completion Gate**: Delivery requires all tests passing and coverage meeting the configured threshold.

## Output Files

Default path: `docs/business-specs/YYYY-MM-DD-<topic>-*`

| Stage | Output |
|-------|--------|
| Understanding | `*-understanding.md` |
| P0 Ledger | `*-p0-questions.md` |
| P1 Ledger | `*-p1-questions.md` |
| P2 Ledger | `*-p2-questions.md` |
| Optional History | `*-question-history.md` |
| P0 Baseline | `*-global-flow.md` |
| P1 Baseline | `*-submodule-design.md` |
| P2 Baseline | `*-boundary-rules.md` |
| Design Doc | `*-design.md` |
| Spec Review | `*-spec-review.md` |
| Test Plan | `*-test-plan.md` |
| Executable Tests | `*-test.js` or `*-test.py` |
| Golden Program | `golden.js` or `golden.py` |

Use [artifact-header-template.md](/home/kgx/.claude/skills/business-spec-to-golden/references/artifact-header-template.md) for stage artifacts and ledgers unless a stronger template overrides it. If upstream structure changes, mark dependent files `stale` before continuing.

## Stage 1: Understanding

Write `*-understanding.md` as a working model, not final truth.

It must separate:

- `Source Facts`
- `Working Interpretation`
- `Scope Proposal`
- `Ambiguities and Risk Points`

Recommended sections:

1. `Status`
2. `Source`
3. `Current Scope Proposal`
4. `Source Facts`
5. `Working Interpretation`
6. `Candidate Modules or Processing Stages`
7. `Known System-Level Inputs and Outputs`
8. `Ambiguities and Risk Points`
9. `What Must Be Confirmed Before P0`

Rules:

- Keep it short and correction-friendly
- Do not present guesses as facts
- If the user corrects structure, scope, or major business meaning, update this file first
- Do not start P0 until this file is accepted or corrected and reconfirmed

## P0/P1/P2 Semantics

- **P0: Structure-Level**
  Use P0 when an answer could change scope, module boundaries, system-level I/O, main flow, inter-module handoffs, or the content of `*-understanding.md`.
- **P1: Normal-Path Module Behavior**
  Use P1 when structure is stable and the question refines one module or a small cluster on the normal business path.
- **P2: Boundary, Conflict, and Failure**
  Use P2 for missing input, invalid input, thresholds, duplicates, conflict resolution, fallback behavior, and error surfaces that affect observable behavior, acceptance criteria, or tests.

Do not classify by topic alone. Classify by impact radius.

## Ledger Strategy

Do not generate a full P0/P1/P2 mega-ledger up front.

Generate ledgers stage by stage:

1. After approved `*-understanding.md`, create `*-p0-questions.md`
2. After approved P0 baseline, create `*-p1-questions.md`
3. After approved P1 baseline, create `*-p2-questions.md`

This keeps the active ledger small and avoids invalid early questions.

### Ledger Body

Use the artifact header, then this body shape:

```markdown
# P0 Question Ledger: [Topic]

| ID | Priority | Depends On | Question | Status | Canonical Answer | Notes |
|----|----------|------------|----------|--------|------------------|-------|
| P0-1 | critical | - | What are the fixed system-level inputs and outputs for this slice? | open | | |

## Decision Summary
- [confirmed decisions only]
```

Row status values:

- `open`
- `answered`
- `confirmed`
- `deferred`
- `resolved-by`
- `obsolete`
- `superseded`

Rules:

- `Canonical Answer` is a compressed decision statement, not a pasted conversation
- `Depends On` blocks questions until the upstream item is settled

### After Every Answer: Reconcile

After each user answer:

1. Mark the current row `answered`
2. Rewrite the answer into a canonical decision
3. Ask for precise confirmation
4. Mark it `confirmed` once confirmed
5. Re-read the active ledger
6. Sweep remaining unresolved items:
   - covered questions → `resolved-by`
   - no-longer-relevant questions → `obsolete`
   - poorly framed questions → `superseded`
   - newly revealed questions → add only if they belong to the current or a later tier
7. Recompute the next highest-priority unresolved question

Do not ask the next question before reconciliation completes.

### Structural Change Rule

If an answer changes scope, module boundaries, or system-level flow:

1. Update `*-understanding.md`
2. Mark dependent artifacts `stale`
3. Rebuild the active ledger as needed
4. Return to P0

## Clarification Boundaries

Separate fixed business contracts from internal implementation contracts.

**Must confirm with the user**

- system-level input structure and semantics
- system-level output structure and semantics
- externally visible interface contracts
- module boundaries that change business behavior
- internal interfaces the user explicitly marks as fixed

**Usually agent-designed**

- internal data structures between submodules
- helper objects, normalized forms, and temporary representations
- implementation-only fields that do not change business meaning

Only ask about submodule I/O details when different choices would change business behavior, module boundaries, errors, or externally visible outcomes.

## P0 Exit Artifact

When all P0 questions are `confirmed` or `deferred`, write `*-global-flow.md` as the structural baseline.

Include:

1. `In-Scope Slice`
2. `System-Level Input Contract`
3. `System-Level Output Contract`
4. `Module List and Responsibilities`
5. `Execution Flow`
6. `Inter-Module Dataflow`
7. `Deferred Structural Questions or Explicit Assumptions`

This file captures confirmed structure only, not Q&A history.

## P1 Exit Artifact

When all P1 questions are `confirmed` or `deferred`, write `*-submodule-design.md` as the normal-path module baseline.

For each module include:

1. `Module Name`
2. `Purpose`
3. `Business Inputs`
4. `Business Outputs`
5. `Normal-Path Transform Logic`
6. `Decision Rules and Precedence`
7. `Dependencies`
8. `Agent-Designed Internal Structures` if needed

Keep it focused on confirmed behavior, not speculative implementation detail.

## P2 Exit Artifact

When all P2 questions are `confirmed` or `deferred`, write `*-boundary-rules.md` as a boundary decision matrix.

Use a decision-oriented format such as:

| Case | Condition | Expected Behavior | Output/Error | Notes |
|------|-----------|-------------------|--------------|-------|

Cover only business-visible cases:

- missing or empty input
- invalid values
- thresholds
- duplicate or conflicting data
- conflict resolution precedence
- error or rejection behavior

Do not turn this file into a general edge-case dump.

## Design Doc

Write `*-design.md` using [spec-template.md](/home/kgx/.claude/skills/business-spec-to-golden/references/spec-template.md).

The spec must:

- be precise enough that two engineers would produce the same visible behavior
- trace critical rules to approved artifacts or confirmed decisions
- separate fixed contracts from agent-designed internals
- contain no `TODO`, `TBD`, placeholders, or unresolved critical ambiguity

## Spec Review and Design Freeze

After writing the spec:

1. Dispatch a reviewer subagent using [spec-document-reviewer-prompt.md](/home/kgx/.claude/skills/business-spec-to-golden/references/spec-document-reviewer-prompt.md)
2. Pass only the spec path and minimum task-local review context
3. Write the reviewer result to `*-spec-review.md` using [spec-review-template.md](/home/kgx/.claude/skills/business-spec-to-golden/references/spec-review-template.md)
4. If blocking issues are found, fix `*-design.md`, then re-dispatch and refresh `*-spec-review.md`
5. Stop after 3 rounds and surface unresolved issues to the user

Rules:

- Do not show `*-design.md` to the user for approval until the isolated review has completed
- Do not show `*-design.md` to the user if `*-spec-review.md` is `Issues Found` or `Review Blocked`
- Do not move to tests unless `*-spec-review.md` says `Ready For User Review: yes` and the user has approved `*-design.md`
- Treat blocking review issues as a hard gate, not advisory text
- If isolated review fails to run or cannot complete, treat it as `Review Blocked` and stop downstream progress

Then require explicit user approval on `*-design.md` before moving to tests.

If business rules change after approval, mark `*-design.md` and dependent test/code artifacts `stale` and return to the earliest affected stage.

## Test Planning

Before writing the formal test plan, collect user test anchors:

1. Ask for at least 2 canonical input/output examples
2. Ask for must-not-break behaviors
3. If failure paths matter, ask for at least 1 failure or error example

Only after receiving these anchors may the agent draft categorized test candidates. Formal `*-test-plan.md` generation using [test-plan-template.md](/home/kgx/.claude/skills/business-spec-to-golden/references/test-plan-template.md) happens only after the user has confirmed or corrected the categories.

Responsibilities:

- user provides canonical examples, must-not-break behaviors, and key failure expectations
- agent expands coverage for boundaries, invalid input, conflicts, and acceptance criteria

Rules:

- do not write the formal test plan before collecting user anchors
- organize expanded tests by category before finalizing the plan
- categories should usually include normal path, boundaries, errors, conflicts/precedence, and special-input handling
- require the user to correct or confirm categories before writing the formal test plan
- map important test cases back to spec rules
- keep human-readable examples separate from executable test code
- require user approval on the test plan before coding

## Executable Tests

After test-plan approval:

1. Choose framework from project context
   - `package.json` → prefer Node.js
   - `requirements.txt` or `pyproject.toml` → prefer Python with `pytest`
   - otherwise default to Node.js
2. Write the executable test file
3. Provide CLI commands for the suite and coverage

The test file must encode canonical examples plus critical boundary and failure behavior, and it must reflect the approved test plan.

## Golden Program

Only after the executable tests exist:

1. make a lightweight code plan
2. implement the golden program
3. run tests until green
4. run coverage
5. report completion only after both gates pass

Implementation rules:

- prefer correctness and readability over performance
- prefer a pure-function entrypoint when practical
- keep the implementation self-contained
- do not depend on wall-clock time, randomness, or network access
- handle approved boundary rules explicitly
- add only brief comments where traceability would otherwise be unclear

Coverage rules:

- default target: at least 80% line coverage
- prefer 90% or higher for pure business-logic code with limited I/O shell
- coverage does not replace explicit testing of critical business rules

## Invalidation Guide

- `*-understanding.md` structural changes can stale P0, P1, P2, stage outputs, spec, tests, and code
- `*-global-flow.md` changes stale P1, P2, spec, tests, and code
- `*-submodule-design.md` changes stale P2, spec, tests, and code
- `*-boundary-rules.md` changes stale spec, tests, and code
- `*-spec-review.md` becomes stale whenever `*-design.md` changes
- `*-design.md` changes after test planning stale tests and code

Mark stale files explicitly before regenerating them.

## Error Recovery

| Violation | Recovery |
|-----------|----------|
| Asked a question not in the active ledger | Add it to the correct tier file first, then ask from the file |
| Asked multiple questions | Keep only the first unresolved question active, then reconcile |
| Failed to reconcile after an answer | Re-read the ledger, update statuses, then continue |
| Kept asking after a structural correction | Update `*-understanding.md`, mark downstream files `stale`, and return to P0 |
| Skipped isolated spec review | Run the reviewer, write `*-spec-review.md`, then continue |
| Wrote a formal test plan before collecting user examples | Mark the test plan `stale`, collect user anchors, then regenerate |
| Asked about internal implementation details too early | Move it to design stage unless it changes business behavior |
| Let P2 expand without business impact | Remove or archive non-observable edge cases |

## Completion Checklist

Before declaring success, ensure these files exist and reflect the latest approved baseline:

1. `*-understanding.md`
2. `*-p0-questions.md`
3. `*-p1-questions.md`
4. `*-p2-questions.md`
5. `*-global-flow.md`
6. `*-submodule-design.md`
7. `*-boundary-rules.md`
8. `*-design.md`
9. `*-spec-review.md`
10. `*-test-plan.md`
11. `*-test.js` or `*-test.py`
12. `golden.js` or `golden.py`
