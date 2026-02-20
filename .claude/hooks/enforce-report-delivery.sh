#!/bin/bash
# PreToolUse hook (Write): Block artifact writes when pending_reports is non-empty.
# The orchestrator must present all required report formats before advancing the workflow.
#
# Allows: writes to docs/.workflow-state.json (so the orchestrator can clear pending_reports)
# Blocks: writes to docs/features/*.md, scripts/**, scenes/**, and other artifacts

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE_FILE="$PROJECT_DIR/docs/.workflow-state.json"

# If no state file, nothing to enforce
if [ ! -f "$STATE_FILE" ]; then
  exit 0
fi

# Extract the file path being written from tool input (passed via stdin)
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(data.get('file_path', ''))
" 2>/dev/null || echo "")

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Always allow writes to the state file itself (needed to set/clear pending_reports)
if echo "$FILE_PATH" | grep -q "docs/\.workflow-state\.json"; then
  exit 0
fi

# Always allow writes to hook scripts and settings (meta-configuration)
if echo "$FILE_PATH" | grep -q "\.claude/"; then
  exit 0
fi

# Always allow writes to memory files
if echo "$FILE_PATH" | grep -q "memory/"; then
  exit 0
fi

# Check if there are pending reports
PENDING=$(python3 -c "
import json
with open('$STATE_FILE') as f:
    data = json.load(f)
reports = data.get('pending_reports', [])
if reports:
    print('|'.join(reports))
else:
    print('')
" 2>/dev/null || echo "")

if [ -z "$PENDING" ]; then
  exit 0
fi

# There are pending reports — build a human-readable message
REPORT_NAMES=$(python3 -c "
import json

REPORT_LABELS = {
    'sprint_end_review': 'Sprint End Review (report-formats.md #4)',
    'sprint_start': 'Sprint Start Card (report-formats.md #4)',
    'epic_review': 'Epic Review Banner (report-formats.md #5)',
    'lifecycle_gate': 'Lifecycle Gate Banner (report-formats.md #6)',
    'integration_check': 'Integration Check Report (report-formats.md #8)',
    'phase_transition': 'Phase Transition Card (report-formats.md #2)',
}

reports = '$PENDING'.split('|')
labels = [REPORT_LABELS.get(r, r) for r in reports]
print(', '.join(labels))
" 2>/dev/null || echo "$PENDING")

# Block the write
echo "BLOCKED: Pending report(s) must be delivered before writing artifacts."
echo ""
echo "Required reports: $REPORT_NAMES"
echo ""
echo "To unblock:"
echo "  1. Present the required report(s) using the format from report-formats.md"
echo "  2. Update docs/.workflow-state.json to clear pending_reports (set to [])"
echo "  3. Then retry this write"
exit 2
