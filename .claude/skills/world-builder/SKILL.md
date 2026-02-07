# World Builder Skill

This skill creates **worldmap data files** (`.worldmap.json`) for the CRPG Engine. It defines locations, routes, regions, and travel events that form the game world.

**Schema Reference:** `crpg_engine/schemas/worldmap_schema.json`

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | content-architect |
| **Sprint Phase** | Phase B (Implementation) |
| **Directory Scope** | `data/world/` |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

> **Genre Note:** RPG-biased examples but the location/connection data structure concept applies to any game with a world map.

---

## Skill Hierarchy Position

```
                    ┌─────────────────────────────┐
                    │      GAME IDEATOR           │
                    │   (Creative Foundation)      │
                    │   docs/design/*.md          │
                    └─────────────────────────────┘
                                 │
                    ┌─────────────────────────────┐
                    │   NARRATIVE ARCHITECT       │
                    │   (Story & Character Detail)│
                    │   docs/narrative/*.md       │
                    └─────────────────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ WORLD           │    │ CHARACTER       │    │ QUEST           │
│ BUILDER         │◄── │ CREATOR         │    │ DESIGNER        │
│ .worldmap.json  │    │ .char files     │    │ quest .json     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
    THIS SKILL          ┌───────┴───────┐               │
                        ▼               ▼               │
               ┌─────────────┐ ┌─────────────┐          │
               │ DIALOGUE    │ │ ENCOUNTER   │          │
               │ DESIGNER    │ │ DESIGNER    │          │
               │ .dtree      │ │ enc .json   │          │
               └─────────────┘ └─────────────┘          │
                        │               │               │
                        └───────────────┴───────────────┘
                                        │
                           ┌─────────────────────────────┐
                           │     CAMPAIGN CREATOR        │
                           │   (Ties everything together)│
                           │   data/campaigns/*.json     │
                           └─────────────────────────────┘
```

**This skill creates:** `data/world/*.worldmap.json` files with locations, routes, regions, terrain, and interior grid layouts.

---

## CRITICAL: What This Skill Does and Does NOT Do

```
+------------------------------------------+------------------------------------------+
|              THIS SKILL DOES             |          THIS SKILL DOES NOT DO         |
+------------------------------------------+------------------------------------------+
| Create worldmap files (.worldmap.json)   | Create campaign files                   |
| Define locations with types and data     | Create character files                  |
| Define routes between locations          | Create encounter files                  |
| Define regions and faction control       | Create dialogue trees                   |
| Configure travel events                  | Modify the Godot project                |
| Reference existing NPCs and encounters   | Assign NPC IDs to placements            |
| Output to data/world/                    | (NPC assignment done separately)        |
| Generate interior layouts from images    |                                         |
| Create interior grid definitions         |                                         |
| ADD locations to existing digitized maps |                                         |
| Preserve terrain data when adding locs   |                                         |
| Extract location names from ref images   |                                         |
+------------------------------------------+------------------------------------------+
```

---

## When to Use This Skill

Invoke this skill when the user:
- Wants to create a new game world/map
- Says "create a worldmap" or "build the world"
- Asks to "define locations and routes"
- Wants to "design the travel system"
- Needs to create regions with faction control
- Says "use world-builder"
- Has interior layout images to convert to grid definitions
- Wants to "add interior layouts from images"
- Has a **digitized terrain map** and wants to add locations from a reference image
- Says "add locations to my digitized map"
- Wants to "extract locations from reference image" without changing terrain
- Has used the **Map Digitizer** and now needs location names added

---

## Prerequisites

Before running this skill:

1. **Narrative documents should exist** (recommended):
   - `docs/design/world-bible.md` - For setting and faction info
   - `docs/narrative/story-arcs.md` - For location significance

2. **Related content may be needed**:
   - NPC character files (if locations reference NPCs)
   - Encounter files (if locations have encounters)

---

## Schema Reference

### Location Definition

The authoritative schema is at `crpg_engine/schemas/worldmap_schema.json`.

```json
{
  "id": "loc_example",
  "name": "Example Location",
  "type": "settlement",
  "region": "region_example",
  "description": "A brief description of this location",
  "position": {"x": 100, "y": 200},
  "map_scene": "",
  "custom_data": {
    "safe_zone": true,
    "services": ["shop", "inn", "blacksmith"],
    "npcs": [
      {"name": "NPC Name", "id": "npc_example", "conditional": false}
    ],
    "hostile": false,
    "encounter": ""
  },
  "interior": {
    "mode": 1,
    "template": "",
    "seed": 0,
    "definition": {}
  }
}
```

### Location Types (from schema)

| Type | Description | Typical Use |
|------|-------------|-------------|
| `settlement` | Towns, villages, cities | Safe zones with services and NPCs |
| `kingdom` | Major political centers | Capital cities, faction headquarters |
| `dungeon` | Dangerous areas to explore | Combat encounters, loot |
| `camp` | Temporary or semi-permanent camps | Rest points, bandit camps |
| `player_base` | Player-owned or controlled location | Home base, headquarters |
| `landmark` | Points of interest | Story locations, quest objectives |
| `ruins` | Abandoned or destroyed places | Exploration, secrets |

### Route Definition

```json
{
  "id": "route_example",
  "from": "loc_a",
  "to": "loc_b",
  "type": "road",
  "direction": "two_way",
  "visibility": "always",
  "travel_time": 1.0,
  "distance": 30,
  "encounter_chance": 0.1,
  "description": "A well-maintained road",
  "travel_events": []
}
```

### Route Types (from schema)

| Type | Description | Danger Implication |
|------|-------------|-------------------|
| `road` | Standard road | Low danger, normal travel |
| `highway` | Major thoroughfare | Very low danger, fast travel |
| `wilderness` | Untamed paths | Medium danger, slower |
| `river` | Water route | Requires boat/crossing |
| `mountain_pass` | Mountain crossing | High danger, slow |
| `sea_route` | Ocean travel | Requires ship, variable danger |

### Route Visibility (from schema)

| Visibility | Description |
|------------|-------------|
| `always` | Route always visible on map |
| `hidden` | Route must be discovered first |
| `blocked` | Route blocked until condition met |

### Region Definition

```json
{
  "id": "region_example",
  "name": "Example Region",
  "description": "A description of this region",
  "color": "#FF5500",
  "faction": "faction_id"
}
```

### Travel Event Definition

```json
{
  "timing": "midpoint",
  "type": "encounter",
  "reference": "enc_bandits",
  "chance": 0.3,
  "condition": {
    "flags_required": [],
    "time_of_day": ""
  }
}
```

### Travel Event Timing (from schema)

| Timing | When Event Triggers |
|--------|---------------------|
| `departure` | When beginning travel |
| `day_1` | First day of travel |
| `midpoint` | Midway through journey |
| `arrival` | Upon arrival |
| `random` | Random point during travel |

### Travel Event Types (from schema)

| Type | Reference Points To |
|------|---------------------|
| `dialogue` | Dialogue ID (conversation) |
| `encounter` | Encounter ID (combat) |
| `discovery` | Location ID (reveal new location) |
| `set_flag` | Flag name (set game flag) |
| `give_item` | Item ID (find item) |
| `cutscene` | Cutscene ID (play cutscene) |

### Interior Mode

| Mode | Value | Description |
|------|-------|-------------|
| None | `0` | No interior (world map point only) |
| Designed | `1` | Hand-crafted grid layout |
| Generated | `2` | Procedurally generated from template |

### Services (custom_data.services)

Common service types:
- `shop` - General goods merchant
- `inn` - Rest and recovery
- `blacksmith` - Weapons and armor
- `temple` - Healing, blessings
- `guild` - Job board, contracts
- `stable` - Mount purchase/care
- `bank` - Gold storage
- `tavern` - Rumors, recruitment

### Geography/Terrain Definition

The `geography` object defines the visual terrain layer of the map:

```json
{
  "geography": {
    "cell_size": 20,
    "coastline_style": "natural",
    "landmass": {
      "cells": ["5,0", "6,0", "7,0", ...],
      "bounds": {"x": 2, "y": 0, "width": 48, "height": 60}
    },
    "biomes": {
      "5,0": "mountains",
      "6,0": "mountains",
      "10,15": "dense_forest",
      "20,30": "plains",
      ...
    }
  }
}
```

### Biome Types

| Biome | Color (Hex) | Typical Use |
|-------|-------------|-------------|
| `plains` | #4a7c4e | Default land, grasslands, fields |
| `forest` | #2d5a30 | Light woods, forest edges |
| `dense_forest` | #1e4020 | Thick woods, ancient forests |
| `hills` | #8b7355 | Rolling hills, highlands |
| `mountains` | #6b6b6b | Mountain ranges, peaks |
| `desert` | #c4a35a | Arid lands, sand dunes |
| `swamp` | #4a5a3a | Marshes, bogs, wetlands |
| `tundra` | #d4e5f7 | Frozen wastes, arctic |
| `wasteland` | #5a4a3a | Barren, corrupted land |
| `farmland` | #6a9a5a | Cultivated areas |

