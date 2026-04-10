# Delivery Spec Template

Use this template when writing `*-spec.md`.

Keep the document implementation-ready, behaviorally precise, and traceable to approved artifacts.
This document is the delivery artifact and the only business document downstream agents should need for test planning and golden-program generation.

## Required Header

```markdown
# [Topic] Delivery Spec

Status: draft | approved | stale | superseded
Last Updated: YYYY-MM-DD HH:mm
Derived From:
- [approved understanding.md]
- [approved global-flow.md]
- [approved submodule-design.md]
- [approved boundary-rules.md]
```

## Required Sections

### 1. Objective

- Business outcome
- Success criteria
- What the golden program must prove
- Why this spec is the standalone downstream source of truth

### 2. Scope

- In-scope slice
- Explicit out-of-scope items
- Assumptions still allowed at implementation time, if any

### 3. Source Context and Confirmed Assumptions

- Short summary of source intent
- Confirmed assumptions that remain active
- Deferred items that are explicitly contained and do not block code generation

### 4. Structural Baseline

- Summary of the approved system-level flow
- System-level input contract
- System-level output contract
- Module boundaries

### 5. Domain Model

- Core entities
- Business meaning of each entity
- Important invariants

### 6. External Contracts

- Inputs visible to the caller or upstream system
- Outputs visible to the caller or downstream system
- Validation rules that affect observable behavior

### 7. Processing Flow

- End-to-end steps
- Branch conditions
- Handoffs between modules
- Ordering and precedence that affect visible behavior

### 8. Module Behavior

For each module:

- Responsibility
- Business inputs and outputs
- Normal-path logic
- Ordering and precedence rules
- Dependencies
- Boundary behavior that this module owns, if any

### 9. Cross-Module Rules and Decision Precedence

- Rules that span multiple modules
- Conflict resolution precedence
- Tie-breaking behavior
- Any rule that tests must assert across module boundaries

### 10. Boundary and Failure Rules

- Missing input behavior
- Invalid input behavior
- Boundary thresholds
- Duplicate and conflict handling
- Error or rejection behavior
- Output or error interpretation expected by callers

Use a compact decision table when practical.

### 11. Canonical Examples

- At least two normal examples
- At least one edge or failure example
- Examples must match the stated rules
- Each example should be detailed enough to turn directly into executable tests

### 12. Acceptance Criteria and Test Implications

- What must be true for the implementation to be considered correct
- Observable behaviors that require explicit tests
- Coverage expectations or non-negotiable business rules

### 13. Internal Design Choices

- Agent-designed internal structures that are not business-fixed
- Why they are safe with respect to the approved contracts

### 14. Clarification Decisions and Traceability

- Important confirmed decisions from the ledgers
- Deferred decisions and how they are contained
- For each critical rule, cite where it came from without requiring the reader to open that file to learn the rule itself

### 15. Standalone Readiness Check

State `yes` or `no` for each item:

- A new session given only this file can design the test plan
- A new session given only this file can implement the golden program
- No business-critical rule exists only in an upstream stage artifact
- No unresolved ambiguity would change visible behavior

## Prohibited Content

- `TODO`
- `TBD`
- placeholders
- unresolved contradictions
- hidden assumptions presented as facts
- normative statements that only point to another artifact instead of restating the rule here

## Quality Bar

The document is ready only if:

- two engineers would implement the same visible behavior
- a downstream agent with only `*-spec.md` could produce stable tests and code
- critical rules are traceable to approved artifacts or confirmed answers
- internal design freedom is separated from fixed business contracts
- no business-visible behavior is exclusive to an upstream working artifact
