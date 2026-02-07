---
name: pixellab-import-to-godot
description: Import PixelLab characters into Godot with proper folder structure, naming conventions, and metadata tracking. Downloads assets, organizes files, creates manifests, and optionally generates SpriteFrames resources. Use this when the user wants to import generated pixel art into their Godot project.
domain: art
type: importer
version: 1.0.0
allowed-tools:
  - mcp__pixellab__list_characters
  - mcp__pixellab__get_character
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - AskUserQuestion
---

# PixelLab Import to Godot Skill

This skill imports PixelLab-generated characters into a Godot project with proper folder organization, consistent naming, and metadata tracking for asset management.

---

## When to Use This Skill

Invoke this skill when the user:
- Says "import character to Godot" or "download PixelLab assets"
- Asks to "bring in the sprites" or "add characters to the project"
- Wants to "set up the character files" or "organize sprite assets"
- Says "import from PixelLab" or "get the generated art"
- Needs to track placeholder vs final art assets

---

## Folder Structure Convention

```
res://assets/
└── sprites/
    └── characters/
        ├── manifest.json              # Master asset registry
        ├── player/                    # Player characters
        │   └── mercenary_captain/
        │       ├── _meta.json         # Character metadata
        │       ├── base/              # Static directional sprites
        │       │   ├── south.png
        │       │   ├── south_west.png
        │       │   └── ...
        │       └── animations/        # Animated sprites
        │           ├── idle/
        │           ├── walk/
        │           └── attack/
        ├── companions/                # Party members
        ├── npcs/                      # Non-combat NPCs
        │   ├── merchants/
        │   ├── quest_givers/
        │   └── townsfolk/
        ├── enemies/                   # Hostile units
        │   ├── bandits/
        │   ├── undead/
        │   ├── beasts/
        │   └── bosses/
        └── factions/                  # Faction-specific units
            ├── ironmark/
            ├── silvermere/
            ├── thornwood/
            └── sunspire/
```

---

## Naming Conventions

### Character Folder Names
```
[role]_[descriptor]_[variant]
Examples:
- mercenary_captain
- bandit_thug_01
- skeleton_archer
- ironmark_knight_elite
```

### File Names
```
Direction sprites:  [direction].png
                    south.png, south_west.png, west.png, etc.

Animation frames:   [animation]_[frame].png
                    idle_00.png, idle_01.png, walk_00.png, etc.

Sprite sheets:      [character]_[animation]_sheet.png
                    bandit_thug_walk_sheet.png
```

### Direction Naming Map
| PixelLab Direction | File Name |
|-------------------|-----------|
| S (South) | south.png |
| SW (South-West) | south_west.png |
| W (West) | west.png |
| NW (North-West) | north_west.png |
| N (North) | north.png |
| NE (North-East) | north_east.png |
| E (East) | east.png |
| SE (South-East) | south_east.png |

---

## Metadata System

### Character Metadata (_meta.json)

Each imported character gets a `_meta.json` file:

```json
{
  "schema_version": "1.0",
  "character": {
    "id": "bandit_thug_01",
    "display_name": "Bandit Thug",
    "pixellab_id": "96cadda5-5bd7-453c-b2d2-dbbceeeb1ff0",
    "pixellab_name": "Bandit Thug"
  },
  "source": {
    "generator": "pixellab",
    "created_date": "2025-01-25",
    "imported_date": "2025-01-25"
  },
  "art_status": {
    "type": "placeholder",
    "quality": "ai_generated",
    "ready_for_production": false,
    "notes": "Replace with hand-drawn art for release"
  },
  "technical": {
    "canvas_size": 64,
    "character_height": 38,
    "directions": 8,
    "view": "low top-down",
    "outline": "single color black outline",
    "shading": "basic shading"
  },
  "animations": [
    {
      "name": "idle",
      "template": "breathing-idle",
      "frame_count": 8,
      "fps_recommended": 8,
      "loop": true
    },
    {
      "name": "walk",
      "template": "walking-8-frames",
      "frame_count": 8,
      "fps_recommended": 10,
      "loop": true
    }
  ],
  "tags": ["enemy", "bandit", "melee", "humanoid"],
  "faction": "bandits",
  "role": "enemy_standard"
}
```

