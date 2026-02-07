# Campaign Creator Skill

> **RPG Pipeline Only** — This skill creates campaign data files that tie together worldmaps, characters, quests, and encounters into playable RPG campaigns. For non-RPG games, the content-architect should create simpler level/progression data suited to the game's needs. The iterative MINIMAL → UPDATE → FINALIZE workflow pattern applies broadly.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | content-architect |
| **Sprint Phase** | Phase B (Implementation) — used iteratively throughout development |
| **Directory Scope** | `data/campaigns/` |
| **Genre** | RPG / CRPG only |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

This skill creates **campaign data files** (`.json`) that tie together all game content - worldmaps, characters, quests, dialogues, and encounters - into a playable campaign.

**Output:** `data/campaigns/[campaign_id].json`

---

## CRITICAL: Iterative Development Support

**This skill supports iterative "test as you go" development.**

Unlike other skills that are used once, campaign-creator is used **multiple times** throughout development:

| Mode | When | Purpose |
|------|------|---------|
| **MINIMAL** | Start of project | Create skeleton campaign so you can run the game |
| **UPDATE** | After adding content | Add new content references to existing campaign |
| **FINALIZE** | End of project | Validate all references, polish chapters/endings |

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     ITERATIVE DEVELOPMENT WORKFLOW                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   1. game-ideator → foundation docs                                          │
│   2. narrative-architect → narrative docs                                    │
│                                                                              │
│   3. CAMPAIGN-CREATOR (MINIMAL) ◄─── Creates playable skeleton               │
│      → You can now run the game (F5)                                         │
│                                                                              │
│   4. world-builder → Add first location                                      │
│      CAMPAIGN-CREATOR (UPDATE) → Add location to campaign                    │
│      → TEST IN GAME ✓                                                        │
│                                                                              │
│   5. character-creator → Add first NPC                                       │
│      CAMPAIGN-CREATOR (UPDATE) → Add NPC to starting_npcs                    │
│      → TEST IN GAME ✓                                                        │
│                                                                              │
│   6. dialogue-designer → Add NPC dialogue                                    │
│      → TEST IN GAME ✓                                                        │
│                                                                              │
│   7. quest-designer → Add first quest                                        │
│      CAMPAIGN-CREATOR (UPDATE) → Add quest to chapter                        │
│      → TEST IN GAME ✓                                                        │
│                                                                              │
│   ... continue adding content, testing after each piece ...                  │
│                                                                              │
│   N. CAMPAIGN-CREATOR (FINALIZE) → Validate, polish, complete                │
│      → FINAL PLAYABLE CAMPAIGN ✓                                             │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Skill Hierarchy Position

```
                    ┌─────────────────────────────┐
                    │      GAME IDEATOR           │
                    │   (Creative Foundation)      │
                    └─────────────────────────────┘
                                 │
                    ┌─────────────────────────────┐
                    │   NARRATIVE ARCHITECT       │
                    │   (Story & Character Detail)│
                    └─────────────────────────────┘
                                 │
                    ┌─────────────────────────────┐
                    │     CAMPAIGN CREATOR        │ ◄── USE EARLY (MINIMAL MODE)
                    │     (Skeleton Campaign)     │
                    └─────────────────────────────┘
                                 │
    ┌────────────────────────────┼────────────────────────────┐
    ↓                            ↓                            ↓
┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
│WORLD     │  │CHARACTER │  │QUEST     │  │DIALOGUE  │  │ENCOUNTER │
│BUILDER   │  │CREATOR   │  │DESIGNER  │  │DESIGNER  │  │DESIGNER  │
└──────────┘  └──────────┘  └──────────┘  └──────────┘  └──────────┘
    │              │              │              │              │
    ↓              ↓              ↓              ↓              ↓
data/world    data/char      data/quests   data/dialogue  data/encounters
                                 │
                    ┌────────────┴────────────┐
                    ↓                         ↓
         CAMPAIGN CREATOR            CAMPAIGN CREATOR
           (UPDATE MODE)              (FINALIZE MODE)
                    │                         │
                    └────────────┬────────────┘
                                 ↓
                    ┌─────────────────────────────┐
                    │   data/campaigns/*.json     │
                    │   (Updated incrementally)   │
                    └─────────────────────────────┘
```

