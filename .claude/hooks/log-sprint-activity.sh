#!/bin/bash
# PostToolUse hook (async): Log file edits to sprint activity log for Phase C review.
# Receives tool use JSON on stdin, appends file path + timestamp to the log.

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE_FILE="$PROJECT_DIR/docs/.workflow-state.json"
LOG_DIR="$PROJECT_DIR/docs/sprint-logs"

# Read hook input from stdin
INPUT=$(cat)

# Extract the file path from tool_input (Edit and Write both use file_path)
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
# tool_input contains the parameters passed to Edit/Write
tool_input = data.get('tool_input', {})
print(tool_input.get('file_path', ''))
" 2>/dev/null)

# Skip if no file path found
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Get current sprint number from workflow state
SPRINT="unknown"
if [ -f "$STATE_FILE" ]; then
  SPRINT=$(python3 -c "
import json
with open('$STATE_FILE') as f:
  data = json.load(f)
print(data.get('workflow_position', {}).get('current_sprint', 'unknown'))
" 2>/dev/null || echo "unknown")
fi

# Create log directory if needed
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/sprint-${SPRINT}-activity.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
TOOL_NAME=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('tool_name', 'unknown'))
" 2>/dev/null || echo "unknown")

# Make path relative to project dir for readability
REL_PATH="${FILE_PATH#$PROJECT_DIR/}"

echo "[$TIMESTAMP] $TOOL_NAME: $REL_PATH" >> "$LOG_FILE"
exit 0
