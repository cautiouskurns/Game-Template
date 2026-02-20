#!/bin/bash
# PostToolUse hook (async): Record workflow state transitions for instrumentation.
# Fires on Edit/Write of any file — only acts when the workflow state file is modified.
# Appends timestamped entries to docs/sprint-logs/workflow-timing.jsonl (JSON Lines format).

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE_FILE="$PROJECT_DIR/docs/.workflow-state.json"
LOG_DIR="$PROJECT_DIR/docs/sprint-logs"
TIMING_LOG="$LOG_DIR/workflow-timing.jsonl"

# Read hook input from stdin
INPUT=$(cat)

# Extract the file path from tool_input
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
tool_input = data.get('tool_input', {})
print(tool_input.get('file_path', ''))
" 2>/dev/null)

# Only act when the workflow state file was just modified
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

REL_PATH="${FILE_PATH#$PROJECT_DIR/}"
if [ "$REL_PATH" != "docs/.workflow-state.json" ]; then
  exit 0
fi

# State file must exist to log
if [ ! -f "$STATE_FILE" ]; then
  exit 0
fi

mkdir -p "$LOG_DIR"

# Read state and append a timing entry
python3 << 'PYEOF'
import json, os, sys
from datetime import datetime, timezone

project_dir = os.environ.get("CLAUDE_PROJECT_DIR", os.getcwd())
state_file = os.path.join(project_dir, "docs", ".workflow-state.json")
timing_log = os.path.join(project_dir, "docs", "sprint-logs", "workflow-timing.jsonl")

try:
    state = json.load(open(state_file))
except (json.JSONDecodeError, FileNotFoundError):
    sys.exit(0)

pos = state.get("workflow_position", {})
lifecycle = state.get("lifecycle_phase", "unknown")
sprint_num = pos.get("current_sprint")
phase = pos.get("step", pos.get("phase"))
status = pos.get("status", "unknown")
substep = pos.get("substep")

# Build the timing entry
entry = {
    "timestamp": datetime.now(timezone.utc).isoformat(),
    "lifecycle": lifecycle,
    "phase": phase,
    "status": status,
}

if sprint_num is not None:
    entry["sprint"] = sprint_num

if substep:
    entry["substep"] = substep

# Check if this is a phase transition by comparing to the last entry
last_entry = None
if os.path.exists(timing_log):
    try:
        with open(timing_log) as f:
            lines = f.readlines()
            if lines:
                last_entry = json.loads(lines[-1].strip())
    except (json.JSONDecodeError, IndexError):
        pass

# Detect if this is a new phase/status (transition event)
is_transition = True
if last_entry:
    same_phase = last_entry.get("phase") == entry.get("phase")
    same_status = last_entry.get("status") == entry.get("status")
    same_substep = last_entry.get("substep") == entry.get("substep")
    same_sprint = last_entry.get("sprint") == entry.get("sprint")
    same_lifecycle = last_entry.get("lifecycle") == entry.get("lifecycle")
    if same_phase and same_status and same_substep and same_sprint and same_lifecycle:
        is_transition = False

if is_transition:
    entry["event"] = "transition"
else:
    entry["event"] = "update"

# Always log transitions, skip redundant updates
if is_transition:
    with open(timing_log, "a") as f:
        f.write(json.dumps(entry) + "\n")

PYEOF

exit 0
