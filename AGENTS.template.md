# AGENTS.md

## Workflow Rules

### 0. Project Kickoff — Requirements Discovery

**Before writing any code or filling in PLAN.md**, conduct a thorough requirements interview with the user. The user will give a brief overview — your job is to ask enough questions to remove ambiguity before committing to a plan.

Ask about **all** of the following. Do not assume defaults — ask explicitly:

- **Intent & purpose:** What problem does this solve? What is the end goal?
- **Users & audience:** Who will use this? Technical level? Solo dev tool, team internal, public-facing?
- **Language & runtime:** What language(s)? What version/runtime (e.g., Node 20, Python 3.12, Go 1.22)?
- **Framework & engine:** Any specific framework (React, Django, Gin, etc.)? Game engine? UI toolkit?
- **Build & tooling:** Package manager preference (npm, pnpm, uv, cargo)? Bundler? Linter/formatter?
- **Testing approach:** Preferred test framework? Unit, integration, E2E? Coverage targets?
- **Infrastructure & deployment:** Where will this run? Docker, bare metal, serverless, edge? CI/CD preferences?
- **Data & storage:** Database? File storage? External APIs? Auth provider?
- **Existing code or reference:** Is this a port/reimplementation? Where is the reference code? What parts should be ported vs. redesigned?
- **Scope & MVP:** What is the minimum viable version? What can be deferred to later?
- **Constraints & preferences:** Performance targets? Accessibility? Browser support? Offline? Mobile?
- **Style & conventions:** Naming conventions? Code style preferences? Commit message format?

You may batch these into logical groups rather than asking all at once. Adapt your questions to what the user has already told you — skip what's been answered, dig deeper where it's vague.

**Do not proceed to PLAN.md until the user confirms the requirements are complete.** Once confirmed, fill in the Project Info section below and the PLAN.md feature list, then get user sign-off on the plan before writing code.

### 1. Plan-Driven Development

- **PLAN.md is the source of truth.** Read it before starting any work.
- Work through features in the order listed. Finish an item completely (implemented + tests passing) before moving to the next.
- **Exception — discovered dependencies:** If implementing feature N reveals an unplanned dependency, STOP.
  1. Add the dependency to the "Discovered Dependencies" table in PLAN.md.
  2. In the "Blocks" column, list **every feature #** that cannot proceed without it.
  3. Update the "Depends On" column in the Features table for each blocked feature to include the new dependency.
  4. Resolve the dependency, then resume the blocked feature.
- Update PLAN.md status after completing each feature. Always keep the "Depends On" column accurate — if a feature is blocked, it must say exactly which items block it.

### 2. Re-implementation Rules (when porting existing software)

When re-implementing software from another language or codebase:

- **Reference code must be local.** The original source code must be cloned/downloaded into `_reference/source/` before any work begins. Never rely on fetching code from the network during implementation — the full reference must be available locally for reading at all times. If it was not provided during bootstrap, clone or download it now before proceeding.
- **Read the reference code first.** Before writing anything, read and understand the original module/function you are porting.
- **Preserve names.** Use the same module names, function names, class names, and variable names as the original wherever the target language allows. Only deviate when the target language has a strong naming convention (e.g., snake_case in Python vs camelCase in JS) — document deviations.
- **Preserve structure.** Match the original's module/file layout. One original file should map to one new file unless there is a compelling reason to split or merge.
- **Preserve behavior.** The ported code must produce identical outputs for identical inputs. If the original has bugs, port the bug first, then fix it as a separate tracked item.
- **Document gaps.** If a reference feature cannot be ported (missing library, platform difference), note it in PLAN.md under Architecture Notes.

### 3. Test Requirements

Every feature added to the codebase **must** have tests before it is marked `done`.

- **Unit/programmatic tests** for logic, data transforms, and utilities.
- **UI/integration tests** for user-facing features (browser-based, CLI output, API responses).
- Tests must be runnable with a single command documented in the "Commands" section below.
- A feature is not complete until its tests pass in CI or local test runner.
- **Tests are assumed correct.** If the implementation fails a test, fix the implementation — not the test. If a test repeatedly fails after genuine implementation attempts, the test may be replaced, but explain why the original test was wrong and what the replacement covers.

### 4. Git Workflow

- **Initialize git immediately.** The first thing you do in a new project is `git init` and commit the scaffolding (AGENTS.md, PLAN.md, project skeleton). Every feature builds on a committed baseline.
- **Commit after every feature.** When a feature's implementation and tests are passing, commit it before moving to the next feature. One feature = one commit. This creates a clean rollback point for each feature.
- **Commit message format:** Start with the feature number from PLAN.md, e.g. `#3: Add user authentication endpoint`
- Do not batch multiple features into a single commit.
- Do not leave uncommitted work when starting the next feature.

### 5. General Coding Standards

- Do not skip ahead or "stub out" future features. Implement fully or not at all.
- Do not add dependencies without checking PLAN.md first. If a new dependency is needed, log it.

---

## Project Info

- **Name**:
- **Language/Stack**: <!-- Pin versions, e.g. "Python 3.12, Flask 3.0, SQLAlchemy 2.0" -->
- **Reference implementation**: <!-- link or "N/A" -->

## Tech Stack

<!-- Pin exact versions to prevent compatibility drift. -->

| Component | Version |
|-----------|---------|
| Language | |
| Framework | |
| Test framework | |
| Package manager | |
| Linter/formatter | |

## Commands

```bash
# Install dependencies
# TODO

# Run the project
# TODO

# Run all tests
# TODO

# Run a single test file
# TODO <path/to/test_file>

# Lint
# TODO

# Format
# TODO

# Build for production
# TODO
```

## Project Structure

```
# TODO — fill in after initial scaffolding
```

## Code Style

<!-- Show, don't tell. Provide real code examples of the conventions used in this project. -->

### Preferred

```
# TODO — add a short code example showing the project's conventions
```

### Avoid

```
# TODO — add a short code example showing what NOT to do
```

## Boundaries

### Always
- Run tests before marking a feature done
- Include types/annotations where the language supports them
- Use the project's existing patterns — match what's already there

### Ask First
- Adding new dependencies or packages
- Changing database schema or data models
- Architectural changes that affect multiple modules
- Deleting or renaming public APIs

### Never
- Commit secrets, credentials, API keys, or .env files
- Modify CI/CD pipelines without explicit approval
- Skip tests to "save time"
- Rewrite working code for style preferences alone
