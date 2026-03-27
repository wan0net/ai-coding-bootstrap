# ai-coding-bootstrap

[![License: BSD-3-Clause](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](LICENSE)
[![AI Generated](https://img.shields.io/badge/AI%20Generated-Claude-blueviolet)](https://claude.ai)

<p align="center"><strong>Project templates that make AI coding agents actually finish what they start</strong><br>Structured instruction files that enforce verifiable development workflows.</p>

<p align="center">
<a href="#why-ai-coding-bootstrap">Why</a> •
<a href="#how-it-works">How It Works</a> •
<a href="#tool-compatibility">Tool Compatibility</a> •
<a href="#getting-started">Getting Started</a> •
<a href="#license">License</a>
</p>

---

> **Status:** Templates stable and in active use. `init-project.sh` handles new projects and re-implementations. Compatible with all major AI coding agents.

## Why ai-coding-bootstrap

If you've spent any time using AI coding agents, you've hit the same walls.

**"Done" doesn't mean done.** The agent declares a feature complete, but half the functions are stubbed out, edge cases are ignored, and nothing actually runs end-to-end.

**Features get skipped.** You ask for A, B, and C. The agent gets excited about C, half-implements A, and forgets B exists.

**No tests.** The agent writes 500 lines of code and moves on. You find out it's broken when you try to use it. By then the agent has built three more features on top of the broken one.

**Tests get gutted instead of code getting fixed.** When tests fail, the agent rewrites the test to pass instead of fixing the implementation. The tests become meaningless.

**Dependencies appear out of nowhere.** Midway through feature 4, the agent realizes it needs something from feature 2 that was never built. Instead of stopping to address it, it hacks around it or pretends it doesn't exist.

**Wrong assumptions, wrong stack.** You say "build me a CLI tool" and the agent picks a language, framework, and architecture without asking. Three hours later you're looking at a Next.js app when you wanted a Go binary.

**Re-implementations lose the plot.** You point the agent at an existing codebase to port, and it "reimagines" the architecture instead of preserving the structure that already works. Functions get renamed, modules get merged, and the mapping back to the original becomes impossible.

These aren't edge cases. This is the default behavior. The templates in this repo exist to fix it.

## How It Works

This repo provides a template and bootstrap script that you drop into any new project to give your AI coding agent a structured workflow.

### `AGENTS.template.md`

The canonical instruction file, following the [AGENTS.md](https://agents.md/) open standard (backed by the Linux Foundation). Defines:

- **Requirements discovery** — forces the agent to interview you about intent, language, framework, tooling, testing, deployment, and scope before writing a single line of code
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
AGENTS.md                                     # Canonical (Codex, Jules, Gemini CLI, Cursor, etc.)
CLAUDE.md -> AGENTS.md                        # Claude Code
.github/copilot-instructions.md -> AGENTS.md  # GitHub Copilot
```

One set of rules, every tool reads them.

| Tool | Instruction file |
|------|-----------------|
| [Claude Code](https://claude.ai/code) | `CLAUDE.md` (symlink) |
| [OpenAI Codex](https://openai.com/codex) | `AGENTS.md` |
| [GitHub Copilot](https://github.com/features/copilot) | `.github/copilot-instructions.md` (symlink) |
| [Google Jules](https://jules.google/) | `AGENTS.md` |
| [Cursor](https://cursor.sh) | `AGENTS.md` |
| Any agent that reads project-level instruction files | `AGENTS.md` |

## Getting Started

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

This does everything above, plus clones or copies the reference into `_reference/source/` and wires the reference path into both `AGENTS.md` and `PLAN.md`. The agent can then read the original source locally at any time during implementation.

### Start coding

```bash
cd ~/projects/my-new-app
claude        # or codex, cursor, etc.
```

The agent will read `AGENTS.md`, ask you questions about what you're building before writing code, fill in `PLAN.md` with the agreed feature list, and work through features in order — testing each one and updating the plan as it goes.

### Personal overrides

Create a `CLAUDE.local.md` in the project root for personal preferences that shouldn't be committed. It's already in `.gitignore`.

## License

BSD-3-Clause. See [LICENSE](LICENSE).
