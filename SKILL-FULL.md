---
name: business-spec-to-golden
description: "Turn rough business requirements into a clarified, reviewed implementation design spec and a test-validated golden program. Enforce file-first question ledger (P0/P1/P2), tiered intermediate outputs, automated spec review, and test-driven golden program development."
---

# Business Spec to Design Spec and Golden Program

Transform a rough requirement document into:

1. A documented understanding of the source document
2. A file-based question ledger with P0/P1/P2 tiering
3. Tiered intermediate outputs (global flow, submodule design, boundary rules)
4. A reviewed implementation design spec
5. Test cases with CLI entry
6. A golden reference program that passes all tests

## Hard Gates

- **Stage Order**: Document Understanding → Question Ledger → P0 Clarification → P1 Clarification → P2 Clarification → Design Doc → Spec Review → User Review → Test Cases → Golden Program. Never skip or reorder.
- **Single Question Rule**: Ask exactly one business question at a time. Wait for the answer before asking the next one.
- **File-First Rule**: Every question MUST come from the question ledger file. Read the file before asking any question. Update the file after each answer. Never ask from memory.
- **Business Focus**: Ask about business meaning, inputs/outputs, module relationships, decision rules, examples, boundaries, and failure behavior. Do not ask engineering choices.
- **No Silent Assumptions**: Do not invent missing business rules. Resolve with user or list as explicit assumptions.
- **Externalize Everything**: All understanding, questions, intermediate outputs, and summaries MUST be written to markdown files.
- **Approval Gates**: Require user approval after document understanding, after each tier's intermediate output (P0/P1/P2), after design doc, after test cases, and after golden program.
- **Test-Driven Golden**: The golden program must pass all test cases before delivery.

## Output Files

All outputs go to `docs/business-specs/YYYY-MM-DD-<topic>-*` unless user specifies otherwise:

| Stage | Output File | Content |
|-------|-------------|---------|
| Understanding | `*-understanding.md` | Document structure, module inventory, known I/O, relationships |
| Question Ledger | `*-questions.md` | P0/P1/P2 questions with status, priority, and answers |
| P0 Output | `*-global-flow.md` | Flow diagrams, I/O contracts, module relationships |
| P1 Output | `*-submodule-design.md` | Each submodule's input/output/transform logic |
| P2 Output | `*-boundary-rules.md` | Boundary rules, exception handling rules |
| Design Doc | `*-design.md` | Full implementation spec |
| Test Cases | `*-test.js` or `*-test.py` | Test file with CLI entry |

## Workflow

1. Read the source document and write understanding notes.
2. Build the question ledger with P0/P1/P2 questions.
3. P0 Clarification: ask from file, update file, produce global-flow output.
4. P1 Clarification: ask from file, update file, produce submodule-design output.
5. P2 Clarification: ask from file, update file, produce boundary-rules output.
6. Write the full design doc.
7. Run spec review loop (subagent).
8. User reviews and approves the spec.
9. Design and write test cases with CLI entry.
10. User confirms test cases.
11. Implement golden program with test-driven iteration.
12. Deliver golden program that passes all tests.

---

## Stage 1: Document Understanding

Before asking any clarification questions:

1. Read the source document and extract its structure
2. Identify major modules, branches, and flows
3. Identify what is already explicit about inputs, outputs, relationships
4. Write understanding notes to `*-understanding.md`

Understanding notes structure:

1. **Document Structure** - sections, modules, flows, processing stages
2. **Current Business Understanding** - what the system appears to do overall
3. **Module Inventory** - candidate submodules or processing steps
4. **Known Global Inputs** - inputs described in source, with formats if known
5. **Known Global Outputs** - outputs described in source, with formats if known
6. **Known Relationships** - which modules are serial, parallel, optional, conditional
7. **Initial Open Questions** - preliminary list of ambiguities

Present a concise understanding summary and ask the user to confirm or correct it.

---

## Stage 2: Question Ledger

Build a complete question ledger and write to `*-questions.md`.

### P0: Global Level

Questions about the overall system structure:

1. **Overall Input Formats** - What are the formats and semantics of all inputs?
2. **Overall Output Formats** - What are the formats and semantics of all outputs?
3. **I/O Contracts** - What guarantees and constraints apply to inputs/outputs?
4. **Submodule List** - What submodules or processing steps exist?
5. **Execution Order** - In what order do submodules execute?
6. **Inter-Module Dataflow** - What data passes between modules?

### P1: Submodule Level

Questions about each submodule's implementation:

1. **Submodule Input** - What exactly does this module receive?
2. **Submodule Output** - What exactly must this module produce?
3. **Transform Logic** - How does it derive output from input?
4. **Decision Rules** - Which rule wins on conflict?
5. **Dependencies** - What does it need from other modules?

### P2: Boundary & Exception

Questions about edge cases and errors:

1. **Empty/Missing Input** - How to handle?
2. **Invalid Values** - What is invalid, what happens?
3. **Boundary Values** - Min/max, inclusive/exclusive thresholds?
4. **Duplicate Data** - Merge, reject, or error?
5. **Exception Handling** - What errors to surface, how?