### Art Status Types

| Type | Description | Use Case |
|------|-------------|----------|
| `placeholder` | Temporary AI art | Development/prototyping |
| `placeholder_approved` | AI art approved for alpha/beta | Early access builds |
| `wip` | Work-in-progress hand-drawn | Artist is working on it |
| `final` | Production-ready art | Release builds |
| `legacy` | Old art being replaced | Transition period |

### Quality Levels

| Quality | Description |
|---------|-------------|
| `ai_generated` | PixelLab or similar AI tool |
| `ai_touched_up` | AI base with manual edits |
| `hand_drawn_rough` | Artist sketch/rough |
| `hand_drawn_polished` | Final artist work |

---

## Master Manifest (manifest.json)

Located at `res://assets/sprites/characters/manifest.json`:

```json
{
  "schema_version": "1.0",
  "last_updated": "2025-01-25T14:30:00Z",
  "statistics": {
    "total_characters": 47,
    "placeholder_count": 45,
    "final_count": 2,
    "by_role": {
      "player": 1,
      "companion": 4,
      "npc": 12,
      "enemy_standard": 20,
      "enemy_elite": 8,
      "boss": 2
    }
  },
  "characters": [
    {
      "id": "mercenary_captain",
      "path": "player/mercenary_captain",
      "pixellab_id": "bc04fe18-9a2b-4b94-8842-8f1143b536f2",
      "display_name": "Mercenary Captain",
      "role": "player",
      "art_status": "placeholder",
      "directions": 8,
      "animations": ["idle", "walk", "attack", "death"],
      "tags": ["player", "fighter", "sword"]
    }
  ]
}
```

---

## Interactive Workflow

### Phase 1: Select Characters to Import

**Start by listing available characters:**

```
I'll help you import PixelLab characters into your Godot project!

Let me show your available characters...

[Call mcp__pixellab__list_characters]

**Available for Import:**
[List characters with status indicators]
- Ready: Has base sprites generated
- Animated: Has animations too
- Already Imported: Exists in project (show path)

Which characters would you like to import?
- Select by name or number
- Type "all" to import everything
- Type "new" to import only characters not yet in the project
```

**Wait for user response.**

---

### Phase 2: Gather Import Details

**For each character (or batch), ask:**

```
**Importing: [Character Name]**

Let me gather some details for proper organization:

**1. Character Role**
How should this character be categorized?
- [ ] Player Character
- [ ] Companion (party member)
- [ ] NPC - Merchant
- [ ] NPC - Quest Giver
- [ ] NPC - Townsfolk
- [ ] Enemy - Standard
- [ ] Enemy - Elite
- [ ] Enemy - Boss
- [ ] Faction Unit (specify faction)

**2. Character ID**
Suggested ID based on PixelLab name: `[auto_generated_id]`
Accept or provide custom ID:

**3. Art Status**
What's the status of this art?
- [ ] Placeholder (temporary, will be replaced)
- [ ] Placeholder Approved (good enough for alpha/beta)
- [ ] Final (production ready)

**4. Tags** (for filtering/searching)
Suggested tags: [auto-suggest based on description]
Add or modify:
```

**For batch imports, offer defaults:**

```
**Batch Import Settings**

Apply these defaults to all [X] characters?
- Role: [detected or ask]
- Art Status: Placeholder
- Tags: Auto-detect from names

[Yes, use defaults] / [No, ask for each]
```

---

### Phase 3: Download and Organize

**Execute the import:**

```
**Starting Import**

Character 1/5: Bandit Thug
├── Fetching from PixelLab...
├── Creating folder: assets/sprites/characters/enemies/bandits/bandit_thug_01/
├── Downloading base sprites (8 directions)...
│   ├── south.png ✓
│   ├── south_west.png ✓
│   └── ... (6 more)
├── Downloading animations...
│   ├── idle/ (8 frames) ✓
│   ├── walk/ (8 frames) ✓
│   └── attack/ (6 frames) ✓
├── Creating _meta.json ✓
└── Done!

Character 2/5: Skeleton Archer
...
```