---

## CRITICAL: What This Skill Does and Does NOT Do

```
+------------------------------------------+------------------------------------------+
|              THIS SKILL DOES             |          THIS SKILL DOES NOT DO         |
+------------------------------------------+------------------------------------------+
| Create campaign JSON files               | Create worldmap files                   |
| Define starting location and NPCs        | (use world-builder for that)            |
|                                          |                                         |
| Configure initial player state           | Create character files                  |
| (gold, items, flags, variables)          | (use character-creator for that)        |
|                                          |                                         |
| Define chapter/act structure             | Create quest files                      |
| with objectives and quest chains         | (use quest-designer for that)           |
|                                          |                                         |
| Configure endings and conditions         | Create dialogue files                   |
|                                          | (use dialogue-designer for that)        |
|                                          |                                         |
| Reference existing content by ID         | Create encounter files                  |
| Save to data/campaigns/                  | (use encounter-designer for that)       |
+------------------------------------------+------------------------------------------+
```

---

## When to Use This Skill

Invoke this skill when the user:
- Says "create a campaign" or "make a new campaign"
- Wants to "tie together my content into a campaign"
- Says "I have a worldmap and quests, now make the campaign"
- Asks to "configure campaign settings"
- Says "use campaign-creator"
- Has created content with other skills and needs the campaign file
- Wants to import/recreate an existing D&D or tabletop campaign
- **Says "I want to test my game" (use MINIMAL mode first)**
- **Says "add this content to the campaign" (UPDATE mode)**
- **Says "finalize the campaign" (FINALIZE mode)**

---

## Phase 0: Mode Selection

**ALWAYS start by asking which mode the user needs:**

```markdown
## Campaign Creator

**Which mode do you need?**

- [ ] **MINIMAL** - Create a new skeleton campaign so I can start testing
      (Use this at the START of your project)

- [ ] **UPDATE** - Add new content to an existing campaign
      (Use this after creating content with other skills)

- [ ] **FINALIZE** - Validate and complete an existing campaign
      (Use this when all content is created)

- [ ] **D&D IMPORT** - Create campaign from D&D/tabletop module
      (Use this when importing existing adventure)
```

**Wait for user response, then proceed to appropriate workflow.**

---

## MINIMAL Mode Workflow

**Purpose:** Create a playable skeleton campaign immediately so you can test in-game.

**When:** Start of project, right after game-ideator and narrative-architect.

### MINIMAL: What Gets Created

```json
{
  "id": "[campaign_id]",
  "name": "[Campaign Name]",
  "description": "[Brief description]",
  "version": 1,
  "author": "Campaign Creator",
  "created_date": "[date]",
  "player_character": "player",
  "worldmap": "[campaign_id]_world",
  "starting_location": "loc_placeholder",
  "starting_locations": ["loc_placeholder"],
  "starting_npcs": [],
  "initial_state": {
    "gold": 0,
    "items": [],
    "flags": ["game_started"],
    "variables": {}
  },
  "chapters": [],
  "endings": [],
  "_metadata": {
    "status": "skeleton",
    "content_needed": []
  }
}
```

### MINIMAL: Questions to Ask

```markdown
## MINIMAL Mode - Skeleton Campaign

I'll create a minimal playable campaign.

**1. Campaign ID** (lowercase, underscores):
________________
Example: `icespire_peak`, `my_adventure`

**2. Campaign Name** (display name):
________________

**3. Brief Description** (1 sentence):
________________

**4. Source** (optional):
- [ ] Original creation
- [ ] D&D module: ________________
- [ ] Other: ________________
```

### MINIMAL: Output

```markdown
## Skeleton Campaign Created

**File:** `data/campaigns/[campaign_id].json`

**Status:** Skeleton (playable but empty)

**What's created:**
- ✅ Campaign file with placeholder references
- ✅ Can run with F5 (will show empty world)

**Next steps:**
1. Use **world-builder** to create: `data/world/[campaign_id]_world.worldmap.json`
2. Run **campaign-creator UPDATE** to add the worldmap
3. TEST IN GAME
4. Use **character-creator** to add NPCs
5. Run **campaign-creator UPDATE** to add NPCs
6. TEST IN GAME
7. Continue adding content...

**To test now:**
Set `DEFAULT_CAMPAIGN = "[campaign_id]"` in `scenes/main.gd`
Run game (F5)
```

