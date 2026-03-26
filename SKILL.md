---
name: business-spec-to-golden
description: "Transform requirements into reviewed implementation design specs and golden programs. Work from global understanding to local clarification: extract document structure, align overall inputs/outputs and module relationships, then clarify one business question at a time before spec and golden generation."
---

# Requirements to Design Spec and Golden Program

Transform a rough requirements or design document into a reviewed implementation spec and a golden reference implementation through staged clarification.

## HARD-GATE

**Stage Order**: Document Understanding → Global Alignment → Local Clarification → Boundary Clarification → Design Doc → Spec Review → Golden Program. Never skip or reorder.

**Single Question Rule**: Ask ONE business question at a time. Wait for answer before next question.

**Business Focus**: Ask about business meaning, inputs/outputs, module relationships, rules, and edge cases. Do NOT ask about engineering choices during clarification.

**Scope Control**: For multi-module or multi-system documents, first identify the whole structure, then pick one in-scope slice for this pass.

**Externalize State**: Before asking detailed questions, write down your understanding and open gaps in markdown notes so key conclusions do not depend on model memory alone.

**Gates**: Require user approval at: (1) document understanding summary, (2) global alignment summary, (3) local clarification summary, (4) boundary/failure summary, (5) design doc draft, (6) written/reviewed spec, (7) golden program.

---

## State Tracking

Before each question, check and state:

```text
State: Tier [Understanding|Global|Local|Boundary] | Question #N | Waiting: Yes/No | Open: Critical=X, Important=Y, Minor=Z
```

If `Waiting: Yes` → STOP. Wait for user answer.

## Pre-Question Checklist

Ask yourself before each question:

- [ ] Not currently waiting for an answer
- [ ] This is a business question, not an implementation question
- [ ] This is ONE question, not a batch
- [ ] The question belongs to the current clarification tier
- [ ] The gap is not already confirmed

Only proceed if ALL checked.

## Error Recovery

If you violate a rule:

| Violation | Recovery |
|-----------|----------|
| Asked multiple questions | Acknowledge, ask only the first one |
| Asked duplicate question | Acknowledge, skip to next gap |
| Asked engineering question | Acknowledge, rephrase as business question |
| Skipped a higher-tier gap | Acknowledge, return to the unresolved higher-tier gap |

---

## Stage 1: Document Understanding

Before asking detailed clarification questions:

1. Read the source document and extract its structure
2. Identify the major modules, branches, and flows it appears to describe
3. Identify what is already explicit about overall inputs, outputs, and relationships
4. Identify what is still ambiguous
5. Write this into a markdown notes file such as `docs/business-specs/YYYY-MM-DD-<topic>-understanding.md` unless the user prefers another location

The understanding notes should include:

1. **Document Structure** - sections, modules, or major flows mentioned in the source
2. **Current Business Understanding** - what the system appears to do overall
3. **Module Inventory** - the candidate submodules or processing steps
4. **Known Global Inputs and Outputs** - anything already explicit in the source
5. **Known Relationships** - which modules appear parallel, serial, optional, or conditional
6. **Open Questions by Tier** - grouped into Global, Local, and Boundary

Before moving on, present a concise understanding summary and ask the user to confirm or correct it.

---

## Stage 2: Global Alignment

Resolve the coarse-grained business structure before drilling into a specific submodule.

Prioritize these questions first:

1. **Overall Inputs** - What external inputs exist? What are their formats and semantics?
2. **Overall Outputs** - What outputs exist? What are their formats and semantics?
3. **Module Decomposition** - What submodules or processing steps are in scope overall?
4. **Relationships** - Which modules are parallel, serial, optional, or conditional?
5. **Inter-Module Handoffs** - For serial flows, what output of one module becomes input to the next?
6. **In-Scope Slice** - Which branch, path, or submodule is being implemented in this pass?

After these are clear enough, produce a concise global alignment summary that includes:

1. In-scope slice
2. Overall input contract for the relevant flow
3. Overall output contract for the relevant flow
4. Module relationships
5. A simple textual dataflow or flowchart-style view

Example:

```text
Input A + Input B
  -> Module M1
  -> Module M2
  -> Branch:
     - Path X -> Module M3 -> Output X
     - Path Y -> Module M4 -> Output Y
```

Ask the user to approve this global picture before moving to local questions.

---

## Stage 3: Local Clarification

Only after the global structure is aligned, clarify the in-scope slice itself.

