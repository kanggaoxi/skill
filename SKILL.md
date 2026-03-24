---
name: business-spec-to-golden
description: "Transform requirements into reviewed implementation design docs and golden programs. Ask ONE question at a time during clarification. Design doc must be written as a markdown spec and reviewed before golden generation."
---

# Requirements to Design Doc and Golden Program

Transform rough requirements into a detailed design document and golden reference implementation through structured clarification.

## HARD-GATE

**Stage Order**: Clarify → Design Doc → Spec Review → Golden Program. Never skip or reorder.

**Single Question Rule**: Ask ONE question at a time. Wait for answer before next question.

**Business Focus**: Ask about business meaning, rules, and edge cases. Do NOT ask about engineering choices.

**Scope Control**: For multi-system documents, decompose and process one slice at a time.

**Gates**: Require user approval at: (1) after business summary, (2) after design doc draft, (3) after written/reviewed spec, (4) after golden program.

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

## Examples

### ✓ Correct: Single Question

```
State: Question #1 | Waiting: No | Resolved: 0 gaps | Remaining: 5 gaps

**Context**: "强度等级：弱/中/强"

**Question**: 边界值6和12属于哪个等级？

**Why it matters**: 不同归属会导致"123abc"（长度6）判定结果不同。

**Options**:
A. 闭区间 [6,12]，6和12都属"中"
B. 半开区间 [6,12)，6属"中"，12属"强"
```

### ✗ Wrong: Multiple Questions

```
**Questions**:
1. 边界值6属于哪个等级？
2. 特殊字符有哪些？
3. 空密码怎么处理？
```
→ **Violation**: Batched 3 questions. User may miss some.

### ✗ Wrong: Engineering Question

```
**Question**: 用正则还是字符遍历检测字符类型？
```
→ **Violation**: Engineering choice, not business meaning.

### ✓ Correct: Answer Confirmation

```
User: A

Agent: To confirm: 边界值6和12都属于"中"等级（闭区间）。正确吗？
```

### ✓ Correct: Error Recovery

```
Agent: 我刚才一次问了多个问题，违反了规则。让我重新问第一个：

**Question**: 边界值6和12属于哪个等级？
```

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

After user confirms business summary, write the implementation design doc with this structure:

1. **Objective** - Business outcome and success criteria
2. **Scope** - In-scope slice and explicit out-of-scope items
3. **Domain Model** - Entities and their business meaning
4. **Input Contract** - Required/optional fields, ranges, units, invariants
5. **Output Contract** - Structure, semantics, ordering, interpretation
6. **Decision Rules** - Business rules in strict precedence order
7. **Processing Flow** - Step-by-step transformation with enough precision to implement
8. **Edge and Failure Cases** - Boundary, invalid, duplicate, partial, and extreme cases
9. **Examples** - Input/output pairs covering normal, edge, and conflict cases
10. **Clarification Decisions** - Key question-answer outcomes and accepted assumptions
11. **Acceptance Criteria** - What correct implementation must do

Goal: Two engineers reading this would produce the same implementation.

### Spec Quality Bar

Before moving on, the design doc must satisfy ALL of these:

- No `TODO`, `TBD`, placeholders, or "decide later" wording
- No hidden ambiguity inside broad wording such as "handle appropriately"
- Every critical rule is traceable to either the source document or a clarification decision
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
   - Brief comments linking to design doc
   - Verify against design doc examples
   - Verify against boundary and failure cases from the spec
   - Surface remaining ambiguities instead of guessing

---

## Output

When complete:
1. Clarified business understanding (user-confirmed)
2. Detailed design document
3. Readable golden reference program