---

## UPDATE Mode Workflow

**Purpose:** Add new content references to an existing campaign.

**When:** After creating content with world-builder, character-creator, quest-designer, etc.

### UPDATE: Questions to Ask

```markdown
## UPDATE Mode - Add Content to Campaign

**Which campaign to update?**

Existing campaigns found:
- [ ] [campaign_id_1] - [name]
- [ ] [campaign_id_2] - [name]

**What content are you adding?**

- [ ] **Worldmap** - Just created a worldmap with world-builder
      Worldmap ID: ________________

- [ ] **Location(s)** - Added locations to the worldmap
      Location IDs: ________________

- [ ] **NPC(s)** - Created NPC characters
      NPC IDs: ________________
      Add to starting_npcs? [yes/no]

- [ ] **Quest(s)** - Created quest files
      Quest IDs: ________________
      Add to chapter: ________________ (or "new chapter")

- [ ] **Encounter(s)** - Created encounter files
      (Note: Encounters are linked via quests, not campaign directly)

- [ ] **Dialogue(s)** - Created dialogue files
      (Note: Dialogues are linked via NPCs/quests, not campaign directly)
```

### UPDATE: What Gets Modified

Based on user input, update the campaign.json:

| Content Type | Campaign Field Updated |
|--------------|----------------------|
| Worldmap | `worldmap` |
| Location | `starting_locations` (if starting area) |
| NPC | `starting_npcs` (if available at start) |
| Quest | `chapters[].quest_chain` |
| Chapter | `chapters[]` (add new chapter) |
| Ending | `endings[]` |

### UPDATE: Output

```markdown
## Campaign Updated

**File:** `data/campaigns/[campaign_id].json`

**Changes made:**
- ✅ Added worldmap reference: [worldmap_id]
- ✅ Added NPCs to starting_npcs: [npc_ids]
- ✅ Added quest to Chapter 1: [quest_id]

**Current campaign state:**
- Worldmap: [worldmap_id] ✓
- Starting Location: [loc_id] ✓
- Starting NPCs: [count] NPCs
- Chapters: [count] chapters
- Quests: [count] quests referenced

**Test now:**
Run game (F5) to see new content
```

---

## FINALIZE Mode Workflow

**Purpose:** Validate all references, add chapters/endings, complete the campaign.

**When:** All content is created and you want to polish/validate.

### FINALIZE: Questions to Ask

```markdown
## FINALIZE Mode - Complete Campaign

**Which campaign to finalize?**
Campaign: ________________

**Validation will check:**
- [ ] All referenced worldmap exists
- [ ] All starting_npcs have .char files
- [ ] All quest_chain quests have .json files
- [ ] All chapter prerequisites are valid
- [ ] No circular dependencies

**Additional configuration:**

**Chapters** (define story progression):
[Interactive chapter definition - same as Phase 4 in original workflow]

**Endings** (define victory conditions):
[Interactive ending definition - same as Phase 5 in original workflow]

**Metadata:**
- Difficulty: [easy/medium/hard]
- Estimated playtime: ________________
- Tags: ________________
```

### FINALIZE: Validation Report

```markdown
## Campaign Validation Report

**Campaign:** [campaign_id]

### References Checked

**Worldmap:**
- [x] `data/world/[worldmap_id].worldmap.json` EXISTS

**Characters:**
- [x] `data/characters/npcs/[npc_1].char` EXISTS
- [x] `data/characters/npcs/[npc_2].char` EXISTS
- [ ] `data/characters/npcs/[npc_3].char` MISSING ⚠️

**Quests:**
- [x] `data/quests/[quest_1].json` EXISTS
- [x] `data/quests/[quest_2].json` EXISTS

**Encounters:** (checked via quest references)
- [x] `data/encounters/[enc_1].json` EXISTS

**Dialogues:** (checked via NPC references)
- [x] `data/dialogue/[dlg_1].dtree` EXISTS

### Issues Found

⚠️ **1 issue(s) to resolve:**
1. Missing NPC: `npc_3` referenced but file not found
   → Create with character-creator or remove reference

### Campaign Status

- [ ] All references valid
- [x] Chapters defined
- [x] Endings defined
- [x] Metadata complete

**Ready to ship:** NO (resolve issues first)
```

