# Test Campaign Generator Skill

> **RPG Pipeline Only** — This skill generates campaign specification documents (markdown) using a CRPG engine content manifest format with locations, NPCs, enemies, quests, dialogues, encounters, and interior grid layouts. For non-RPG games, the content-architect should create simpler level/content specifications suited to the game's needs. The tiered complexity approach and spec-then-scaffold workflow pattern apply broadly.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | content-architect |
| **Sprint Phase** | Phase B (Implementation) — used to plan bulk content creation |
| **Directory Scope** | `docs/test-campaigns/` (specs only, no data files) |
| **Genre** | RPG / CRPG only |
| **Schema Dependency** | References all CRPG engine schemas (character, quest, dialogue, encounter) |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

This skill generates **SPECIFICATION DOCUMENTS ONLY** - markdown files that describe test campaign content. It does NOT create JSON files or any game data files.

---

## CRITICAL: What This Skill Does and Does NOT Do

```
+------------------------------------------+------------------------------------------+
|              THIS SKILL DOES             |          THIS SKILL DOES NOT DO         |
+------------------------------------------+------------------------------------------+
| Create markdown specification documents  | Create JSON files                        |
| Define content in human-readable tables  | Create .char files                       |
| Save specs to docs/test-campaigns/       | Create .dtree files                      |
| Describe what content SHOULD exist       | Create worldmap files                    |
| Provide a blueprint for implementation   | Modify any files in data/ directory      |
| Offer to invoke test-campaign-scaffolder | Write to project.godot or main.gd        |
+------------------------------------------+------------------------------------------+
```

**After generating a spec, ASK the user if they want to scaffold the files using `test-campaign-scaffolder`.**

---

## Two-Step Workflow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         TEST CAMPAIGN CREATION WORKFLOW                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   STEP 1: test-campaign-generator (THIS SKILL)                              │
│   ─────────────────────────────────────────────                              │
│   Input:  User requirements (tier, theme, focus areas)                       │
│   Output: docs/test-campaigns/[name].md (SPECIFICATION ONLY)                 │
│                                                                              │
│                              ↓                                               │
│                                                                              │
│   STEP 2: test-campaign-scaffolder (SEPARATE SKILL)                          │
│   ─────────────────────────────────────────────────                          │
│   Input:  The spec file from Step 1                                          │
│   Output: All JSON/data files in data/ directory                             │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## When to Use This Skill

Invoke this skill when the user:
- Wants to **plan** a test campaign before creating files
- Says "generate a test campaign **spec**" or "create test content **specification**"
- Wants to design campaign content requirements
- Asks for "campaign to test editors"
- Needs structured content requirements for testing

**DO NOT use this skill if the user wants files created immediately** - in that case, run this skill first, then immediately invoke `test-campaign-scaffolder`.

---

## Phase 0: Input Mode Selection

**ALWAYS start by asking how the user wants to generate the campaign specification:**

```markdown
## Test Campaign Generator Session

How would you like to create your campaign specification?

**Generation Mode:**
- [ ] **Tier-based** - Choose a complexity tier (1-4) and theme
- [ ] **D&D/Tabletop Import** - Translate an existing D&D module/adventure
- [ ] **Custom Scope** - Define specific content counts and requirements
- [ ] **Editor Focus** - Create a campaign to stress-test specific editors

Select your preferred mode to continue.
```

**Wait for user response before proceeding to the appropriate workflow.**

---

## Phase 0-DND: D&D/Tabletop Module Import

**If user selects D&D/Tabletop Import:**

```markdown
## D&D Module Import

I'll help you create a campaign specification from your D&D module.

**Module Information:**
1. What D&D module/adventure is this? (e.g., "Dragons of Icespire Peak", "Lost Mine of Phandelver")
2. What level range does it cover?
3. Do you want to import the entire module or specific sections?

**Import Options:**
- [ ] Full module (all locations, NPCs, quests, encounters)
- [ ] Chapter/Section only (specify which)
- [ ] Core quests only (main story path)
- [ ] Starter content only (first 1-3 quests)

**Please provide:**
- Module name and source
- Section to import (if not full)
- Any content you want to skip or modify
```

### D&D Module to CRPG Campaign Mapping