### Terrain Cell Format

- **cell_size:** Pixels per cell (default 20)
- **landmass.cells:** Array of "x,y" strings for all LAND cells
- **biomes:** Dictionary mapping "x,y" to biome type
- **bounds:** Bounding rectangle with x, y, width, height

**Grid coordinates:** Cell (0,0) is top-left of map. Coordinates increase right (x) and down (y).

---

## Interactive Workflow

### Phase 0: Input Mode Selection

**ALWAYS start by asking how the user wants to provide world information:**

```markdown
## World Builder Session

How would you like to define your world?

**Input Mode:**
- [ ] **D&D/Tabletop Module** - I have a D&D adventure map or module to translate
- [ ] **Image-based** - I have a map image/sketch to recreate
- [ ] **Digitized Map + Reference** - I have a digitized terrain map and want to add locations from a reference image
- [ ] **Structured data** - I have a prepared list of locations (table, text, or file)
- [ ] **Reference document** - Extract locations from an existing design document
- [ ] **Interactive Q&A** - Guide me through the process step by step

Select your preferred input mode to continue.
```

**Wait for user response before proceeding to the appropriate phase.**

---

### Phase 0-DND: D&D/Tabletop Module Input

**If user selects D&D/Tabletop Module input:**

```markdown
## D&D Module World Building

I'll help you translate your D&D adventure into a CRPG worldmap.

**1. Adventure Information**
- What D&D adventure/module is this? (e.g., "Dragons of Icespire Peak", "Lost Mine of Phandelver")
- Do you have a map image? (Can be from the book, a screenshot, or custom map)

**2. Map Source**
How will you provide the map?
- [ ] **Map image** - I have an image file of the adventure map
- [ ] **Text description** - I'll describe the locations and connections
- [ ] **Both** - I have a map image AND additional notes

**3. Scope**
What portion of the adventure are you building?
- [ ] **Full adventure** - All locations from the module
- [ ] **Starting area** - Just the initial region/chapter
- [ ] **Specific locations** - Only certain key locations

**Your input:**
```

**Wait for user response.**

#### D&D Map Image Processing

If user provides a D&D adventure map image:

1. **Read and analyze** the map image
2. **Identify D&D-specific elements:**
   - Towns and villages (settlements)
   - Dungeons and lairs (dungeon type)
   - Quest locations (landmarks)
   - Camps and outposts (camp type)
   - Ruins and ancient sites (ruins type)
   - Travel routes (roads, trails, wilderness paths)

3. **Present analysis with D&D terminology:**

```markdown
## D&D Map Analysis: [Adventure Name]

I've analyzed your adventure map. Here's what I identified:

### Locations from Module

| # | D&D Name | CRPG Type | Position | Quest Relevance | Notes |
|---|----------|-----------|----------|-----------------|-------|
| 1 | Phandalin | settlement | center | Starting town | Safe zone, multiple NPCs |
| 2 | Cragmaw Hideout | dungeon | northeast | Quest: Goblin Arrows | Hostile, goblins |
| 3 | Tresendar Manor | dungeon | center-east | Quest: Redbrand Hideout | Under town, secret |
| ... | ... | ... | ... | ... | ... |

### D&D to CRPG Type Mapping

| D&D Term | CRPG Type | Notes |
|----------|-----------|-------|
| Town/Village | settlement | Safe zones with services |
| Dungeon/Lair | dungeon | Hostile with encounters |
| Ruin/Ancient Site | ruins | Exploration, secrets |
| Camp/Outpost | camp | Can be friendly or hostile |
| Landmark/Monument | landmark | Quest objectives, story |
| Castle/Fortress | kingdom | Major power centers |

### Travel Routes

| From | To | D&D Description | CRPG Route Type | Danger |
|------|----|-----------------|-----------------|--------|
| Phandalin | Cragmaw Hideout | Triboar Trail | road | low |
| Phandalin | Wave Echo Cave | Wilderness | wilderness | high |
| ... | ... | ... | ... | ... |

### Services by Location (D&D Mapping)

| D&D Service | CRPG Service | Typical Locations |
|-------------|--------------|-------------------|
| General Store | shop | Towns, villages |
| Inn/Tavern | inn, tavern | Towns, villages |
| Smith | blacksmith | Towns |
| Temple/Shrine | temple | Towns, holy sites |
| Quest Board | guild | Towns, camps |

---

**Please review:**
1. Are all key locations from the adventure included?
2. Are the location types correct?
3. Are the travel routes accurate?
4. Any hidden/unlockable locations to mark as "hidden" or "blocked"?

**Provide corrections or type "confirmed" to proceed.**
```

**Wait for user confirmation.**

#### D&D Interior Considerations

For D&D dungeon/location interiors:

```markdown
## Interior Layouts for D&D Locations

Several locations in [Adventure Name] have detailed maps in the module.
Do you have interior map images for any of these?

**Locations that typically have interior maps in D&D:**

| Location | Type | Has Interior Map? | Grid Size Estimate |
|----------|------|-------------------|-------------------|
| [Dungeon 1] | dungeon | [ ] Yes [ ] No | ~30x25 |
| [Town 1] | settlement | [ ] Yes [ ] No | ~20x15 |
| ... | ... | ... | ... |

**Options:**
- [ ] **Provide interior images** - I have dungeon/building maps to convert
- [ ] **Skip interiors** - Generate interiors later or manually in editor
- [ ] **Use templates** - Generate procedural interiors from templates

**Your choice:**
```

**Process interior images using the existing Phase 0A-4 workflow.**

---

### Phase 0-DIGITIZED: Digitized Map + Reference Image Input

**If user selects "Digitized Map + Reference" input:**

This mode is for when you have ALREADY digitized terrain using the World Map Builder's Map Digitizer tool and want to add locations from a reference image WITHOUT modifying the terrain data.

```markdown
## Digitized Map + Reference Image Mode

I'll help you add locations to your digitized terrain map by analyzing your reference image.

**IMPORTANT:** This mode will:
- ✅ ADD locations to your worldmap
- ✅ ADD routes between locations
- ✅ ADD regions if identifiable
- ❌ NOT modify your digitized terrain (landmass, biomes, paths)
- ❌ NOT change any existing geography data

**Step 1: Provide Your Worldmap File**

What is the path to your existing worldmap JSON file with digitized terrain?
- Example: `data/world/blood_and_gold_world.worldmap.json`
- The file should have `geography` data from the Map Digitizer

**Worldmap file path:**
```

**Wait for user to provide worldmap file path.**

**After receiving worldmap path, read and verify it has terrain data:**

```markdown
## Worldmap Loaded: [filename]

I've loaded your worldmap file. Here's the current state:

### Terrain Data (PRESERVED - Will NOT be modified)
- **Landmass cells:** [X] cells
- **Biome cells:** [Y] cells
- **Terrain bounds:** [bounds info]
- **Paths traced:** [Z] paths (roads, rivers, etc.)

### Existing Content
- **Locations:** [N] locations currently defined
- **Routes:** [M] routes currently defined
- **Regions:** [R] regions currently defined

---

**Step 2: Provide Reference Image**

Now provide the path to your reference image (the original map you digitized from).
I'll analyze it to identify location names, types, and positions.

**Reference image path:**
```

**Wait for user to provide reference image path.**

#### Reference Image Analysis

**After receiving the reference image, use the Read tool to view it, then:**

```markdown
## Reference Image Analysis

I've analyzed your reference image. Here are the locations I identified:

### Locations Detected

| # | Name (from text/label) | Type (inferred) | Approx. Position | Confidence | Notes |
|---|------------------------|-----------------|------------------|------------|-------|
| 1 | [Text found on map] | [settlement/dungeon/etc.] | [relative position] | High/Medium/Low | [Any notes] |
| 2 | ... | ... | ... | ... | ... |

### Text/Labels Found
- [List all readable text on the map]
- [Include partial or unclear text with "?" suffix]

### Geographic Features with Names
- Mountains: [Named ranges]
- Rivers: [Named waterways]
- Forests: [Named woodlands]
- Regions: [Named areas/territories]

### Position Mapping

I'll map the identified locations to your digitized terrain:

| Location | Reference Position | Mapped Terrain Position (x, y) | Terrain at Position |
|----------|-------------------|-------------------------------|---------------------|
| [Name] | [e.g., "northwest coast"] | [100, 150] | [plains/forest/etc.] |
| ... | ... | ... | ... |

---

**Please review and correct:**

1. Are the location names correct? (Fix any misread text)
2. Are the location types correct?
3. Are there locations I missed? (Add them)
4. Are the position mappings accurate?
5. Should any locations NOT be included?

**Provide corrections or type "confirmed" to proceed.**
```

