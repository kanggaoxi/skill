---
name: business-spec-to-golden
description: Turn rough business requirements into a clarified implementation design doc and a correctness-first golden program. Ask one business question at a time, track ambiguity in a gap ledger, and require approval between Clarify → Design Doc → Golden Program.
---

# Business Spec to Design Doc and Golden Program

Transform a rough requirement document into:

1. A clarified business understanding
2. A detailed implementation design document
3. A readable golden reference program

## Hard Gates

- **Stage Order**: Clarify → Design Doc → Golden Program. Never skip or reorder.
- **Single Question Rule**: Ask exactly one business question at a time. Wait for the answer before asking the next one.
- **Business Focus**: Ask about business meaning, rules, priorities, examples, boundaries, and failure behavior. Do not ask engineering choices unless the user explicitly asks for them.
- **No Silent Assumptions**: Do not invent missing business rules and quietly continue. Resolve them with the user, or list them as explicit assumptions and get acceptance before proceeding.
- **Scope Control**: If the source document covers multiple subsystems or flows, decompose it and work one slice at a time.
- **Approval Gates**: Require user approval after the clarified business summary, after the design doc, and after the golden program.
- **Correctness First**: Optimize the golden program for correctness, determinism, and auditability before convenience or performance.

## Workflow

1. Read the source document and any immediately relevant local context.
2. Build a **Business Gap Ledger**.
3. If needed, decompose scope and pick one slice.
4. Clarify gaps one by one until the clarification exit criteria are met.
5. Write a clarified business summary and get user approval.
6. Write the design doc and get user approval.
7. Create a lightweight golden-program plan.
8. Implement the golden program.
9. Verify it against the design doc examples and boundary cases.
10. Ask the user to review the golden program.

## Business Gap Ledger

Before asking questions, identify the business gaps that affect correctness.

Track them mentally or explicitly in a compact table with these fields:

| Field | Meaning |
|------|---------|
| `ID` | Stable gap label such as `G1`, `G2` |
| `Source` | Quote or section from the input document |
| `Gap` | What is ambiguous or missing |
| `Risk` | Why this affects correctness |
| `Priority` | `P0`, `P1`, or `P2` |
| `Status` | `open`, `answered`, `confirmed`, `accepted-assumption` |

Priority guidance:

- **P0**: A wrong answer would likely change core output behavior.
- **P1**: A wrong answer would change edge-case or failure behavior.
- **P2**: Helpful detail, but not a likely blocker for a correct first implementation.

## Scope Control

If the document describes multiple business areas, do not attempt one giant pass.

First produce a compact decomposition:

- Slices or subsystems
- Which slice should be handled now
- What is explicitly out of scope for this pass

Then continue with a single slice only.

## Clarification Stage

### What to Clarify First

Prioritize gaps in this order:

1. **Goal and success meaning**: What business outcome is considered correct?
2. **Input and output semantics**: What each important field, record, or result means.
3. **Decision rules and precedence**: How inputs map to outputs, and which rule wins on conflict.
4. **Boundary and failure behavior**: Empty input, missing fields, invalid values, duplicates, min/max, rounding, overflow, negative values, unsupported values.
5. **Context dependencies**: Time, state, history, external context, or prior records.
6. **Representative examples**: Concrete examples that lock down intended behavior.

### Pre-Question Checklist

Before asking ANY question, verify ALL of the following:

- [ ] I am NOT currently waiting for an answer to a previous question
- [ ] This is a BUSINESS question (not about libraries, architecture, or implementation)
- [ ] This is ONE question (not multiple questions bundled together)
- [ ] This is NOT a duplicate of an already-confirmed gap

**If any box is unchecked, STOP and fix before proceeding.**

### Question Format

Before each question, state:

```text
State: Slice [name] | Question #N | Waiting: Yes/No | Open: P0=X, P1=Y, P2=Z
```

If `Waiting: Yes`, stop and wait.

Ask using this format:

