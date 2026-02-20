#!/bin/bash
# PostToolUse hook (async): Keep CLAUDE.md Project Context table in sync with actual docs.
# When a key doc file is created in docs/, updates the CLAUDE.md table to confirm it exists.
# Also syncs lifecycle phase and current sprint from the workflow state file.

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
CLAUDE_MD="$PROJECT_DIR/CLAUDE.md"
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

# Skip if no file path or CLAUDE.md doesn't exist
if [ -z "$FILE_PATH" ] || [ ! -f "$CLAUDE_MD" ]; then
  exit 0
fi

# Make path relative to project dir
REL_PATH="${FILE_PATH#$PROJECT_DIR/}"

# Only act on docs/ files and the workflow state file
if [[ "$REL_PATH" != docs/* ]] && [[ "$REL_PATH" != "CHANGELOG.md" ]]; then
  exit 0
fi

python3 << 'PYEOF'
import json, os, re, sys

project_dir = os.environ.get("CLAUDE_PROJECT_DIR", os.getcwd())
claude_md = os.path.join(project_dir, "CLAUDE.md")
state_file = os.path.join(project_dir, "docs", ".workflow-state.json")

if not os.path.exists(claude_md):
    sys.exit(0)

content = open(claude_md).read()
changed = False

# --- Part 1: Update "(when it exists)" markers for docs that now exist ---
doc_files = {
    "docs/design-bible.md": "Design pillars, creative vision, tone",
    "docs/systems-bible.md": "Technical documentation of how systems work",
    "docs/architecture.md": "Project structure, scene trees, signal maps",
    "CHANGELOG.md": "What has changed and when",
    "docs/art-direction.md": "Visual style guide with palette and style anchors",
    "docs/audio-direction.md": "Audio style guide with search anchors",
    "docs/narrative-direction.md": "Narrative voice and lore delivery patterns",
}

for doc_path, description in doc_files.items():
    full_path = os.path.join(project_dir, doc_path)
    old_entry = f"| `{doc_path}` | {description} (when it exists) |"
    new_entry = f"| `{doc_path}` | {description} |"
    if os.path.exists(full_path) and old_entry in content:
        content = content.replace(old_entry, new_entry)
        changed = True

# --- Part 2: Sync lifecycle phase and sprint info into CLAUDE.md ---
if os.path.exists(state_file):
    try:
        state = json.load(open(state_file))
        lifecycle = state.get("lifecycle_phase", "not_started")
        pos = state.get("workflow_position", {})
        sprint = pos.get("current_sprint", None)
        phase = pos.get("step", None)

        # Update or insert a Current Status line after the Overview section header
        status_line = f"**Current Status:** Lifecycle: `{lifecycle}`"
        if sprint is not None:
            status_line += f" | Sprint: `{sprint}`"
        if phase is not None:
            status_line += f" | Phase: `{phase}`"

        # Check if status line already exists
        status_pattern = r"\*\*Current Status:\*\*.*"
        if re.search(status_pattern, content):
            new_content = re.sub(status_pattern, status_line, content)
            if new_content != content:
                content = new_content
                changed = True
        else:
            # Insert after the first "## Overview" line
            overview_marker = "## Overview\n"
            if overview_marker in content:
                insert_pos = content.index(overview_marker) + len(overview_marker)
                # Find the next non-empty line to insert before
                rest = content[insert_pos:]
                content = content[:insert_pos] + "\n" + status_line + "\n" + rest
                changed = True
    except (json.JSONDecodeError, KeyError):
        pass

# --- Part 3: Detect GDD files and add them to the table if missing ---
gdd_pattern = re.compile(r"docs/.*-gdd\.md$")
for f in os.listdir(os.path.join(project_dir, "docs")):
    if f.endswith("-gdd.md"):
        gdd_path = f"docs/{f}"
        # Check if this specific GDD is already in the table
        if gdd_path not in content and "`docs/*-gdd.md`" in content:
            # The wildcard entry covers it, no action needed
            pass

if changed:
    open(claude_md, "w").write(content)

PYEOF

exit 0