### Question Ledger File Format

```markdown
# Question Ledger: [Topic]

Generated: YYYY-MM-DD
Source: [source document path]

## P0: Global Level
| ID | Priority | Question | Status | Answer | Notes |
|----|----------|----------|--------|--------|-------|
| P0-1 | critical | What are the overall input formats? | open | | |
| P0-2 | critical | What submodules exist? | open | | |

## P1: Submodule Level
| ID | Priority | Question | Status | Answer | Notes |
|----|----------|----------|--------|--------|-------|
| P1-1 | high | How does Module A transform input? | open | | |

## P2: Boundary & Exception
| ID | Priority | Question | Status | Answer | Notes |
|----|----------|----------|--------|--------|-------|
| P2-1 | medium | How to handle empty input? | open | | |

## Summary
- P0: X open, Y confirmed, Z deferred
- P1: X open, Y confirmed, Z deferred
- P2: X open, Y confirmed, Z deferred
```

**Status values**: `open`, `answered`, `confirmed`, `deferred`
**Priority values**: `critical`, `high`, `medium`, `low`

---

## Stage 3: P0 Clarification (Global)

### Pre-Question Checklist

Before asking ANY P0 question:
- [ ] I have read `*-questions.md`
- [ ] The question exists in the P0 section with status `open`
- [ ] I am not waiting for a previous answer
- [ ] This is a business question, not engineering

### Question Format

```markdown
**From**: P0-1 in *-questions.md
**Priority**: critical
**Question**: [the exact question from the file]
**Context**: [quote from source document if relevant]
**Why it matters**: [how different answers change behavior]
**Options** (if useful):
A. ...
B. ...
```

### After Answer

1. Update the question's `Status` to `answered` and fill `Answer` in `*-questions.md`
2. If answer reveals new questions:
   - Add them to the appropriate section first
   - Then continue with current tier
3. Confirm: "To confirm: [precise restatement]. Correct?"
4. If confirmed, update status to `confirmed`

### P0 Exit Criteria

All P0 questions must be `confirmed` or `deferred` before proceeding.

### P0 Intermediate Output

Write `*-global-flow.md` containing:

1. **Overall Input Contract**
   - Format specification
   - Required/optional fields
   - Semantics of each field
   - Constraints and invariants

2. **Overall Output Contract**
   - Format specification
   - Field semantics
   - Ordering guarantees
   - Interpretation rules

3. **Module List**
   - All submodules in scope
   - Brief description of each

4. **Execution Flow**
   - Order of execution
   - Branching conditions
   - Parallel vs serial execution

5. **Inter-Module Dataflow**
   - What data passes between modules
   - Data transformation at each handoff

Example flow diagram:
```text
Input A + Input B
  -> [Validate] Module M1
  -> [Transform] Module M2
  -> [Branch] Decision D1:
     - Condition X -> Module M3 -> Output X
     - Condition Y -> Module M4 -> Module M5 -> Output Y
```

Ask user to approve this output before proceeding to P1.

---

## Stage 4: P1 Clarification (Submodule)

Same process as P0, but for P1 questions.

### P1 Intermediate Output

Write `*-submodule-design.md` containing, for each submodule:

1. **Module Name**
2. **Purpose** - what this module does
3. **Input**
   - What it receives
   - Format and constraints
4. **Output**
   - What it produces
   - Format and guarantees
5. **Transform Logic** - step-by-step transformation
6. **Decision Rules** - rules in precedence order
7. **Dependencies** - what it needs from other modules

Ask user to approve before proceeding to P2.

---

## Stage 5: P2 Clarification (Boundary)

Same process as P0, but for P2 questions.

### P2 Intermediate Output

Write `*-boundary-rules.md` containing:

1. **Empty/Missing Input Handling**
   - Which fields can be empty
   - What happens when required field is missing
   - Default values if any

2. **Invalid Value Handling**
   - Validation rules
   - What is considered invalid
   - Error messages or codes

3. **Boundary Values**
   - Min/max for numeric fields
   - Length limits for strings
   - Inclusive vs exclusive boundaries

4. **Duplicate Data Handling**
   - How to detect duplicates
   - Merge, reject, or error behavior

5. **Exception Handling**
   - What errors to surface
   - Error format
   - Recovery behavior if any

Ask user to approve before proceeding to design doc.

---

## Stage 6: Design Doc

Write the full implementation spec to `*-design.md`:

1. **Objective** - Business outcome and success criteria
2. **Scope** - In-scope slice, explicit out-of-scope items
3. **Global Flow** - From P0 output (reference or include)
4. **Domain Model** - Entities and business meaning
5. **Input Contract** - Full specification
6. **Output Contract** - Full specification
7. **Submodule Designs** - From P1 output (reference or include)
8. **Processing Flow** - End-to-end steps with precision
9. **Boundary Rules** - From P2 output (reference or include)
10. **Examples** - Input/output pairs for normal, edge, and conflict cases
11. **Clarification Decisions** - Summary of key Q&A outcomes
12. **Acceptance Criteria** - What correct implementation must do

