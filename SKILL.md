---
name: business-spec-to-golden
description: "Transform requirements into reviewed design specs and golden programs with test-driven development. Enforce file-first question ledger (P0/P1/P2), tiered intermediate outputs, and automated test validation before golden program."
---

# Requirements to Design Spec and Golden Program

Transform a rough requirements document into a reviewed implementation spec and a golden reference program through staged clarification with test-driven development.

## HARD-GATE

**Stage Order**: Document Understanding → Question Ledger → P0 Clarification → P1 Clarification → P2 Clarification → Design Doc → Spec Review → User Review → Test Cases → Golden Program. Never skip or reorder.

**Single Question Rule**: Ask ONE business question at a time. Wait for answer before next question.

**File-First Rule**: Every question MUST come from the question ledger file. Read the file before asking. Update the file after each answer. Never ask from memory.

**Business Focus**: Ask about business meaning, inputs/outputs, module relationships, rules, and edge cases. Do NOT ask about engineering choices during clarification.

**Scope Control**: For multi-module documents, first identify the whole structure, then pick one in-scope slice.

**Externalize State**: All understanding, questions, and summaries MUST be written to markdown files.

**Gates**: Require user approval at: (1) document understanding, (2) each tier's intermediate output (P0/P1/P2), (3) design doc, (4) test cases, (5) golden program.

---

## Output Files

All outputs go to `docs/business-specs/YYYY-MM-DD-<topic>-*` unless user specifies otherwise:

| Stage | Output File | Content |
|-------|-------------|---------|
| Understanding | `*-understanding.md` | Document structure, module inventory, known I/O |
| Question Ledger | `*-questions.md` | P0/P1/P2 questions with status and answers |
| P0 Output | `*-global-flow.md` | Flow diagrams, I/O contracts, module relationships |
| P1 Output | `*-submodule-design.md` | Each submodule's input/output/transform logic |
| P2 Output | `*-boundary-rules.md` | Boundary rules, exception handling rules |
| Design Doc | `*-design.md` | Full implementation spec |
| Test Cases | `*-test.js` or `*-test.py` | Test file with CLI entry |

---

## Stage 1: Document Understanding

1. Read the source document and extract its structure
2. Identify major modules, branches, and flows
3. Write understanding notes to `*-understanding.md`

Understanding notes structure:
1. **Document Structure** - sections, modules, flows
2. **Current Business Understanding** - what the system appears to do
3. **Module Inventory** - candidate submodules
4. **Known Global Inputs/Outputs** - anything explicit in source
5. **Known Relationships** - serial, parallel, optional, conditional

Present a concise summary and ask user to confirm or correct.

---

## Stage 2: Question Ledger

Build a complete question ledger and write to `*-questions.md`.

**P0: Global Level** - Questions about:
- Overall input formats and semantics
- Overall output formats and semantics
- I/O contracts
- List of submodules
- Execution order of submodules
- Input/output relationships between submodules

**P1: Submodule Level** - Questions about:
- Each submodule's input/output details
- Transformation logic
- Decision rules and precedence
- Dependencies on other modules

**P2: Boundary & Exception** - Questions about:
- Empty or missing input handling
- Invalid value handling
- Boundary values (min/max, thresholds)
- Duplicate or conflicting data
- Exception handling rules

### Question Ledger File Format

```markdown
# Question Ledger: [Topic]

## P0: Global Level
| ID | Question | Status | Answer |
|----|----------|--------|--------|
| P0-1 | What are the overall input formats? | open | |
| P0-2 | What submodules exist? | open | |

## P1: Submodule Level
| ID | Question | Status | Answer |
|----|----------|--------|--------|
| P1-1 | How does Module A transform input? | open | |

## P2: Boundary & Exception
| ID | Question | Status | Answer |
|----|----------|--------|--------|
| P2-1 | How to handle empty input? | open | |
```

**Status values**: `open`, `answered`, `confirmed`, `deferred`

---

## Stage 3: P0 Clarification (Global)

**Before each question**: Read `*-questions.md`, find next `open` P0 question.

**Question format**:
```markdown
**From**: P0-1 in questions.md
**Question**: [the question]
**Why it matters**: [correctness impact]
```

**After each answer**:
1. Update the question's `Status` and `Answer` in `*-questions.md`
2. If answer reveals new questions, add them to the ledger first
3. Confirm: "To confirm: [restatement]. Correct?"

**When P0 is complete** (all P0 questions `confirmed` or `deferred`):

Write `*-global-flow.md` containing:
1. **Overall Input Contract** - format, fields, semantics
2. **Overall Output Contract** - format, fields, semantics
3. **Module List** - all submodules in scope
4. **Execution Flow** - textual or diagram showing order and branching
5. **Inter-Module Dataflow** - what passes between modules

