#!/bin/bash
# PreToolUse hook (command): Enforce that implementation only happens in valid phases
# with approved specs. Extends enforce-feature-spec.sh with state-aware validation.
#
# Checks:
# 1. Current phase must be B or later to write implementation files
# 2. At least one feature spec must have "completed" status in state file
# 3. Blocks writing .gd/.tscn files during Phase A (spec/foundation phase)

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE_FILE="$PROJECT_DIR/docs/.workflow-state.json"
INPUT=$(cat)

# Extract tool info
TOOL_NAME=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('tool_name', ''))
" 2>/dev/null)

FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('tool_input', {}).get('file_path', ''))
" 2>/dev/null)

# Only check Write tool (new file creation)
if [ "$TOOL_NAME" != "Write" ]; then
  exit 0
fi

# Only check implementation files (.gd and .tscn)
if [[ "$FILE_PATH" != *.gd ]] && [[ "$FILE_PATH" != *.tscn ]]; then
  exit 0
fi

# If the file already exists, this is an overwrite — allow it
if [ -f "$FILE_PATH" ]; then
  exit 0
fi

# Skip hook scripts, simulation scripts, and test files
REL_PATH="${FILE_PATH#$PROJECT_DIR/}"
if [[ "$REL_PATH" == .claude/* ]] || [[ "$REL_PATH" == scripts/simulation/* ]] || [[ "$REL_PATH" == *test* ]]; then
  exit 0
fi

# If no state file exists, fall through to the basic enforce-feature-spec hook
if [ ! -f "$STATE_FILE" ]; then
  exit 0
fi

# Validate current phase allows implementation
python3 << 'PYEOF'
import json, os, sys

project_dir = os.environ.get("CLAUDE_PROJECT_DIR", os.getcwd())
state_file = os.path.join(project_dir, "docs", ".workflow-state.json")

try:
    state = json.load(open(state_file))
except (json.JSONDecodeError, FileNotFoundError):
    # Can't read state — let the basic hook handle it
    sys.exit(0)

pos = state.get("workflow_position", {})
phase = pos.get("phase", "")
step = pos.get("step", "")

# During Phase 0, only design docs should be created — no implementation files
if phase == "phase_0" or phase == "pre_phase_0":
    print("Cannot create implementation files during Phase 0 (design pipeline). Complete the design pipeline first.", file=sys.stderr)
    sys.exit(2)

# During sprint Phase A, only foundation/spec work — not gameplay implementation
# Allow systems-dev files (autoloads, systems) since they build foundations in Phase A
rel_path = os.environ.get("REL_PATH", "")

if step == "A":
    # Systems-dev directories are allowed in Phase A (foundation work)
    allowed_a_dirs = ["scripts/autoloads/", "scripts/systems/", "scripts/resources/", "addons/"]
    is_foundation = any(rel_path.startswith(d) for d in allowed_a_dirs)
    if not is_foundation:
        print(f"Phase A is for specs and foundations. Non-foundation implementation files should wait for Phase B. Current file: {rel_path}", file=sys.stderr)
        sys.exit(2)

# Check that at least one feature spec is approved in the state file
sprints = state.get("sprints", [])
current_sprint = pos.get("current_sprint")
spec_approved = False

for sprint in sprints:
    if sprint.get("sprint_number") == current_sprint:
        features = sprint.get("features", [])
        for feature in features:
            if feature.get("status") in ("completed", "approved", "in_progress"):
                spec_approved = True
                break
        break

if not spec_approved:
    # Also check phase_0_progress for feature pipeline completion
    p0 = state.get("phase_0_progress", {})
    feature_pipeline = p0.get("feature_pipeline", {})
    if feature_pipeline.get("status") in ("completed", "in_progress"):
        spec_approved = True

if not spec_approved:
    # Check docs/features/ as fallback
    spec_dir = os.path.join(project_dir, "docs", "features")
    if os.path.isdir(spec_dir):
        specs = [f for f in os.listdir(spec_dir) if f.endswith(".md")]
        if specs:
            spec_approved = True

if not spec_approved:
    print("No approved feature specs found. Approve feature specs before implementation.", file=sys.stderr)
    sys.exit(2)

# All checks passed
sys.exit(0)

PYEOF

exit $?
