#!/bin/bash
# PreToolUse hook (command): Check if a feature spec exists before allowing new script creation.
# Only blocks creation of NEW .gd files — editing existing files is always allowed.

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
INPUT=$(cat)

# Extract tool info
TOOL_NAME=$(python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('tool_name', ''))
" <<< "$INPUT" 2>/dev/null)

FILE_PATH=$(python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('tool_input', {}).get('file_path', ''))
" <<< "$INPUT" 2>/dev/null)

# Only check Write tool (new file creation) — Edit is for existing files
if [ "$TOOL_NAME" != "Write" ]; then
  exit 0
fi

# Only check .gd script files (not .tres, .tscn, .md, .json, etc.)
if [[ "$FILE_PATH" != *.gd ]]; then
  exit 0
fi

# If the file already exists, this is an overwrite, not a new creation — allow it
if [ -f "$FILE_PATH" ]; then
  exit 0
fi

# Skip hook scripts, simulation scripts, and test files
REL_PATH="${FILE_PATH#$PROJECT_DIR/}"
if [[ "$REL_PATH" == .claude/* ]] || [[ "$REL_PATH" == scripts/simulation/* ]] || [[ "$REL_PATH" == *test* ]]; then
  exit 0
fi

# Check if any feature spec exists in docs/features/
SPEC_DIR="$PROJECT_DIR/docs/features"
if [ ! -d "$SPEC_DIR" ]; then
  echo "No docs/features/ directory found. Create a feature spec before writing new scripts. See docs/agent-team-workflow.md for the feature pipeline." >&2
  exit 2
fi

SPEC_COUNT=$(find "$SPEC_DIR" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
if [ "$SPEC_COUNT" -eq 0 ]; then
  echo "No feature specs found in docs/features/. Create a feature spec before writing new scripts. See docs/agent-team-workflow.md for the feature pipeline." >&2
  exit 2
fi

# Feature specs exist — allow the creation.
# (A more sophisticated version could check if the specific file maps to a spec,
# but that would require parsing specs and mapping to file paths, which is fragile.
# The existence of any spec means the design pipeline has been followed.)
exit 0