**Wait for user confirmation/corrections.**

#### Generating Locations for Digitized Map

**After user confirms, generate location data WITHOUT modifying terrain:**

```markdown
## Location Generation Plan

I'll add the following to your worldmap:

### Locations to Add ([N] total)

| ID | Name | Type | Position | Services | Safe Zone |
|----|------|------|----------|----------|-----------|
| loc_[name] | [Name] | [type] | ([x], [y]) | [services] | [yes/no] |
| ... | ... | ... | ... | ... | ... |

### Routes to Add ([M] total)

Based on visible paths/roads on the reference image and proximity:

| ID | From | To | Type | Notes |
|----|------|----|------|-------|
| route_[a]_[b] | loc_[a] | loc_[b] | [road/path/etc.] | [visible connection] |
| ... | ... | ... | ... | ... |

### Regions to Add (if applicable)

| ID | Name | Color | Locations Included |
|----|------|-------|-------------------|
| region_[name] | [Name] | #[hex] | [list] |

---

**Data Preservation Notice:**

The following will NOT be changed:
- ✅ `geography.landmass` - [X] cells preserved
- ✅ `geography.biomes` - [Y] biome assignments preserved
- ✅ `geography.paths` - [Z] traced paths preserved
- ✅ `geography.cell_size` - [size]px preserved
- ✅ `geography.coastline_style` - "[style]" preserved

**Proceed with adding locations? (yes/no)**
```

**Wait for user confirmation.**

#### Updating the Worldmap File

**After confirmation, update ONLY the locations, routes, and regions arrays:**

```gdscript
# PSEUDO-CODE for what gets updated:

# These arrays get ADDED TO (not replaced):
worldmap.locations.append_array(new_locations)
worldmap.routes.append_array(new_routes)
worldmap.regions.append_array(new_regions)

# These are NEVER touched:
# worldmap.geography  ← PRESERVED EXACTLY
# worldmap.map_data   ← PRESERVED EXACTLY
```

**Generate the updated worldmap and save:**

```markdown
## Worldmap Updated: [filename]

I've added locations to your digitized worldmap.

### Summary

| Category | Before | After | Added |
|----------|--------|-------|-------|
| Locations | [X] | [X+N] | +[N] |
| Routes | [Y] | [Y+M] | +[M] |
| Regions | [Z] | [Z+R] | +[R] |

### Terrain Data (Unchanged)
- ✅ Landmass: [cells] cells (unchanged)
- ✅ Biomes: [cells] cells (unchanged)
- ✅ Paths: [count] paths (unchanged)

### Files Updated
- `data/world/[worldmap_id].worldmap.json`

### Next Steps
1. Open World Map Builder to verify location positions
2. Fine-tune positions by dragging in the Graph view
3. Add interior layouts to locations if needed
4. Create NPCs and encounters for hostile locations
5. Use the Campaign Creator to tie everything together

### Testing
1. Load the worldmap in the game
2. Verify locations appear at correct positions
3. Check that routes connect properly
4. Confirm terrain displays correctly with locations overlaid
```

---

#### Handling Edge Cases

**If reference image is very different from digitized terrain:**

```markdown
## Alignment Warning

The reference image and digitized terrain appear to have significant differences:

**Potential Issues:**
- [ ] Scale mismatch (reference may be larger/smaller)
- [ ] Rotation difference
- [ ] Coastline doesn't align with locations
- [ ] Some locations fall outside digitized land area

**Options:**
1. **Adjust locations** - Move locations to nearest valid terrain
2. **Manual placement** - Let me list locations and you specify coordinates
3. **Skip misaligned** - Only add locations that clearly align
4. **Expand terrain** - (Requires re-digitizing - not recommended)

**Your choice:**
```

**If no text is readable on reference image:**

```markdown
## No Text Detected

I couldn't identify readable location names on the reference image.

**Options:**
1. **Describe locations** - Tell me the location names and I'll identify them visually
2. **Provide a legend** - Share a separate list of location names
3. **Interactive placement** - I'll identify visual markers (dots, icons) and you name them
4. **Use existing data** - If you have location data elsewhere, provide it

**Your choice:**
```

---

### Phase 0A: Image-Based Input

**If user selects image-based input:**

```markdown
## Image-Based World Building

Please provide the path to your map image.

**Supported formats:** PNG, JPG, GIF, WebP
**Example:** `assets/maps/my_world_sketch.png` or `~/Desktop/map_draft.png`

**What I'll analyze:**
- Location markers, icons, or labels
- Geographic features (mountains, rivers, forests, roads)
- Relative positions and spatial relationships
- Any text or annotations visible
- Route connections between locations
- **Terrain regions** (ocean, forests, mountains, plains, swamps, hills)

**Image path:**
```

**Wait for user to provide image path.**

**After receiving the image path, use the Read tool to view the image, then:**

```markdown
## Map Analysis

I've analyzed your map image. Here's what I identified:

### Locations Detected

| # | Name/Label | Type (inferred) | Position (relative) | Notes |
|---|------------|-----------------|---------------------|-------|
| 1 | [Label or description] | [settlement/dungeon/etc.] | [center/north/etc.] | [Any observations] |
| 2 | ... | ... | ... | ... |

### Geographic Features
- **Terrain:** [Mountains, forests, water bodies observed]
- **Roads/Paths:** [Visible connections between locations]
- **Regions:** [Any distinct areas or boundaries]

### Terrain Regions Detected

| Region Name | Biome Type | Approximate Area | Notes |
|-------------|------------|------------------|-------|
| [e.g., "Western Ocean"] | water | Left 10-15% of map | Ocean/sea coastline |
| [e.g., "Great Forest"] | dense_forest | Center-north | Major forest area |
| [e.g., "Northern Mountains"] | mountains | Top-right corner | Mountain range |
| [e.g., "Central Plains"] | plains | Remaining land | Default grassland |

**Biome Types:** `plains`, `forest`, `dense_forest`, `hills`, `mountains`, `swamp`, `desert`, `tundra`, `wasteland`, `farmland`

### Connections Detected

| From | To | Route Type (inferred) | Notes |
|------|----|-----------------------|-------|
| Location 1 | Location 2 | [road/path/river] | [Visual connection observed] |

### Map Dimensions
- **Suggested map size:** [width] x [height] based on layout
- **Cell size:** 20px (terrain grid)
- **Coordinate mapping:** [How I'll translate positions to x,y]

---

**Please review and correct my interpretation:**

1. Are the location names correct? (Edit any labels I misread)
2. Are the location types correct? (settlement, dungeon, camp, etc.)
3. Are there any locations I missed?
4. Are the connections accurate?
5. **Are the terrain regions accurate?** (forests, mountains, water, etc.)
6. Any additional details to add (NPCs, encounters, services)?

**Provide corrections or type "confirmed" to proceed with generation.**
```

**Wait for user confirmation/corrections on locations and routes.**

---

### Phase 0A-2: ASCII Map Preview (REQUIRED)

**After initial confirmation of locations, generate an ASCII map preview for terrain verification:**

```markdown
## ASCII Map Preview

Here's a visual representation of the geography and locations. Review this carefully before I generate the final worldmap.

**Map Legend:**
```
~ = Ocean/Water      . = Plains          # = Forest
F = Dense Forest     ^ = Mountains       h = Hills
% = Swamp            * = Desert          : = Tundra
@ = Location marker  - = Road/Route
```

**ASCII Map (50 columns x 30 rows = 1000x600 at 20px cells):**
```
     0    1    2    3    4    5    6    7    8    9
     0----5----0----5----0----5----0----5----0----5
 0 | ~~~~....^^^^^^^^^^^^^^^^^^^^^^..........^^^^^ |
 1 | ~~~.....^^^[The Crags]^^^^^^^^..........^^^^^ |
 2 | ~~......######################..........hhhhh |
 3 | ~@1.....###[Neverwinter Wood]#..........@2... |
 4 | ~~......######################...@3.....##### |
 5 | ~~.@4...######..........######..........##### |
 6 | ~~......######..@5......######...@6.....##### |
 7 | ~~~.....######..........######..........##### |
 8 | ~~~.......................@7............##### |
 9 | ~~~~....@8..............@9......@10.....##### |
10 | ~~~~%%%...................@11....^^^^^^^##### |
11 | ~~~~~%%%[Mere]...@12.....@13....^^^^^^^^#### |
12 | ~~~~~~%%%%.........@14...........^^^^^^^FFFF |
     0----5----0----5----0----5----0----5----0----5
