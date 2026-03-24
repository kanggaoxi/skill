# business-spec-to-golden

A Claude Code Skill that transforms requirement documents into detailed design specifications and golden reference programs.

## Overview

This Skill helps you convert ambiguous requirements, business, or design documents (in markdown or notes form) into:

1. **Clarified Business Understanding** - Identify and resolve ambiguities in requirements
2. **Detailed Design Document** - Implementation-ready specification
3. **Golden Reference Program** - A readable, correctness-focused reference implementation

## Two Versions

This skill provides two versions for different model capabilities:

| Version | File | Lines | Target Models |
|---------|------|-------|---------------|
| **General** | `SKILL.md` | 176 | All models, especially weaker ones |
| **Full** | `SKILL-FULL.md` | 221 | Strong models (GLM 5+, Claude, GPT-4) |

### When to Use Which Version

| Model | Recommended Version |
|-------|---------------------|
| GLM 4.7 or weaker | `SKILL.md` |
| GLM 5+ | `SKILL-FULL.md` |
| Claude (Sonnet/Opus) | `SKILL-FULL.md` |
| GPT-4 / GPT-4o | `SKILL-FULL.md` |
| Unknown or mixed | `SKILL.md` |

### Version Differences

| Feature | SKILL.md (General) | SKILL-FULL.md (Full) |
|---------|-------------------|----------------------|
| Few-shot Examples | ✓ 5 examples | ✗ |
| Pre-Question Checklist | ✓ | ✓ |
| Error Recovery | ✓ | ✓ |
| Business Gap Ledger | ✗ | ✓ P0/P1/P2 priority |
| 10-step Workflow | ✗ | ✓ |
| Clarification Exit Criteria | ✗ | ✓ |
| Design Doc Traceability | ✗ | ✓ |
| Golden Correctness Rules | Basic | Strict |

### How to Switch Versions

```bash
# Back up the currently active skill file first
cp SKILL.md SKILL.md.bak

# Use full version (for stronger models)
cp SKILL-FULL.md SKILL.md

# Restore the previous active version when needed
mv SKILL.md.bak SKILL.md
```

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

## Key Features

- **Single Question Rule** - Ask ONE question at a time, wait for answer
- **Business Focus** - Questions about business meaning, not engineering choices
- **Self-Check Mechanisms** - Pre-question checklist and error recovery
- **Gate Mechanism** - No code is written until design document is approved
- **Correctness First** - Golden program prioritizes correctness over performance

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
├── SKILL.md          # General version (default)
├── SKILL-FULL.md     # Full version for strong models
└── README.md         # This file
```

## License

MIT
