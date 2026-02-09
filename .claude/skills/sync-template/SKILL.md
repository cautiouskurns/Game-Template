---
description: Sync workflow and skill improvements from the current project back to the Game-Template repo. Compares template files, shows diffs, and pushes approved changes. Use this when you've improved a skill, agent, or workflow file and want to update the upstream template.
trigger: user
---

# Sync Template Skill

Push workflow, skill, and agent improvements from the current game project back to the upstream Game-Template repository.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | Any (typically run by user directly) |
| **Sprint Phase** | Any — maintenance task |
| **Directory Scope** | `.claude/`, `docs/agent-team-workflow.md`, `CLAUDE.md` |
| **Template Clone** | `~/repos/Game-Template` |

## How to Invoke This Skill

Users can trigger this skill by saying:
- "Sync template"
- "Push improvements to the template"
- "Update the game template"
- `/sync-template`

## Prerequisites

- A clean clone of `Game-Template` must exist at `~/repos/Game-Template`
- If it doesn't exist, clone it: `git clone https://github.com/cautiouskurns/Game-Template.git ~/repos/Game-Template`

## Template Files (What Gets Synced)

Only these categories of files are considered for syncing. Game-specific code, scenes, assets, and data are **never synced**.

| Category | Path Pattern |
|----------|-------------|
| **Agents** | `.claude/agents/*.md` |
| **Skills** | `.claude/skills/*/SKILL.md`, `.claude/skills/*/skill.md`, and supporting `.md` files |
| **Workflow** | `docs/agent-team-workflow.md` |
| **Project Context Template** | `CLAUDE.md` (only structural changes, not project-specific names) |
| **Settings** | `.claude/settings.json` (not `.local.json`) |

## Procedure

### Step 1: Pull Latest Template

```bash
git -C ~/repos/Game-Template pull origin main
```

If this fails, the clone may not exist. Offer to create it.

### Step 2: Compare Files

For each template file category, run diffs between the current project and `~/repos/Game-Template`. Report results in this format:

```
Template Sync Report
====================

CHANGED (current project is newer):
  - .claude/skills/game-ideator/SKILL.md (324 insertions, 430 deletions)
  - docs/agent-team-workflow.md (12 insertions, 3 deletions)

IDENTICAL (no sync needed):
  - .claude/agents/design-lead.md
  - .claude/skills/feature-implementer/SKILL.md
  - ... (N more)

NEW IN CURRENT PROJECT (not in template):
  - .claude/skills/sync-template/SKILL.md
```

**Important**: For CLAUDE.md, ignore project-specific differences (project name, Godot version reference, game-specific descriptions). Only flag structural changes to the template.

### Step 3: User Review

Present the diff summary to the user and ask which changes to sync. Use AskUserQuestion:

- "Sync all changes"
- "Let me pick which ones"
- "Show me the diffs first"
- "Cancel"

If they want to see diffs, show the actual diff output for each changed file.

### Step 4: Apply Changes

For each approved change:
1. Copy the file from the current project to `~/repos/Game-Template`
2. For CLAUDE.md specifically: copy the template version (generic names like `{project-name}`) rather than the project-specific version

### Step 5: Commit and Push

Stage all copied files, create a commit with a descriptive message, and push:

```bash
git -C ~/repos/Game-Template add -A
git -C ~/repos/Game-Template commit -m "feat: sync template with [description of changes]"
git -C ~/repos/Game-Template push origin main
```

Always ask user confirmation before pushing.

### Step 6: Confirm

Report the commit hash and list of files that were updated. Remind the user that other projects cloned from the template won't automatically get these changes — they'd need to pull or manually copy.

## Edge Cases

### New Skills Created in Current Project
If a skill exists in the current project but not in the template, ask the user if it should be added. Some skills may be game-specific and shouldn't go in the template.

### Template Has Changes Not in Current Project
If `~/repos/Game-Template` has been updated independently (e.g., from another project), show those differences too and warn the user before overwriting.

### CLAUDE.md Handling
CLAUDE.md always has project-specific content (project name, game description). When syncing:
- Only sync structural changes (new sections, updated instructions)
- Keep the template's generic placeholders (`{project-name}`, generic descriptions)
- Never copy game-specific content to the template

## Quick Reference

```bash
# One-time setup (if ~/repos/Game-Template doesn't exist):
git clone https://github.com/cautiouskurns/Game-Template.git ~/repos/Game-Template

# Sync from any game project:
# Just say "/sync-template" in Claude Code
```
