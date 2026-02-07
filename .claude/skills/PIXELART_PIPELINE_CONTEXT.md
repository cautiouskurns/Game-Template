# PixelLab Skills Enhancement - Context Document

**Project:** CRPG Engine (Godot 4.x)
**Date:** 2025-01-22
**Purpose:** Enhance Claude Code skills for pixel art creation pipeline using PixelLab MCP

---

## Project Overview

This is a CRPG game engine built in Godot 4.x. The goal is to create a pixel art pipeline for generating placeholder art assets using PixelLab MCP integration. The skills should work for any project using this engine, not just the "Blood & Gold" example game.

**Key Directories:**
```
/Users/diarmuidcurran/Godot Projects/crpg-engine/
├── .claude/
│   └── skills/
│       ├── pixellab-create-character/SKILL.md   # Character creation skill
│       └── pixellab-animate-character/SKILL.md  # Animation skill
├── assets/
│   └── sprites/
│       └── characters/                          # Where generated art goes
└── data/                                        # Game data (quests, items, etc.)
```

---

## Current Skills Summary

### 1. pixellab-create-character
**Location:** `.claude/skills/pixellab-create-character/SKILL.md`
**Purpose:** Create pixel art characters via PixelLab MCP with guided prompts
**Workflow:** 5-phase interactive process (Concept → Specs → Style → Review → Generate)

**Key Features:**
- Faction-based color palettes
- Size recommendations by character role
- Description writing guidelines
- Post-generation workflow

### 2. pixellab-animate-character
**Location:** `.claude/skills/pixellab-animate-character/SKILL.md`
**Purpose:** Add animations to existing PixelLab characters
**Workflow:** 6-phase interactive process (Select → Check → Type → Custom → Confirm → Generate)

**Key Features:**
- Animation template tables (movement, combat, utility)
- Animation sets by role (Essential, Combat, Full)
- Weapon-specific attack recommendations
- Batch animation queuing

### 3. pixellab-import-to-godot (NEW)
**Location:** `.claude/skills/pixellab-import-to-godot/SKILL.md`
**Purpose:** Import PixelLab characters into Godot with organization and metadata
**Workflow:** 5-phase interactive process (Select → Details → Download → Manifest → Summary)

**Key Features:**
- Structured folder organization (by role, faction, enemy type)
- Consistent file naming conventions (directions, animations)
- Per-character metadata (`_meta.json`) with art status tracking
- Master manifest (`manifest.json`) for project-wide asset registry
- Placeholder vs final art status tracking
- JSON schemas for validation
- Batch import support

---

## Identified Issues & Feedback

### Critical Issues

#### 1. MCP Tool Dependency - MUST VERIFY
Both skills reference PixelLab MCP tools that may not be configured:
- `mcp__pixellab__create_character`
- `mcp__pixellab__animate_character`
- `mcp__pixellab__list_characters`
- `mcp__pixellab__get_character`

**Action:** Verify PixelLab MCP is configured. Check `.claude/settings.json` or run `claude mcp list`

#### 2. Hardcoded Project Context
Skills are locked to "Blood & Gold" project with hardcoded:
- Faction names and colors
- Size presets
- Art style settings

**Action:** Make configurable via a project art config file

### Missing Features

| Feature | Description | Priority | Status |
|---------|-------------|----------|--------|
| Batch Creation | Generate multiple characters at once | High | Pending |
| Asset Registry | Track what's been generated (manifest.json) | High | **DONE** (pixellab-import-to-godot) |
| Godot Import | Auto-setup AnimatedSprite2D, SpriteFrames | High | Partial (folder org done, SpriteFrames pending) |
| Style Consistency | Compare new art to existing assets | Medium | Pending |
| Retry Workflow | Regenerate with tweaked prompts | Medium | Pending |
| Frame Rate Guide | FPS recommendations by animation type | Medium | **DONE** (in import skill) |
| Sprite Sheet Specs | Format, frame order, slicing guidance | Medium | **DONE** (in import skill) |
| Version Control | Guidance on committing generated assets | Low | Pending |
| Placeholder Tracking | Mark art as placeholder vs final | High | **DONE** (pixellab-import-to-godot) |

### Incomplete Documentation

**pixellab-create-character:**
- Missing exact file naming conventions
- No sprite sheet organization details
- No regeneration/iteration workflow

**pixellab-animate-character:**
- No FPS recommendations per animation type
- Missing sprite sheet format specs (grid? strip? frame order?)
- Incomplete Godot AnimatedSprite2D setup
- No animation preview workflow

---

## Recommended Enhancements

### 1. Create Project Art Config System

Create a config file that skills read from:

```json
// .claude/art-direction.json
{
  "project_name": "My CRPG Project",
  "art_style": {
    "outline": "single color black outline",
    "shading": "basic shading",
    "detail": "medium detail",
    "view": "low top-down",
    "default_directions": 8
  },
  "size_presets": {
    "player": { "canvas": 64, "height_ratio": 0.6 },
    "npc": { "canvas": 32, "height_ratio": 0.6 },
    "enemy_standard": { "canvas": 32, "height_ratio": 0.6 },
    "enemy_elite": { "canvas": 48, "height_ratio": 0.6 },
    "boss": { "canvas": 96, "height_ratio": 0.6 }
  },
  "factions": {
    "faction_1": {
      "name": "Kingdom A",
      "colors": ["#steel_gray", "#military_red"]
    }
  },
  "animation_fps": {
    "idle": 8,
    "walk": 10,
    "run": 12,
    "attack": 15,
    "death": 10
  }
}
```

