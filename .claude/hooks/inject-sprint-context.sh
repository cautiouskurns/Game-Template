#!/bin/bash
# SessionStart hook (command): Inject workflow state so Claude never starts a session blind.
# Reads docs/.workflow-state.json and outputs a structured context summary.

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE_FILE="$PROJECT_DIR/docs/.workflow-state.json"

# If no workflow state exists yet (fresh project), skip gracefully
if [ ! -f "$STATE_FILE" ]; then
  echo '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"No workflow state file found at docs/.workflow-state.json. If this project has been bootstrapped, run /project-orchestrator to initialize the workflow."}}'
  exit 0
fi

# Extract key workflow fields
CONTEXT=$(python3 -c "
import json, sys

with open('$STATE_FILE') as f:
    data = json.load(f)

pos = data.get('workflow_position', {})
sprint = pos.get('current_sprint', '?')
phase = pos.get('step', '?')
status = pos.get('status', '?')
substep = pos.get('substep', '')
lifecycle = data.get('lifecycle_phase', '?')

# Get the current sprint's details
sprints = data.get('sprints', [])
current = None
for s in sprints:
    if s.get('sprint_number') == sprint:
        current = s
        break

sprint_name = current.get('name', 'Unknown') if current else 'Unknown'

# Find current epic
epic_name = 'None'
epic_num = None
if current:
    epic_num = current.get('epic_number')
if epic_num is not None:
    for e in data.get('epics', []):
        if e.get('epic_number') == epic_num:
            epic_name = e.get('name', 'Unknown')
            break

features = []
if current:
    for f in current.get('features', []):
        features.append(f'{f.get("name", "?")} ({f.get("status", "?")})')

phase_status = {}
if current:
    for p_key in ['A', 'B', 'C', 'D']:
        p = current.get('phases', {}).get(p_key, {})
        phase_status[p_key] = p.get('status', 'pending')

summary_lines = [
    f'WORKFLOW STATE — READ THIS BEFORE DOING ANY WORK:',
    f'  Lifecycle: {lifecycle}',
]
if epic_num is not None:
    summary_lines.append(f'  Epic {epic_num}: "{epic_name}"')
summary_lines.extend([
    f'  Sprint {sprint}: "{sprint_name}"',
    f'  Current Phase: {phase} (status: {status})',
])
if substep:
    summary_lines.append(f'  Substep: {substep}')

summary_lines.append(f'  Phase progress: A={phase_status.get(\"A\",\"?\")}, B={phase_status.get(\"B\",\"?\")}, C={phase_status.get(\"C\",\"?\")}, D={phase_status.get(\"D\",\"?\")}')

if features:
    summary_lines.append(f'  Features: {\" | \".join(features)}')

summary_lines.extend([
    '',
    'MANDATORY ACTIONS:',
    '1. Present the user with this sprint status summary before starting work.',
    '2. Follow the workflow defined in docs/agent-team-workflow.md.',
    '3. Do NOT skip phases or approval gates.',
    '4. Read docs/.workflow-state.json for full details if needed.',
    '5. Before executing any workflow step, the required skill must be read per .claude/skills/project-orchestrator/skill-registry.json.',
    '6. Use the structured report formats from .claude/skills/project-orchestrator/report-formats.md for all status updates, deliveries, and transitions.',
])

context = '\\n'.join(summary_lines)
print(context)
" 2>/dev/null)

if [ -z "$CONTEXT" ]; then
  CONTEXT="Workflow state file exists but could not be parsed. Read docs/.workflow-state.json manually before starting work."
fi

# Escape for JSON output (handle newlines and quotes)
ESCAPED=$(python3 -c "
import json, sys
context = sys.stdin.read()
print(json.dumps(context))
" <<< "$CONTEXT")

echo "{\"hookSpecificOutput\":{\"hookEventName\":\"SessionStart\",\"additionalContext\":${ESCAPED}}}"
exit 0
