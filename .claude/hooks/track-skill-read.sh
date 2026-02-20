#!/bin/bash
# PostToolUse hook (command, synchronous): Track when SKILL.md files are read.
# Records skill reads in docs/.workflow-state.json so enforce-skill-read.sh can verify
# the required skill was read before allowing artifact writes.

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE_FILE="$PROJECT_DIR/docs/.workflow-state.json"

# Read hook input from stdin
INPUT=$(cat)

# Extract file_path from tool_input
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
tool_input = data.get('tool_input', {})
print(tool_input.get('file_path', ''))
" 2>/dev/null)

# Only act if path matches .claude/skills/*/SKILL.md
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Make path relative to project dir
REL_PATH="${FILE_PATH#$PROJECT_DIR/}"

# Check if this is a skill file read
if ! echo "$REL_PATH" | grep -qE '^\.claude/skills/[^/]+/SKILL\.md$'; then
  exit 0
fi

# State file must exist to record the read
if [ ! -f "$STATE_FILE" ]; then
  exit 0
fi

# Record the skill read in the state file
python3 << PYEOF
import json, os, sys
from datetime import datetime, timezone

project_dir = os.environ.get("CLAUDE_PROJECT_DIR", os.getcwd())
state_file = os.path.join(project_dir, "docs", ".workflow-state.json")
rel_path = "$REL_PATH"

try:
    with open(state_file, "r") as f:
        state = json.load(f)
except (json.JSONDecodeError, FileNotFoundError):
    sys.exit(0)

# Get current workflow step
pos = state.get("workflow_position", {})
current_step = pos.get("step")
current_phase = pos.get("phase")

# Build a step key for tracking
if current_phase == "phase_0":
    step_key = current_step or "unknown"
elif current_phase == "sprint":
    step_key = f"sprint_{current_step}" if current_step else "unknown"
else:
    step_key = current_phase or "unknown"

# Initialize skill_reads if missing
if "skill_reads" not in state:
    state["skill_reads"] = {
        "current_step": None,
        "reads": []
    }

skill_reads = state["skill_reads"]

# Reset reads if the step changed (prevents stale reads from a previous step)
if skill_reads.get("current_step") != step_key:
    skill_reads["current_step"] = step_key
    skill_reads["reads"] = []

# Record this read (avoid duplicates for same skill in same step)
already_recorded = any(r.get("skill") == rel_path for r in skill_reads["reads"])
if not already_recorded:
    skill_reads["reads"].append({
        "skill": rel_path,
        "read_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    })

# Write back
with open(state_file, "w") as f:
    json.dump(state, f, indent=2)

PYEOF

exit 0