---

### Phase 4: Update Manifest

**After all imports:**

```
**Updating Master Manifest**

Adding 5 new characters to manifest.json...
├── bandit_thug_01 ✓
├── skeleton_archer ✓
├── skeleton_warrior ✓
├── bandit_captain ✓
└── wolf ✓

**Manifest Updated:**
- Total characters: 47 → 52
- Placeholders: 45 → 50
- New this session: 5

Manifest saved to: res://assets/sprites/characters/manifest.json
```

---

### Phase 5: Summary and Next Steps

**Provide import summary:**

```
**Import Complete!**

**Imported Characters:**
| Character | Location | Directions | Animations |
|-----------|----------|------------|------------|
| Bandit Thug | enemies/bandits/bandit_thug_01 | 8 | 3 |
| Skeleton Archer | enemies/undead/skeleton_archer | 8 | 4 |
| ... | ... | ... | ... |

**Files Created:**
- 5 character folders
- 40 base direction sprites
- 120 animation frames
- 5 metadata files
- 1 manifest update

**Next Steps:**
1. **Create SpriteFrames:** Run `/pixellab-create-spriteframes` to generate Godot resources
2. **Review in Godot:** Open the assets folder in the FileSystem dock
3. **Add animations:** Use `/pixellab-animate-character` if you need more animations
4. **Track art status:** Update _meta.json when replacing placeholder art

**Quick Commands:**
- "Create SpriteFrames for bandit_thug_01"
- "Show all placeholder characters"
- "Mark skeleton_archer as final"
```

---

## Import Commands

### Import Single Character

```
User: "Import the Ironmark Knight"

1. Find character by name match in PixelLab
2. Ask for role/categorization
3. Download to appropriate folder
4. Create metadata
5. Update manifest
```

### Import All New Characters

```
User: "Import all new characters"

1. List all PixelLab characters
2. Compare against manifest
3. Import only those not in manifest
4. Use auto-detected settings
5. Batch update manifest
```

### Import by Tag/Filter

```
User: "Import all enemies"

1. List PixelLab characters
2. Filter by name patterns (bandit, skeleton, etc.)
3. Confirm selection
4. Batch import with enemy role default
```

### Re-import (Update)

```
User: "Re-import the knight with new animations"

1. Find existing character in manifest
2. Fetch latest from PixelLab
3. Download only new/changed files
4. Update metadata
5. Preserve art_status if manually set
```

---

## File Download Process

### Using curl for Downloads

```bash
# Download base sprite
curl -o "assets/sprites/characters/[path]/base/south.png" "[pixellab_url]"

# Download animation frame
curl -o "assets/sprites/characters/[path]/animations/walk/walk_00.png" "[pixellab_url]"

# Download sprite sheet
curl -o "assets/sprites/characters/[path]/[name]_sheet.png" "[pixellab_url]"
```

### Download from PixelLab Response

The `get_character` response includes:
- `rotations`: Array of direction images with URLs
- `animations`: Array of animation data with frame URLs
- `zip_url`: Complete character ZIP download

**Preferred approach:**
1. Download ZIP for complete character
2. Extract to temp location
3. Reorganize into project structure
4. Rename files to conventions

**Alternative approach:**
1. Download individual files from URLs
2. Save directly to final locations
3. Better for selective imports

---

## Godot Import Settings

### Recommended .import Configuration

For pixel art sprites, ensure these settings:

```
[remap]
importer="texture"
type="CompressedTexture2D"

[deps]
source_file="res://assets/sprites/characters/..."

[params]
compress/mode=0
compress/high_quality=false
compress/lossy_quality=0.7
compress/hdr_compression=1
compress/normal_map=0
compress/channel_pack=0
mipmaps/generate=false
mipmaps/limit=-1
roughness/mode=0
roughness/src_normal=""
process/fix_alpha_border=true
process/premult_alpha=false
process/normal_map_invert_y=false
process/hdr_as_srgb=false
process/hdr_clamp_exposure=false
process/size_limit=0
detect_3d/compress_to=1
```

