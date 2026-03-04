# ai-coding-bootstrap

Project templates that make AI coding agents actually finish what they start.

## The Problem

If you've spent any time using AI coding agents, you've hit the same walls:

- **"Done" doesn't mean done.** The agent declares a feature complete, but half the functions are stubbed out, edge cases are ignored, and nothing actually runs end-to-end.
- **Features get skipped.** You ask for A, B, and C. The agent gets excited about C, half-implements A, and forgets B exists.
- **No tests.** The agent writes 500 lines of code and moves on. You find out it's broken when you try to use it. By then the agent has built three more features on top of the broken one.
- **Dependencies appear out of nowhere.** Midway through feature 4, the agent realizes it needs something from feature 2 that was never built. Instead of stopping to address it, it hacks around it or pretends it doesn't exist.
- **Wrong assumptions, wrong stack.** You say "build me a CLI tool" and the agent picks a language, framework, and architecture without asking. Three hours later you're looking at a Next.js app when you wanted a Go binary.
- **Re-implementations lose the plot.** You point the agent at an existing codebase to port, and it "reimagines" the architecture instead of preserving the structure that already works. Functions get renamed, modules get merged, and the mapping back to the original becomes impossible.

These aren't edge cases. This is the default behavior. The templates in this repo exist to fix it.

## What This Does

This repo provides three files that you drop into any new project to give your AI coding agent (Claude Code, or similar) a structured workflow:

### `CLAUDE.template.md`
Project-level instructions the agent reads on every interaction. Defines:

- **Requirements discovery** — forces the agent to interview you about intent, language, framework, tooling, testing, deployment, and scope *before* writing a single line of code
- **Plan-driven development** — features are worked in order, one at a time, each completed fully before moving on
- **Dependency tracking** — when a surprise dependency is found, the agent must stop, document exactly what it blocks, and resolve it before continuing
- **Re-implementation rules** — when porting existing code, preserve names, structure, and behavior; reference code must be local, not fetched on the fly
- **Mandatory testing** — every feature gets tests; nothing is "done" until tests pass

### `PLAN.template.md`
A structured feature tracker with:

- Prioritized feature table with explicit dependency chains (which feature depends on which)
- Status and test-status columns so nothing slips through
- A discovered-dependencies table that records what was found, during which feature, and what it blocks
- Completion criteria checklist

### `init-project.sh`
A bootstrap script that sets up a new project directory with these templates, initializes git, and optionally clones a reference codebase for re-implementation work.

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
  CLAUDE.md    # Workflow rules for the agent
  PLAN.md      # Feature tracker (empty, ready to fill)
  .git/        # Initialized repo
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
- Adds `_reference/` to `.gitignore`
- Wires the reference path into both CLAUDE.md and PLAN.md

The agent can then read the original source locally at any time during implementation.

### Start coding

Open the project directory in Claude Code (or your AI coding tool of choice):

```bash
cd ~/projects/my-new-app
claude
```

The agent will:
1. Read CLAUDE.md and follow the workflow rules
2. Ask you questions about what you're building before writing code
3. Fill in PLAN.md with the agreed feature list
4. Work through features in order, testing each one, updating the plan as it goes

## Designed For

- [Claude Code](https://claude.ai/code) (primary target — uses CLAUDE.md natively)
- Any AI coding agent that respects project-level instruction files

## License

Do whatever you want with it. If it saves you from one more "done but not actually done" moment, it was worth it.
