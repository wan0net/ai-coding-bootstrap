#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
# Bootstrap a new Claude-managed software project
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
cp "$SCRIPT_DIR/CLAUDE.template.md" "$PROJECT_DIR/CLAUDE.md"
cp "$SCRIPT_DIR/PLAN.template.md"   "$PROJECT_DIR/PLAN.md"
echo "Copied CLAUDE.md and PLAN.md templates"

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

    # Add reference path to CLAUDE.md
    sed -i '' "s|<!-- link or \"N/A\" -->|_reference/source/|" "$PROJECT_DIR/CLAUDE.md"

    # Add reference info to PLAN.md
    sed -i '' "s|- \*\*Source repo/docs\*\*:|- \*\*Source repo/docs\*\*: $REF_SOURCE|" "$PROJECT_DIR/PLAN.md"

    # Prevent accidentally committing the reference source into the new project
    echo "_reference/" >> "$PROJECT_DIR/.gitignore"

    echo "Reference implementation stored in: $REF_DIR/source/"
    echo "Added _reference/ to .gitignore"
fi

# ── Summary ─────────────────────────────────────────────────
echo ""
echo "── Project bootstrapped ──────────────────────────────"
echo "  Directory : $PROJECT_DIR"
echo "  CLAUDE.md : $PROJECT_DIR/CLAUDE.md"
echo "  PLAN.md   : $PROJECT_DIR/PLAN.md"
if [[ -n "$REF_SOURCE" ]]; then
echo "  Reference : $PROJECT_DIR/_reference/source/"
fi
echo ""
echo "Next steps:"
echo "  1. Fill in PLAN.md with your objective and feature list"
echo "  2. Fill in the Project Info and Commands sections of CLAUDE.md"
echo "  3. Start Claude Code in the project directory"
echo "───────────────────────────────────────────────────────"