---

## Two Input Modes

### Mode A: From Existing Content (Recommended)

When the user has already created content with other skills:

```
Existing Files:
├── data/world/my_world.worldmap.json      ✓ Created by world-builder
├── data/characters/npcs/elder.char        ✓ Created by character-creator
├── data/quests/main_quest.json            ✓ Created by quest-designer
├── data/dialogue/elder_talk.dtree         ✓ Created by dialogue-designer
└── data/encounters/wolves.json            ✓ Created by encounter-designer
                    │
                    ↓
            campaign-creator
                    │
                    ↓
└── data/campaigns/my_campaign.json        ✓ TIES EVERYTHING TOGETHER
```

### Mode B: D&D/Tabletop Import

When recreating an existing campaign (like Icespire Peak):

1. User provides campaign info (name, setting, structure)
2. Skill creates campaign.json with references to content TO BE CREATED
3. Outputs a checklist of content files needed
4. User creates content with other skills
5. Campaign becomes playable

---

## Prerequisites

**Recommended (Mode A):**
- Worldmap file exists in `data/world/`
- At least one NPC character file in `data/characters/`
- At least one quest file in `data/quests/` (optional for sandbox)

**Minimal (Mode B):**
- Campaign name and description
- Starting location ID (worldmap can be created after)

---

## Output

### File Location
`data/campaigns/[campaign_id].json`

### Campaign JSON Structure

```json
{
  "id": "campaign_id",
  "name": "Campaign Display Name",
  "description": "Full description of the campaign",
  "version": 1,
  "author": "Author Name",
  "created_date": "YYYY-MM-DD",

  "player_character": "player",
  "worldmap": "worldmap_id",
  "starting_location": "loc_starting",
  "starting_locations": ["loc_starting", "loc_nearby"],
  "starting_npcs": ["npc_quest_giver", "npc_merchant"],

  "initial_state": {
    "gold": 0,
    "items": [],
    "flags": ["game_started"],
    "variables": {}
  },

  "chapters": [
    {
      "id": "chapter_1",
      "name": "Chapter Name",
      "description": "Chapter description",
      "objectives": ["High-level objective 1", "High-level objective 2"],
      "quest_chain": ["quest_id_1", "quest_id_2"],
      "unlocks_locations": ["loc_new_area"],
      "unlocks_npcs": ["npc_new_character"],
      "prerequisites": {
        "required_flags": [],
        "completed_quests": [],
        "min_level": 1
      }
    }
  ],

  "endings": [
    {
      "id": "ending_good",
      "name": "Ending Name",
      "description": "How this ending is achieved",
      "prerequisites": {
        "completed_quests": ["main_quest"],
        "required_flags": ["good_path"]
      },
      "epilogue": "Epilogue text describing the outcome"
    }
  ],

  "_metadata": {
    "difficulty": "medium",
    "estimated_playtime": "2-4 hours",
    "tier": 2,
    "source": "original",
    "based_on": "",
    "tags": ["fantasy", "adventure"]
  }
}
```

---

## Interactive Workflow

### Phase 1: Campaign Identity

```markdown
## Campaign Creator

**Input Mode:**
- [ ] **From Existing Content** - I have worldmap/quests/NPCs ready
- [ ] **D&D/Tabletop Import** - Recreating an existing campaign
- [ ] **From Scratch** - Starting fresh, will create content after

---

**1. Campaign ID**
Unique identifier (lowercase, underscores): ________________
Example: `icespire_peak`, `curse_of_strahd`, `my_adventure`

**2. Campaign Name**
Display name: ________________
Example: "Dragons of Icespire Peak"

**3. Description**
Brief description (1-3 sentences):
________________

**4. Author**
________________

**5. Source (for imports)**
- [ ] Original creation
- [ ] D&D 5e module: ________________
- [ ] Pathfinder module: ________________
- [ ] Other tabletop: ________________
```