| D&D Element | CRPG Specification | Notes |
|-------------|-------------------|-------|
| Adventure overview | Campaign Overview section | Theme, purpose, scope |
| Locations/Areas | Locations table | With interior layouts |
| NPCs | NPCs table | With grid positions, dialogues |
| Monsters | Enemies table | Map to CRPG enemy types |
| Encounters | Encounters table | With CR→difficulty conversion |
| Quests/Objectives | Quests table | With prerequisites |
| Read-aloud text | Dialogue concepts | For dialogue-designer to expand |
| Treasure/Rewards | Rewards in quests/encounters | Gold, items, XP |
| Maps | Interior Layouts | Translate to grid definitions |

### Dragons of Icespire Peak Full Spec Template

```markdown
# Test Campaign: Dragons of Icespire Peak

## Overview
- **Source:** D&D Essentials Kit - Dragons of Icespire Peak
- **Tier:** 4 (Complex - Full Module)
- **Theme:** Dragon threat in the Sword Coast region
- **Level Range:** 1-6 (D&D) → 1-30 (CRPG scaled)

## Content Manifest

### Locations (from module)
| ID | Name | Type | D&D Source | Interior Mode | Grid Size |
|----|------|------|------------|---------------|-----------|
| loc_phandalin | Phandalin | settlement | Starting town | designed | 20x15 |
| loc_umbrage_hill | Umbrage Hill | landmark | Quest location | designed | 12x10 |
| loc_dwarven_excavation | Dwarven Excavation | dungeon | Quest location | designed | 15x12 |
| loc_gnomengarde | Gnomengarde | dungeon | Quest location | designed | 18x14 |
| loc_axeholm | Axeholm | dungeon | Quest location | designed | 20x16 |
| loc_dragon_barrow | Dragon Barrow | dungeon | Quest location | designed | 14x12 |
| loc_icespire_hold | Icespire Hold | dungeon | Final dungeon | designed | 25x20 |

### NPCs (from module)
| ID | Name | Role | D&D Source | Location | Dialogue |
|----|------|------|------------|----------|----------|
| npc_toblen | Toblen Stonehill | quest_giver | Innkeeper | loc_phandalin | dlg_toblen |
| npc_harbin | Harbin Wester | quest_giver | Townmaster | loc_phandalin | dlg_harbin |
| npc_adabra | Adabra Gwynn | quest_giver | Midwife | loc_umbrage_hill | dlg_adabra |
...

### Enemies (from module)
| ID | D&D Monster | Type | CR | CRPG Level | Notes |
|----|-------------|------|----|-----------:|-------|
| enemy_orc | Orc | humanoid | 1/2 | 3 | Standard orc |
| enemy_manticore | Manticore | monstrosity | 3 | 15 | Boss at Umbrage Hill |
| enemy_ochre_jelly | Ochre Jelly | ooze | 2 | 10 | Dwarven Excavation |
| enemy_cryovain | Young White Dragon | dragon | 6 | 30 | Final boss |
...

### Quests (from module)
| ID | D&D Quest | Type | Giver | Objectives | Prerequisites |
|----|-----------|------|-------|------------|---------------|
| quest_umbrage_hill | Umbrage Hill | side_quest | npc_harbin | Talk to Adabra, Deal with Manticore | none |
| quest_dwarven_excavation | Dwarven Excavation | side_quest | npc_harbin | Investigate mine, Clear jellies | none |
| quest_gnomengarde | Gnomengarde | side_quest | npc_harbin | Find inventors, Deal with mimics | none |
| quest_dragon_slayer | Slay Cryovain | main_quest | npc_harbin | Find Icespire Hold, Defeat Cryovain | 3+ side quests |
...
```

---

## Editor Coverage

This skill generates specifications that exercise ALL editors in the workflow:

| Editor | Content Specified |
|--------|-------------------|
| **Campaign Editor** | Campaign config, chapters, starting conditions |
| **World Map Builder** | Locations, travel routes, region connections, **interior layouts** |
| **Quest Designer** | Quests with objectives, rewards, branching |
| **Dialogue Editor** | Conversation trees, skill checks, flags |
| **Character Creator** | NPCs, enemies, companions with full stats |
| **Encounter Designer** | Combat encounters with composition, conditions |
| **Ability Designer** | Custom abilities if needed |
| **Entity Editor** | Validation of all cross-references |

---

## Complexity Tiers

### Tier 1: Minimal (Editor Smoke Test)
**Purpose:** Verify each editor works and files save/load correctly

