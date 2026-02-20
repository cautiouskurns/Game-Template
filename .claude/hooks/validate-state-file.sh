#!/bin/bash
# PostToolUse hook (command): Validate workflow state file integrity after every write.
# Checks structure, required fields, valid enum values, and phase transition legality.

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE_FILE="$PROJECT_DIR/docs/.workflow-state.json"

# Read hook input from stdin
INPUT=$(cat)

# Extract the file path from tool_input
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
tool_input = data.get('tool_input', {})
print(tool_input.get('file_path', ''))
" 2>/dev/null)

# Only validate when the workflow state file was modified
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

REL_PATH="${FILE_PATH#$PROJECT_DIR/}"
if [ "$REL_PATH" != "docs/.workflow-state.json" ]; then
  exit 0
fi

# State file must exist
if [ ! -f "$STATE_FILE" ]; then
  exit 0
fi

python3 << 'PYEOF'
import json, os, sys

project_dir = os.environ.get("CLAUDE_PROJECT_DIR", os.getcwd())
state_file = os.path.join(project_dir, "docs", ".workflow-state.json")

errors = []

# --- Parse JSON ---
try:
    state = json.load(open(state_file))
except json.JSONDecodeError as e:
    print(f"STATE FILE INVALID: Malformed JSON — {e}", file=sys.stderr)
    sys.exit(2)

# --- Required top-level fields ---
required_fields = ["lifecycle_phase", "workflow_position", "updated_at"]
for field in required_fields:
    if field not in state:
        errors.append(f"Missing required field: '{field}'")

# --- Validate lifecycle_phase enum ---
valid_lifecycle = {"not_started", "prototype", "vertical_slice", "production", "killed"}
lifecycle = state.get("lifecycle_phase", "")
if lifecycle and lifecycle not in valid_lifecycle:
    errors.append(f"Invalid lifecycle_phase: '{lifecycle}'. Must be one of: {', '.join(sorted(valid_lifecycle))}")

# --- Validate workflow_position ---
pos = state.get("workflow_position", {})
if not isinstance(pos, dict):
    errors.append("workflow_position must be an object")
else:
    # Validate phase
    valid_phases = {"pre_phase_0", "phase_0", "sprint"}
    phase = pos.get("phase", "")
    if phase and phase not in valid_phases:
        errors.append(f"Invalid workflow_position.phase: '{phase}'. Must be one of: {', '.join(sorted(valid_phases))}")

    # Validate status
    valid_statuses = {"pending", "in_progress", "completed", "awaiting_user_approval", "user_requested_changes", "skipped"}
    status = pos.get("status", "")
    if status and status not in valid_statuses:
        errors.append(f"Invalid workflow_position.status: '{status}'. Must be one of: {', '.join(sorted(valid_statuses))}")

# --- Validate lifecycle/phase coherence ---
if lifecycle == "not_started" and pos.get("phase") == "sprint":
    errors.append("Incoherent state: lifecycle_phase is 'not_started' but workflow_position.phase is 'sprint'. Cannot be in sprint mode before starting.")

if lifecycle == "not_started" and pos.get("phase") == "phase_0" and pos.get("status") not in ("pending", "in_progress", None):
    # phase_0 can start while lifecycle is not_started (it transitions after)
    pass

# --- Validate sprint phase progression ---
valid_sprint_steps = {"A", "B", "B5", "C", "D"}
if pos.get("phase") == "sprint":
    step = pos.get("step", "")
    if step and step not in valid_sprint_steps:
        # Step might also be a phase_0 step name during transitions, allow those
        valid_phase0_steps = {
            "game_ideator", "concept_validator", "design_bible_updater",
            "art_reference_collector", "audio_reference_collector",
            "narrative_reference_collector", "gdd_generator", "roadmap_planner",
            "feature_pipeline", "vertical_slice_gdd", "vertical_slice_roadmap",
            "vertical_slice_features"
        }
        if step not in valid_phase0_steps:
            errors.append(f"Invalid sprint step: '{step}'. Expected one of: {', '.join(sorted(valid_sprint_steps))}")

    # Validate sprint exists in sprints array
    current_sprint = pos.get("current_sprint")
    if current_sprint is not None:
        sprints = state.get("sprints", [])
        sprint_nums = [s.get("sprint_number") for s in sprints]
        if current_sprint not in sprint_nums:
            errors.append(f"current_sprint={current_sprint} not found in sprints array (has: {sprint_nums})")

# --- Validate epics array structure ---
epics = state.get("epics", [])
if not isinstance(epics, list):
    errors.append("'epics' must be an array")
else:
    valid_epic_statuses = {"pending", "in_progress", "completed", "iterated"}
    epic_numbers = set()
    for i, epic in enumerate(epics):
        if not isinstance(epic, dict):
            errors.append(f"epics[{i}] must be an object")
            continue
        if "epic_number" not in epic:
            errors.append(f"epics[{i}] missing 'epic_number'")
        else:
            en = epic["epic_number"]
            if en in epic_numbers:
                errors.append(f"Duplicate epic_number: {en}")
            epic_numbers.add(en)
        if "name" not in epic:
            errors.append(f"epics[{i}] missing 'name'")
        es = epic.get("status", "")
        if es and es not in valid_epic_statuses:
            errors.append(f"epics[{i}].status='{es}' is invalid. Must be one of: {', '.join(sorted(valid_epic_statuses))}")
        sprint_nums = epic.get("sprint_numbers", [])
        if not isinstance(sprint_nums, list):
            errors.append(f"epics[{i}].sprint_numbers must be an array")

# --- Validate sprints array structure ---
sprints = state.get("sprints", [])
if not isinstance(sprints, list):
    errors.append("'sprints' must be an array")
else:
    for i, sprint in enumerate(sprints):
        if not isinstance(sprint, dict):
            errors.append(f"sprints[{i}] must be an object")
            continue
        if "sprint_number" not in sprint:
            errors.append(f"sprints[{i}] missing 'sprint_number'")

        # Validate epic_number reference if present
        epic_num = sprint.get("epic_number")
        if epic_num is not None and isinstance(epics, list):
            if epic_num not in epic_numbers:
                errors.append(f"sprints[{i}].epic_number={epic_num} references non-existent epic")

        # Validate phase statuses within sprint
        phases = sprint.get("phases", {})
        valid_phase_status = {"pending", "in_progress", "completed"}
        for phase_key in ["A", "B", "B5", "C", "D"]:
            phase_data = phases.get(phase_key, {})
            if isinstance(phase_data, dict):
                ps = phase_data.get("status", "")
                if ps and ps not in valid_phase_status:
                    errors.append(f"sprints[{i}].phases.{phase_key}.status='{ps}' is invalid")

# --- Report results ---
if errors:
    print(f"STATE FILE VALIDATION FAILED ({len(errors)} errors):", file=sys.stderr)
    for err in errors:
        print(f"  - {err}", file=sys.stderr)
    sys.exit(2)

sys.exit(0)

PYEOF

exit $?
