---
description: Bootstrap a new game project from the agent team template. Creates directory structure, customizes project name, initializes git, and verifies all agent/skill/workflow files are in place. Run this after cloning the template repo.
trigger: user
---

# Project Bootstrap Skill

You are bootstrapping a new game project from the agent team template repository.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | Any (typically run by user directly) |
| **Sprint Phase** | Pre-sprint — one-time project setup |
| **Directory Scope** | Entire project root |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

## How to Invoke This Skill

Users can trigger this skill by saying:
- "Bootstrap this project"
- "Set up this game project"
- "Initialize the project"
- "Run project bootstrap"
- `/project-bootstrap`

## Prerequisites

This skill assumes the user has **cloned the template repository** and is now customizing it for a new game. The template should already contain:
- `.claude/skills/` (all skills)
- `.claude/agents/` (all 7 agent definitions)
- `docs/agent-team-workflow.md` (workflow document)
- `CLAUDE.md` (project context)
- `project.godot` (Godot project config)
- `.gitignore`, `.gitattributes`, `.editorconfig`

## Process

### Step 1: Gather Project Information

Ask the user these questions (do NOT skip any):

1. **"What is your game's project name?"** (used for directory naming and project.godot)
2. **"What resolution should we target?"** (default: 1920x1080)
3. **"Is this a 2D or 3D project?"** (affects renderer and physics settings)

### Step 2: Verify Template Files

Check that all required template files exist. Report any missing files:

**Required files:**
- `CLAUDE.md`
- `docs/agent-team-workflow.md`
- `.claude/agents/design-lead.md`
- `.claude/agents/systems-dev.md`
- `.claude/agents/gameplay-dev.md`
- `.claude/agents/ui-dev.md`
- `.claude/agents/content-architect.md`
- `.claude/agents/asset-artist.md`
- `.claude/agents/qa-docs.md`
- `project.godot`
- `.gitignore`

If any files are missing, warn the user: "Template files are incomplete. The following are missing: [list]. The project may not work correctly with the agent team workflow."

### Step 3: Update project.godot

Update the project name and settings in `project.godot`:
- Set `config/name` to the user's chosen project name
- Set viewport width/height to the chosen resolution
- If 3D: ensure `rendering/renderer/rendering_method="forward_plus"` and Jolt physics
- If 2D: set `rendering/renderer/rendering_method="gl_compatibility"` for broader support

### Step 4: Update CLAUDE.md

Update the project header in `CLAUDE.md`:
- Replace "Agent Team Test" with the actual project name
- Keep all other content unchanged

### Step 5: Create Directory Structure

Create all directories from the directory ownership map:

```bash
mkdir -p \
  scripts/autoloads scripts/systems scripts/resources scripts/entities scripts/components scripts/ui \
  scenes/gameplay scenes/levels scenes/ui \
  data/characters data/quests data/dialogue data/encounters data/campaigns data/world data/items \
  assets/sprites assets/tilesets assets/animations assets/ui assets/backgrounds assets/models assets/vfx \
  resources/themes \
  music sfx voice \
  addons \
  docs/features docs/ideas docs/tools docs/code-reviews docs/data-analysis
```

### Step 6: Initialize Git

```bash
git init
git add -A
git commit -m "feat: initialize [project-name] from agent team template

Bootstrapped from the Godot agent team template with:
- 7 agent role definitions
- 46 development skills
- Agent team workflow with sprint structure
- Directory structure per ownership map

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

### Step 7: Remove Template Git History

Before initializing git, ensure any cloned `.git` directory is removed so the project starts with a clean history:

```bash
rm -rf .git
git init
```

**IMPORTANT:** Always confirm with the user before removing `.git` — they may have intentionally kept the template history.

### Step 8: Provide Summary

Output a clear summary:

```
Project "[name]" bootstrapped successfully!

✓ Project name set in project.godot and CLAUDE.md
✓ Resolution: [width]x[height] ([2D/3D])
✓ Directory structure created (per agent ownership map)
✓ Git repository initialized with initial commit
✓ All 7 agent definitions verified
✓ All skills verified
✓ Workflow document in place

Directory Ownership:
  scripts/autoloads/    → systems-dev
  scripts/systems/      → systems-dev
  scripts/entities/     → gameplay-dev
  scripts/components/   → gameplay-dev
  scripts/ui/           → ui-dev
  scenes/gameplay/      → gameplay-dev
  scenes/ui/            → ui-dev
  data/                 → content-architect
  assets/, music/, sfx/ → asset-artist
  docs/features/        → design-lead
  docs/code-reviews/    → qa-docs

Next steps:
  1. Open the project in Godot Editor to verify settings
  2. Begin Phase 0: run /game-concept-generator with design-lead
  3. Follow the workflow in docs/agent-team-workflow.md
```

## Error Handling

- If `project.godot` doesn't exist, warn the user and offer to create a minimal one
- If git is already initialized, ask if user wants to keep existing history or start fresh
- If directories already exist, skip them silently (mkdir -p handles this)
- If any agent definition is missing, offer to recreate it

## Important Guidelines

- Always ask before removing `.git` — never delete git history without confirmation
- Use the exact directory names from `docs/agent-team-workflow.md` — don't deviate
- Verify files after creation to ensure nothing was missed
- Keep CLAUDE.md and workflow doc content unchanged except for the project name