- 1 Location (with interior grid)
- 1 NPC (quest giver, placed on grid)
- 1 Enemy type
- 1 Quest (single objective)
- 1 Dialogue tree (linear, 3-4 nodes)
- 1 Encounter
- 1 Campaign config

---

### Tier 2: Simple (Basic Workflow Test)
**Purpose:** Test editor-to-editor linking and basic branching

- 2 Locations (connected, both with interiors)
- 3-4 NPCs (placed on grids)
- 2 Enemy types
- 2 Quests (one leads to another)
- 3 Dialogue trees (with 1 branch each)
- 2 Encounters
- 1 Campaign with chapter structure

---

### Tier 3: Standard (Integration Test)
**Purpose:** Test complex references, conditions, and branching

- 4-5 Locations (hub + spokes, varied interior sizes)
- 6-8 NPCs (various roles, grid placements)
- 4 Enemy types + 1 boss
- 4-5 Quests (main + side, with prerequisites)
- 6-8 Dialogue trees (skill checks, flags, quest triggers)
- 4-5 Encounters (varied difficulty)
- Campaign with 2 chapters, unlocks

---

### Tier 4: Complex (Stress Test)
**Purpose:** Push editors to limits, find edge cases

- 8-10 Locations (multiple regions, varied interiors)
- 12-15 NPCs (with conditional appearances)
- 6+ Enemy types, multiple bosses
- 8-10 Quests (branching outcomes, faction reputation)
- 15+ Dialogue trees (complex conditions)
- 8-10 Encounters (templates, scaling)
- Campaign with 3+ chapters, multiple endings

---

### Tier 5: D&D Module Import
**Purpose:** Translate existing D&D adventures into CRPG format

- Locations from module maps
- NPCs from module descriptions
- Enemies mapped from D&D monsters
- Quests from module objectives/hooks
- Dialogues from read-aloud text and NPC descriptions
- Encounters from module combat encounters
- Full campaign structure from module chapters

**D&D Conversion Rules:**
- **Stats:** D&D stat × 5 (D&D 10 → CRPG 50)
- **CR to Level:** CR × 5 (CR 2 → Level 10)
- **DC Conversion:** D&D DC × 5 (DC 10 → 50)
- **HP Conversion:** D&D HP × 2 or × 3 (for CRPG pacing)
- **Gold:** D&D gold × 1 (roughly equivalent)

---

## Generation Process

### Step 1: Gather Requirements

Ask the user for:

1. **Complexity Tier** (1-4) or custom scope
2. **Theme/Setting** (fantasy village, dungeon, city, wilderness, etc.)
3. **Focus Areas** (which editors to stress-test most)
4. **Special Requirements** (specific features to test)

### Step 2: Generate Campaign Specification (MARKDOWN ONLY)

Output a structured specification with:

