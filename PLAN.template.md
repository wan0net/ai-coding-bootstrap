# PLAN.md — [Project Name]

## Objective

<!-- One paragraph describing what this project does and the end goal. -->

## Reference Implementation

<!-- If re-implementing existing software, link or describe the source here. -->
- **Source repo/docs**:
- **Language/framework**:
- **Key modules to preserve**:

## Features (Priority & Dependency Order)

Work through items top-to-bottom. Do not skip ahead unless a new dependency is discovered — document it and resolve it first.

| # | Feature | Depends On | Status | Tests |
|---|---------|------------|--------|-------|
| 1 | | — | `pending` | `none` |
| 2 | | #1 | `pending` | `none` |
| 3 | | #1, #2 | `pending` | `none` |

**Status values**: `pending` | `in-progress` | `blocked` | `done`
**Test values**: `none` | `written` | `passing`

## Discovered Dependencies

<!-- Log any dependency discovered mid-implementation that was not in the original plan.
     - "Discovered During": which feature # you were working on when you found it.
     - "Blocks": which feature(s) cannot proceed until this is resolved.
     - After resolving, update the Features table "Depends On" column to reflect the new dependency.
-->

| Discovered During | Dependency | Blocks | Resolution | Status |
|-------------------|------------|--------|------------|--------|
| #N | description | #N, #N | how it was resolved | `pending` |

## Architecture Notes

<!-- Key decisions, module layout, data flow, etc. -->

## Completion Criteria

- [ ] All features `done`
- [ ] All tests `passing`
- [ ] Manual smoke test completed