### Design Doc Requirements

- No `TODO`, `TBD`, placeholders, or deferred decisions
- No hidden ambiguity in broad wording
- Every critical rule traceable to source or clarification
- Two engineers reading this produce the same implementation

---

## Stage 7: Spec Review Loop

After writing the spec file:

1. Dispatch a spec reviewer subagent using `references/spec-document-reviewer-prompt.md`
2. Provide only the spec path and minimum task-local context
3. Never pass full session history or private reasoning
4. If `Issues Found`, fix and re-dispatch
5. Maximum 3 iterations, then surface unresolved issues to user

---

## Stage 8: User Review

Present the reviewed spec:

> "Spec written and reviewed. Please review `*-design.md` and let me know if you want any changes before we proceed to test cases."

Wait for user approval. Make changes if requested.

---

## Stage 9: Test Cases

### 9.1 Collect Examples from User

Ask the user to provide input/output examples:

> "Please provide 2-3 examples of input and expected output. You can describe them in any format you prefer (JSON, plain text, code snippets, etc.). I'll convert them to structured test data."

### 9.2 Design Additional Tests

Based on P2 output, design tests for:
- Boundary values
- Invalid inputs
- Exception cases
- Edge cases

### 9.3 Choose Test Framework

Detect project context:
- Has `package.json` → Node.js with simple asserts
- Has `requirements.txt` or `pyproject.toml` → Python with pytest
- Unknown → Default to Node.js

### 9.4 Write Test File

Node.js example (`*-test.js`):
```javascript
// Test cases for [topic]
// Run: node *-test.js --all

const assert = require('assert');

const tests = [
  { name: 'normal case 1', input: {...}, expected: {...} },
  { name: 'boundary case', input: {...}, expected: {...} },
  { name: 'exception case', input: {...}, expectedError: '...' },
];

function runAll() {
  let passed = 0, failed = 0;
  for (const t of tests) {
    try {
      // Call the golden program
      const result = require('./golden.js').transform(t.input);
      assert.deepStrictEqual(result, t.expected);
      console.log(`✓ ${t.name}`);
      passed++;
    } catch (e) {
      console.log(`✗ ${t.name}: ${e.message}`);
      failed++;
    }
  }
  console.log(`\nResults: ${passed} passed, ${failed} failed`);
  process.exit(failed > 0 ? 1 : 0);
}

if (process.argv.includes('--all')) runAll();
```

Python example (`*-test.py`):
```python
# Test cases for [topic]
# Run: python -m pytest *_test.py -v

import pytest
from golden import transform

def test_normal_case_1():
    assert transform({...}) == {...}

def test_boundary_case():
    assert transform({...}) == {...}

def test_exception_case():
    with pytest.raises(ValueError):
        transform({...})
```

### 9.5 User Confirmation

> "Test cases ready. Run the test command to see current status (they will fail until golden program is implemented). Please confirm the test cases are correct before we proceed."

---

## Stage 10: Golden Program

### 10.1 Create Plan

Lightweight plan covering:
- Public entrypoint function
- Main modules/helpers
- How tests will validate

### 10.2 Implement

Rules:
- Correctness and readability over performance
- Self-contained implementation
- Prefer pure-function entrypoint
- No hidden dependence on wall-clock time, randomness, network
- Brief comments linking to spec sections
- Explicit handling for all boundary cases

### 10.3 Test-Driven Iteration

1. Run all tests
2. For each failing test:
   - Identify the issue
   - Fix the code
   - Re-run tests
3. Repeat until ALL tests pass
4. Report final status:

> "Golden program complete. All X tests pass. Run `node *-test.js --all` to verify."

---

## State Tracking

Before each question:

```text
State: Stage [P0|P1|P2] | Question [ID] | Waiting: Yes/No | File: *-questions.md | P0-Open: X | P1-Open: Y | P2-Open: Z
```

If `Waiting: Yes` → STOP. Wait for user answer.

---

## Error Recovery

| Violation | Recovery Action |
|-----------|-----------------|
| Asked question not in file | "That question isn't in the ledger. Let me add it first." Add to file, then ask. |
| Asked multiple questions | Acknowledge: "I asked multiple questions. Let me ask only the first one." |
| Didn't read file before asking | "I need to read the question file first." Read file, then ask. |
| Asked engineering question | "That was an implementation question. Let me rephrase for business meaning." |
| Made silent assumption | "I assumed [X]. Let me verify." Ask user to confirm. |

**Self-correction is expected.** Acknowledge violations and recover.

---

## Output Summary

When complete, the following files exist:

1. `*-understanding.md` - Document understanding
2. `*-questions.md` - Full question ledger with all answers
3. `*-global-flow.md` - P0 intermediate output
4. `*-submodule-design.md` - P1 intermediate output
5. `*-boundary-rules.md` - P2 intermediate output
6. `*-design.md` - Full implementation spec
7. `*-test.js` or `*-test.py` - Test cases with CLI
8. `golden.js` or `golden.py` - Golden program (all tests passing)
