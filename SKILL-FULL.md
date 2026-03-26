---
name: business-spec-to-golden
description: Turn rough business requirements into a clarified, reviewed implementation design spec and a correctness-first golden program. Work from global understanding to local clarification: extract document structure, build a tiered gap inventory, align overall I/O and module relationships, confirm each tier, then generate a reviewed spec and golden program.
---

# Business Spec to Design Spec and Golden Program

Transform a rough requirement document into:

1. A documented understanding of the source document
2. A clarified and reviewed implementation design spec
3. A readable golden reference program

## Hard Gates

- **Stage Order**: Document Understanding → Global Alignment → Local Clarification → Boundary Clarification → Design Doc → Spec Review → Golden Program. Never skip or reorder.
- **Single Question Rule**: Ask exactly one business question at a time. Wait for the answer before asking the next one.
- **Business Focus**: Ask about business meaning, overall inputs/outputs, module relationships, decision rules, examples, boundaries, and failure behavior. Do not ask engineering choices unless the user explicitly asks for them.
- **No Silent Assumptions**: Do not invent missing business rules and quietly continue. Resolve them with the user, or list them as explicit assumptions and get acceptance before proceeding.
- **Global Before Local**: Do not ask detailed submodule questions until the overall structure, scope, and inter-module flow for the in-scope slice are aligned.
- **Externalize State**: Write the understanding, gap inventory, and confirmed summaries into markdown notes so key decisions do not depend on model memory alone.
- **Approval Gates**: Require user approval after the document understanding summary, after the global alignment summary, after the local clarification summary, after the boundary/failure summary, after the design doc draft, after the written/reviewed spec, and after the golden program.
- **Correctness First**: Optimize the golden program for correctness, determinism, and auditability before convenience or performance.

## Workflow

1. Read the source document and any immediately relevant local context.
2. Extract the document structure and write understanding notes.
3. Build a **Tiered Business Gap Ledger**.
4. If needed, decompose scope and pick one slice.
5. Align the global picture for the in-scope slice.
6. Ask one business question at a time within the current tier until that tier is ready to summarize.
7. Summarize the current tier and get user approval before moving deeper.
8. Repeat for Local Clarification, then Boundary Clarification.
9. Write the design doc and get user approval on the draft.
10. Save the design doc as a markdown spec file.
11. Run the spec review loop and fix issues until approved.
12. Ask the user to review the written spec.
13. Create a lightweight golden-program plan.
14. Implement the golden program.
15. Verify it against the spec examples, flow relationships, and boundary cases.
16. Ask the user to review the golden program.

## Document Understanding Notes

Before asking detailed clarification questions, write a markdown notes file such as:

`docs/business-specs/YYYY-MM-DD-<topic>-understanding.md`

unless the user prefers another location.

The understanding notes should include:

1. **Document Structure** - sections, modules, branches, flows, or processing stages named in the source
2. **Current Business Understanding** - what the overall system appears to do
3. **Module Inventory** - candidate submodules or processing steps
4. **Known Global Inputs** - inputs explicitly described in the source, with formats and semantics if known
5. **Known Global Outputs** - outputs explicitly described in the source, with formats and semantics if known
6. **Known Relationships** - which modules appear serial, parallel, optional, conditional, or mutually exclusive
7. **Open Questions by Tier** - grouped into Global, Local, and Boundary

Before entering the question loop, present a concise document understanding summary and ask the user to confirm or correct it.

## Tiered Business Gap Ledger

Before asking questions, identify the business gaps that affect correctness.

Track them mentally or explicitly in a compact table with these fields:

| Field | Meaning |
|------|---------|
| `ID` | Stable gap label such as `G1`, `G2` |
| `Tier` | `Global`, `Local`, or `Boundary` |
| `Source` | Quote or section from the input document |
| `Gap` | What is ambiguous or missing |
| `Risk` | Why this affects correctness |
| `Priority` | `P0`, `P1`, or `P2` |
| `Status` | `open`, `answered`, `confirmed`, `accepted-assumption` |

Priority guidance:

- **P0**: A wrong answer would likely change core output behavior or the structure of the in-scope flow.
- **P1**: A wrong answer would change edge-case, failure behavior, or inter-module handoff details.
- **P2**: Helpful detail, but not a likely blocker for a correct first implementation.

## Scope Control

If the document describes multiple business areas, do not attempt one giant pass.

