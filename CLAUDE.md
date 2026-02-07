# Agent Team Test — Project Context

## Overview

This is a Godot 4.6 game project developed using an AI agent team workflow. All agents must read and follow the workflow defined in `docs/agent-team-workflow.md`.

## Workflow

This project uses a structured agent team with 7 roles: design-lead, systems-dev, gameplay-dev, ui-dev, content-architect, asset-artist, and qa-docs. See `docs/agent-team-workflow.md` for full details including:
- Agent roles and responsibilities
- Directory ownership (agents only write to their owned directories)
- Sprint structure (Phase A → B → C → D with user review)
- Development lifecycle (Prototype → Vertical Slice → Production with go/no-go gates)
- Quality gates and mandatory checkpoints
- Feature pipeline (idea → spec → implement → review)

## Critical Rules

1. **Directory ownership is enforced.** Each agent only writes to its owned directories. See the Directory Ownership Map in the workflow doc. Writing outside your owned directories is not allowed.
2. **User approval is required** at every control point. Never proceed past a gate without explicit user approval.
3. **Feature specs come before code.** No implementation without an approved feature spec in `docs/features/`.
4. **Use `feature-implementer` for all implementation.** All three dev agents (systems-dev, gameplay-dev, ui-dev) use the `feature-implementer` skill to implement features from specs.
5. **Quality reviews are mandatory.** qa-docs runs `gdscript-quality-checker` on all new code. Critical issues block the next sprint.

## Project Context Files

Before starting work, read the relevant project context:

| File | Contains |
|------|----------|
| `docs/agent-team-workflow.md` | Full workflow, roles, sprint structure, quality gates |
| `docs/design-bible.md` | Design pillars, creative vision, tone (when it exists) |
| `docs/*-gdd.md` | Game Design Document (when it exists) |
| `docs/features/*.md` | Feature specifications |
| `docs/systems-bible.md` | Technical documentation of how systems work (when it exists) |
| `docs/architecture.md` | Project structure, scene trees, signal maps (when it exists) |
| `CHANGELOG.md` | What has changed and when (when it exists) |

## GDScript Conventions

- **File naming:** `snake_case.gd`, `snake_case.tscn`, `snake_case.tres`
- **Class naming:** `PascalCase` with `class_name` declarations
- **Signals:** Past tense (`health_changed`, `enemy_died`, not `change_health`)
- **Constants:** `UPPER_SNAKE_CASE`
- **Private members:** Prefix with `_` (`_velocity`, `_is_ready`)
- **Type hints:** Use static typing everywhere (`var speed: float = 100.0`)
- **Exports:** Use `@export` with type hints (`@export var max_health: int = 100`)
- **Onready:** Use `@onready` for node references (`@onready var sprite: Sprite2D = $Sprite2D`)
- **No magic numbers:** Extract constants or use exported variables
- **Signals over direct calls:** Prefer signal connections for decoupling

## Asset Generation

- **Visual assets:** Generated via Ludo MCP (sprites, animations, backgrounds, UI, models, voice)
- **Music & SFX:** Sourced via Epidemic Sound MCP (search, download, edit)
- **Style consistency:** All visual assets use `generateWithStyle` with an established reference image

## Git Conventions

- **Commits:** Conventional Commits format (`feat:`, `fix:`, `refactor:`, `docs:`, `asset:`, `content:`)
- **Branches:** `main` (stable), `sprint/N-description` (sprint work)
- **Never force push to main**