**Wait for user response.**

---

### Phase 2: World Connection

```markdown
## World & Starting Point

**6. Worldmap**
Which worldmap does this campaign use?

Existing worldmaps found:
- [ ] [worldmap_id_1] - [name]
- [ ] [worldmap_id_2] - [name]
- [ ] Create new worldmap (use world-builder after)
- [ ] Worldmap ID to create: ________________

**7. Starting Location**
Where does the player begin?
Location ID: ________________
(Must exist in the worldmap)

**8. Starting NPCs**
Which NPCs are available at game start?
NPC IDs (comma-separated): ________________

Example: npc_innkeeper, npc_quest_giver
```

**Wait for user response.**

---

### Phase 3: Initial State

```markdown
## Initial Player State

**9. Starting Gold**
Amount: ________ (default: 0)

**10. Starting Items**
Item IDs (comma-separated, or "none"):
________________

**11. Starting Flags**
Flags set at game start (comma-separated):
________________
Default: game_started

**12. Starting Variables**
Key-value pairs (or "none"):
Example: reputation_town=0, days_passed=0
________________
```

**Wait for user response.**

---

### Phase 4: Chapter Structure

```markdown
## Campaign Structure

**13. Chapter Count**
How many chapters/acts?
- [ ] 1 (short campaign)
- [ ] 2-3 (standard campaign)
- [ ] 4+ (epic campaign)
- [ ] No chapters (sandbox/open world)

**For each chapter, provide:**

### Chapter 1: ________________ (name)
- **Description:** ________________
- **Main Objectives:** (high-level goals)
  1. ________________
  2. ________________
- **Quest Chain:** (quest IDs in order)
  ________________
- **Unlocks:** (locations/NPCs revealed after chapter)
  - Locations: ________________
  - NPCs: ________________
- **Prerequisites:** (what's needed to start this chapter)
  - Flags: ________________
  - Quests: ________________
  - Min Level: ________

[Repeat for additional chapters]
```

**Wait for user response.**

---

### Phase 5: Endings

```markdown
## Campaign Endings

**14. Ending Count**
- [ ] 1 (linear story)
- [ ] 2-3 (branching outcomes)
- [ ] 4+ (complex branching)

**For each ending:**

### Ending: ________________ (name)
- **ID:** ________________
- **Description:** ________________
- **Prerequisites:**
  - Completed Quests: ________________
  - Required Flags: ________________
- **Epilogue:** (ending text)
________________
```

**Wait for user response.**

---

### Phase 6: Metadata

```markdown
## Campaign Metadata

**15. Difficulty**
- [ ] Easy (casual, forgiving)
- [ ] Medium (balanced)
- [ ] Hard (challenging)
- [ ] Very Hard (punishing)

**16. Estimated Playtime**
________________
Example: "2-4 hours", "10-15 hours"

**17. Tags**
(comma-separated): ________________
Example: fantasy, horror, mystery, combat-heavy, story-focused
```

**Wait for user response, then generate.**

---

## D&D Import Workflow

When importing from D&D (like Icespire Peak):

### Step 1: Provide D&D Content

```markdown
## D&D Campaign Import

Please provide the following from your D&D campaign:

**Campaign Info:**
- Name: Dragons of Icespire Peak
- Setting: Sword Coast, near Phandalin
- Level Range: 1-6
- Main Threat: White dragon Cryovain

**Starting Location:**
- Name: Phandalin
- Type: Small mining town

**Key NPCs:** (list 5-10 important NPCs)
1. Harbin Wester - Townmaster (cowardly, quest giver)
2. Toblen Stonehill - Innkeeper (friendly, rumors)
3. Sister Garaele - Priestess (kind, side quests)
[etc.]

**Key Locations:** (list major areas)
1. Phandalin - Starting town
2. Gnomengarde - Gnome workshop
3. Dwarven Excavation - Dig site
[etc.]

**Main Quests:** (list adventures)
1. Dwarven Excavation - Investigate missing miners
2. Gnomengarde - Help the gnomes
[etc.]
```

### Step 2: Generate Campaign Shell