```markdown
# Test Campaign: [Name]

## Overview
- **Tier:** [1-4]
- **Theme:** [Setting description]
- **Purpose:** [What this tests]

## Content Manifest

### Locations (World Map Builder)

| ID | Name | Type | Connections | Interior Mode | Grid Size | Terrain Theme |
|----|------|------|-------------|---------------|-----------|---------------|
| loc_001 | [Name] | [Type] | [Connected to] | designed | 12x10 | [grass/floor/road] |

**Interior Mode Options:**
- `none` - No explorable interior (world map point only)
- `designed` - Hand-crafted grid layout
- `generated` - Procedurally generated from template

### Characters (Character Creator)

#### NPCs
| ID | Name | Role | Location | Grid Position | Dialogue | Conditional | Notes |
|----|------|------|----------|---------------|----------|-------------|-------|
| npc_001 | [Name] | [Role] | [Location] | (5, 3) | [Dialogue ID] | no | [Notes] |

**Grid Position:** (x, y) coordinates on the location's interior grid. Place NPCs on walkable terrain.
**Conditional:** If "yes", NPC only appears when a flag is set (flag name = npc_id + "_present")

#### Enemies
| ID | Name | Type | Level | Abilities | Notes |
|----|------|------|-------|-----------|-------|
| enemy_001 | [Name] | [Type] | [Level] | [Abilities] | [Notes] |

### Quests (Quest Designer)
| ID | Name | Type | Giver | Objectives | Rewards | Prerequisites |
|----|------|------|-------|------------|---------|---------------|
| quest_001 | [Name] | [Type] | [NPC] | [Objectives] | [Rewards] | [Prereqs] |

### Dialogues (Dialogue Editor)
| ID | Speaker | Triggers | Flags Set | Skill Checks | Quest Links |
|----|---------|----------|-----------|--------------|-------------|
| dlg_001 | [NPC] | [Conditions] | [Flags] | [Checks] | [Quests] |

**CRITICAL - Quest-Dialogue Integration:**
Every quest MUST have associated dialogues that:
1. **Start the quest** - Dialogue includes a `Quest` node with `quest_action: "Start"`
2. **Complete the quest** - Dialogue includes a `Quest` node with `quest_action: "Complete"`

The **Quest Links** column should specify:
- `quest_id (start)` - This dialogue starts the quest
- `quest_id (complete)` - This dialogue completes the quest
- `quest_id (start, complete)` - This dialogue can do both (via different branches)

### Dialogue-Quest Reference Table

For each quest, ensure a corresponding dialogue entry exists:

| Quest ID | Start Dialogue | Complete Dialogue | Quest Giver NPC |
|----------|---------------|-------------------|-----------------|
| quest_001 | dlg_001 | dlg_001 | npc_001 |

### Encounters (Encounter Designer)
| ID | Name | Type | Enemies | Location | Conditions | Rewards | Quest Link |
|----|------|------|---------|----------|------------|---------|------------|
| enc_001 | [Name] | [Type] | [Enemy list] | [Location] | [Win/Lose] | [Loot] | [Quest] |

### Interior Layouts (per location with designed interiors)

#### [Location Name] Interior (loc_001)
- **Grid Size:** 12 x 10
- **Terrain:** Mostly grass with road paths
- **Spawn Point:** (6, 9) - south entrance

**Structure Placements:**
| Structure Type | Position | Notes |
|----------------|----------|-------|
| campfire | (6, 5) | Central gathering area |
| tent | (3, 3) | NPC dwelling |
| rock | (10, 2) | Decorative |

**Zone Definitions:**
| Zone ID | Type | Area (x,y,w,h) | Notes |
|---------|------|----------------|-------|
| zone_entrance | entrance | (5, 8, 3, 2) | Player spawn area |
| zone_shop | shop | (2, 2, 4, 3) | Near merchant NPC |

### Campaign Config (Campaign Editor)
- **Campaign ID:** [campaign_id]
- **Starting Location:** [Location ID]
- **Starting Gold:** [Amount]
- **Starting Items:** [Item list or "none"]
- **Initial Flags:** [Flag list]
- **Chapter Structure:** [Chapter breakdown]
- **Unlock Rules:** [Progression triggers]

## Cross-Reference Map

[Visual diagram showing how content connects]

```
[Location A] ←── route ──→ [Location B]
     │                          │
     └── npc_001 ───────── dlg_001 ── quest_001
                                          │
                                     enc_001 ── enemy_001
```

## Creation Order

Recommended order to create content (respecting dependencies):

1. [ ] Create characters (enemies first, then NPCs)
2. [ ] Create locations with interior layouts
3. [ ] Create abilities (if custom)
4. [ ] Create dialogues
5. [ ] Create encounters
6. [ ] Create quests
7. [ ] Create world map with routes
8. [ ] Create campaign config
9. [ ] Validate in Entity Editor

## Test Checklist

After creation, verify:

- [ ] All files save without errors
- [ ] All files load correctly
- [ ] Cross-references resolve (Entity Editor)
- [ ] Quest objectives reference valid content
- [ ] Dialogue flags are consistent
- [ ] **Every quest has a dialogue that STARTS it** (Quest node with `quest_action: "Start"`)
- [ ] **Every quest has a dialogue that COMPLETES it** (Quest node with `quest_action: "Complete"`)
- [ ] **Dialogue choices display correctly** (NOT showing "[1]", "[2]", etc.)
- [ ] Encounter enemies exist
- [ ] World map connections work both ways
- [ ] **NPCs appear on location grids at correct positions**
- [ ] **Interior terrain renders correctly**
- [ ] **Player can move via WASD and click-to-move**

## Testing Walkthrough

**IMPORTANT: This section provides step-by-step instructions for manually testing the campaign from start to finish.**

### Setup
1. Change `DEFAULT_CAMPAIGN` in `scenes/main.gd` to `"[campaign_id]"`
2. Run the game (F5)

### Main Path Walkthrough

[Provide numbered steps that walk through the entire campaign's main quest path]

**Step 1: [Location/Action]**
- You start at: [starting location]
- **Grid position:** Player spawns at (x, y)
- NPCs visible: [list NPCs with their grid positions]
- Action: [what to do - e.g., "Click on NPC or walk to (5,3)"]
- Expected result: [what should happen]

**Step 2: [Location/Action]**
- Travel to: [location] via world map
- **Grid position:** Player spawns at location's spawn point
- Action: [what to do]
- Expected result: [what should happen]

[Continue for each major step...]

### Side Quest Walkthroughs

**[Side Quest Name]**
1. [Step 1]
2. [Step 2]
3. [Expected completion state]

### Branching Paths (if applicable)

**Path A: [Name]**
- At [decision point], choose [option]
- This leads to: [outcome]
- Ending achieved: [ending_id]

**Path B: [Name]**
- At [decision point], choose [option]
- This leads to: [outcome]
- Ending achieved: [ending_id]

### Verification Checkpoints

| Checkpoint | Location | Grid Pos | Expected State |
|------------|----------|----------|----------------|
| After Step X | [location] | (x, y) | [flags set, quests active, etc.] |

```

