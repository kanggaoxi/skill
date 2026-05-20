# business-spec-to-golden

A Codex Skill for turning unreliable design documents and a few test cases into a clarified spec, executable tests, and a golden program.

## Positioning

This Skill is not tied to one narrow business scenario. Its core use case is:

- source design documents may be incomplete, misleading, domain-heavy, or internally inconsistent
- the user has only a small number of test cases
- the agent must clarify the implementation target without overwhelming the developer
- the final output must be a test-validated golden implementation

The default implementation profile is Python with `pytest` and `golden.py`. Other languages should be used only when explicitly requested or required by the repository.

## Key Features

- **Evidence discipline** - separates source document facts, user test facts, user confirmations, assumptions, and agent inferences
- **P0/P1/P2 layered convergence** - keeps the original staged clarification model, but generates questions layer by layer
- **Question budget** - asks only the smallest high-impact batch needed for the next baseline
- **Optional P2 pass** - lets the developer decide whether to spend time on boundary/conflict details
- **Bad-document resistance** - records source/test conflicts and does not treat official-looking prose as unquestioned truth
- **Standalone spec** - folds all golden-relevant rules into `*-spec.md`
- **Spec review gate** - reviews the spec before user approval and test planning
- **Test-first golden generation** - writes executable tests before `golden.py`
- **Optional test harness** - generated only when test loading or expected-output comparison would otherwise become fragile

## Workflow

```
1. Understanding → *-understanding.md
2. P0 system contract → *-p0-questions.md → *-global-flow.md
3. P1 core behavior → *-p1-questions.md → *-submodule-design.md
4. Optional P2 boundary/conflict/default behavior → *-p2-questions.md → optional *-boundary-rules.md
5. Spec → *-spec.md
6. Spec review → *-spec-review.md
7. User approval
8. Test plan → *-test-plan.md
9. Executable tests → *-test.py
10. Golden program → golden.py
```

## P0/P1/P2 Semantics

| Layer | Purpose | Typical Questions |
|-------|---------|-------------------|
| P0 | Golden scope and system contract | inputs, outputs, in-scope slice, external contracts, authoritative tests |
| P1 | Core normal-path behavior | extraction, mapping, calculation, conversion, filtering, aggregation, ordering, precedence |
| P2 | Optional boundary and conflict behavior | missing input, invalid values, duplicates, conflicts, defaults, error/rejection behavior |

The agent should not dump all questions at once. Each layer has a candidate pool, a ranked question budget, and a baseline summary. P2 is entered only when the developer chooses full or critical-only boundary clarification; otherwise skipped P2 risks are recorded in the spec.

## Output Files

All files normally go to `docs/business-specs/YYYY-MM-DD-<topic>-*`:

| File | Content |
|------|---------|
| `*-understanding.md` | working model, evidence map, trust/conflict notes |
| `*-p0-questions.md` | P0 candidate pool and decisions |
| `*-global-flow.md` | approved system contract baseline |
| `*-p1-questions.md` | P1 candidate pool and decisions |
| `*-submodule-design.md` | approved core behavior baseline |
| `*-p2-questions.md` | P2 candidate pool and decisions |
| `*-boundary-rules.md` | approved boundary/conflict/default baseline when P2 is run |
| `*-spec.md` | standalone golden-oriented spec |
| `*-spec-review.md` | blocking review result |
| `*-test-plan.md` | concise test plan and executable mapping |
| `*-test.py` | executable pytest tests |
| `*-cases.json` | optional case data when useful |
| `golden_test_harness.py` | optional helper for loading cases and comparing expected outputs |
| `golden.py` | standard golden implementation |

## Profiles

The workflow is general. The Skill includes default guidance for:

- Python golden generation
- CPU preprocessing before model inference
- telecom or other domain-heavy source documents

Profile-specific checks are applied only when they match the task.

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