First produce a compact decomposition:

- Slices or subsystems
- Which slice should be handled now
- What is explicitly out of scope for this pass
- Which upstream and downstream modules still matter for this slice

Then continue with a single in-scope slice only.

## Clarification Tiers

### Tier 1: Global Alignment

Resolve the coarse-grained business structure before drilling into a specific submodule.

Prioritize gaps in this order:

1. **Overall objective and success meaning**: What overall business outcome is considered correct?
2. **Overall input semantics**: What external inputs exist? What do they mean? What are their formats?
3. **Overall output semantics**: What outputs exist? What do they mean? What are their formats?
4. **Module decomposition**: What submodules, branches, or stages exist in the relevant flow?
5. **Relationships**: Which modules are serial, parallel, optional, conditional, or mutually exclusive?
6. **Inter-module handoffs**: For serial flows, what output of one module becomes input to the next?
7. **In-scope slice selection**: Which branch, path, or submodule is being implemented in this pass?

Before moving on, produce a **Global Alignment Summary** that includes:

1. In-scope slice
2. Overall input contract for the relevant flow
3. Overall output contract for the relevant flow
4. Module inventory for the relevant flow
5. Confirmed relationships between modules
6. A simple textual dataflow or flowchart-style diagram
7. Explicit accepted assumptions, if any

Example:

```text
Input A + Input B
  -> Module M1
  -> Branch:
     - Path X -> Module M2 -> Output X
     - Path Y -> Module M3 -> Module M4 -> Output Y
```

Ask the user to approve this global picture before moving to local questions.

### Tier 2: Local Clarification

Only after the global structure is aligned, clarify the in-scope slice itself.

Prioritize gaps in this order:

1. **Slice input semantics**: What exactly enters this slice, from where, and in what format?
2. **Slice output semantics**: What exactly must this slice produce, for whom, and in what format?
3. **Transformation logic**: How does the slice derive output from input?
4. **Decision rules and precedence**: How do rules interact, and which rule wins on conflict?
5. **Upstream/downstream dependencies**: Which assumptions from neighboring modules affect this slice?
6. **Representative examples**: Concrete examples that lock down intended behavior

Before moving on, produce a **Local Clarification Summary** that includes:

1. Slice purpose
2. Slice input contract
3. Slice output contract
4. Confirmed transformation logic
5. Decision rules in precedence order
6. Dependencies on upstream or downstream modules
7. Explicit accepted assumptions, if any

Ask the user to approve this local picture before moving to boundary questions.

### Tier 3: Boundary Clarification

After the main flow is clear, ask about:

1. Empty or missing input
2. Invalid or unsupported values
3. Duplicate or conflicting records
4. Min/max, thresholds, and boundary inclusivity
5. Ordering and determinism requirements
6. Failure behavior and visible error handling
7. Extreme or conflict cases involving upstream/downstream assumptions

Before moving on, produce a **Boundary and Failure Summary** and ask the user to approve it.

## Pre-Question Checklist

Before asking ANY question, verify ALL of the following:

- [ ] I am NOT currently waiting for an answer to a previous question
- [ ] This is a BUSINESS question (not about libraries, architecture, or implementation)
- [ ] This is ONE question (not multiple questions bundled together)
- [ ] The question belongs to the current clarification tier
- [ ] This is NOT a duplicate of an already-confirmed gap
- [ ] No unresolved higher-tier `P0` gap should block this question

**If any box is unchecked, STOP and fix before proceeding.**

## Question Format

Before each question, state:

```text
State: Tier [Global|Local|Boundary] | Question #N | Waiting: Yes/No | Open: P0=X, P1=Y, P2=Z
```

If `Waiting: Yes`, stop and wait.

Ask using this format:

```markdown
**Context**: "[quoted or paraphrased source]"

**Tier**: [Global|Local|Boundary]

**Gap**: [gap ID and short ambiguity summary]

**Question**: [one specific business question]

**Why it matters**: [how a different answer would change visible behavior]

**Options** (if useful):
A. ...
B. ...
```

After the user answers:

1. Restate the answer precisely.
2. Confirm it.
3. Update the gap status.
4. Move to the next highest-priority open gap within the current tier.

## Clarification Exit Criteria

Do not move to the design doc until all of the following are true:

