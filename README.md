# ai-coding-bootstrap

Project templates that make AI coding agents actually finish what they start.

## The Problem

If you've spent any time using AI coding agents, you've hit the same walls:

- **"Done" doesn't mean done.** The agent declares a feature complete, but half the functions are stubbed out, edge cases are ignored, and nothing actually runs end-to-end.
- **Features get skipped.** You ask for A, B, and C. The agent gets excited about C, half-implements A, and forgets B exists.
- **No tests.** The agent writes 500 lines of code and moves on. You find out it's broken when you try to use it. By then the agent has built three more features on top of the broken one.
- **Tests get gutted instead of code getting fixed.** When tests fail, the agent rewrites the test to pass instead of fixing the implementation. The tests become meaningless.
- **Dependencies appear out of nowhere.** Midway through feature 4, the agent realizes it needs something from feature 2 that was never built. Instead of stopping to address it, it hacks around it or pretends it doesn't exist.
- **Wrong assumptions, wrong stack.** You say "build me a CLI tool" and the agent picks a language, framework, and architecture without asking. Three hours later you're looking at a Next.js app when you wanted a Go binary.
- **Re-implementations lose the plot.** You point the agent at an existing codebase to port, and it "reimagines" the architecture instead of preserving the structure that already works. Functions get renamed, modules get merged, and the mapping back to the original becomes impossible.

These aren't edge cases. This is the default behavior. The templates in this repo exist to fix it.

## What This Does

This repo provides a template and bootstrap script that you drop into any new project to give your AI coding agent a structured workflow.

### `AGENTS.template.md`

The canonical instruction file, following the [AGENTS.md](https://agents.md/) open standard (backed by the Linux Foundation). Defines:

- **Requirements discovery** — forces the agent to interview you about intent, language, framework, tooling, testing, deployment, and scope *before* writing a single line of code
- **Plan-driven development** — features are worked in order, one at a time, each completed fully before moving on
- **Dependency tracking** — when a surprise dependency is found, the agent must stop, document exactly what it blocks, and resolve it before continuing
- **Re-implementation rules** — when porting existing code, preserve names, structure, and behavior; reference code must be downloaded locally
- **Mandatory testing** — every feature gets tests; nothing is "done" until tests pass; tests are assumed correct (fix the code, not the test)
- **Tech stack with pinned versions** — prevents the agent from drifting to incompatible library versions
- **Code style examples** — show, don't tell; concrete code snippets beat abstract descriptions
- **Boundaries** — explicit Always / Ask First / Never rules so the agent knows what it can do autonomously and what requires your approval

### `PLAN.template.md`

A structured feature tracker with:

- Prioritized feature table with explicit dependency chains (which feature depends on which)
- Status and test-status columns so nothing slips through
- A discovered-dependencies table that records what was found, during which feature, and what it blocks
- Completion criteria checklist

### `init-project.sh`

A bootstrap script that:

- Copies `AGENTS.md` and `PLAN.md` into your project
- Creates symlinks for tool compatibility (`CLAUDE.md` and `.github/copilot-instructions.md` both point to `AGENTS.md`)
- Sets up `.gitignore` with `CLAUDE.local.md` (personal overrides) and `_reference/` (reference code)
- Initializes a git repo
- Optionally clones a reference codebase for re-implementation work

## Tool Compatibility

The instruction file is written once as `AGENTS.md` and symlinked for tools that use their own filename:

```
AGENTS.md                          # Canonical (Codex, Jules, Gemini CLI, Cursor, etc.)
CLAUDE.md -> AGENTS.md             # Claude Code
.github/copilot-instructions.md -> AGENTS.md  # GitHub Copilot
```

One set of rules, every tool reads them.

## Usage

### Clone this repo

```bash
git clone git@github.com:wan0net/ai-coding-bootstrap.git
```

### Start a new project

```bash
./ai-coding-bootstrap/init-project.sh ~/projects/my-new-app
```

This creates:
```
my-new-app/
  AGENTS.md    # Workflow rules (canonical)
  CLAUDE.md    # Symlink -> AGENTS.md
  PLAN.md      # Feature tracker (empty, ready to fill)
  .github/
    copilot-instructions.md  # Symlink -> AGENTS.md
  .gitignore   # Excludes CLAUDE.local.md, _reference/
  .git/
```

### Start a re-implementation (porting existing code)

```bash
# From a GitHub repo
./ai-coding-bootstrap/init-project.sh ~/projects/my-port --ref https://github.com/org/original-repo

# From a local directory
./ai-coding-bootstrap/init-project.sh ~/projects/my-port --ref /path/to/existing/code
```

This does everything above, plus:
- Clones/copies the reference into `_reference/source/`
- Wires the reference path into both AGENTS.md and PLAN.md

The agent can then read the original source locally at any time during implementation.

### Start coding

Open the project directory in your AI coding tool:

```bash
cd ~/projects/my-new-app
claude        # or codex, cursor, etc.
```

The agent will:
1. Read AGENTS.md and follow the workflow rules
2. Ask you questions about what you're building before writing code
3. Fill in PLAN.md with the agreed feature list
4. Work through features in order, testing each one, updating the plan as it goes

### Personal overrides

Create a `CLAUDE.local.md` in the project root for personal preferences that shouldn't be committed (it's already in `.gitignore`).

## Designed For

- [Claude Code](https://claude.ai/code) — reads CLAUDE.md natively
- [OpenAI Codex](https://openai.com/codex) — reads AGENTS.md natively
- [GitHub Copilot](https://github.com/features/copilot) — reads .github/copilot-instructions.md
- [Google Jules](https://jules.google/) — reads AGENTS.md
- [Cursor](https://cursor.sh) — reads AGENTS.md and .cursorrules
- Any AI coding agent that respects project-level instruction files

## License

MIT. See [LICENSE](LICENSE).
