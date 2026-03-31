# Implementation Spec Template

Use this template when writing `*-design.md`.

Keep the document implementation-ready, behaviorally precise, and traceable to approved artifacts.

## Required Header

```markdown
# [Topic] Implementation Spec

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

### 2. Scope

- In-scope slice
- Explicit out-of-scope items
- Assumptions still allowed at implementation time, if any

### 3. Structural Baseline

- Summary of the approved system-level flow
- System-level input contract
- System-level output contract
- Module boundaries

### 4. Domain Model

- Core entities
- Business meaning of each entity
- Important invariants

### 5. External Contracts

- Inputs visible to the caller or upstream system
- Outputs visible to the caller or downstream system
- Validation rules that affect observable behavior

### 6. Module Behavior

For each module:

- Responsibility
- Business inputs and outputs
- Normal-path logic
- Ordering and precedence rules
- Dependencies

### 7. Internal Design Choices

- Agent-designed internal structures that are not business-fixed
- Why they are safe with respect to the approved contracts

### 8. Processing Flow

- End-to-end steps
- Branch conditions
- Handoffs between modules

### 9. Boundary and Failure Rules

- Missing input behavior
- Invalid input behavior
- Boundary thresholds
- Duplicate and conflict handling
- Error or rejection behavior

### 10. Examples

- At least two normal examples
- At least one edge or failure example
- Examples must match the stated rules

### 11. Clarification Decisions

- Important confirmed decisions from the ledgers
- Deferred decisions and how they are contained

### 12. Acceptance Criteria

- What must be true for the implementation to be considered correct
- Include observable behavior, not vague quality claims

## Prohibited Content

- `TODO`
- `TBD`
- placeholders
- unresolved contradictions
- hidden assumptions presented as facts

## Quality Bar

The document is ready only if:

- two engineers would implement the same visible behavior
- critical rules are traceable to approved artifacts or confirmed answers
- internal design freedom is separated from fixed business contracts