```

**Location Key:**
```
@1  = Neverwinter (kingdom)       @8  = Dragon Barrow (ruins)
@2  = Butterskull Ranch           @9  = Phandalin (settlement)
@3  = Loggers' Camp               @10 = Mountain's Toe Gold Mine
@4  = Tower of Storms             @11 = Icespire Peak (landmark)
@5  = Falcon's Hunting Lodge      @12 = Leilon (settlement)
@6  = Circle of Thunder           @13 = Axeholm (dungeon)
@7  = Triboar Trail Region        @14 = Gnomengarde (dungeon)
```

**Terrain Regions Summary:**
| Symbol | Biome | Approximate Grid Area (x1-x2, y1-y2) |
|--------|-------|--------------------------------------|
| ~ | water | x: 0-3, y: all (western ocean) |
| ^ | mountains | x: 40-50, y: 0-12 (The Crags, Sword Mtns) |
| # | dense_forest | x: 15-35, y: 2-8 (Neverwinter Wood) |
| F | dense_forest | x: 42-50, y: 10-12 (Kryptgarden) |
| % | swamp | x: 4-10, y: 10-12 (Mere of Dead Men) |
| h | hills | x: 42-48, y: 2-4 (Starmetal Hills) |
| . | plains | everywhere else |

---

**Review the ASCII map and tell me:**

1. **Is the coastline shape correct?** (Should water be further east/west?)
2. **Are terrain regions in the right places?** (e.g., "Move Neverwinter Wood further north")
3. **Are locations positioned correctly relative to terrain?**
4. **Any regions missing or misplaced?**

**You can:**
- Describe adjustments: "Move the mountains to the right edge"
- Provide grid coordinates: "Forest should be x:10-30, y:5-15"
- Copy/edit the ASCII and paste it back with changes
- Type "confirmed" to proceed with generation

**Your feedback:**
```

**Wait for user to confirm or request adjustments. Iterate on the ASCII map until approved.**

#### ASCII Map Generation Guidelines

When creating the ASCII map:

1. **Use HIGH RESOLUTION for accurate terrain:**
   - **Minimum:** 80 columns x 60 rows
   - **Recommended:** 100 columns x 75 rows for detailed maps
   - **Maximum practical:** 120 columns x 90 rows
   - Each character should represent 1-2 terrain cells maximum
   - For a 1000x1200px map at 20px cells (50x60 grid), use at least 50x60 ASCII

2. **Use consistent symbols:**
   ```
   ~ = water/ocean     . = plains         # = forest
   F = dense_forest    ^ = mountains      h = hills
   % = swamp/marsh     * = desert         : = tundra
   @ = location (numbered)    - = road/route (horizontal)
   | = road (vertical)        + = road intersection
   ```

3. **Include reference grid:**
   - Number columns (0, 5, 10, 15...) at top
   - Number rows (0, 5, 10...) at left
   - This helps users specify exact regions

4. **Show location markers:**
   - Use `@N` where N is location number
   - Provide a legend mapping numbers to names
   - Place markers at correct relative positions

5. **Indicate terrain boundaries clearly:**
   - Group similar terrain together
   - Label major regions inline: `###[Forest Name]###`

#### Handling User Feedback

When user requests adjustments:

- **"Move X east/west/north/south"** → Adjust the terrain region coordinates
- **"Make coastline more curved"** → Redesign the water boundary
- **"Forest should extend to X"** → Expand/contract region bounds
- **"Location X should be in the forest"** → Move location marker
- **Pasted ASCII edit** → Parse the changes and update region definitions

Regenerate the ASCII map after each adjustment until user confirms.

---

### Phase 0A-3: Final Generation

**After ASCII map is confirmed, generate terrain data:**

1. **Calculate grid dimensions:**
   - Grid width = map_width / cell_size (default 20px)
   - Grid height = map_height / cell_size

2. **Generate landmass cells based on confirmed ASCII:**
   - Create coastline matching the confirmed shape
   - All cells that are land (not ocean) get added to `landmass.cells`

3. **Generate biome assignments from confirmed regions:**
   - Use the grid coordinates confirmed in the ASCII preview
   - Apply biome gradients at edges (dense_forest -> forest -> plains)
   - Default remaining land to `plains`

4. **Format terrain data:**
```json
{
  "geography": {
    "cell_size": 20,
    "coastline_style": "natural",
    "landmass": {
      "cells": ["x,y", "x,y", ...],
      "bounds": {"x": min_x, "y": min_y, "width": w, "height": h}
    },
    "biomes": {
      "x,y": "biome_type",
      ...
    }
  }
}
```

**IMPORTANT:** Always generate terrain data when processing map images. The World Map Builder displays terrain as the visual foundation of the map.

---

### Phase 0A-4: Interior Layout Images (Optional)

**After world map generation is complete, offer interior image analysis:**

```markdown
## Interior Layout Images (Optional)

Your worldmap has been generated with **[X] locations**. Would you like to provide interior layout images for any of these locations?

**Locations that can have interiors:**

| # | Location ID | Name | Type | Current Interior |
|---|-------------|------|------|------------------|
| 1 | loc_neverwinter | Neverwinter | kingdom | mode: 0 (none) |
| 2 | loc_phandalin | Phandalin | settlement | mode: 0 (none) |
| 3 | loc_axeholm | Axeholm | dungeon | mode: 0 (none) |
| ... | ... | ... | ... | ... |

**Options:**
- [ ] **Yes** - I have interior layout images to provide
- [ ] **No** - Skip interior layouts for now (can be done later in World Map Builder editor)
- [ ] **Some** - I only have images for specific locations

**Your choice:**
```

**Wait for user response.**

---

#### If User Wants Interior Images

**Ask for location selection and image path:**

```markdown
## Interior Image Input

**Which locations have interior images?**

Enter location IDs (comma-separated) or "all" to provide images for all:
Example: `loc_phandalin, loc_axeholm` or `1, 3, 5` (using numbers from list)

**Location selection:**
```

**Wait for user to specify which locations.**

**Then for EACH selected location:**

```markdown
## Interior Image: [Location Name] ([location_id])

Please provide the path to the interior layout image for **[Location Name]**.

**Supported formats:** PNG, JPG, GIF, WebP
**Example:** `assets/maps/interiors/phandalin_tavern.png` or `~/Desktop/dungeon_layout.png`

**What I'll analyze:**
- Walls and boundaries
- Floor types and walkable areas
- Doors and entry points
- Structure placements (furniture, objects)
- Potential NPC positions
- Spawn point location

**Image path for [Location Name]:**
```

**Wait for user to provide image path.**

---

#### Interior Image Analysis

**After receiving the interior image, use the Read tool to view it, then present analysis:**

```markdown
## Interior Analysis: [Location Name]

I've analyzed the interior layout image. Here's what I identified:

### Grid Dimensions
- **Suggested grid size:** [width] x [height] cells
- **Cell size:** 32px (default for interiors)
- **Total area:** [area] cells

### Terrain Types Detected

| Zone | Cell Type | Approximate Area | Notes |
|------|-----------|------------------|-------|
| Main floor | FLOOR (1) | 60% of grid | Walkable interior space |
| Walls | WALL (2) | 15% of grid | Boundaries |
| Grass/outdoor | GRASS (6) | 10% of grid | Courtyard areas |
| Paths | PATH (4) | 5% of grid | Connecting walkways |
| Doors | DOOR (3) | <1% of grid | Entry/exit points |

### Structures Detected

| # | Structure Type | Position (x,y) | Notes |
|---|----------------|----------------|-------|
| 1 | CAMPFIRE (8) | (5, 4) | Central hearth |
| 2 | CHEST (10) | (2, 7) | Against wall |
| 3 | STALL (3) | (8, 3) | Shop counter |
| ... | ... | ... | ... |

**Structure Types Available:**
- BUILDING (1), TENT (2), STALL (3), WELL (4), STATUE (5)
- TREE (6), ROCK (7), CAMPFIRE (8), SHRINE (9), CHEST (10), SIGN (11)

### NPC Positions Detected

| # | Suggested NPC Role | Position (x,y) | Facing | Notes |
|---|-------------------|----------------|--------|-------|
| 1 | Shopkeeper | (8, 4) | south | Behind counter |
| 2 | Guard | (3, 8) | east | Near entrance |
| ... | ... | ... | ... | ... |

### Zones Detected

| Zone ID | Type | Area (x,y,w,h) | Notes |
|---------|------|----------------|-------|
| zone_entrance | ENTRANCE (1) | (4, 9, 3, 2) | Main entry point |
| zone_shop | SHOP (5) | (7, 2, 4, 4) | Shop area |
| zone_rest | REST (6) | (1, 1, 3, 3) | Inn/rest area |

**Zone Types Available:**
- ENTRANCE (1), EXIT (2), SAFE (3), DANGER (4), SHOP (5)
- REST (6), QUEST (7), SECRET (8), COMBAT (9)

### Spawn Point
- **Default spawn:** ([x], [y]) - [location description]
- **From specific routes:** (Can define different spawns based on travel origin)

---

**Please review and correct my interpretation:**

1. Are the grid dimensions correct?
2. Are the terrain zones accurate?
3. Are structure placements correct? (Adjust positions as needed)
4. Are NPC positions appropriate?
5. Is the spawn point in the right location?
6. Any zones missing or incorrect?

**Provide corrections or type "confirmed" to generate interior definition.**
```