### Step 3: Save the Specification

Save the spec to: `docs/test-campaigns/[campaign-name].md`

### Step 4: Offer Next Steps

**ALWAYS ask the user:**

> "I've created the campaign specification at `docs/test-campaigns/[name].md`.
>
> Would you like me to scaffold the actual data files using **test-campaign-scaffolder**?
> This will create all the JSON, .char, .dtree, and worldmap files in the data/ directory,
> including interior grid layouts with NPC placements."

---

## Example Specifications

### Tier 1 Example: "The Rat Cellar"

```markdown
# Test Campaign: The Rat Cellar

## Overview
- **Tier:** 1 (Minimal)
- **Theme:** Classic tavern basement rat problem
- **Purpose:** Smoke test all editors with minimal content

## Content Manifest

### Locations
| ID | Name | Type | Connections | Interior Mode | Grid Size | Terrain Theme |
|----|------|------|-------------|---------------|-----------|---------------|
| loc_tavern | The Dusty Flagon | settlement | none | designed | 10x8 | floor/wood |

### NPCs
| ID | Name | Role | Location | Grid Position | Dialogue | Conditional |
|----|------|------|----------|---------------|----------|-------------|
| npc_hilda | Barkeep Hilda | quest_giver | loc_tavern | (5, 2) | dlg_hilda | no |

### Enemies
| ID | Name | Type | Level |
|----|------|------|-------|
| enemy_rat | Giant Rat | beast | 1 |

### Quests
| ID | Name | Giver | Objectives |
|----|------|-------|------------|
| quest_rats | Cellar Cleanup | npc_hilda | Kill 3 rats |

### Dialogues
| ID | Speaker | Quest Links |
|----|---------|-------------|
| dlg_hilda | npc_hilda | quest_rats (give, complete) |

### Encounters
| ID | Name | Enemies | Location | Quest Link |
|----|------|---------|----------|------------|
| enc_cellar | Rat Infestation | 3x enemy_rat | loc_tavern | quest_rats |

### Interior Layout: The Dusty Flagon (loc_tavern)
- **Grid Size:** 10 x 8
- **Terrain:** Floor tiles throughout
- **Spawn Point:** (5, 7) - entrance at south

**Structure Placements:**
| Structure Type | Position | Notes |
|----------------|----------|-------|
| campfire | (5, 4) | Hearth/fireplace |
| stall | (2, 2) | Bar counter |

**NPC Placements:**
| NPC ID | Position | Facing |
|--------|----------|--------|
| npc_hilda | (5, 2) | down |

### Campaign Config
- **Campaign ID:** rat_cellar
- **Starting Location:** loc_tavern
- **Starting Gold:** 10
- **Initial Flags:** ["game_started"]

## Creation Order
1. [ ] enemy_rat (Character Creator)
2. [ ] npc_hilda (Character Creator)
3. [ ] loc_tavern with interior (World Map Builder)
4. [ ] dlg_hilda (Dialogue Editor)
5. [ ] enc_cellar (Encounter Designer)
6. [ ] quest_rats (Quest Designer)
7. [ ] campaign_rat_cellar (Campaign Editor)
8. [ ] Validate (Entity Editor)

## Testing Walkthrough

### Setup
1. Set `DEFAULT_CAMPAIGN = "rat_cellar"` in `scenes/main.gd`
2. Run game (F5)

### Main Path
**Step 1: Talk to Barkeep**
- You start at: loc_tavern, grid position (5, 7)
- NPC visible: Barkeep Hilda at (5, 2)
- Action: Walk north to (5, 2) or click on Hilda
- Expected: Dialogue starts, quest offered

**Step 2: Accept Quest**
- In dialogue, select "I'll help"
- Expected: quest_rats becomes active, journal updates

**Step 3: Fight Rats**
- Action: Trigger encounter (via dialogue or zone)
- Expected: Combat starts with 3 Giant Rats

**Step 4: Return to Hilda**
- After combat victory, talk to Hilda again
- Expected: Quest completes, rewards given
```