### 2. Create Asset Manifest System

Track all generated assets:

```json
// assets/sprites/manifest.json
{
  "version": 1,
  "characters": [
    {
      "id": "knight_01",
      "pixellab_id": "uuid-from-pixellab",
      "name": "Ironmark Knight",
      "created": "2025-01-22",
      "size": 48,
      "directions": 8,
      "animations": ["idle", "walk", "attack", "death"],
      "faction": "ironmark",
      "role": "enemy_standard",
      "files": {
        "base": "characters/ironmark/knight_01/",
        "spritesheet": "knight_01_sheet.png"
      }
    }
  ]
}
```

### 3. Create New Skill: pixellab-import-to-godot

Bridges the gap between PixelLab output and Godot-ready assets:

**Responsibilities:**
- Download and organize files from PixelLab
- Create SpriteFrames resource (.tres)
- Generate AnimatedSprite2D scene (.tscn)
- Set up animation state machine
- Update asset manifest
- Configure import settings

### 4. Add Frame Rate Reference

```markdown
## Animation Frame Rates (Recommended)

| Animation Type | FPS | Loop | Notes |
|----------------|-----|------|-------|
| breathing-idle | 6-8 | Yes | Slow, subtle movement |
| walk | 8-10 | Yes | Smooth, not rushed |
| run | 10-12 | Yes | Faster, urgent |
| attack | 12-15 | No | Snappy, impactful |
| death | 8-10 | No | Dramatic fall |
| hit-reaction | 12 | No | Quick feedback |
| cast-spell | 10-12 | No | Magical buildup |
```

### 5. Add Sprite Sheet Specifications

```markdown
## PixelLab Output Format

**Direction Order (8-direction):**
S → SW → W → NW → N → NE → E → SE

**Sprite Sheet Layout:**
- Horizontal strip per animation
- Each direction is a separate row (or file)
- Frame 0 is leftmost

**Godot Import Settings:**
- Import as: Texture2D
- Filter: Nearest (for pixel art)
- Repeat: Disabled
- Use AtlasTexture for individual frames
```

---

## Current Skill Structure

```
.claude/skills/
├── pixellab-create-character/
│   └── SKILL.md                    # Character creation with art direction
├── pixellab-animate-character/
│   └── SKILL.md                    # Animation with templates
├── pixellab-import-to-godot/       # IMPLEMENTED 2025-01-25
│   ├── SKILL.md                    # Full import workflow
│   ├── manifest-template.json      # Empty manifest template
│   ├── manifest-schema.json        # JSON schema for validation
│   ├── character-meta-template.json # Per-character metadata template
│   └── character-meta-schema.json  # JSON schema for metadata
├── pixellab-batch-generator/       # TODO (optional)
│   └── SKILL.md
└── shared/
    ├── art-direction-template.json # Template for projects (TODO)
    └── animation-reference.md      # FPS, timing, etc. (TODO)
```

---

## Implementation Priority

### Phase 1: Foundation
1. ~~Verify PixelLab MCP is configured and working~~ **DONE**
2. Create art-direction.json config system - TODO
3. ~~Create asset manifest system~~ **DONE** (pixellab-import-to-godot)
4. Update pixellab-create-character to read from config - TODO

### Phase 2: Pipeline Completion
5. Update pixellab-animate-character with frame rates and specs - TODO
6. ~~Create pixellab-import-to-godot skill~~ **DONE** (2025-01-25)
7. Add Godot SpriteFrames resource generation - TODO

### Phase 3: Enhancements
8. Add batch generation capability - TODO
9. Add style consistency checking - TODO
10. Add regeneration/iteration workflow - TODO

---

## Questions to Resolve

1. **Is PixelLab MCP configured?** Check `.claude/settings.json` for MCP server config
2. **What's the exact PixelLab output format?** Need to test actual API responses
3. **Preferred sprite sheet format?** Horizontal strip vs grid vs individual files
4. **Animation state machine approach?** AnimationTree vs AnimationPlayer states

---

## Testing Checklist

After enhancements:
- [ ] Can create character with default settings
- [ ] Can create character with custom faction colors
- [ ] Can add single animation
- [ ] Can add animation set (batch)
- [ ] Assets download to correct location
- [ ] Manifest updates automatically
- [ ] Godot import works (SpriteFrames created)
- [ ] AnimatedSprite2D scene works in editor
- [ ] Style is consistent across multiple characters

---

## Reference: Current Skill Locations

Read the existing skills for full context:
- `/.claude/skills/pixellab-create-character/SKILL.md`
- `/.claude/skills/pixellab-animate-character/SKILL.md`

Related skills for reference:
- `/.claude/skills/vfx-generator/SKILL.md` (procedural VFX, no external service)
