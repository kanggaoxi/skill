# Artifact Header Template

Use this header for stage artifacts and ledgers unless a more specific template overrides it.

Recommended targets:

- `*-understanding.md`
- `*-p0-questions.md`
- `*-p1-questions.md`
- `*-p2-questions.md`
- `*-question-history.md`
- `*-global-flow.md`
- `*-submodule-design.md`
- `*-boundary-rules.md`

## Standard Header

```markdown
Status: draft | approved | stale | superseded
Last Updated: YYYY-MM-DD HH:mm
Derived From:
- [source document path]
- [approved upstream artifact path]
- [confirmed question IDs if relevant]
```

## Optional Header Fields

Add these only when they improve traceability:

```markdown
Supersedes: [older artifact path]
Invalidated By: [newer artifact path or correction source]
Notes:
- [short note about why this file changed]
```

## Status Meanings

- `draft`: current working version, not yet approved
- `approved`: accepted as the current baseline
- `stale`: upstream facts changed, so this file must not be trusted without refresh
- `superseded`: replaced by a newer artifact

## Usage Rules

- Keep headers short and factual
- `Derived From` should name only the artifacts actually used
- If a user correction invalidates the file, update `Status` first before rewriting the body
- Do not use this template for executable code files
- If a file has its own stronger template, follow that template instead