**Key settings for pixel art:**
- `compress/mode=0` (Lossless)
- `mipmaps/generate=false`
- Filter: Nearest (set in Project Settings or per-texture)

---

## Utility Functions

### Check Import Status

```
User: "What characters haven't been imported?"

1. Load manifest.json
2. List all PixelLab characters
3. Compare and show differences
4. Offer to import missing
```

### Find Placeholders

```
User: "Show all placeholder art"

1. Read manifest.json
2. Filter by art_status == "placeholder"
3. Display list with paths
4. Offer bulk status update
```

### Update Art Status

```
User: "Mark knight as final art"

1. Find character in manifest
2. Update manifest entry
3. Update _meta.json
4. Confirm change
```

### Generate Report

```
User: "Give me an art status report"

**Art Asset Report**
Generated: 2025-01-25

| Status | Count | Percentage |
|--------|-------|------------|
| Placeholder | 45 | 86.5% |
| Placeholder Approved | 3 | 5.8% |
| WIP | 2 | 3.8% |
| Final | 2 | 3.8% |

**By Role:**
| Role | Total | Placeholder | Final |
|------|-------|-------------|-------|
| Player | 1 | 1 | 0 |
| Enemies | 30 | 28 | 2 |
| NPCs | 15 | 14 | 1 |

**Needs Attention:**
- Player character still placeholder
- 3 enemies missing walk animations
```

---

## Error Handling

### Character Not Found

```
Could not find "[name]" in PixelLab.

**Did you mean:**
- [Similar name 1]
- [Similar name 2]

Or check your PixelLab characters with: mcp__pixellab__list_characters
```

### Download Failed

```
Failed to download [file] from PixelLab.

**Possible causes:**
- Network connectivity issue
- PixelLab service temporarily unavailable
- Character generation still in progress

**Actions:**
1. Check if character is fully generated
2. Retry download
3. Try downloading ZIP instead
```

### Folder Already Exists

```
Character folder already exists: assets/sprites/characters/enemies/bandits/bandit_thug_01/

**Options:**
1. **Overwrite** - Replace all files
2. **Merge** - Add new files, keep existing
3. **Rename** - Create bandit_thug_02 instead
4. **Skip** - Don't import this character

Select option:
```

### Manifest Conflict

```
Character ID "knight_01" already exists in manifest.

**Existing entry:**
- Path: factions/ironmark/knight_01
- PixelLab ID: abc-123

**New character:**
- PixelLab ID: xyz-789

**Options:**
1. **Update** - Replace existing with new
2. **Rename** - Use knight_02 for new
3. **Skip** - Keep existing, don't import
```

---

## Quick Reference

### Role to Folder Mapping

| Role | Base Path |
|------|-----------|
| Player | `player/` |
| Companion | `companions/` |
| NPC - Merchant | `npcs/merchants/` |
| NPC - Quest Giver | `npcs/quest_givers/` |
| NPC - Townsfolk | `npcs/townsfolk/` |
| Enemy - Standard | `enemies/[type]/` |
| Enemy - Elite | `enemies/[type]/` |
| Enemy - Boss | `enemies/bosses/` |
| Faction Unit | `factions/[faction]/` |

### Auto-Detected Enemy Types

| Name Pattern | Subfolder |
|--------------|-----------|
| bandit, thug, outlaw | `enemies/bandits/` |
| skeleton, zombie, ghost, wraith | `enemies/undead/` |
| wolf, bear, spider | `enemies/beasts/` |
| cultist, necromancer | `enemies/cult/` |
| knight, soldier, guard | `enemies/military/` |

### Animation FPS Recommendations

| Animation | FPS | Loop |
|-----------|-----|------|
| breathing-idle | 6-8 | Yes |
| walk | 8-10 | Yes |
| run | 10-12 | Yes |
| attack | 12-15 | No |
| death | 8-10 | No |
| hit-reaction | 12 | No |

---

## Example Invocations

User: "Import the bandit characters to Godot"
User: "Download all my PixelLab sprites"
User: "Set up the character files in the project"
User: "Import new characters since last time"
User: "Re-import the knight with updated animations"
User: "Show me what needs to be imported"
User: "Mark all ironmark units as placeholder approved"
