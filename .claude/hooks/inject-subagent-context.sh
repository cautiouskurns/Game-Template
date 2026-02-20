#!/bin/bash
# SubagentStart hook (command): Inject workflow rules into every spawned teammate.
# Ensures subagents know the current sprint, their directory ownership, and key rules.

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE_FILE="$PROJECT_DIR/docs/.workflow-state.json"

# Extract sprint info if available
SPRINT_INFO="No workflow state available."
if [ -f "$STATE_FILE" ]; then
  SPRINT_INFO=$(python3 -c "
import json
with open('$STATE_FILE') as f:
    data = json.load(f)
pos = data.get('workflow_position', {})
sprint = pos.get('current_sprint', '?')
phase = pos.get('step', '?')
lifecycle = data.get('lifecycle_phase', '?')

sprints = data.get('sprints', [])
sprint_name = 'Unknown'
for s in sprints:
    if s.get('sprint_number') == sprint:
        sprint_name = s.get('name', 'Unknown')
        break

print(f'Sprint {sprint} (\"{sprint_name}\"), Phase {phase}, Lifecycle: {lifecycle}')
" 2>/dev/null || echo "Could not parse workflow state.")
fi

CONTEXT="SUBAGENT WORKFLOW RULES — YOU MUST FOLLOW THESE:

CURRENT STATE: ${SPRINT_INFO}

DIRECTORY OWNERSHIP (only write to your owned directories):
  systems-dev: scripts/autoloads/, scripts/systems/, scripts/resources/, resources/
  gameplay-dev: scenes/gameplay/, scripts/entities/, scripts/components/
  ui-dev: scenes/ui/, scripts/ui/, resources/themes/
  content-architect: data/, resources/*.tres (data instances)
  asset-artist: assets/

RULES:
1. Only write files in your owned directories. Do NOT edit files outside your scope.
2. Use static typing everywhere. Prefer signals over direct calls.
3. Use snake_case for files, PascalCase for classes, prefix private members with _.
4. Do NOT add class_name that matches an autoload name.
5. Feature specs in docs/features/ define what to implement. Read them before coding.
6. Run smoke test (godot --headless --quit) after making changes if possible.
7. When done, use the Feature Delivery Card format from .claude/skills/project-orchestrator/report-formats.md to report what you built.
8. SKILL PROTOCOL: Before implementing any feature, read the skill file for your phase from .claude/skills/project-orchestrator/skill-registry.json. The enforce-skill-read hook will block writes if you skip this.
9. OUTPUT FORMAT: Use structured report formats from .claude/skills/project-orchestrator/report-formats.md for all status updates and deliveries."

# Escape for JSON
ESCAPED=$(python3 -c "
import json, sys
context = sys.stdin.read()
print(json.dumps(context))
" <<< "$CONTEXT")

echo "{\"hookSpecificOutput\":{\"hookEventName\":\"SubagentStart\",\"additionalContext\":${ESCAPED}}}"
exit 0