Prioritize local questions in this order:

1. **Slice Input Semantics** - What exactly enters this slice?
2. **Slice Output Semantics** - What exactly must this slice produce?
3. **Transformation Logic** - How does the slice derive output from input?
4. **Decision Rules** - Which rule wins on conflict? What order is applied?
5. **Dependencies** - Which upstream results are required? Which downstream consumer assumptions matter?
6. **Representative Examples** - Concrete examples that lock down intended behavior

When the local logic is clarified, provide a local clarification summary and ask the user to approve it before moving to boundaries.

---

## Stage 4: Boundary Clarification

After the main flow is clear, ask about:

1. Empty or missing input
2. Invalid or unsupported values
3. Duplicate or conflicting records
4. Min/max and threshold boundaries
5. Ordering and determinism requirements
6. Failure behavior and visible error handling

Then summarize the confirmed boundary and failure behavior and ask for approval.

---

## Question Format

```markdown
**Context**: "[Quote or paraphrase from the document or understanding notes]"

**Tier**: [Global|Local|Boundary]

**Question**: [One specific business question]

**Why it matters**: [How different answers would change visible behavior]

**Options** (if applicable):
A. ...
B. ...
```

After the user answers, confirm with:

`To confirm: [precise restatement]. Correct?`

---

## Design Doc Stage

After the user approves the staged clarification summaries, write the implementation design doc with this structure:

1. **Objective** - Business outcome and success criteria
2. **Scope** - In-scope slice and explicit out-of-scope items
3. **Document Understanding** - High-level structure and the chosen slice's place in it
4. **Global Flow** - Overall inputs, outputs, branches, module relationships, and inter-module handoffs
5. **Domain Model** - Entities and their business meaning
6. **Input Contract** - Required/optional fields, ranges, units, invariants
7. **Output Contract** - Structure, semantics, ordering, interpretation
8. **Decision Rules** - Business rules in strict precedence order
9. **Processing Flow** - Step-by-step transformation with enough precision to implement
10. **Edge and Failure Cases** - Boundary, invalid, duplicate, partial, and extreme cases
11. **Examples** - Input/output pairs covering normal, edge, and conflict cases
12. **Clarification Decisions** - Key question-answer outcomes and accepted assumptions
13. **Acceptance Criteria** - What correct implementation must do

Goal: Two engineers reading this would produce the same implementation.

### Spec Quality Bar

Before moving on, the design doc must satisfy ALL of these:

- No `TODO`, `TBD`, placeholders, or "decide later" wording
- No hidden ambiguity inside broad wording such as "handle appropriately"
- Every critical rule is traceable to either the source document or a clarification decision
- Overall flow and inter-module relationships are explicit for the in-scope slice
- Rule precedence, ordering, invalid-input behavior, and boundary behavior are explicit
- Examples are strong enough to anchor expected output behavior

### Written Spec

After presenting the design doc and getting user approval on the draft:

1. Write it as a markdown spec file
2. Use a stable path such as `docs/business-specs/YYYY-MM-DD-<topic>-design.md` unless the user prefers another location
3. Run a spec review loop using `references/spec-document-reviewer-prompt.md`
4. If issues are found, fix the spec and re-review it
5. Ask the user to review the written spec file before starting the golden program

---

## Spec Review Loop

After writing the spec file:

1. Dispatch a focused spec reviewer subagent using the prompt template in `references/spec-document-reviewer-prompt.md`
2. Isolate context: provide only the spec path and the minimum task-local review context needed to evaluate the written spec
3. Never pass full session history, hidden reasoning, or your own intended conclusions into the review context
4. If the reviewer returns `Issues Found`, revise the spec and re-dispatch
5. Repeat until `Approved`, with a maximum of 3 review iterations
6. If the loop still fails after 3 iterations, surface the unresolved issues to the user

## Golden Program Stage

After user approves the written and reviewed spec:

1. Create lightweight plan (entrypoint, modules, verification approach)
2. Implement with these rules:
   - Optimize for correctness and readability
   - Self-contained implementation
   - Brief comments linking to the spec
   - Verify against examples from the spec
   - Verify against boundary and failure cases from the spec
   - Surface remaining ambiguities instead of guessing

---

## Output

When complete:
1. Document understanding notes
2. Clarified business understanding (user-confirmed, from global to local)
3. Detailed reviewed design spec
4. Readable golden reference program