**Wait for user confirmation/corrections.**

---

#### ASCII Interior Preview

**After initial confirmation, generate ASCII preview:**

```markdown
## ASCII Interior Preview: [Location Name]

Here's a visual representation of the interior layout:

**Legend:**
```
# = Wall          . = Floor         + = Door
~ = Water         , = Grass         = = Path/Road
@ = Spawn Point   N = NPC Position  S = Structure
```

**ASCII Layout ([width]x[height]):**
```
    0    5    10   15   20
    |----|----|----|----|
 0 |#################    |
 1 |#...............#    |
 2 |#..S..........S.#    |
 3 |#.......N.......#    |
 4 |#...S...........#    |
 5 |#...............#    |
 6 |#...............#    |
 7 |#.....S.........#    |
 8 |#...N...........#    |
 9 |#####++++########    |
10 |,,,,@,,,,,,,,,,,,    |
    |----|----|----|----|
```

**Structure Key:**
```
S(2,2)  = STALL - Shop counter
S(14,2) = CHEST - Storage
S(4,4)  = CAMPFIRE - Hearth
S(6,7)  = WELL - Water source
```

**NPC Key:**
```
N(8,3)  = Shopkeeper position
N(4,8)  = Guard position
```

**Spawn:** @(5,10) - Entrance area

---

**Review the ASCII layout:**
1. Does the wall layout match your image?
2. Are walkable areas (floor) correct?
3. Are structures in the right positions?
4. Are NPCs placed appropriately?
5. Is the spawn point correct?

**Type "confirmed" to generate interior definition, or describe adjustments.**
```

**Wait for user confirmation.**

---

#### Interior Definition Generation

**After ASCII is confirmed, generate the interior definition:**

```json
{
  "interior": {
    "mode": 1,
    "template": "",
    "seed": 0,
    "definition": {
      "grid_width": 20,
      "grid_height": 12,
      "cells": [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,0,0, ...],
      "structures": [
        {
          "id": "struct_0",
          "type": 3,
          "position": {"x": 2, "y": 2},
          "rotation": 0,
          "custom_data": {}
        },
        {
          "id": "struct_1",
          "type": 10,
          "position": {"x": 14, "y": 2},
          "rotation": 0,
          "custom_data": {}
        }
      ],
      "paths": [],
      "zones": [
        {
          "id": "zone_entrance",
          "type": 1,
          "rect": {"x": 4, "y": 9, "w": 4, "h": 2},
          "custom_data": {}
        },
        {
          "id": "zone_shop",
          "type": 5,
          "rect": {"x": 1, "y": 1, "w": 5, "h": 4},
          "custom_data": {}
        }
      ],
      "npc_placements": [
        {
          "npc_id": "",
          "position": {"x": 8, "y": 3},
          "facing": "south",
          "patrol_path": [],
          "conditions": {}
        }
      ],
      "interactables": [],
      "spawn_points": [
        {
          "id": "default",
          "position": {"x": 5, "y": 10},
          "from_location": ""
        }
      ],
      "template_id": "",
      "generation_seed": 0,
      "created_at": "[timestamp]",
      "modified_at": "[timestamp]"
    }
  }
}
```

**Update the worldmap file with the interior definition for this location.**

---

#### Interior Cell Types Reference

| Value | Constant | Description | Walkable |
|-------|----------|-------------|----------|
| 0 | EMPTY | Non-walkable empty space | No |
| 1 | FLOOR | Basic walkable floor | Yes |
| 2 | WALL | Non-walkable wall | No |
| 3 | DOOR | Walkable door cell | Yes |
| 4 | PATH | Walkable path/road | Yes |
| 5 | WATER | Non-walkable water | No |
| 6 | GRASS | Walkable grass terrain | Yes |
| 7 | ROAD | Walkable road | Yes |

#### Interior Structure Types Reference

| Value | Constant | Description |
|-------|----------|-------------|
| 0 | NONE | No structure |
| 1 | BUILDING | Building structure |
| 2 | TENT | Tent |
| 3 | STALL | Market stall |
| 4 | WELL | Well |
| 5 | STATUE | Statue |
| 6 | TREE | Tree |
| 7 | ROCK | Rock |
| 8 | CAMPFIRE | Campfire |
| 9 | SHRINE | Shrine |
| 10 | CHEST | Chest |
| 11 | SIGN | Sign |

#### Interior Zone Types Reference

| Value | Constant | Description |
|-------|----------|-------------|
| 0 | NONE | No special zone |
| 1 | ENTRANCE | Entry point zone |
| 2 | EXIT | Exit point zone |
| 3 | SAFE | Safe zone |
| 4 | DANGER | Danger zone |
| 5 | SHOP | Shop area |
| 6 | REST | Rest area |
| 7 | QUEST | Quest trigger zone |
| 8 | SECRET | Secret area |
| 9 | COMBAT | Combat arena |

---

#### Processing Multiple Interior Images

**If user selected multiple locations, repeat the process for each:**

1. Request image path for location 1
2. Analyze and present findings
3. Generate ASCII preview
4. Confirm and generate interior definition
5. Update worldmap file
6. Move to location 2...

**Progress tracking:**
```markdown
## Interior Layout Progress

| # | Location | Status | Interior Size |
|---|----------|--------|---------------|
| 1 | loc_phandalin | ✅ Complete | 20x12 |
| 2 | loc_axeholm | 🔄 In Progress | - |
| 3 | loc_gnomengarde | ⏳ Pending | - |
```

---

#### Saving Interior Definitions

After all interior layouts are processed:

1. **Update worldmap file** with all interior definitions
2. **Verify JSON validity**
3. **Report summary:**

```markdown
## Interior Layouts Complete

I've added interior definitions to **[X] locations** in your worldmap.

### Summary

| Location | Grid Size | Structures | NPCs | Zones |
|----------|-----------|------------|------|-------|
| loc_phandalin | 20x12 | 5 | 2 | 3 |
| loc_axeholm | 30x25 | 12 | 4 | 6 |
| ... | ... | ... | ... | ... |

### Files Updated
- `data/world/[worldmap_id].worldmap.json` - Interior definitions added

### Next Steps
1. Open World Map Builder to preview interiors
2. Fine-tune structure positions if needed
3. Assign actual NPC IDs to npc_placements
4. Test spawn points by entering locations
```

---

### Phase 0B: Structured Data Input

**If user selects structured data input:**

```markdown
## Structured Data Input

Provide your location data in one of these formats:

### Option 1: Markdown Table

| ID | Name | Type | Region | Position | Connects To | Services | Safe | Notes |
|----|------|------|--------|----------|-------------|----------|------|-------|
| loc_town | Riverside | settlement | west | center | Forest, Ruins | shop,inn | yes | Starting area |
| loc_forest | Dark Forest | dungeon | north | north | Town | none | no | Wolf encounters |

### Option 2: Text Description

```
Locations:
- Riverside Town (settlement, center of map, safe) - Starting town with shop and inn
  - Connects to: Dark Forest (north), Ancient Ruins (east)
- Dark Forest (dungeon, north, dangerous) - Wolf encounters
  - Connects to: Riverside Town
- Ancient Ruins (ruins, east, dangerous) - Undead encounters
  - Connects to: Riverside Town
```

### Option 3: File Path

Provide a path to a text/markdown file containing location data:
`docs/design/world-locations.md`

### Option 4: Simple List

Just list your locations and I'll ask follow-up questions:
```
- Starting Town
- Dark Forest
- Bandit Camp
- Ancient Temple
- Mountain Pass
```

**Paste your data or provide a file path:**
```

**Wait for user input, then parse and confirm:**

```markdown
## Data Parsed

I've extracted the following from your input:

### Locations (X total)
| ID | Name | Type | Position | Safe | Services |
|----|------|------|----------|------|----------|
| [generated] | [name] | [type] | [auto-assigned] | [yes/no] | [list] |

### Routes (X total)
| From | To | Type | Notes |
|------|----|----|-------|
| [loc_a] | [loc_b] | [inferred] | [from "connects to"] |

### Missing Information
- [ ] Exact positions (will auto-layout if not specified)
- [ ] NPCs at locations
- [ ] Encounter IDs for hostile locations
- [ ] Travel event details

**Confirm this is correct, or provide corrections:**
```

**Wait for user confirmation, then proceed.**

