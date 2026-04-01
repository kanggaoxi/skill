# Spec Review Template

Use this template when writing `*-spec-review.md`.

This file is the blocking review record between `*-design.md` and user approval.

## Required Header

```markdown
# [Topic] Spec Review

Status: Approved | Issues Found | Review Blocked
Last Updated: YYYY-MM-DD HH:mm
Derived From:
- [design.md path]
- [reviewer prompt path]
```

## Required Sections

### 1. Reviewed Against

- Design spec path
- Template or structure reference used
- Reviewer scope

### 2. Blocking Issues

- List issues that must be fixed before user review
- If none, write `None`

### 3. Advisory Suggestions

- Non-blocking improvements
- If none, write `None`

### 4. Template Compliance

- Whether the spec follows the required template
- Missing sections or format deviations

### 5. Code-Generation Readiness

- Is the spec ready to guide test planning and implementation?
- Are there unresolved details that would lead to unstable code generation?

### 6. Ready For User Review

- `yes` or `no`
- One-sentence justification

## Rules

- `Approved` means no blocking issues remain
- `Issues Found` means user review and downstream stages must stop
- `Review Blocked` means the review itself failed or could not complete; downstream stages must stop
