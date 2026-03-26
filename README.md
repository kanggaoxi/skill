# business-spec-to-golden

A Claude Code Skill that transforms requirement documents into detailed design specifications and golden reference programs.

## Overview

This Skill helps you convert ambiguous requirements, business, or design documents into:

1. **Document Understanding Notes** - Externalized interpretation of the source
2. **Clarified Business Understanding** - From global structure to local detail
3. **Reviewed Design Spec** - Implementation-ready specification with quality checks
4. **Golden Reference Program** - A correctness-focused reference implementation

## Two Versions

This skill provides two versions for different model capabilities:

| Version | File | Lines | Target Models |
|---------|------|-------|---------------|
| **General** | `SKILL.md` | ~250 | All models, especially weaker ones |
| **Full** | `SKILL-FULL.md` | ~338 | Strong models (GLM 5+, Claude, GPT-4) |

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
| Tiered Gap Ledger | Simplified | Full P0/P1/P2 table |
| Clarification Exit Criteria | ✗ | ✓ |
| Tier Summary Templates | Simplified | Detailed |
| Error Recovery | 4 violations | 5 violations |
| Pre-Question Checklist | ✓ | ✓ |
| Spec Review Loop | ✓ | ✓ |

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
Document Understanding → Global Alignment → Local Clarification → Boundary Clarification
                                                                              ↓
User Reviews Golden ← Implement Golden ← Written Spec ← Design Doc ← Spec Review
```

### Seven Stages

| Stage | Output |
|-------|--------|
| **Document Understanding** | Understanding notes with structure, modules, and open questions |
| **Global Alignment** | Overall I/O, module relationships, in-scope slice selection |
| **Local Clarification** | Slice-specific logic, decision rules, examples |
| **Boundary Clarification** | Edge cases, failure behavior, invalid input handling |
| **Design Doc** | 13-section implementation specification |
| **Spec Review** | Automated review loop (max 3 iterations) |
| **Golden Program** | Executable reference implementation |

## Design Document Structure

The generated design document includes 13 sections:

- **Objective** - Business goals and success criteria
- **Scope** - In-scope slice and explicit out-of-scope items
- **Document Understanding** - High-level structure of the source
- **Global Flow** - Overall inputs, outputs, and module relationships
- **Domain Model** - Domain entities and their business meaning
- **Input Contract** - Input data specification with invariants
- **Output Contract** - Output data specification with interpretation
- **Decision Rules** - Business rules in strict precedence order
- **Processing Flow** - Step-by-step transformation
- **Edge and Failure Cases** - Boundary and error handling
- **Examples** - Input/output pairs for normal, edge, and conflict cases
- **Clarification Decisions** - Key Q&A outcomes and accepted assumptions
- **Acceptance Criteria** - Verification standards

## Key Features

- **Global Before Local** - Align overall structure before diving into details
- **Externalize State** - Write understanding to markdown, reduce memory dependence
- **Tiered Clarification** - Global → Local → Boundary, with approval gates
- **Single Question Rule** - Ask ONE question at a time, wait for answer
- **Spec Review Loop** - Automated quality check before golden program
- **Correctness First** - Golden program prioritizes correctness over performance

## Use Cases

- Product Requirements Documents (PRD) to technical design
- Business rules documents to decision logic
- Design notes to executable specifications
- Creating team-shared reference implementations

## Example

**Input**: A product document describing promotion rules

**Output**:
1. Understanding notes (document structure, module inventory, open questions)
2. Global alignment (overall inputs/outputs, flow diagram)
3. Local clarification (slice-specific rules and examples)
4. Boundary clarification (edge cases and failure handling)
5. Reviewed design specification
6. Runnable promotion calculation reference program

## Files

```
business-spec-to-golden/
├── SKILL.md          # General version (default)
├── SKILL-FULL.md     # Full version for strong models
├── README.md         # This file
└── references/
    └── spec-document-reviewer-prompt.md  # Spec review template
```

## License

MIT