---

### Phase 0C: Reference Document Input

**If user selects reference document input:**

```markdown
## Reference Document Input

Which document should I extract world information from?

**Common sources:**
- `docs/design/world-bible.md` - Geography and faction sections
- `docs/narrative/story-arcs.md` - Locations mentioned in plot
- `docs/test-campaigns/[name].md` - Campaign specification
- Custom path: `[your file path]`

**Document path:**
```

**Wait for user to provide path, then read and analyze:**

```markdown
## Document Analysis: [filename]

I've extracted the following world information:

### Locations Mentioned
| Name | Context | Inferred Type | Region/Faction |
|------|---------|---------------|----------------|
| [name] | "[quote from doc]" | [type] | [if mentioned] |

### Geographic References
- [Any terrain, distances, or spatial relationships mentioned]

### Faction Territories
| Faction | Locations Controlled | Notes |
|---------|---------------------|-------|
| [faction] | [locations] | [from doc] |

### Connections Implied
- [Any travel or route references from the document]

---

**This is what I found in the document. Please:**
1. Confirm which locations to include
2. Add any missing locations
3. Specify location types if unclear
4. Provide position preferences (or I'll auto-layout)

**Your input:**
```

**Wait for user confirmation, then proceed.**

---

### Phase 0D: Interactive Q&A (Default)

**If user selects interactive Q&A, proceed to Phase 1.**

---

### Phase 1: World Overview

```markdown
## World Builder Session

Let's create a worldmap for your game.

**1. World Name**
What is this worldmap called?
(This becomes the file name, e.g., "blood_and_gold_world")

**2. World Description**
Brief description of this world region:

**3. Scale & Scope**
How large is this map?
- [ ] Small (2-4 locations) - Tutorial or single quest area
- [ ] Medium (5-10 locations) - Act or chapter scope
- [ ] Large (10-20 locations) - Full game world
- [ ] Epic (20+ locations) - Massive open world

**4. Region Structure**
Will this world have distinct regions?
- [ ] No regions - Single unified area
- [ ] 2-3 regions - Moderate division
- [ ] 4+ regions - Complex political/geographic divisions
```

**Wait for user response before proceeding.**

---

### Phase 2: Region Definition (if applicable)

```markdown
## Region Setup

Let's define the regions of your world.

**For each region, provide:**

| Region ID | Name | Description | Faction | Color |
|-----------|------|-------------|---------|-------|
| region_1 | [Name] | [Description] | [Faction or "none"] | #HEXCOLOR |
| region_2 | [Name] | [Description] | [Faction or "none"] | #HEXCOLOR |

**Faction Control:**
- Which faction controls each region?
- Are there contested areas?
- Do factions affect services/NPCs available?
```

**Wait for user response before proceeding.**

---

### Phase 3: Location Definition

```markdown
## Location Planning

Let's define the locations in your world.

**For each location, provide:**

| ID | Name | Type | Region | Description | Services | Safe? |
|----|------|------|--------|-------------|----------|-------|
| loc_1 | [Name] | [Type] | [Region] | [Brief desc] | [Services] | yes/no |

**Location Types:**
- settlement, kingdom, dungeon, camp, player_base, landmark, ruins

**Services (for settlements):**
- shop, inn, blacksmith, temple, guild, stable, bank, tavern

**Questions for each location:**
1. Is this a safe zone? (No random encounters)
2. What NPCs are here? (List NPC IDs)
3. Is there a fixed encounter? (Encounter ID)
4. Does it need an interior grid?
```

**Wait for user response before proceeding.**

---

### Phase 4: Route Definition

```markdown
## Route Planning

Let's connect your locations with routes.

**For each route, provide:**

| From | To | Type | Visibility | Travel Time | Danger | Requirements |
|------|----|------|------------|-------------|--------|--------------|
| loc_a | loc_b | road | always | 1.0 | 0 | none |

**Route Types:**
- road, highway, wilderness, river, mountain_pass, sea_route

**Visibility:**
- always, hidden, blocked

**Travel Time:**
- 0.5 = Quick, 1.0 = Normal, 2.0 = Long, 3.0+ = Journey

**Danger Level:**
- 0 = Safe, 1-2 = Low, 3-5 = Medium, 6-8 = High, 9-10 = Deadly

**Requirements:**
- flags: ["flag_name"] - Must have flag set
- items: ["item_id"] - Must have item
- min_level: 5 - Minimum party level
```

**Wait for user response before proceeding.**

---

### Phase 5: Travel Events

```markdown
## Travel Events

Do routes have random events during travel?

**For routes with events, define:**

| Route | Event Timing | Event Type | Reference | Chance | Condition |
|-------|--------------|------------|-----------|--------|-----------|
| route_1 | during | encounter | enc_bandits | 0.3 | none |

**Event Timing:** start, during, end, interrupt

**Event Types:**
- encounter (combat)
- dialogue (conversation)
- discovery (reveal location)
- item (find item)
- flag (set flag)

**Conditions:**
- chance: 0.0-1.0 (probability)
- flags: ["required_flag"]
- time_of_day: "day" / "night" / ""
```

**Wait for user response before proceeding.**

---

### Phase 6: Interior Definitions (if needed)

```markdown
## Interior Layouts

For locations with explorable interiors, define the grid layout.

**Interior Mode:**
- 0 = None (world map point only)
- 1 = Designed (hand-crafted layout)
- 2 = Generated (procedural from template)

**For designed interiors, specify:**
- Grid size (width x height)
- Terrain theme (floor, grass, road)
- Structure placements
- NPC positions
- Spawn point

**Note:** Detailed interior definition can be done in the World Map Builder editor or specified here for scaffolding.
```

---

## Output Format

Save worldmap files to: `data/world/[worldmap_id].worldmap.json`

### Complete Worldmap Structure

```json
{
  "name": "World Name",
  "description": "World description",
  "author": "Author Name",
  "version": "1.0",
  "file_version": 1,
  "map_data": {
    "width": 1000,
    "height": 800,
    "background_color": "#2d5a27",
    "grid_size": 32
  },
  "editor_state": {
    "zoom": 1.0,
    "scroll_offset": {"x": 0, "y": 0}
  },
  "regions": [
    {
      "id": "region_example",
      "name": "Example Region",
      "description": "Description",
      "color": "#FF5500",
      "faction": ""
    }
  ],
  "locations": [
    {
      "id": "loc_example",
      "name": "Example Location",
      "type": "settlement",
      "region": "region_example",
      "description": "Description",
      "position": {"x": 100, "y": 200},
      "map_scene": "",
      "custom_data": {
        "safe_zone": true,
        "services": ["shop", "inn"],
        "npcs": [],
        "hostile": false,
        "encounter": ""
      },
      "interior": {
        "mode": 0,
        "template": "",
        "seed": 0,
        "definition": {}
      }
    }
  ],
  "routes": [
    {
      "id": "route_example",
      "from_location": "loc_a",
      "to_location": "loc_b",
      "type": "road",
      "visibility": "always",
      "travel_time": 1.0,
      "danger_level": 0,
      "description": "Route description",
      "requirements": {
        "flags": [],
        "items": [],
        "min_level": 0
      },
      "events": []
    }
  ]
}
```

---

## Templates

### Template 1: Simple Hub World

A central hub with surrounding locations.

```json
{
  "name": "Simple Hub World",
  "description": "A central town with surrounding areas",
  "author": "World Builder",
  "version": "1.0",
  "file_version": 1,
  "map_data": {
    "width": 800,
    "height": 600,
    "background_color": "#2d5a27",
    "grid_size": 32
  },
  "editor_state": {
    "zoom": 1.0,
    "scroll_offset": {"x": 0, "y": 0}
  },
  "regions": [],
  "locations": [
    {
      "id": "loc_town",
      "name": "Riverside Town",
      "type": "settlement",
      "region": "",
      "description": "A peaceful town by the river",
      "position": {"x": 400, "y": 300},
      "map_scene": "",
      "custom_data": {
        "safe_zone": true,
        "services": ["shop", "inn", "blacksmith"],
        "npcs": [],
        "hostile": false,
        "encounter": ""
      },
      "interior": {"mode": 1, "template": "", "seed": 0, "definition": {}}
    },
    {
      "id": "loc_forest",
      "name": "Dark Forest",
      "type": "dungeon",
      "region": "",
      "description": "A foreboding forest to the north",
      "position": {"x": 400, "y": 100},
      "map_scene": "",
      "custom_data": {
        "safe_zone": false,
        "services": [],
        "npcs": [],
        "hostile": true,
        "encounter": "enc_forest_wolves"
      },
      "interior": {"mode": 0, "template": "", "seed": 0, "definition": {}}
    },
    {
      "id": "loc_ruins",
      "name": "Ancient Ruins",
      "type": "ruins",
      "region": "",
      "description": "Crumbling ruins hiding secrets",
      "position": {"x": 600, "y": 300},
      "map_scene": "",
      "custom_data": {
        "safe_zone": false,
        "services": [],
        "npcs": [],
        "hostile": true,
        "encounter": "enc_ruins_undead"
      },
      "interior": {"mode": 1, "template": "", "seed": 0, "definition": {}}
    }
  ],
  "routes": [
    {
      "id": "route_town_forest",
      "from": "loc_town",
      "to": "loc_forest",
      "type": "road",
      "direction": "two_way",
      "visibility": "always",
      "travel_time": 1.0,
      "distance": 30,
      "encounter_chance": 0.2,
      "description": "A winding path into the forest",
      "requirements": {"flags": [], "items": [], "min_level": 0},
      "events": []
    },
    {
      "id": "route_town_ruins",
      "from": "loc_town",
      "to": "loc_ruins",
      "type": "path",
      "direction": "two_way",
      "visibility": "always",
      "travel_time": 1.5,
      "distance": 45,
      "encounter_chance": 0.4,
      "description": "An overgrown path to the ruins",
      "requirements": {"flags": [], "items": [], "min_level": 0},
      "events": []
    }
  ]
}
```