The skill creates:
```json
{
  "id": "icespire_peak",
  "name": "Dragons of Icespire Peak",
  "worldmap": "icespire_peak",  // TO BE CREATED
  "starting_location": "loc_phandalin",  // TO BE CREATED
  "starting_npcs": ["npc_harbin_wester", "npc_toblen_stonehill"],  // TO BE CREATED
  // ...
}
```

### Step 3: Output Content Checklist

```markdown
## Content Needed

Campaign file created: `data/campaigns/icespire_peak.json`

**Files to create with other skills:**

### Worldmap (use /world-builder)
- [ ] `data/world/icespire_peak.worldmap.json`
  - Locations: loc_phandalin, loc_gnomengarde, loc_dwarven_excavation, ...
  - Routes connecting locations

### NPCs (use /character-creator)
- [ ] `data/characters/npcs/npc_harbin_wester.char`
- [ ] `data/characters/npcs/npc_toblen_stonehill.char`
- [ ] `data/characters/npcs/npc_sister_garaele.char`
[etc.]

### Enemies (use /character-creator)
- [ ] `data/characters/enemies/enemy_orc.char`
- [ ] `data/characters/enemies/enemy_cryovain.char`
[etc.]

### Quests (use /quest-designer)
- [ ] `data/quests/quest_dwarven_excavation.json`
- [ ] `data/quests/quest_gnomengarde.json`
[etc.]

### Dialogues (use /dialogue-designer)
- [ ] `data/dialogue/dlg_harbin_intro.dtree`
[etc.]

### Encounters (use /encounter-designer)
- [ ] `data/encounters/enc_excavation_orcs.json`
[etc.]

**Recommended creation order:**
1. worldmap (defines locations)
2. characters (NPCs and enemies)
3. encounters (uses enemies)
4. dialogues (uses NPCs)
5. quests (ties dialogues and encounters together)
```

---

## Templates

### Template: Minimal Campaign (Tier 1)

```json
{
  "id": "[campaign_id]",
  "name": "[Campaign Name]",
  "description": "[Brief description]",
  "version": 1,
  "author": "Campaign Creator",
  "created_date": "[YYYY-MM-DD]",
  "player_character": "player",
  "worldmap": "[worldmap_id]",
  "starting_location": "[loc_id]",
  "starting_locations": ["[loc_id]"],
  "starting_npcs": ["[npc_id]"],
  "initial_state": {
    "gold": 0,
    "items": [],
    "flags": ["game_started"],
    "variables": {}
  },
  "chapters": [
    {
      "id": "chapter_1",
      "name": "[Chapter Name]",
      "description": "[Chapter description]",
      "objectives": ["[Objective 1]"],
      "quest_chain": ["[quest_id]"],
      "unlocks_locations": [],
      "unlocks_npcs": [],
      "prerequisites": {
        "required_flags": ["game_started"]
      }
    }
  ],
  "endings": [
    {
      "id": "ending_complete",
      "name": "[Ending Name]",
      "description": "[How achieved]",
      "prerequisites": {
        "completed_quests": ["[quest_id]"]
      },
      "epilogue": "[Ending text]"
    }
  ],
  "_metadata": {
    "difficulty": "easy",
    "estimated_playtime": "15-30 minutes",
    "tier": 1,
    "source": "original"
  }
}
```

### Template: D&D Module Import

