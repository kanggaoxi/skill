---
name: business-spec-to-golden
description: Transform requirements into design docs and golden programs. Ask ONE question at a time during clarification. Three stages: Clarify → Design Doc → Golden Program.
---

# Requirements to Design Doc and Golden Program

Transform rough requirements into a detailed design document and golden reference implementation through structured clarification.

## HARD-GATE

**Stage Order**: Clarify → Design Doc → Golden Program. Never skip or reorder.

**Single Question Rule**: Ask ONE question at a time. Wait for answer before next question.

**Business Focus**: Ask about business meaning, rules, and edge cases. Do NOT ask about engineering choices.

**Scope Control**: For multi-system documents, decompose and process one slice at a time.

**Gates**: Require user approval at: (1) after business summary, (2) after design doc, (3) after golden program.

---

## State Tracking

Before each question, check and state:

```
State: Question #N | Waiting: Yes/No | Resolved: X gaps | Remaining: Y gaps
```

If "Waiting: Yes" → STOP. Wait for user answer.

## Pre-Question Checklist

Ask yourself before each question:

- [ ] Not currently waiting for an answer
- [ ] This is a business question (not engineering)
- [ ] This is ONE question (not multiple)
- [ ] Not a duplicate of resolved question

Only proceed if ALL checked.

## Error Recovery

If you violate a rule:

| Violation | Recovery |
|-----------|----------|
| Asked multiple questions | Acknowledge, ask only the first one |
| Asked duplicate question | Acknowledge, skip to next gap |
| Asked engineering question | Acknowledge, rephrase as business question |

---

## Clarification Stage

### Priority Order

1. **Goal & Meaning**: What outcome? What do inputs/outputs mean?
2. **Rules**: How do inputs map to outputs? Which rule wins on conflict?
3. **Boundaries**: Empty/invalid input? Missing fields? Min/max values?
4. **Context**: Time-sensitive? State-dependent? Volume constraints?

### Question Format

```
**Context**: "[Quote from document]"

**Question**: [Single specific business question]

**Why it matters**: [Correctness impact]

**Options** (if applicable):
A. ...
B. ...
```

### After Answer

Confirm: "To confirm: [restatement]. Correct?"

---

## Design Doc Stage

After user confirms business summary, write design doc with this structure:

1. **Objective** - Business outcome and success criteria
2. **Domain Model** - Entities and their business meaning
3. **Input Contract** - Required/optional fields, ranges, units
4. **Output Contract** - Structure, semantics, ordering
5. **Decision Rules** - Business rules in precedence order
6. **Processing Flow** - Step-by-step transformation
7. **Edge Cases** - Boundary and error handling
8. **Examples** - Input/output pairs (normal and edge cases)
9. **Acceptance Criteria** - What correct implementation must do

Goal: Two engineers reading this would produce the same implementation.

---

## Golden Program Stage

After user approves design doc:

1. Create lightweight plan (entrypoint, modules, verification approach)
2. Implement with these rules:
   - Optimize for correctness and readability
   - Self-contained implementation
   - Brief comments linking to design doc
   - Verify against design doc examples
   - Surface remaining ambiguities instead of guessing

---

## Output

When complete:
1. Clarified business understanding (user-confirmed)
2. Detailed design document
3. Readable golden reference program
