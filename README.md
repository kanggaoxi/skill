# business-spec-to-golden

A Claude Code Skill that transforms requirement documents into reviewed delivery specs and test-validated golden reference programs.

## Overview

This Skill converts ambiguous requirements into:

1. **Working-Model Understanding** - A correction-friendly baseline that separates source facts from agent interpretation
2. **Staged Question Ledgers** - Separate P0, P1, and P2 ledgers with reconciliation
3. **Tiered Baseline Outputs** - Structural, module, and boundary artifacts
4. **Reviewed Delivery Spec** - A standalone implementation-ready spec plus isolated review
5. **Approved Test Plan and Executable Tests** - User-anchored plan plus runnable tests
6. **Golden Reference Program** - Passing tests and coverage gates

## Key Features

- **Working-Model Understanding** - Scope, structure, and ambiguities are surfaced before detailed questioning
- **Stage-by-Stage Ledgers** - P0, P1, and P2 are generated only when needed
- **Ledger Reconciliation** - New answers can resolve, obsolete, or supersede future questions
- **Baseline Artifacts** - Each tier produces a compact input for the next stage
- **Isolated Spec Review** - Design docs are reviewed by a separate subagent before user approval
- **User-Anchored Test Planning** - Formal test planning starts from user examples, then agent expands coverage
- **Design Freeze and Test Freeze** - Code starts only after approved spec and test plan
- **Coverage Gate** - Golden program must pass tests and meet coverage targets

## Single Skill

This repository maintains a single `SKILL.md`, with detailed format references under `references/`.

## Workflow

```
1. Working-Model Understanding → *-understanding.md
2. P0 Clarification → *-p0-questions.md → *-global-flow.md
3. P1 Clarification → *-p1-questions.md → *-submodule-design.md
4. P2 Clarification → *-p2-questions.md → *-boundary-rules.md
5. Spec Doc → *-spec.md
6. Spec Review → *-spec-review.md
7. User Review & Design Freeze
8. Collect User Examples → Test Plan → *-test-plan.md
9. Executable Tests → *-test.js / *-test.py
10. Golden Program → tests + coverage gates
```

## P0/P1/P2 Semantics

| Tier | Scope | Questions About |
|------|-------|-----------------|
| **P0** | Structure-level | Scope, module boundaries, system I/O, main flow, structural handoffs |
| **P1** | Normal-path module behavior | Module responsibilities, business inputs/outputs, transform logic, precedence |
| **P2** | Boundary and failure behavior | Missing input, invalid values, duplicates, conflicts, rejection behavior |

## Output Files

All files go to `docs/business-specs/YYYY-MM-DD-<topic>-*`:

| File | Content |
|------|---------|
| `*-understanding.md` | Working-model understanding and ambiguity list |
| `*-p0-questions.md` | Structure-level question ledger |
| `*-p1-questions.md` | Normal-path question ledger |
| `*-p2-questions.md` | Boundary/failure question ledger |
| `*-global-flow.md` | Structural baseline |
| `*-submodule-design.md` | Normal-path module baseline |
| `*-boundary-rules.md` | Boundary decision matrix |
| `*-spec.md` | Full delivery spec and downstream source of truth |
| `*-spec-review.md` | Isolated review result for the delivery spec |
| `*-test-plan.md` | Human-readable test design and traceability |
| `*-test.js` / `*-test.py` | Executable tests with CLI and coverage commands |

## Usage

```
/business-spec-to-golden
```

Or provide your requirements document:

```
Here's my product requirements document [attach document].
Please help me generate a delivery spec and reference implementation.
```

## Test-Driven Golden Program

The golden program is developed only after the spec is reviewed and the test plan is user-anchored:

1. Review `*-spec.md` through an isolated subagent and record the result
2. Collect user canonical examples and must-not-break behaviors
3. Expand a human-readable `*-test-plan.md` by test category
4. Write executable tests with CLI and coverage commands
5. Implement the golden program
6. Iterate until all tests pass
7. Enforce coverage target (`>= 80%`, prefer `>= 90%` for pure business logic)

## Standalone Spec Rule

`*-spec.md` is the delivery artifact. A fresh session given only that file should still be able to design tests and generate the golden program correctly. Earlier artifacts such as `*-understanding.md`, `*-global-flow.md`, `*-submodule-design.md`, and `*-boundary-rules.md` are for clarification traceability and staging, not for carrying business-critical rules exclusively.

## Files

```
business-spec-to-golden/
├── SKILL.md
├── README.md
├── README-CN.md
└── references/
    ├── artifact-header-template.md
    ├── spec-template.md
    ├── spec-document-reviewer-prompt.md
    ├── spec-review-template.md
    └── test-plan-template.md
```

## License

MIT
