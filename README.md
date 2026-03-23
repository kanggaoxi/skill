# business-spec-to-golden

A Claude Code Skill that transforms requirement documents into detailed design specifications and golden reference programs.

## Overview

This Skill helps you convert ambiguous requirements, business, or design documents (in markdown or notes form) into:

1. **Clarified Business Understanding** - Identify and resolve ambiguities in requirements
2. **Detailed Design Document** - Implementation-ready specification
3. **Golden Reference Program** - A readable, correctness-focused reference implementation

## Usage

```
/business-spec-to-golden
```

Or simply provide your requirements document and state your intent:

```
Here's my product requirements document [attach document]. Please help me understand it and generate a design document and reference implementation.
```

## Workflow

```
Read Requirements → Identify Business Gaps → Clarify Questions One-by-One → User Confirms Understanding
                                                                                    ↓
User Reviews Golden Program ← Implement Golden Program ← Create Implementation Plan ← User Approves Design Doc
```

### Three Stages

| Stage | Output |
|-------|--------|
| **Clarify** | Clarified business logic understanding |
| **Write Spec** | Detailed design document |
| **Build Golden Program** | Executable reference implementation |

## Design Document Structure

The generated design document includes:

- **Objective** - Business goals and success criteria
- **Domain Model** - Domain entities and their business meaning
- **Input Contract** - Input data specification
- **Output Contract** - Output data specification
- **Decision Rules** - Business decision rules (in priority order)
- **Processing Flow** - End-to-end processing steps
- **Edge Cases** - Boundary condition handling
- **Examples** - Input/output examples
- **Acceptance Criteria** - Verification standards

## Features

- **Business-First** - Questions focus on business meaning, not engineering choices
- **Incremental Confirmation** - Ask one question at a time to avoid overload
- **Gate Mechanism** - No code is written until design document is approved
- **Scope Control** - Complex systems are decomposed into smaller slices
- **Verifiable** - Reference program is validated against design document examples

## Use Cases

- Product Requirements Documents (PRD) to technical design
- Business rules documents to decision logic
- Design notes to executable specifications
- Creating team-shared reference implementations

## Example

**Input**: A product document describing promotion rules

**Output**:
1. Clarified promotion rules (discount stacking order, boundary conditions, etc.)
2. Detailed promotion engine design document
3. Runnable promotion calculation reference program

## Files

```
business-spec-to-golden/
├── SKILL.md      # Skill definition file
└── README.md     # This file
```

## License

MIT