- The document understanding summary is user-confirmed
- All `Global` `P0` gaps are `confirmed` or `accepted-assumption`
- The in-scope slice, overall I/O, module relationships, and inter-module handoffs for the relevant flow are explicit
- All `Local` `P0` gaps are `confirmed` or `accepted-assumption`
- Rule precedence is explicit where conflicts are possible
- All `Boundary` `P1` gaps that affect visible behavior are `confirmed` or `accepted-assumption`
- Boundary and invalid-input behavior is explicit enough to implement
- There are enough concrete examples to anchor normal and edge behavior

If this is not true, keep clarifying.

## Error Recovery

If you detect that you have violated a rule, acknowledge and recover:

| Violation | Recovery Action |
|-----------|-----------------|
| Asked multiple questions at once | Acknowledge: "I asked multiple questions. Let me ask only the first one." Then ask only the first question. |
| Asked a duplicate question | Acknowledge: "This was already clarified." Skip to next open gap. |
| Asked an engineering question | Acknowledge: "That was an implementation question. Let me rephrase for business meaning." Rephrase as business question. |
| Made a silent assumption | Acknowledge: "I assumed [X]. Let me verify this with you." Ask the user to confirm or correct. |
| Asked a lower-tier question too early | Acknowledge: "I moved too far into details before the higher-level flow was clear. Let me return to the unresolved higher-level gap." |

**Self-correction is expected and encouraged.** Do not hide violations; acknowledge them and recover.

## Design Doc Stage

After the user approves the staged clarification summaries, write a design doc that is precise enough that two engineers would produce the same externally visible behavior.

Use this structure:

1. **Objective**: Business outcome and success criteria
2. **Scope**: In-scope flow and explicit out-of-scope items
3. **Document Understanding**: High-level structure of the source and the chosen slice's place in it
4. **Global Flow**: Overall inputs, outputs, branches, module relationships, and inter-module handoffs for the relevant flow
5. **Domain Model**: Entities, records, and their business meaning
6. **Input Contract**: Required and optional fields, units, ranges, invariants, assumptions
7. **Output Contract**: Structure, semantics, ordering, and interpretation
8. **Decision Rules**: Business rules in strict precedence order
9. **Processing Flow**: Step-by-step transformation from input to output
10. **Edge and Failure Cases**: Empty, invalid, duplicate, partial, extreme, and conflict cases
11. **Examples**: Representative normal, boundary, and failure examples
12. **Clarification Decisions**: Key question-answer outcomes and accepted assumptions
13. **Acceptance Criteria**: What a correct implementation must do

Design-doc requirements:

- Every critical rule should be traceable to either the source document or a clarification decision.
- If the source document is vague, the design doc must make the chosen interpretation explicit.
- Do not hide unresolved ambiguity inside broad wording.
- Do not leave `TODO`, `TBD`, placeholders, or deferred decisions in the spec.
- Make overall flow, ordering, determinism, invalid-input behavior, and boundary behavior explicit when they affect visible output.
- Make upstream/downstream contracts explicit for the in-scope slice where they affect correctness.

### Written Spec

After the user approves the design doc draft:

1. Write it as a markdown spec file
2. Use a stable path such as `docs/business-specs/YYYY-MM-DD-<topic>-design.md` unless the user prefers another location
3. Run the spec review loop using `references/spec-document-reviewer-prompt.md`
4. Revise and re-review until approved
5. Ask the user to review the written spec before moving to the golden program

## Spec Review Loop

After writing the spec file:

1. Dispatch a focused spec reviewer subagent using the template in `references/spec-document-reviewer-prompt.md`
2. Isolate context: provide only the spec path and minimum task-local review context needed to evaluate the written spec
3. Never pass full session history, hidden reasoning, or your own intended conclusions into the review context
4. If the reviewer returns `Issues Found`, revise and re-dispatch
5. Repeat until `Approved`, with a maximum of 3 review iterations
6. If still blocked after 3 iterations, surface the unresolved issues to the user

## Golden Program Stage

After the user approves the written and reviewed spec:

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
   - the confirmed global flow and inter-module handoff assumptions for the in-scope slice

If a missing business rule still blocks a correct implementation, stop and ask instead of guessing.

## Output Expectations

When this skill is used well, it should produce:

1. Document understanding notes that externalize the current interpretation
2. A clarified and user-approved business understanding from global structure to local detail
3. A design spec with explicit flow, rules, boundaries, and traceability
4. A correctness-first golden reference program that is easy to inspect

Do not skip the approval gates between these stages.
