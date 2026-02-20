#!/bin/bash
# PreToolUse hook (command): Block artifact writes when the required skill hasn't been read.
# Checks skill_reads in docs/.workflow-state.json against skill-registry.json.
# Exit 0 = allow, Exit 2 = block with message.

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE_FILE="$PROJECT_DIR/docs/.workflow-state.json"
REGISTRY="$PROJECT_DIR/.claude/skills/project-orchestrator/skill-registry.json"

# Read hook input from stdin
INPUT=$(cat)

# Extract file_path from tool_input
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
tool_input = data.get('tool_input', {})
print(tool_input.get('file_path', ''))
" 2>/dev/null)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Make path relative to project dir
REL_PATH="${FILE_PATH#$PROJECT_DIR/}"

# Skip non-artifact paths (hooks, settings, state file, etc.)
# Only enforce on known artifact directories
if ! echo "$REL_PATH" | grep -qE '^(docs/|scripts/|scenes/)'; then
  exit 0
fi

# Skip the state file itself — orchestrator must always be able to write it
if [ "$REL_PATH" = "docs/.workflow-state.json" ]; then
  exit 0
fi

# Skip sprint log files
if echo "$REL_PATH" | grep -qE '^docs/sprint-logs/'; then
  exit 0
fi

# Skip code review outputs (qa-docs writes these during Phase C)
if echo "$REL_PATH" | grep -qE '^docs/code-reviews/'; then
  exit 0
fi

# Skip documentation updates (systems-bible, architecture, changelog)
if echo "$REL_PATH" | grep -qE '^docs/(systems-bible|architecture|known-patterns)\.md$'; then
  exit 0
fi
if [ "$REL_PATH" = "CHANGELOG.md" ]; then
  exit 0
fi

# Registry and state file must both exist
if [ ! -f "$REGISTRY" ] || [ ! -f "$STATE_FILE" ]; then
  exit 0
fi

# Run the enforcement check
python3 << PYEOF
import json, os, sys, fnmatch

project_dir = os.environ.get("CLAUDE_PROJECT_DIR", os.getcwd())
state_file = os.path.join(project_dir, "docs", ".workflow-state.json")
registry_file = os.path.join(project_dir, ".claude", "skills", "project-orchestrator", "skill-registry.json")
rel_path = "$REL_PATH"

try:
    with open(state_file, "r") as f:
        state = json.load(f)
    with open(registry_file, "r") as f:
        registry = json.load(f)
except (json.JSONDecodeError, FileNotFoundError):
    sys.exit(0)

pos = state.get("workflow_position", {})
current_phase = pos.get("phase")
current_step = pos.get("step")

# Determine required skill based on current workflow position
required_skill = None
match_found = False

if current_phase == "phase_0" and current_step:
    step_entry = registry.get("phase_0", {}).get(current_step, {})
    if step_entry:
        # Check if this file matches the artifact or artifact_pattern
        artifact = step_entry.get("artifact")
        artifact_pattern = step_entry.get("artifact_pattern")
        if artifact and rel_path == artifact:
            required_skill = step_entry.get("skill")
            match_found = True
        elif artifact_pattern and fnmatch.fnmatch(rel_path, artifact_pattern):
            required_skill = step_entry.get("skill")
            match_found = True

elif current_phase == "sprint" and current_step:
    step_entry = registry.get("sprint", {}).get(current_step, {})
    if step_entry:
        artifact_pattern = step_entry.get("artifact_pattern")
        artifact = step_entry.get("artifact")
        if artifact and rel_path == artifact:
            required_skill = step_entry.get("skill")
            match_found = True
        elif artifact_pattern and fnmatch.fnmatch(rel_path, artifact_pattern):
            required_skill = step_entry.get("skill")
            match_found = True

# If no registry entry matches this file, allow the write
if not match_found or not required_skill:
    sys.exit(0)

# Check skill_reads in state
skill_reads = state.get("skill_reads", {})
reads = skill_reads.get("reads", [])
skill_was_read = any(r.get("skill") == required_skill for r in reads)

if skill_was_read:
    sys.exit(0)
else:
    print(f"BLOCKED: Cannot write '{rel_path}' — the required skill has not been read yet.", file=sys.stderr)
    print(f"", file=sys.stderr)
    print(f"Before writing this artifact, you MUST read: {required_skill}", file=sys.stderr)
    print(f"", file=sys.stderr)
    print(f"This is enforced by the Skill Invocation Protocol. Read the skill file first,", file=sys.stderr)
    print(f"then retry this write.", file=sys.stderr)
    sys.exit(2)

PYEOF

exit $?
