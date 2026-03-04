#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
# Bootstrap a new AI-agent-managed software project
#
# Usage:
#   ./init-project.sh <project-dir> [--ref <git-url-or-path>]
#
# Examples:
#   ./init-project.sh ~/Workspace/my-app
#   ./init-project.sh ~/Workspace/my-port --ref https://github.com/org/original-repo
#   ./init-project.sh ~/Workspace/my-port --ref /path/to/local/repo
# ─────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR=""
REF_SOURCE=""

# ── Parse args ──────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
    case "$1" in
        --ref)
            REF_SOURCE="$2"
            shift 2
            ;;
        *)
            PROJECT_DIR="$1"
            shift
            ;;
    esac
done

if [[ -z "$PROJECT_DIR" ]]; then
    echo "Usage: $0 <project-dir> [--ref <git-url-or-path>]"
    exit 1
fi

# ── Create project ──────────────────────────────────────────
mkdir -p "$PROJECT_DIR"
echo "Created project directory: $PROJECT_DIR"

# ── Copy templates ──────────────────────────────────────────
cp "$SCRIPT_DIR/AGENTS.template.md" "$PROJECT_DIR/AGENTS.md"
cp "$SCRIPT_DIR/PLAN.template.md"   "$PROJECT_DIR/PLAN.md"
echo "Copied AGENTS.md and PLAN.md templates"

# ── Create symlinks for tool compatibility ──────────────────
# Claude Code reads CLAUDE.md, other tools read AGENTS.md
cd "$PROJECT_DIR"
ln -sf AGENTS.md CLAUDE.md
mkdir -p .github
ln -sf ../AGENTS.md .github/copilot-instructions.md
echo "Created symlinks: CLAUDE.md, .github/copilot-instructions.md -> AGENTS.md"

# ── Create .gitignore ──────────────────────────────────────
cat > "$PROJECT_DIR/.gitignore" << 'GITIGNORE'
# Personal agent overrides (not committed)
CLAUDE.local.md

# Reference implementation (not committed)
_reference/
GITIGNORE
echo "Created .gitignore"

# ── Initialize git ──────────────────────────────────────────
if [[ ! -d "$PROJECT_DIR/.git" ]]; then
    git -C "$PROJECT_DIR" init
    echo "Initialized git repository"
fi

# ── Clone / copy reference implementation ───────────────────
if [[ -n "$REF_SOURCE" ]]; then
    REF_DIR="$PROJECT_DIR/_reference"
    mkdir -p "$REF_DIR"

    if [[ "$REF_SOURCE" == http* ]] || [[ "$REF_SOURCE" == git@* ]]; then
        echo "Cloning reference repo: $REF_SOURCE"
        git clone --depth 1 "$REF_SOURCE" "$REF_DIR/source"
    elif [[ -d "$REF_SOURCE" ]]; then
        echo "Copying local reference: $REF_SOURCE"
        cp -R "$REF_SOURCE" "$REF_DIR/source"
    else
        echo "ERROR: Reference source not found: $REF_SOURCE"
        exit 1
    fi

    # Add reference path to AGENTS.md
    sed -i '' "s|<!-- link or \"N/A\" -->|_reference/source/|" "$PROJECT_DIR/AGENTS.md"

    # Add reference info to PLAN.md
    sed -i '' "s|- \*\*Source repo/docs\*\*:|- \*\*Source repo/docs\*\*: $REF_SOURCE|" "$PROJECT_DIR/PLAN.md"

    echo "Reference implementation stored in: $REF_DIR/source/"
fi

# ── Summary ─────────────────────────────────────────────────
echo ""
echo "── Project bootstrapped ──────────────────────────────"
echo "  Directory  : $PROJECT_DIR"
echo "  AGENTS.md  : $PROJECT_DIR/AGENTS.md  (canonical)"
echo "  CLAUDE.md  : $PROJECT_DIR/CLAUDE.md  (symlink)"
echo "  Copilot    : $PROJECT_DIR/.github/copilot-instructions.md (symlink)"
echo "  PLAN.md    : $PROJECT_DIR/PLAN.md"
if [[ -n "$REF_SOURCE" ]]; then
echo "  Reference  : $PROJECT_DIR/_reference/source/"
fi
echo ""
echo "Next steps:"
echo "  1. Fill in PLAN.md with your objective and feature list"
echo "  2. Fill in the Project Info, Tech Stack, and Commands sections of AGENTS.md"
echo "  3. Start your AI coding agent in the project directory"
echo "───────────────────────────────────────────────────────"
