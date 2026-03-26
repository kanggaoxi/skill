# business-spec-to-golden

A Claude Code Skill that transforms requirement documents into detailed design specifications and golden reference programs with test-driven development.

## Overview

This Skill converts ambiguous requirements into:

1. **Document Understanding Notes** - Externalized interpretation of the source
2. **Question Ledger** - File-based P0/P1/P2 questions with answers
3. **Tiered Intermediate Outputs** - Global flow, submodule design, boundary rules
4. **Reviewed Design Spec** - Implementation-ready specification
5. **Test Cases** - With CLI entry for validation
6. **Golden Reference Program** - Passing all tests

## Key Features

- **File-First Rule** - Every question comes from the question ledger file, never from memory
- **P0/P1/P2 Tiering** - Global → Submodule → Boundary questions in strict order
- **Intermediate Outputs** - Each tier produces a structured markdown file
- **Test-Driven Development** - Golden program must pass all tests
- **Automated Spec Review** - Subagent reviews spec before user review

## Two Versions

| Version | File | Lines | Target Models |
|---------|------|-------|---------------|
| **General** | `SKILL.md` | ~230 | All models |
| **Full** | `SKILL-FULL.md` | ~350 | Strong models (Claude, GPT-4) |

### Version Differences

| Feature | SKILL.md | SKILL-FULL.md |
|---------|----------|---------------|
| Detailed workflow steps | Basic | Comprehensive |
| Test file examples | Minimal | Full examples |
| Error recovery table | 4 items | 5 items |
| State tracking | Simple | Detailed |

## Workflow (10 Stages)

```
1. Document Understanding → *-understanding.md
2. Question Ledger → *-questions.md (P0/P1/P2)
3. P0 Clarification → *-global-flow.md
4. P1 Clarification → *-submodule-design.md
5. P2 Clarification → *-boundary-rules.md
6. Design Doc → *-design.md
7. Spec Review (subagent)
8. User Review & Approve
9. Test Cases → *-test.js with CLI
10. Golden Program → test-driven iteration
```

## P0/P1/P2 Tiering

| Tier | Scope | Questions About |
|------|-------|-----------------|
| **P0** | Global | Input/output formats, I/O contracts, submodule list, execution order, inter-module dataflow |
| **P1** | Submodule | Each module's input/output, transform logic, decision rules |
| **P2** | Boundary | Empty/invalid input, boundary values, exception handling |

## Output Files

All files go to `docs/business-specs/YYYY-MM-DD-<topic>-*`:

| File | Content |
|------|---------|
| `*-understanding.md` | Document structure, module inventory, known I/O |
| `*-questions.md` | P0/P1/P2 questions with status and answers |
| `*-global-flow.md` | Flow diagrams, I/O contracts, module relationships |
| `*-submodule-design.md` | Each submodule's input/output/transform |
| `*-boundary-rules.md` | Boundary rules, exception handling |
| `*-design.md` | Full implementation spec |
| `*-test.js` | Test cases with CLI (`node *-test.js --all`) |

## Usage

```
/business-spec-to-golden
```

Or provide your requirements document:

```
Here's my product requirements document [attach document].
Please help me generate a design document and reference implementation.
```

## Test-Driven Golden Program

The golden program is developed test-first:

1. Collect input/output examples from user
2. Design boundary and exception test cases
3. Write test file with CLI entry
4. Implement golden program
5. Iterate until ALL tests pass

```bash
# Run all tests
node docs/business-specs/2024-01-15-promo-test.js --all
```

## Example Session

**Input**: Promotion rules document

**Process**:
1. Agent writes understanding notes
2. Agent builds question ledger (P0: 5, P1: 8, P2: 4 questions)
3. P0: Asks about inputs, outputs, modules → writes global-flow.md
4. P1: Asks about each module's logic → writes submodule-design.md
5. P2: Asks about boundaries → writes boundary-rules.md
6. Writes design.md
7. Subagent reviews design
8. User approves
9. User provides test examples, agent writes test file
10. Agent implements golden program, all tests pass

## Files

```
business-spec-to-golden/
├── SKILL.md          # General version
├── SKILL-FULL.md     # Full version for strong models
├── README.md         # This file
└── references/
    └── spec-document-reviewer-prompt.md
```

## License

MIT