---

### Template 2: Regional World with Factions

Multiple regions controlled by different factions.

```json
{
  "name": "Three Kingdoms World",
  "description": "A land divided between three warring kingdoms",
  "author": "World Builder",
  "version": "1.0",
  "file_version": 1,
  "map_data": {
    "width": 1200,
    "height": 900,
    "background_color": "#2d5a27",
    "grid_size": 32
  },
  "editor_state": {"zoom": 1.0, "scroll_offset": {"x": 0, "y": 0}},
  "regions": [
    {
      "id": "region_valdris",
      "name": "Valdris Heartland",
      "description": "The rich agricultural center",
      "color": "#4488FF",
      "faction": "valdris"
    },
    {
      "id": "region_corvaine",
      "name": "Corvaine Highlands",
      "description": "Mountain fortresses and mining",
      "color": "#FF4444",
      "faction": "corvaine"
    },
    {
      "id": "region_thornmark",
      "name": "Thornmark Border",
      "description": "Contested frontier lands",
      "color": "#44FF44",
      "faction": "thornmark"
    }
  ],
  "locations": [
    {
      "id": "loc_valdris_capital",
      "name": "Valdris Keep",
      "type": "kingdom",
      "region": "region_valdris",
      "description": "The seat of Valdris power",
      "position": {"x": 200, "y": 450},
      "map_scene": "",
      "custom_data": {
        "safe_zone": true,
        "services": ["shop", "inn", "blacksmith", "temple", "guild"],
        "npcs": [],
        "hostile": false,
        "encounter": ""
      },
      "interior": {"mode": 1, "template": "", "seed": 0, "definition": {}}
    },
    {
      "id": "loc_corvaine_capital",
      "name": "Iron Citadel",
      "type": "kingdom",
      "region": "region_corvaine",
      "description": "The impregnable Corvaine fortress",
      "position": {"x": 1000, "y": 200},
      "map_scene": "",
      "custom_data": {
        "safe_zone": true,
        "services": ["shop", "blacksmith", "guild"],
        "npcs": [],
        "hostile": false,
        "encounter": ""
      },
      "interior": {"mode": 1, "template": "", "seed": 0, "definition": {}}
    },
    {
      "id": "loc_thornmark_camp",
      "name": "Mercenary Camp",
      "type": "camp",
      "region": "region_thornmark",
      "description": "A neutral meeting ground for sellswords",
      "position": {"x": 600, "y": 450},
      "map_scene": "",
      "custom_data": {
        "safe_zone": true,
        "services": ["tavern", "guild"],
        "npcs": [],
        "hostile": false,
        "encounter": ""
      },
      "interior": {"mode": 1, "template": "", "seed": 0, "definition": {}}
    }
  ],
  "routes": [
    {
      "id": "route_valdris_thornmark",
      "from": "loc_valdris_capital",
      "to": "loc_thornmark_camp",
      "type": "road",
      "direction": "two_way",
      "visibility": "always",
      "travel_time": 2.0,
      "distance": 60,
      "encounter_chance": 0.3,
      "description": "The western trade road",
      "requirements": {"flags": [], "items": [], "min_level": 0},
      "events": [
        {
          "timing": "random",
          "type": "encounter",
          "reference": "enc_road_bandits",
          "condition": {"chance": 0.2, "flags": [], "time_of_day": ""}
        }
      ]
    },
    {
      "id": "route_corvaine_thornmark",
      "from": "loc_corvaine_capital",
      "to": "loc_thornmark_camp",
      "type": "path",
      "direction": "two_way",
      "visibility": "always",
      "travel_time": 3.0,
      "distance": 90,
      "encounter_chance": 0.5,
      "description": "The treacherous mountain crossing",
      "requirements": {"flags": [], "items": [], "min_level": 3},
      "events": [
        {
          "timing": "midpoint",
          "type": "encounter",
          "reference": "enc_mountain_beasts",
          "condition": {"chance": 0.4, "flags": [], "time_of_day": ""}
        }
      ]
    }
  ]
}
```

---

### Template 3: Dungeon Complex

A multi-level dungeon with connected areas.

```json
{
  "name": "Crypt of Shadows",
  "description": "A multi-level dungeon beneath the ruins",
  "author": "World Builder",
  "version": "1.0",
  "file_version": 1,
  "map_data": {
    "width": 600,
    "height": 800,
    "background_color": "#1a1a2e",
    "grid_size": 32
  },
  "editor_state": {"zoom": 1.0, "scroll_offset": {"x": 0, "y": 0}},
  "regions": [],
  "locations": [
    {
      "id": "loc_entrance",
      "name": "Crypt Entrance",
      "type": "ruins",
      "region": "",
      "description": "The crumbling entrance to the crypt",
      "position": {"x": 300, "y": 100},
      "map_scene": "",
      "custom_data": {
        "safe_zone": false,
        "services": [],
        "npcs": [],
        "hostile": false,
        "encounter": ""
      },
      "interior": {"mode": 1, "template": "", "seed": 0, "definition": {}}
    },
    {
      "id": "loc_upper_halls",
      "name": "Upper Halls",
      "type": "dungeon",
      "region": "",
      "description": "Dusty corridors lined with tombs",
      "position": {"x": 300, "y": 300},
      "map_scene": "",
      "custom_data": {
        "safe_zone": false,
        "services": [],
        "npcs": [],
        "hostile": true,
        "encounter": "enc_skeleton_patrol"
      },
      "interior": {"mode": 1, "template": "", "seed": 0, "definition": {}}
    },
    {
      "id": "loc_lower_depths",
      "name": "Lower Depths",
      "type": "dungeon",
      "region": "",
      "description": "The deeper, more dangerous levels",
      "position": {"x": 300, "y": 500},
      "map_scene": "",
      "custom_data": {
        "safe_zone": false,
        "services": [],
        "npcs": [],
        "hostile": true,
        "encounter": "enc_wraith_ambush"
      },
      "interior": {"mode": 1, "template": "", "seed": 0, "definition": {}}
    },
    {
      "id": "loc_boss_chamber",
      "name": "Throne of Shadows",
      "type": "dungeon",
      "region": "",
      "description": "The lair of the ancient evil",
      "position": {"x": 300, "y": 700},
      "map_scene": "",
      "custom_data": {
        "safe_zone": false,
        "services": [],
        "npcs": [],
        "hostile": true,
        "encounter": "enc_shadow_lord_boss"
      },
      "interior": {"mode": 1, "template": "", "seed": 0, "definition": {}}
    }
  ],
  "routes": [
    {
      "id": "route_entrance_upper",
      "from": "loc_entrance",
      "to": "loc_upper_halls",
      "type": "path",
      "direction": "two_way",
      "visibility": "always",
      "travel_time": 0.5,
      "distance": 10,
      "encounter_chance": 0.2,
      "description": "Stairs descending into darkness",
      "requirements": {"flags": [], "items": [], "min_level": 0},
      "events": []
    },
    {
      "id": "route_upper_lower",
      "from": "loc_upper_halls",
      "to": "loc_lower_depths",
      "type": "secret",
      "direction": "two_way",
      "visibility": "hidden",
      "travel_time": 0.5,
      "distance": 15,
      "encounter_chance": 0.4,
      "description": "A hidden passage deeper",
      "requirements": {"flags": ["upper_halls_cleared"], "items": [], "min_level": 0},
      "events": []
    },
    {
      "id": "route_lower_boss",
      "from": "loc_lower_depths",
      "to": "loc_boss_chamber",
      "type": "path",
      "direction": "two_way",
      "visibility": "blocked",
      "travel_time": 0.5,
      "distance": 10,
      "encounter_chance": 0.8,
      "description": "The sealed door to the throne",
      "requirements": {"flags": ["boss_key_found"], "items": ["shadow_key"], "min_level": 5},
      "events": []
    }
  ]
}
```