Example flow diagram:
```text
Input A + Input B
  -> Module M1
  -> Module M2
  -> Branch:
     - Path X -> Module M3 -> Output X
     - Path Y -> Module M4 -> Output Y
```

Ask user to approve this intermediate output before proceeding.

---

## Stage 4: P1 Clarification (Submodule)

**Before each question**: Read `*-questions.md`, find next `open` P1 question.

Same question format and update process as P0.

**When P1 is complete**:

Write `*-submodule-design.md` containing, for each submodule:
1. **Purpose** - what this module does
2. **Input** - what it receives
3. **Output** - what it produces
4. **Transform Logic** - step-by-step transformation
5. **Decision Rules** - rules in precedence order

Ask user to approve before proceeding.

---

## Stage 5: P2 Clarification (Boundary)

**Before each question**: Read `*-questions.md`, find next `open` P2 question.

Same question format and update process as P0.

**When P2 is complete**:

Write `*-boundary-rules.md` containing:
1. **Empty/Missing Input** - how to handle
2. **Invalid Values** - validation rules and rejection behavior
3. **Boundary Values** - min/max, inclusive/exclusive thresholds
4. **Duplicate Data** - merge, reject, or error?
5. **Exception Handling** - what errors to surface, how

Ask user to approve before proceeding.

---

## Stage 6: Design Doc

Write the full implementation spec to `*-design.md`:

1. **Objective** - Business outcome and success criteria
2. **Scope** - In-scope slice, out-of-scope items
3. **Global Flow** - From P0 output
4. **Domain Model** - Entities and business meaning
5. **Input Contract** - Full specification
6. **Output Contract** - Full specification
7. **Submodule Designs** - From P1 output
8. **Processing Flow** - End-to-end steps
9. **Boundary Rules** - From P2 output
10. **Examples** - Input/output pairs
11. **Clarification Decisions** - Key Q&A summary
12. **Acceptance Criteria** - What correct implementation must do

Goal: Two engineers reading this produce the same implementation.

---

## Stage 7: Spec Review Loop

After writing the spec file:

1. Dispatch a spec reviewer subagent using `references/spec-document-reviewer-prompt.md`
2. Provide only the spec path and minimum context
3. If `Issues Found`, fix and re-dispatch
4. Maximum 3 iterations, then surface to user

---

## Stage 8: User Review

Present the reviewed spec to user:

> "Spec written and reviewed. Please review `*-design.md` and confirm before we proceed to test cases."

Wait for user approval. Make changes if requested.

---

## Stage 9: Test Cases

### 9.1 Collect Examples from User

Ask user to provide 2-3 input/output examples:
> "Please provide 2-3 examples of input and expected output. You can describe them in any format you prefer."

Convert user's description to structured test data.

### 9.2 Design Additional Tests

Based on P2 output, design:
- Boundary value tests
- Exception handling tests
- Edge cases

### 9.3 Write Test File

Choose test framework based on project context:
- Node.js project → `*-test.js` with simple asserts
- Python project → `*-test.py` with pytest
- Unknown → default to Node.js

Provide CLI entry:
```bash
# Run all tests
node *-test.js --all

# Or for Python
python -m pytest *-test.py -v
```

### 9.4 User Confirmation

> "Test cases ready. Run `node *-test.js --all` to see them. Please confirm before we proceed to golden program."

---

## Stage 10: Golden Program

### 10.1 Create Plan

Lightweight plan covering:
- Public entrypoint
- Main modules
- Test verification approach

### 10.2 Implement

Rules:
- Correctness and readability first
- Self-contained implementation
- Brief comments linking to spec
- Explicit handling for boundary cases

### 10.3 Test-Driven Iteration

1. Run all tests
2. If any fail, fix the code
3. Repeat until ALL tests pass
4. Report final status to user

---

## State Tracking

Before each question, state:

```text
State: Stage [P0|P1|P2] | Question [ID] | Waiting: Yes/No | File: *-questions.md
```

If `Waiting: Yes` → STOP. Wait for user answer.

---

## Error Recovery

| Violation | Recovery |
|-----------|----------|
| Asked question not in file | "That question isn't in the ledger. Let me add it first." Add, then ask. |
| Asked multiple questions | Acknowledge, ask only the first one |
| Skipped reading file | "I need to read the question file first." Read, then ask. |
| Asked engineering question | Rephrase as business question |

---

## Output Summary

When complete:
1. `*-understanding.md` - Document understanding
2. `*-questions.md` - Full question ledger with answers
3. `*-global-flow.md` - P0 intermediate output
4. `*-submodule-design.md` - P1 intermediate output
5. `*-boundary-rules.md` - P2 intermediate output
6. `*-design.md` - Full implementation spec
7. `*-test.js` or `*-test.py` - Test cases with CLI
8. Golden program - Passing all tests