```json
{
  "id": "[module_id]",
  "name": "[D&D Module Name]",
  "description": "[Module description from book]",
  "version": 1,
  "author": "Campaign Creator (from D&D)",
  "created_date": "[YYYY-MM-DD]",
  "player_character": "player",
  "worldmap": "[module_id]",
  "starting_location": "[loc_starting_town]",
  "starting_locations": ["[loc_starting_town]"],
  "starting_npcs": ["[npc_quest_giver]", "[npc_merchant]"],
  "initial_state": {
    "gold": 10,
    "items": [],
    "flags": ["game_started", "arrived_in_town"],
    "variables": {
      "dragon_attacks": 0
    }
  },
  "chapters": [
    {
      "id": "chapter_1_levels_1_2",
      "name": "Starting Out",
      "description": "Establish yourself and take on starter quests",
      "objectives": [
        "Speak with the townmaster",
        "Complete 2-3 starting quests",
        "Reach level 3"
      ],
      "quest_chain": ["quest_1", "quest_2", "quest_3"],
      "unlocks_locations": [],
      "unlocks_npcs": [],
      "prerequisites": {
        "required_flags": ["game_started"]
      }
    }
  ],
  "endings": [
    {
      "id": "ending_victory",
      "name": "Victory",
      "description": "Defeated the main threat",
      "prerequisites": {
        "completed_quests": ["quest_final_boss"],
        "required_flags": ["boss_defeated"]
      },
      "epilogue": "[Victory epilogue]"
    }
  ],
  "_metadata": {
    "difficulty": "medium",
    "estimated_playtime": "15-25 hours",
    "tier": 3,
    "source": "dnd_5e",
    "based_on": "[D&D Module Name]",
    "level_range": "1-6",
    "tags": ["fantasy", "dragon", "adventure"]
  }
}
```

---

## Integration with Other Skills

| Skill | Relationship |
|-------|--------------|
| **game-ideator** | Provides setting context (optional) |
| **narrative-architect** | Provides story structure (optional) |
| **world-builder** | Creates worldmap referenced by campaign |
| **character-creator** | Creates NPCs referenced in starting_npcs |
| **quest-designer** | Creates quests referenced in chapters |
| **dialogue-designer** | Creates dialogues used by quests |
| **encounter-designer** | Creates encounters used by quests |

---

## Validation

Before finalizing, the skill checks:

1. **Worldmap exists** (or notes it needs creation)
2. **Starting location** is in worldmap (or notes it needs creation)
3. **Starting NPCs** have character files (or lists what's needed)
4. **Quest chains** reference valid quest IDs (or lists what's needed)
5. **No circular dependencies** in chapter prerequisites

---

## Example Invocations

**MINIMAL Mode (Start of Project):**
- "Create a skeleton campaign so I can start testing"
- "I need a minimal campaign to run the game"
- "Set up a new campaign called Dragons of Icespire Peak"
- "Start a new campaign, I'll add content as I go"

**UPDATE Mode (Adding Content):**
- "Add this worldmap to the campaign"
- "I just created an NPC, add them to the campaign"
- "Add this quest to chapter 1"
- "Update the campaign with my new dialogue"
- "I created a new location, add it to starting locations"

**FINALIZE Mode (End of Project):**
- "Finalize my campaign"
- "Validate all campaign references"
- "Add chapters and endings to my campaign"
- "Check if my campaign is ready to ship"

**D&D Import:**
- "Create a campaign from Dragons of Icespire Peak"
- "Import Lost Mine of Phandelver as a campaign"

---

## Output Report

```markdown
## Campaign Created

**File:** `data/campaigns/[campaign_id].json`

### Summary
- **Name:** [Campaign Name]
- **Worldmap:** [worldmap_id]
- **Starting Location:** [location_id]
- **Chapters:** [count]
- **Endings:** [count]

### Content References

**Existing (found):**
- [x] Worldmap: [id]
- [x] NPCs: [list]
- [x] Quests: [list]

**Needed (create with other skills):**
- [ ] Use `/world-builder` to create: [list]
- [ ] Use `/character-creator` to create: [list]
- [ ] Use `/quest-designer` to create: [list]
- [ ] Use `/dialogue-designer` to create: [list]
- [ ] Use `/encounter-designer` to create: [list]

### Testing
1. Set `DEFAULT_CAMPAIGN = "[campaign_id]"` in `scenes/main.gd`
2. Run game (F5)
3. Verify starting location loads
4. Verify starting NPCs appear
5. Test quest progression
```

---

## Checklist Before Completing

- [ ] Asked for campaign identity (name, ID, description)
- [ ] Determined worldmap reference
- [ ] Set starting location and NPCs
- [ ] Configured initial player state
- [ ] Defined chapter structure (if applicable)
- [ ] Defined endings
- [ ] Generated valid JSON
- [ ] Saved to `data/campaigns/[id].json`
- [ ] Listed content that needs to be created
- [ ] Provided testing instructions