---

### Template 4: Travel Event World

A world with rich random travel events.

```json
{
  "name": "Dangerous Roads",
  "description": "A world where travel itself is an adventure",
  "author": "World Builder",
  "version": "1.0",
  "file_version": 1,
  "map_data": {"width": 800, "height": 600, "background_color": "#2d5a27", "grid_size": 32},
  "editor_state": {"zoom": 1.0, "scroll_offset": {"x": 0, "y": 0}},
  "regions": [],
  "locations": [
    {
      "id": "loc_city",
      "name": "Trade City",
      "type": "settlement",
      "region": "",
      "description": "A bustling trade hub",
      "position": {"x": 100, "y": 300},
      "map_scene": "",
      "custom_data": {"safe_zone": true, "services": ["shop", "inn", "guild"], "npcs": [], "hostile": false, "encounter": ""},
      "interior": {"mode": 1, "template": "", "seed": 0, "definition": {}}
    },
    {
      "id": "loc_village",
      "name": "Frontier Village",
      "type": "settlement",
      "region": "",
      "description": "A remote village",
      "position": {"x": 700, "y": 300},
      "map_scene": "",
      "custom_data": {"safe_zone": true, "services": ["inn"], "npcs": [], "hostile": false, "encounter": ""},
      "interior": {"mode": 1, "template": "", "seed": 0, "definition": {}}
    }
  ],
  "routes": [
    {
      "id": "route_trade_road",
      "from": "loc_city",
      "to": "loc_village",
      "type": "road",
      "direction": "two_way",
      "visibility": "always",
      "travel_time": 3.0,
      "distance": 90,
      "encounter_chance": 0.5,
      "description": "The long road to the frontier",
      "requirements": {"flags": [], "items": [], "min_level": 0},
      "events": [
        {
          "timing": "departure",
          "type": "dialogue",
          "reference": "dlg_road_warning",
          "condition": {"chance": 1.0, "flags": ["!road_warning_seen"], "time_of_day": ""}
        },
        {
          "timing": "random",
          "type": "encounter",
          "reference": "enc_bandit_ambush",
          "condition": {"chance": 0.3, "flags": [], "time_of_day": ""}
        },
        {
          "timing": "day_1",
          "type": "encounter",
          "reference": "enc_wolf_pack",
          "condition": {"chance": 0.2, "flags": [], "time_of_day": "night"}
        },
        {
          "timing": "midpoint",
          "type": "discovery",
          "reference": "loc_hidden_shrine",
          "condition": {"chance": 0.1, "flags": ["!shrine_discovered"], "time_of_day": ""}
        },
        {
          "timing": "random",
          "type": "give_item",
          "reference": "gold_pouch",
          "condition": {"chance": 0.05, "flags": [], "time_of_day": ""}
        },
        {
          "timing": "arrival",
          "type": "set_flag",
          "reference": "reached_frontier",
          "condition": {"chance": 1.0, "flags": ["!reached_frontier"], "time_of_day": ""}
        }
      ]
    }
  ]
}
```

---

## Integration with Other Skills

| Skill | Relationship | Direction |
|-------|--------------|-----------|
| **game-ideator** | Provides world-bible.md for setting context | Reads from |
| **narrative-architect** | Provides story significance for locations | Reads from |
| **character-creator** | NPCs referenced in location custom_data | Works with |
| **quest-designer** | Quests reference locations and routes | Provides to |
| **encounter-designer** | Encounters tied to hostile locations | Provides to |
| **dialogue-designer** | NPCs at locations have dialogues | Provides to |
| **campaign-creator** | Uses worldmap in final campaign assembly | Provides to |
| **test-campaign-generator** | Bulk worldmap specs from campaign specs | Alternative path |
| **test-campaign-scaffolder** | Generates worldmaps from specs | Alternative path |

### Skill Workflow Paths

**Incremental Path (this skill):**
```
game-ideator → narrative-architect → WORLD-BUILDER → character-creator → ...
                                         ↓
                                   .worldmap.json
```

**Bulk Path (test campaigns):**
```
test-campaign-generator → test-campaign-scaffolder → (creates worldmap automatically)
```

**D&D Import Path:**
```
D&D module map → WORLD-BUILDER (D&D mode) → .worldmap.json
                       ↓
              character-creator → encounter-designer → campaign-creator
```

---

## Troubleshooting

### Common Issues

**Location not appearing on map:**
- Check `position` has valid x, y coordinates
- Verify location is in `locations` array
- Ensure worldmap is loaded by campaign

**Route not connecting locations:**
- Verify `from` and `to` match location IDs exactly
- Check both locations exist in the same worldmap
- Ensure `visibility` is "always" or conditions are met

**Travel events not triggering:**
- Check `chance` value (0.0-1.0 range)
- Verify `reference` points to valid encounter/dialogue/etc.
- Check `condition.flags` requirements are met

**NPCs not appearing at location:**
- NPCs in `custom_data.npcs` need matching .char files
- If `conditional: true`, the flag `[npc_id]_present` must be set
- NPC placement requires interior mode > 0 for grid position

**Interior not loading:**
- Check `interior.mode` is 1 (designed) or 2 (generated)
- For designed interiors, ensure `definition` has valid grid data
- For generated, ensure `template` points to valid template

**Interior from image not matching original:**
- Verify grid dimensions are appropriate for the detail level
- Adjust structure positions after generation in World Map Builder
- NPC placements may need manual position tweaking
- Spawn point should be on a walkable cell (FLOOR, GRASS, PATH, ROAD, DOOR)

**Cells array wrong size:**
- `cells` array must have exactly `grid_width * grid_height` elements
- Cells are stored row by row: `[row0_col0, row0_col1, ..., row1_col0, ...]`
- Index formula: `cells[y * grid_width + x]`

**NPCs not appearing on interior grid:**
- Check `npc_placements` has valid positions within grid bounds
- Ensure NPC position is on a walkable cell
- Verify `npc_id` matches a valid character file (or leave empty for placeholder)

---

## Validation Checklist

Before completing, verify:

- [ ] All locations have unique IDs starting with `loc_`
- [ ] All routes have unique IDs starting with `route_`
- [ ] All regions have unique IDs starting with `region_`
- [ ] Route `from` and `to` match existing location IDs
- [ ] Location `region` matches existing region IDs (or is empty)
- [ ] `custom_data.npcs` reference valid NPC IDs (or will be created)
- [ ] `custom_data.encounter` references valid encounter IDs (or will be created)
- [ ] Travel event `reference` fields point to valid content IDs
- [ ] File saved to `data/world/[worldmap_id].worldmap.json`
- [ ] JSON is valid (no syntax errors)

### Interior Layout Validation (if using image-based interiors)
- [ ] `interior.mode` is set to 1 (designed) for locations with definitions
- [ ] `definition.cells` array has exactly `grid_width * grid_height` elements
- [ ] All cell values are valid (0-7)
- [ ] `spawn_points` has at least one entry with `id: "default"`
- [ ] Spawn point position is on a walkable cell
- [ ] Structure positions are within grid bounds
- [ ] NPC placement positions are within grid bounds and on walkable cells
- [ ] Zone rectangles are within grid bounds

---

## Example Invocations

### Standard Invocations
- "Create a worldmap for the test campaign"
- "Build the world for Act 1"
- "Design a dungeon complex map"
- "Create a regional world with three factions"
- "Set up travel routes with random encounters"
- "Use world-builder to create a hub town with surrounding areas"

### Image-Based Invocations
- "Add interior layouts to my worldmap locations"
- "I have interior images for Phandalin and Axeholm"
- "Convert my dungeon map image to an interior grid"
- "Generate interior definitions from my tavern layout image"

### D&D/Tabletop Invocations
- "Create a worldmap from Dragons of Icespire Peak"
- "I want to recreate the Lost Mine of Phandelver map"
- "Build the Sword Coast region from my D&D campaign"
- "Convert my D&D adventure map to a CRPG worldmap"
- "I have the map from Storm King's Thunder to translate"
- "Create locations from my D&D module - I have the map image"
- "Build the worldmap for my Curse of Strahd campaign"

### Digitized Map + Reference Image Invocations
- "I've digitized my map terrain, now add locations from the reference image"
- "Add locations to my digitized worldmap using the original reference"
- "I have a digitized map and want to identify locations from the source image"
- "Use the reference image to add location names to my digitized terrain"
- "Compare my digitized map with the reference and add the locations"
- "My terrain is digitized, now extract locations from the original map image"
- "Add places from my reference map to the existing worldmap without changing terrain"