---

## Output Location

Save generated specs to: `docs/test-campaigns/[campaign-name].md`

**DO NOT save anything to:**
- `data/` directory
- `scenes/` directory
- Any `.json`, `.char`, `.dtree`, or `.worldmap.json` files

---

## Integration with Other Skills

| Skill | Relationship |
|-------|--------------|
| **game-ideator** | Can provide world-bible.md for themed campaigns |
| **narrative-architect** | Can provide story structure for complex campaigns |
| **test-campaign-scaffolder** | Takes specs from this skill and creates actual files |
| **character-creator** | Individual skills can create content referenced in specs |
| **quest-designer** | Individual skills can create content referenced in specs |
| **dialogue-designer** | Individual skills can create content referenced in specs |
| **encounter-designer** | Individual skills can create content referenced in specs |
| **world-builder** | Individual skills can create content referenced in specs |
| **campaign-creator** | Assembles all scaffolded content into final campaign |
| **entity-editor validation** | After scaffolding, use Entity Editor to validate |
| **error-debugger** | If editors have issues, use error-debugger |
| **changelog-updater** | Track test campaigns created |

### Workflow Paths

**Bulk Creation (Recommended for Test Campaigns):**
```
1. test-campaign-generator → Create specification (THIS SKILL)
2. test-campaign-scaffolder → Generate all files from spec
3. Entity Editor → Validate cross-references
4. Game → Test playthrough
```

**Incremental Creation (For Custom/Detailed Work):**
```
1. test-campaign-generator → Create specification as blueprint
2. Use individual skills to create each content piece:
   - character-creator → NPCs and enemies
   - dialogue-designer → Dialogue trees
   - quest-designer → Quest definitions
   - encounter-designer → Combat encounters
   - world-builder → Worldmap and locations
3. campaign-creator → Assemble final campaign
```

**D&D Import Path:**
```
1. test-campaign-generator (D&D mode) → Create spec from module
2. Review/edit spec for CRPG adjustments
3. test-campaign-scaffolder → Generate all files
4. Use individual skills for any custom content needed
```

---

## Invocation Examples

**Tier-Based:**
- "Generate a tier 1 test campaign spec"
- "Create a tier 3 test campaign specification for a haunted forest"
- "I need a complex test campaign spec to stress-test dialogue branching"

**D&D/Tabletop Import:**
- "Create a spec from Dragons of Icespire Peak"
- "Import Lost Mine of Phandelver as a campaign spec"
- "Generate a campaign spec from my D&D module"
- "Translate the Starter Set adventure to CRPG format"

**Custom/Editor Focus:**
- "Design test content for the editors"
- "Plan a campaign to test quest prerequisites"
- "Create a spec focused on dialogue branching"

---

## Checklist Before Completing This Skill

Before finishing, verify:

- [ ] Only created a markdown file in `docs/test-campaigns/`
- [ ] Did NOT create any JSON, .char, .dtree, or worldmap files
- [ ] Did NOT modify any files in `data/` directory
- [ ] **Included Interior Mode and Grid Size for each location**
- [ ] **Included Grid Position for each NPC**
- [ ] **Included Interior Layout section for designed interiors**
- [ ] **Included Quest Links column in Dialogues table**
- [ ] **Every quest has a corresponding dialogue entry with start/complete actions**
- [ ] **Included Dialogue-Quest Reference Table mapping quests to dialogues**
- [ ] Asked user if they want to scaffold files using `test-campaign-scaffolder`
