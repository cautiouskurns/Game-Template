#!/bin/bash
# PostToolUse hook (async): Capture and parse Godot headless smoke test output.
# Fires on Bash tool use — detects when a smoke test command was run,
# captures the output, parses for errors/warnings, and logs to sprint log file.

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE_FILE="$PROJECT_DIR/docs/.workflow-state.json"
LOG_DIR="$PROJECT_DIR/docs/sprint-logs"

# Read hook input from stdin
INPUT=$(cat)

# Extract the command that was run and its output
COMMAND=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
tool_input = data.get('tool_input', {})
print(tool_input.get('command', ''))
" 2>/dev/null)

# Only act on smoke test commands (godot --headless)
if [[ "$COMMAND" != *"--headless"* ]] || [[ "$COMMAND" != *"--quit"* ]]; then
  exit 0
fi

# Skip class cache rebuilds (--editor flag) — only capture actual smoke tests
if [[ "$COMMAND" == *"--editor"* ]]; then
  exit 0
fi

TOOL_OUTPUT=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('tool_output', ''))
" 2>/dev/null)

mkdir -p "$LOG_DIR"

# Parse output and write log
python3 << 'PYEOF'
import json, os, sys, re
from datetime import datetime, timezone

project_dir = os.environ.get("CLAUDE_PROJECT_DIR", os.getcwd())
state_file = os.path.join(project_dir, "docs", ".workflow-state.json")
log_dir = os.path.join(project_dir, "docs", "sprint-logs")

# Get tool output from environment
tool_output = os.environ.get("TOOL_OUTPUT", "")
command = os.environ.get("COMMAND", "")

# Get current sprint from state file
sprint_num = "unknown"
if os.path.exists(state_file):
    try:
        state = json.load(open(state_file))
        sprint_num = state.get("workflow_position", {}).get("current_sprint", "unknown")
    except (json.JSONDecodeError, KeyError):
        pass

timestamp = datetime.now(timezone.utc).isoformat()
log_file = os.path.join(log_dir, f"sprint-{sprint_num}-smoke-test.log")

# Parse the output for errors, warnings, and script errors
lines = tool_output.split("\n") if tool_output else []

errors = []
warnings = []
script_errors = []
other_issues = []

for line in lines:
    line_stripped = line.strip()
    if not line_stripped:
        continue

    # Categorize each line
    line_lower = line_stripped.lower()
    if "error" in line_lower or "ERROR" in line_stripped:
        if "script_error" in line_lower or "SCRIPT ERROR" in line_stripped:
            script_errors.append(line_stripped)
        else:
            errors.append(line_stripped)
    elif "warning" in line_lower or "WARNING" in line_stripped:
        warnings.append(line_stripped)
    elif "failed" in line_lower or "FAILED" in line_stripped:
        errors.append(line_stripped)
    elif "missing" in line_lower and ("resource" in line_lower or "class" in line_lower or "node" in line_lower):
        errors.append(line_stripped)

# Determine pass/fail
total_errors = len(errors) + len(script_errors)
status = "PASSED" if total_errors == 0 else "FAILED"

# Build log entry
log_entry = []
log_entry.append(f"{'='*60}")
log_entry.append(f"SMOKE TEST — {timestamp}")
log_entry.append(f"Command: {command}")
log_entry.append(f"Status: {status}")
log_entry.append(f"Errors: {len(errors)} | Script Errors: {len(script_errors)} | Warnings: {len(warnings)}")
log_entry.append(f"{'='*60}")

if script_errors:
    log_entry.append("")
    log_entry.append("SCRIPT ERRORS:")
    for e in script_errors:
        log_entry.append(f"  {e}")

if errors:
    log_entry.append("")
    log_entry.append("ERRORS:")
    for e in errors:
        log_entry.append(f"  {e}")

if warnings:
    log_entry.append("")
    log_entry.append("WARNINGS:")
    for w in warnings:
        log_entry.append(f"  {w}")

if total_errors == 0 and len(warnings) == 0:
    log_entry.append("")
    log_entry.append("Clean run — no errors or warnings detected.")

log_entry.append("")

# Append to log file
with open(log_file, "a") as f:
    f.write("\n".join(log_entry) + "\n")

# Also write a summary JSON for programmatic access
summary_file = os.path.join(log_dir, f"sprint-{sprint_num}-smoke-test-latest.json")
summary = {
    "timestamp": timestamp,
    "sprint": sprint_num,
    "status": status,
    "command": command,
    "error_count": len(errors),
    "script_error_count": len(script_errors),
    "warning_count": len(warnings),
    "errors": errors[:10],  # Cap at 10 to avoid huge files
    "script_errors": script_errors[:10],
    "warnings": warnings[:10],
}
with open(summary_file, "w") as f:
    json.dump(summary, f, indent=2)

PYEOF

exit 0