```markdown
**Context**: "[quoted or paraphrased source]"

**Gap**: [gap ID and short ambiguity summary]

**Question**: [one specific business question]

**Why it matters**: [how a different answer would change behavior]

**Options** (if useful):
A. ...
B. ...
```

After the user answers:

1. Restate the answer precisely.
2. Confirm it.
3. Update the gap status.
4. Move to the next highest-priority open gap.

### Clarification Exit Criteria

Do not move to the design doc until all of the following are true:

- All `P0` gaps are `confirmed` or `accepted-assumption`
- All `P1` gaps that affect visible behavior are `confirmed` or `accepted-assumption`
- Rule precedence is explicit where conflicts are possible
- Boundary and invalid-input behavior is explicit enough to implement
- There are enough concrete examples to anchor normal and edge behavior

If this is not true, keep clarifying.

### Error Recovery

If you detect that you have violated a rule, acknowledge and recover:

| Violation | Recovery Action |
|-----------|-----------------|
| Asked multiple questions at once | Acknowledge: "I asked multiple questions. Let me ask only the first one." Then ask only the first question. |
| Asked a duplicate question | Acknowledge: "This was already clarified." Skip to next open gap. |
| Asked an engineering question | Acknowledge: "That was an implementation question. Let me rephrase for business meaning." Rephrase as business question. |
| Made a silent assumption | Acknowledge: "I assumed [X]. Let me verify this with you." Ask the user to confirm or correct. |

**Self-correction is expected and encouraged.** Do not hide violations; acknowledge them and recover.

## Clarified Business Summary

Before writing the design doc, provide a concise summary that includes:

1. In-scope slice
2. Business objective
3. Confirmed decision rules in precedence order
4. Confirmed boundary and failure behavior
5. Explicit accepted assumptions, if any
6. Remaining out-of-scope items

Ask the user to approve this summary before proceeding.

## Design Doc Stage

After the user approves the clarified summary, write a design doc that is precise enough that two engineers would produce the same externally visible behavior.

Use this structure:

1. **Objective**: Business outcome and success criteria
2. **Scope**: In-scope flow and explicit out-of-scope items
3. **Domain Model**: Entities, records, and their business meaning
4. **Input Contract**: Required and optional fields, units, ranges, invariants, assumptions
5. **Output Contract**: Structure, semantics, ordering, and interpretation
6. **Decision Rules**: Business rules in strict precedence order
7. **Processing Flow**: Step-by-step transformation from input to output
8. **Edge and Failure Cases**: Empty, invalid, duplicate, partial, extreme, and conflict cases
9. **Examples**: Representative normal, boundary, and failure examples
10. **Clarification Decisions**: Key question-answer outcomes and accepted assumptions
11. **Acceptance Criteria**: What a correct implementation must do

Design-doc requirements:

- Every critical rule should be traceable to either the source document or a clarification decision.
- If the source document is vague, the design doc must make the chosen interpretation explicit.
- Do not hide unresolved ambiguity inside broad wording.

## Golden Program Stage

After the user approves the design doc:

1. Create a lightweight plan covering:
   - public entrypoint
   - main logic steps or modules
   - verification approach
2. Implement the golden program with these rules:
   - correctness over performance
   - deterministic behavior
   - self-contained unless the repo already dictates a pattern
   - prefer a pure-function style entrypoint when practical
   - no hidden dependence on wall-clock time, randomness, network, or mutable external state
   - explicit handling for invalid or boundary cases defined in the design
   - readable decomposition and naming
   - brief comments only where they help map code back to design rules
3. Verify the implementation against:
   - design doc examples
   - key edge and failure cases
   - precedence-conflict cases if they exist

If a missing business rule still blocks a correct implementation, stop and ask instead of guessing.

## Output Expectations

When this skill is used well, it should produce:

1. A clarified and user-approved business understanding
2. A design doc with explicit rules, boundaries, and traceability
3. A correctness-first golden reference program that is easy to inspect

Do not skip the approval gates between these stages.
