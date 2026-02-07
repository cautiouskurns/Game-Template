# Quest Designer Skill

This skill creates **quest data files (.json)** that integrate objectives, dialogues, encounters, and rewards into cohesive gameplay experiences. It reads narrative documents for story context and generates quests that conform to the engine's schema.

**IMPORTANT:** This skill generates quest files that conform to the official schema at:
`crpg_engine/schemas/quest_schema.json`

Always reference this schema for the authoritative definitions.

---

## Skill Hierarchy Position

```
                    ┌─────────────────────────────┐
                    │      GAME IDEATOR           │
                    │   (Creative Foundation)      │
                    │                             │
                    │   Outputs: docs/design/     │
                    │   • world-bible.md          │
                    │   • narrative-bible.md      │
                    │   • design-pillars.md       │
                    └─────────────────────────────┘
                                 │
                    ┌─────────────────────────────┐
                    │   NARRATIVE ARCHITECT       │
                    │   (Story & Character Detail)│
                    │                             │
                    │   Outputs: docs/narrative/  │
                    │   • quest-hooks.md          │
                    │   • story-arcs.md           │
                    │   • character-profiles.md   │
                    └─────────────────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ WORLD           │    │ CHARACTER       │    │ QUEST           │  ◄── THIS SKILL
│ BUILDER         │    │ CREATOR         │    │ DESIGNER        │
│                 │    │                 │    │                 │
│ → .worldmap.json│    │ → .char files   │    │ → .json quests  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    ▼                         ▼
         ┌─────────────────┐       ┌─────────────────┐
         │ DIALOGUE        │       │ ENCOUNTER       │
         │ DESIGNER        │       │ DESIGNER        │
         │ → .dtree files  │       │ → .json files   │
         └─────────────────┘       └─────────────────┘
                    │                         │
                    └────────────┬────────────┘
                                 ▼
                    ┌─────────────────────────────┐
                    │     CAMPAIGN CREATOR        │
                    │   (Assembles all content)   │
                    │                             │
                    │   → data/campaigns/*.json   │
                    └─────────────────────────────┘

WORKFLOW PATHS:
─────────────────────────────────────────────────────────────────
INCREMENTAL: Use individual skills to create content piece by piece
             game-ideator → narrative-architect → quest-designer → ...

BULK:        Use test-campaign-generator + test-campaign-scaffolder
             for rapid campaign generation from specifications
─────────────────────────────────────────────────────────────────
```

---

## CRITICAL: What This Skill Does and Does NOT Do

```
+------------------------------------------+------------------------------------------+
|              THIS SKILL DOES             |          THIS SKILL DOES NOT DO         |
+------------------------------------------+------------------------------------------+
| Create .json quest files                 | Create dialogue trees                   |
| Match narrative hooks from quest-hooks.md| (use dialogue-designer for that)        |
|                                          |                                          |
| Define objectives with proper types      | Create encounter files                  |
| (kill, collect, talk, escort, etc.)      | (use encounter-designer for that)       |
|                                          |                                          |
| Set up prerequisites, rewards, journal   | Create character files                  |
| entries, and map markers                 | (use character-creator for that)        |
|                                          |                                          |
| Configure branching paths and outcomes   | Create foundation documents             |
| for complex quests                       | (use game-ideator for that)             |
|                                          |                                          |
| Save quest files to data/quests/         | Scaffold entire campaigns               |
|                                          | (use test-campaign-scaffolder for that) |
+------------------------------------------+------------------------------------------+
```

---

## When to Use This Skill

Invoke this skill when the user:
- Says "create quest for [objective/story]" or "design a quest about [topic]"
- Asks to "generate a quest from hook [MQ01/SQ03/etc.]"
- Says "use quest-designer"
- Wants to create a main quest, side quest, companion quest, or contract
- Needs to implement a quest seed from quest-hooks.md

**DO NOT use this skill if:**
- User wants to create dialogues (use dialogue-designer)
- User wants to create combat encounters (use encounter-designer)
- User wants to scaffold entire campaigns (use test-campaign-scaffolder)

---

## Prerequisites

Before running this skill, check for:

1. **Narrative context** (recommended):
   - `docs/narrative/quest-hooks.md` (quest seeds with narrative purpose)
   - `docs/narrative/story-arcs.md` (where this quest fits)
   - `docs/narrative/character-profiles.md` (NPC details)
   - `docs/design/narrative-bible.md` (tone guidelines)

2. **Referenced entities** (should exist or be created):
   - NPCs referenced in objectives (quest giver, targets)
   - Locations referenced (starting location, objective destinations)
   - Dialogues referenced (will need to be created separately)
   - Encounters referenced (will need to be created separately)

If no narrative documents exist, the skill can still create quests but will ask for more context.

---

## Interactive Workflow

### Phase 0: Input Mode Selection

**ALWAYS start by asking how the user wants to provide quest information:**

```markdown
## Quest Designer Session

How would you like to define your quest?

**Input Mode:**
- [ ] **D&D/Tabletop Import** - I have a D&D adventure or tabletop quest to convert
- [ ] **Hook-based** - Create from a quest hook in quest-hooks.md
- [ ] **Type-based** - I know the quest type (main, side, companion, etc.)
- [ ] **Objective-based** - I know what the player should do
- [ ] **Interactive Q&A** - Guide me through the process step by step

Select your preferred input mode to continue.
```

**Wait for user response before proceeding to the appropriate phase.**

---

### Phase 0-DND: D&D/Tabletop Quest Import

**If user selects D&D/Tabletop import:**

```markdown
## D&D Quest Import

Please provide your D&D quest information.

**Option 1: Adventure Name**
Which published adventure or homebrew quest?
Example: "Goblin Arrows from Dragon of Icespire Peak"

**Option 2: Quest Description**
Paste or describe the quest:
- Quest name
- Quest giver (NPC who assigns it)
- Objectives (what players must do)
- Rewards (gold, XP, items)
- Location(s) involved
- Enemies/challenges

**Option 3: File Path**
Path to a document with quest details:
`docs/source-material/adventure-quests.md`
```

**Wait for user input, then parse and translate:**

```markdown
## Quest Translation: [D&D Quest Name]

I've analyzed your D&D quest. Here's the CRPG engine translation:

### D&D → CRPG Mapping

| D&D Element | CRPG Equivalent | Notes |
|-------------|-----------------|-------|
| Quest Name | `id`: [generated_id] | Converted to snake_case |
| Quest Giver | `quest_giver_id`: [npc_id] | NPC must be created via character-creator |
| Reward: X gp | `gold`: [X] | Direct conversion |
| Reward: X XP | `xp`: [X * 10] | D&D XP × 10 for CRPG scale |
| DC X check | `dc`: [X * 5] | D&D DC × 5 for CRPG 1-100 scale |

### D&D Objective Type Mapping

| D&D Objective | CRPG Type | Example |
|---------------|-----------|---------|
| Speak to NPC | `talk_to_npc` | "Ask Harbin about the job" |
| Go to location | `reach_location` | "Travel to Umbrage Hill" |
| Find/collect item(s) | `collect_items` | "Recover the stolen supplies" |
| Kill X creatures | `kill_enemies` | "Defeat the orcs at Wyvern Tor" |
| Escort NPC | `escort_npc` | "Escort the caravan to Phandalin" |
| Investigate | `discover_secret` | "Search for clues in the mine" |
| Survive X rounds | `defend_location` | "Hold the bridge for 3 rounds" |
| Make a skill check | `skill_check` | "Persuade the guard (DC 15)" |
| Complete encounter | `custom` | Complex multi-step objectives |

### Dragons of Icespire Peak Quest Examples

| D&D Quest | CRPG Quest ID | Type | Key Objectives |
|-----------|---------------|------|----------------|
| Dwarven Excavation | `quest_dwarven_excavation` | side_quest | reach_location, talk_to_npc, kill_enemies |
| Gnomengarde | `quest_gnomengarde` | side_quest | reach_location, talk_to_npc, collect_items |
| Umbrage Hill | `quest_umbrage_hill` | side_quest | reach_location, talk_to_npc, kill_enemies |
| Butterskull Ranch | `quest_butterskull_ranch` | side_quest | reach_location, kill_enemies, talk_to_npc |
| Loggers' Camp | `quest_loggers_camp` | side_quest | reach_location, talk_to_npc, custom |
| Mountain's Toe | `quest_mountains_toe` | side_quest | reach_location, kill_enemies, collect_items |
| Axeholm | `quest_axeholm` | main_quest | reach_location, kill_enemies, discover_secret |
| Woodland Manse | `quest_woodland_manse` | main_quest | reach_location, talk_to_npc, kill_enemies |
| Icespire Hold | `quest_icespire_hold` | main_quest | reach_location, kill_enemies (boss) |

### Translated Quest Structure

**Quest ID:** `[generated_id]`
**Type:** [main_quest/side_quest based on adventure structure]
**Difficulty:** [easy/medium/hard based on level recommendation]
**Recommended Level:** [from adventure]

**Objectives:**
1. [Objective 1 - type: X]
2. [Objective 2 - type: X]
3. [Objective 3 - type: X]

**Rewards:**
- Gold: [amount]
- XP: [amount]
- Items: [list]

**Dependencies to Create:**
- [ ] NPC: [quest_giver] → use character-creator
- [ ] Location: [location] → use world-builder
- [ ] Enemies: [list] → use character-creator
- [ ] Encounters: [list] → use encounter-designer
- [ ] Dialogues: [list] → use dialogue-designer

**Confirm this translation or provide corrections:**
```

**Wait for user confirmation, then proceed to generate the quest file.**

---

## Input

The skill accepts quest requests in several forms:

1. **Hook-based**: "Create quest from MQ03: The Frame"
2. **Type-based**: "Create a side quest about recovering stolen grain"
3. **Objective-based**: "I need a quest where the player escorts a merchant"
4. **Character-based**: "Create Mira's companion quest"

---

## Output

### File Location
`data/quests/[quest_id].json`

### Naming Conventions
- Main quests: `main_[name].json`
- Side quests: `side_[name].json` or `quest_[name].json`
- Companion quests: `companion_[companion_name]_[topic].json`
- Faction quests: `faction_[faction]_[name].json`
- Contracts: `contract_[name].json`

---

## Schema Reference

**Schema:** `crpg_engine/schemas/quest_schema.json`

### Required Top-Level Fields

```json
{
  "id": "quest_id",              // Unique identifier (lowercase, underscores)
  "name": "Internal Name",       // Internal reference name
  "type": "side_quest",          // Quest classification
  "description": {
    "brief": "Short desc",       // 1-2 sentences
    "full": "Full story desc"    // Complete narrative context
  },
  "objectives": [...]            // At least one objective required
}
```

### Quest Types

| Type | Use Case |
|------|----------|
| `main_quest` | Core story progression |
| `side_quest` | Optional content, world-building |
| `companion_quest` | Personal companion stories |
| `faction_quest` | Faction reputation/storylines |
| `contract` | Repeatable jobs (bounties, deliveries) |
| `misc` | Miscellaneous objectives |

### Difficulty Levels

| Level | Typical Level Range | Combat Encounters |
|-------|---------------------|-------------------|
| `easy` | 1-3 | Few/weak enemies |
| `medium` | 4-6 | Moderate challenge |
| `hard` | 7-9 | Significant challenge |
| `very_hard` | 10+ | Major challenge, boss encounters |

---

## Objective Types Reference

### talk_to_npc
Have a conversation with an NPC.

```json
{
  "id": "obj_speak_elder",
  "description": "Speak with Elder Theron",
  "type": "talk_to_npc",
  "objective_category": "primary",
  "target_npc_id": "elder_theron",
  "dialogue_id": "elder_theron_quest",
  "required_items": [],
  "specific_choice": ""
}
```

### reach_location
Travel to a location.

```json
{
  "id": "obj_reach_ruins",
  "description": "Travel to the Ruins of Valdros",
  "type": "reach_location",
  "objective_category": "primary",
  "target_location_id": "valdros_ruins",
  "target_area": "",
  "must_travel": false
}
```

### collect_items
Gather specific items.

```json
{
  "id": "obj_collect_herbs",
  "description": "Collect healing herbs (0/5)",
  "type": "collect_items",
  "objective_category": "primary",
  "items": [
    {"item_id": "healing_herb", "quantity": 5}
  ],
  "collection_methods": {
    "find": true,
    "loot": true,
    "buy": false,
    "craft": false
  },
  "location_hint": "Found near water sources",
  "return_items": true
}
```

### kill_enemies
Defeat enemies.

```json
{
  "id": "obj_clear_bandits",
  "description": "Eliminate the bandits (0/5)",
  "type": "kill_enemies",
  "objective_category": "primary",
  "kill_target_type": "bandit",
  "kill_count": 5,
  "kill_area_restriction": "bandit_camp",
  "allow_non_lethal": false,
  "must_kill_all": false
}
```

### escort_npc
Protect and escort an NPC.

```json
{
  "id": "obj_escort_merchant",
  "description": "Escort the merchant to Silverdale",
  "type": "escort_npc",
  "objective_category": "primary",
  "escort_npc_id": "merchant_willem",
  "target_location_id": "silverdale_village",
  "escort_radius": 50,
  "must_travel": true
}
```

### defend_location
Hold a position against waves of enemies.

```json
{
  "id": "obj_defend_bridge",
  "description": "Defend the bridge for 5 turns",
  "type": "defend_location",
  "objective_category": "primary",
  "location_id": "stone_bridge",
  "zone": "bridge_center",
  "radius": 30,
  "duration_turns": 5,
  "enemy_waves": [
    {"turn": 1, "encounter_id": "wave_1_bandits"},
    {"turn": 3, "encounter_id": "wave_2_bandits"}
  ],
  "fail_on_breach": true
}
```

### discover_secret
Find hidden content.

```json
{
  "id": "obj_find_cache",
  "description": "Discover the hidden cache",
  "type": "discover_secret",
  "objective_category": "hidden",
  "area": "old_ruins_basement",
  "conditions": [
    {"type": "perception_check", "params": {"dc": 15}}
  ],
  "reveal_on_discovery": true,
  "mark_on_map": true,
  "unlock_quest": ""
}
```

### keep_alive
Protect an NPC from death.

```json
{
  "id": "obj_protect_villagers",
  "description": "Keep the villagers alive",
  "type": "keep_alive",
  "objective_category": "secondary",
  "npc_id": "captured_villagers",
  "duration": "entire_quest",
  "min_hp": 1,
  "warn_50": true,
  "warn_25": true
}
```

### skill_check
Pass a skill check.

```json
{
  "id": "obj_pick_lock",
  "description": "Pick the treasury lock",
  "type": "skill_check",
  "objective_category": "primary",
  "skill": "lockpicking",
  "dc": 15
}
```

### wait_time
Wait for time to pass.

```json
{
  "id": "obj_wait_nightfall",
  "description": "Wait for nightfall",
  "type": "wait_time",
  "objective_category": "primary",
  "duration_minutes": 480,
  "condition": ""
}
```

### custom
Script-evaluated condition.

```json
{
  "id": "obj_special_condition",
  "description": "Complete the ritual",
  "type": "custom",
  "objective_category": "primary",
  "condition": "ritual_complete",
  "script": ""
}
```

### Objective Categories

| Category | Meaning | Shown in Journal |
|----------|---------|------------------|
| `primary` | Required to complete quest | Yes |
| `secondary` | Optional bonus objective | Yes (marked optional) |
| `hidden` | Secret objective | Only after discovered |

---

## Prerequisites Definition

```json
{
  "prerequisites": {
    "required_quests": ["quest_id_1", "quest_id_2"],
    "blocked_by_quests": ["mutually_exclusive_quest"],
    "requires_active_quests": ["must_be_in_progress"],
    "min_level": 5,
    "required_flags": ["flag_name"],
    "blocked_flags": ["flag_that_blocks"],
    "character": {
      "min_level": 5,
      "max_level": 15,
      "class": "warrior",
      "skills": [{"skill": "persuasion", "min_level": 3}],
      "attributes": [{"attribute": "charisma", "min_value": 14}]
    },
    "reputation": {
      "min": [{"faction": "guild", "min_value": 50}],
      "max": [{"faction": "enemies", "max_value": -20}],
      "allied": ["friendly_faction"],
      "hostile": ["enemy_faction"]
    },
    "inventory": {
      "items": [{"item_id": "key_item", "quantity": 1}],
      "gold": 100
    },
    "world_state": {
      "flags_required": ["world_event_happened"],
      "flags_blocked": ["world_event_prevented"],
      "npcs_alive": ["important_npc"],
      "npcs_dead": ["villain_npc"],
      "locations_discovered": ["hidden_location"]
    },
    "time_story": {
      "min_chapter": 2,
      "max_chapter": 3,
      "time_of_day": "night",
      "min_days_passed": 7
    },
    "companions": {
      "required": ["companion_id"],
      "excluded": ["incompatible_companion"],
      "min_party_size": 2
    }
  }
}
```

---

## Rewards Definition

### Flat Format (Simple)
```json
{
  "rewards": {
    "gold": 100,
    "xp": 500,
    "items": [
      {"item_id": "reward_sword", "quantity": 1}
    ],
    "reputation": [
      {"faction": "village", "change": 25}
    ],
    "unlocks": ["ability_special_move"]
  }
}
```

### Nested Format (Complex)
```json
{
  "rewards": {
    "base": {
      "gold": 100,
      "xp": 500,
      "items": [{"item_id": "basic_reward", "quantity": 1}],
      "reputation": [{"faction": "village", "change": 15}]
    },
    "conditional": {
      "all_optional": {
        "gold": 50,
        "xp": 100,
        "items": [{"item_id": "bonus_item", "quantity": 1}]
      },
      "speed_completion": {
        "time_limit_minutes": 30,
        "gold": 75,
        "xp": 150
      },
      "no_casualties": {
        "gold": 100,
        "xp": 200
      },
      "stealth": {
        "gold": 50,
        "xp": 100
      }
    },
    "choice": {
      "enabled": true,
      "options": [
        {
          "label": "Take the gold",
          "gold": 200,
          "reputation": [{"faction": "merchant_guild", "change": -10}]
        },
        {
          "label": "Refuse payment",
          "xp": 300,
          "reputation": [{"faction": "village", "change": 30}]
        }
      ]
    },
    "outcome_based": {
      "outcome_good": {"gold": 150, "xp": 600},
      "outcome_neutral": {"gold": 100, "xp": 400},
      "outcome_bad": {"gold": 50, "xp": 200}
    }
  }
}
```

---

## Branches and Outcomes

### Branches
Different paths through the quest based on player choices.

```json
{
  "branches": [
    {
      "id": "branch_combat",
      "condition": "chose_combat",
      "description": "Fight through the enemies"
    },
    {
      "id": "branch_stealth",
      "condition": "chose_stealth",
      "description": "Sneak past defenses"
    },
    {
      "id": "branch_diplomacy",
      "condition": "chose_diplomacy",
      "description": "Negotiate a peaceful solution"
    }
  ]
}
```

### Outcomes
Final results of the quest based on player actions.

```json
{
  "outcomes": [
    {
      "id": "outcome_complete_victory",
      "name": "Complete Victory",
      "description": "All objectives completed, all NPCs saved",
      "is_default": false
    },
    {
      "id": "outcome_pyrrhic",
      "name": "Pyrrhic Victory",
      "description": "Quest completed but with losses",
      "is_default": true
    },
    {
      "id": "outcome_compromise",
      "name": "Compromise",
      "description": "Negotiated settlement, neither side fully satisfied",
      "is_default": false
    }
  ],
  "default_outcome": "outcome_pyrrhic"
}
```

---

## Failure Conditions

```json
{
  "failure": {
    "on_npc_death": ["protected_npc_id"],
    "time_limit_minutes": 60,
    "on_player_death": false,
    "custom_condition": "village_destroyed",
    "behavior": "fail_permanent"
  }
}
```

Or flat format:
```json
{
  "fail_on_npc_death": ["protected_npc_id"],
  "failure_behavior": "fail_permanent"
}
```

Failure behaviors:
- `fail_permanent` - Quest fails, cannot retry
- `restart_from_checkpoint` - Return to last checkpoint
- `retry_objective` - Retry the failed objective

---

## Journal Configuration

```json
{
  "journal": {
    "entries": [
      {"trigger": "quest_start", "entry": "I've accepted the quest to help the village."},
      {"trigger": "obj_find_evidence_complete", "entry": "I found evidence of the cult's activities."},
      {"trigger": "quest_complete", "entry": "The village is safe once more."},
      {"trigger": "quest_failed", "entry": "I failed to protect the village in time."}
    ],
    "markers": [
      {"location": "target_location", "label": "Investigate Here", "show_when": "quest_start"},
      {"location": "return_location", "label": "Return to Elder", "show_when": "obj_main_complete"}
    ],
    "show_tracker": true
  }
}
```

Journal trigger patterns:
- `quest_start` - When quest begins
- `quest_complete` - When quest successfully ends
- `quest_failed` - When quest fails
- `obj_[id]_complete` - When specific objective completes
- `obj_[id]_failed` - When specific objective fails

---

## Workflow

### Phase 1: Gather Context

**Step 1.1: Identify the Quest Hook**

If creating from narrative docs:
1. Check `docs/narrative/quest-hooks.md` for the quest seed
2. Extract: story purpose, key beats, NPCs involved, rewards
3. Note where it fits in the story arc

**Step 1.2: Identify Quest Type and Scope**

Determine:
- Quest type (main, side, companion, faction, contract)
- Difficulty and recommended level
- Number and complexity of objectives
- Branching requirements
- Integration with other systems (dialogues, encounters)

### Phase 2: Interactive Design

Ask the user targeted questions:

```markdown
## Quest Design: [Quest Name]

**1. Quest Classification**
- Type: main_quest / side_quest / companion_quest / faction_quest / contract
- Difficulty: easy / medium / hard / very_hard
- Recommended Level: [number]

**2. Story Context**
- Quest Giver: [NPC ID]
- Starting Location: [Location ID]
- Brief Description: [1-2 sentences]
- Full Description: [Narrative context]

**3. Objectives**
What must the player do? (List in order)
1. [Objective 1 - type and target]
2. [Objective 2 - type and target]
3. [Objective 3 - type and target]

Are objectives linear (sequential) or parallel (any order)?

**4. Optional/Secondary Objectives**
Are there bonus objectives?
- [ ] None
- [ ] Collect extra items
- [ ] Save optional NPCs
- [ ] Complete under time limit
- [ ] Complete stealthily

**5. Prerequisites**
What's required to start this quest?
- Required quests completed: [list]
- Required level: [number]
- Required flags: [list]
- Other requirements: [describe]

**6. Rewards**
What does the player get?
- Gold: [amount]
- XP: [amount]
- Items: [list]
- Reputation changes: [faction: amount]
- Unlocks: [abilities/content]

**7. Branching**
Does this quest have multiple paths?
- [ ] Single path (linear)
- [ ] 2-3 branches based on approach
- [ ] Complex branching with outcomes

**8. Failure Conditions**
What causes quest failure?
- [ ] No failure possible
- [ ] NPC death fails quest
- [ ] Time limit
- [ ] Custom condition

**9. Related Content**
What dialogues/encounters does this quest use?
- Dialogues: [list IDs - need to be created]
- Encounters: [list IDs - need to be created]
```

**Wait for user response before generating.**

### Phase 3: Quest Generation

**Step 3.1: Validate References**

Before generating:
- Check if referenced NPCs exist (or note they need creation)
- Check if referenced locations exist
- Note dialogues that need to be created
- Note encounters that need to be created

**Step 3.2: Generate Quest File**

Create the complete JSON structure following the schema.

**Step 3.3: Save File**

Save to: `data/quests/[quest_id].json`

### Phase 4: Output Report

```markdown
## Quest Created

**File:** `data/quests/[quest_id].json`
**Type:** [Quest Type]
**Difficulty:** [Difficulty] (Level [X])

### Summary
- **Objectives:** [count] primary, [count] secondary
- **Branches:** [count or "linear"]
- **Outcomes:** [count or "single"]

### Objectives Overview
1. [Primary] [Description] - [Type]
2. [Primary] [Description] - [Type]
3. [Secondary] [Description] - [Type]

### Rewards
- Gold: [amount]
- XP: [amount]
- Items: [list]
- Reputation: [changes]

### Dependencies (Need to Create)
- [ ] Dialogue: [dialogue_id] - [description]
- [ ] Dialogue: [dialogue_id] - [description]
- [ ] Encounter: [encounter_id] - [description]
- [ ] NPC: [npc_id] - [description]

### Integration Notes
- Quest giver: [NPC] at [location]
- Add dialogue reference [dialogue_id] to trigger quest
- Encounters trigger at: [objective triggers]

### Testing Checklist
1. Start quest via dialogue with [NPC]
2. Complete objective 1: [description]
3. Complete objective 2: [description]
4. Verify journal updates correctly
5. Verify rewards granted on completion
```

---

## Quest Templates

### Template: Simple Side Quest (Fetch)

```json
{
  "id": "quest_[name]",
  "name": "[Quest Name]",
  "display_name": "[Display Name]",
  "type": "side_quest",
  "difficulty": "easy",
  "recommended_level": 2,
  "quest_giver_id": "[npc_id]",
  "starting_location_id": "[location_id]",
  "description": {
    "brief": "[Short description - 1-2 sentences]",
    "full": "[Full narrative context - what's happening, why it matters]"
  },
  "designer_notes": "[Internal notes about design intent]",
  "tags": ["side_quest", "fetch", "[theme]"],
  "objectives": [
    {
      "id": "obj_talk_giver",
      "description": "Speak with [NPC]",
      "type": "talk_to_npc",
      "objective_category": "primary",
      "target_npc_id": "[npc_id]",
      "dialogue_id": "[dlg_id]_start"
    },
    {
      "id": "obj_collect",
      "description": "Collect [items] (0/[count])",
      "type": "collect_items",
      "objective_category": "primary",
      "items": [{"item_id": "[item_id]", "quantity": 3}],
      "return_items": true
    },
    {
      "id": "obj_return",
      "description": "Return to [NPC]",
      "type": "talk_to_npc",
      "objective_category": "primary",
      "target_npc_id": "[npc_id]",
      "dialogue_id": "[dlg_id]_complete"
    }
  ],
  "objective_flow": "linear",
  "prerequisites": {
    "min_level": 1
  },
  "rewards": {
    "gold": 50,
    "xp": 150,
    "reputation": [{"faction": "[faction]", "change": 10}]
  },
  "dialogues": ["[dlg_id]_start", "[dlg_id]_complete"],
  "journal": {
    "entries": [
      {"trigger": "quest_start", "entry": "[Journal text when quest starts]"},
      {"trigger": "quest_complete", "entry": "[Journal text when quest ends]"}
    ],
    "markers": [
      {"location": "[target_location]", "label": "[Marker text]", "show_when": "obj_talk_giver_complete"}
    ],
    "show_tracker": true
  },
  "_metadata": {
    "version": 1,
    "last_modified": "[date]",
    "author": "Quest Designer Skill",
    "validation_status": "not_validated",
    "campaign_id": "[campaign_id]"
  }
}
```

**CRITICAL:** The `campaign_id` field is REQUIRED for editor filtering. Without it, the quest won't appear in the Quest Designer when filtering by campaign.

### Template: Combat Quest (Kill Enemies)

```json
{
  "id": "quest_[name]",
  "name": "[Quest Name]",
  "display_name": "[Display Name]",
  "type": "side_quest",
  "difficulty": "medium",
  "recommended_level": 4,
  "quest_giver_id": "[npc_id]",
  "starting_location_id": "[location_id]",
  "description": {
    "brief": "[Short description]",
    "full": "[Full narrative - why enemies need killing, what's at stake]"
  },
  "designer_notes": "[Combat-focused quest notes]",
  "tags": ["combat", "elimination", "[enemy_type]"],
  "objectives": [
    {
      "id": "obj_accept",
      "description": "Accept the bounty from [NPC]",
      "type": "talk_to_npc",
      "objective_category": "primary",
      "target_npc_id": "[npc_id]",
      "dialogue_id": "[dlg_id]_start"
    },
    {
      "id": "obj_travel",
      "description": "Travel to [location]",
      "type": "reach_location",
      "objective_category": "primary",
      "target_location_id": "[target_location]"
    },
    {
      "id": "obj_kill",
      "description": "Eliminate the [enemies] (0/[count])",
      "type": "kill_enemies",
      "objective_category": "primary",
      "kill_target_type": "[enemy_type]",
      "kill_count": 5,
      "kill_area_restriction": "[location_id]",
      "must_kill_all": false
    },
    {
      "id": "obj_return",
      "description": "Report back to [NPC]",
      "type": "talk_to_npc",
      "objective_category": "primary",
      "target_npc_id": "[npc_id]",
      "dialogue_id": "[dlg_id]_complete"
    }
  ],
  "objective_flow": "linear",
  "prerequisites": {
    "min_level": 3
  },
  "rewards": {
    "gold": 150,
    "xp": 400,
    "items": [{"item_id": "[reward_item]", "quantity": 1}]
  },
  "encounters": [
    {"trigger": "obj_travel_complete", "encounter_id": "[encounter_id]"}
  ],
  "dialogues": ["[dlg_id]_start", "[dlg_id]_complete"],
  "journal": {
    "entries": [
      {"trigger": "quest_start", "entry": "[Journal entry]"},
      {"trigger": "obj_kill_complete", "entry": "[Progress entry]"},
      {"trigger": "quest_complete", "entry": "[Completion entry]"}
    ],
    "markers": [
      {"location": "[target_location]", "label": "[Enemy Location]", "show_when": "obj_accept_complete"}
    ],
    "show_tracker": true
  },
  "_metadata": {
    "version": 1,
    "last_modified": "[date]",
    "author": "Quest Designer Skill",
    "validation_status": "not_validated",
    "campaign_id": "[campaign_id]"
  }
}
```

### Template: Companion Quest

```json
{
  "id": "companion_[name]_[topic]",
  "name": "[Companion]'s [Quest Theme]",
  "display_name": "[Display Name]",
  "type": "companion_quest",
  "difficulty": "medium",
  "recommended_level": 6,
  "quest_giver_id": "companion_[name]",
  "starting_location_id": "camp",
  "description": {
    "brief": "Help [Companion] [brief goal].",
    "full": "[Full narrative about companion's personal story and stakes]"
  },
  "designer_notes": "Companion loyalty quest. Completing unlocks [reward]. Three resolutions: [list approaches].",
  "tags": ["companion", "[companion_name]", "personal_story", "loyalty"],
  "objectives": [
    {
      "id": "obj_talk_companion",
      "description": "Speak with [Companion] about their past",
      "type": "talk_to_npc",
      "objective_category": "primary",
      "target_npc_id": "companion_[name]",
      "dialogue_id": "[companion]_confession"
    },
    {
      "id": "obj_investigate",
      "description": "[Investigation objective]",
      "type": "reach_location",
      "objective_category": "primary",
      "target_location_id": "[target_location]"
    },
    {
      "id": "obj_confront",
      "description": "[Confrontation/resolution objective]",
      "type": "custom",
      "objective_category": "primary",
      "custom_condition": "[condition_flag]"
    },
    {
      "id": "obj_companion_keepsake",
      "description": "Find [Companion]'s [personal item]",
      "type": "collect_items",
      "objective_category": "secondary",
      "items": [{"item_id": "[keepsake_id]", "quantity": 1}]
    },
    {
      "id": "obj_return",
      "description": "Return to [Companion]",
      "type": "talk_to_npc",
      "objective_category": "primary",
      "target_npc_id": "companion_[name]",
      "dialogue_id": "[companion]_resolution"
    }
  ],
  "objective_flow": "linear",
  "prerequisites": {
    "min_level": 5,
    "required_flags": ["[companion]_recruited", "[companion]_trust_high"]
  },
  "rewards": {
    "gold": 200,
    "xp": 600,
    "items": [{"item_id": "[personal_item]", "quantity": 1}],
    "reputation": [{"faction": "companions", "change": 25}],
    "unlocks": ["ability_[companion]_special"]
  },
  "outcomes": [
    {
      "id": "outcome_peace",
      "name": "Found Peace",
      "description": "[Companion] has made peace with their past",
      "is_default": true
    },
    {
      "id": "outcome_revenge",
      "name": "Revenge Taken",
      "description": "[Companion] chose revenge over forgiveness"
    },
    {
      "id": "outcome_unresolved",
      "name": "Unfinished Business",
      "description": "The matter remains unresolved"
    }
  ],
  "fail_on_npc_death": ["companion_[name]"],
  "failure_behavior": "fail_permanent",
  "dialogues": ["[companion]_confession", "[companion]_confrontation", "[companion]_resolution"],
  "encounters": [
    {"trigger": "obj_investigate_complete", "encounter_id": "[encounter_id]"}
  ],
  "journal": {
    "entries": [
      {"trigger": "quest_start", "entry": "[Companion] has finally opened up about their past..."},
      {"trigger": "obj_investigate_complete", "entry": "[Progress entry]"},
      {"trigger": "quest_complete", "entry": "[Companion]'s past has been [resolved/confronted]..."}
    ],
    "markers": [
      {"location": "[target]", "label": "[Marker]", "show_when": "obj_talk_companion_complete"}
    ],
    "show_tracker": true
  },
  "_metadata": {
    "version": 1,
    "last_modified": "[date]",
    "author": "Quest Designer Skill",
    "validation_status": "not_validated",
    "campaign_id": "[campaign_id]"
  }
}
```

### Template: Main Quest (Branching)

```json
{
  "id": "main_[name]",
  "name": "[Quest Name]",
  "display_name": "[Display Name]",
  "type": "main_quest",
  "difficulty": "hard",
  "recommended_level": 8,
  "quest_giver_id": "[npc_id]",
  "starting_location_id": "[location_id]",
  "description": {
    "brief": "[Brief description of main story beat]",
    "full": "[Full narrative context - stakes, background, what this means for the story]"
  },
  "designer_notes": "Main story quest - Act [X]. Multiple paths: [list approaches]. Leads to [next quest/outcome].",
  "tags": ["main_story", "[act]", "[theme]"],
  "objectives": [
    {
      "id": "obj_receive",
      "description": "Learn of [plot point]",
      "type": "talk_to_npc",
      "objective_category": "primary",
      "target_npc_id": "[npc_id]",
      "dialogue_id": "[dlg]_briefing"
    },
    {
      "id": "obj_investigate",
      "description": "Investigate [location/event]",
      "type": "reach_location",
      "objective_category": "primary",
      "target_location_id": "[location]"
    },
    {
      "id": "obj_gather_evidence",
      "description": "Collect evidence",
      "type": "collect_items",
      "objective_category": "primary",
      "items": [
        {"item_id": "evidence_1", "quantity": 1},
        {"item_id": "evidence_2", "quantity": 1}
      ]
    },
    {
      "id": "obj_choose_approach",
      "description": "Decide how to proceed",
      "type": "custom",
      "objective_category": "primary",
      "condition": "approach_chosen"
    },
    {
      "id": "obj_execute",
      "description": "Confront [antagonist/situation]",
      "type": "custom",
      "objective_category": "primary",
      "condition": "confrontation_complete"
    },
    {
      "id": "obj_save_innocents",
      "description": "Rescue the prisoners",
      "type": "keep_alive",
      "objective_category": "secondary",
      "npc_id": "prisoners",
      "duration": "entire_quest"
    },
    {
      "id": "obj_report",
      "description": "Report the outcome",
      "type": "talk_to_npc",
      "objective_category": "primary",
      "target_npc_id": "[npc_id]",
      "dialogue_id": "[dlg]_conclusion"
    }
  ],
  "objective_flow": "linear",
  "branches": [
    {
      "id": "branch_combat",
      "condition": "chose_combat",
      "description": "Fight through the opposition"
    },
    {
      "id": "branch_stealth",
      "condition": "chose_stealth",
      "description": "Infiltrate without detection"
    },
    {
      "id": "branch_diplomacy",
      "condition": "chose_diplomacy",
      "description": "Negotiate a resolution"
    }
  ],
  "outcomes": [
    {
      "id": "outcome_victory",
      "name": "Complete Victory",
      "description": "All objectives completed, innocents saved",
      "is_default": false
    },
    {
      "id": "outcome_pyrrhic",
      "name": "Pyrrhic Victory",
      "description": "Main objective complete but with losses",
      "is_default": true
    },
    {
      "id": "outcome_compromise",
      "name": "Compromise",
      "description": "Negotiated settlement with trade-offs"
    }
  ],
  "default_outcome": "outcome_pyrrhic",
  "prerequisites": {
    "required_quests": ["main_previous_quest"],
    "character": {"min_level": 6}
  },
  "rewards": {
    "base": {
      "gold": 500,
      "xp": 1200,
      "items": [{"item_id": "story_reward", "quantity": 1}],
      "reputation": [{"faction": "main_faction", "change": 50}]
    },
    "conditional": {
      "all_optional": {
        "gold": 200,
        "xp": 300,
        "items": [{"item_id": "bonus_reward", "quantity": 1}]
      }
    },
    "outcome_based": {
      "outcome_victory": {"gold": 750, "xp": 1500},
      "outcome_pyrrhic": {"gold": 500, "xp": 1200},
      "outcome_compromise": {"gold": 400, "xp": 1000}
    }
  },
  "encounters": [
    {"trigger": "obj_investigate_complete", "encounter_id": "patrol_encounter"},
    {"trigger": "obj_execute", "encounter_id": "boss_encounter"}
  ],
  "dialogues": ["[dlg]_briefing", "[dlg]_confrontation", "[dlg]_conclusion"],
  "journal": {
    "entries": [
      {"trigger": "quest_start", "entry": "[Opening journal entry]"},
      {"trigger": "obj_investigate_complete", "entry": "[Discovery entry]"},
      {"trigger": "obj_gather_evidence_complete", "entry": "[Evidence found entry]"},
      {"trigger": "quest_complete", "entry": "[Resolution entry based on outcome]"}
    ],
    "markers": [
      {"location": "[location_1]", "label": "[Label]", "show_when": "quest_start"},
      {"location": "[location_2]", "label": "[Label]", "show_when": "obj_investigate_complete"}
    ],
    "show_tracker": true
  },
  "_metadata": {
    "version": 1,
    "last_modified": "[date]",
    "author": "Quest Designer Skill",
    "validation_status": "not_validated",
    "campaign_id": "[campaign_id]"
  }
}
```

### Template: Contract (Repeatable)

```json
{
  "id": "contract_[name]",
  "name": "[Contract Name]",
  "display_name": "[Display Name]",
  "type": "contract",
  "difficulty": "medium",
  "recommended_level": 3,
  "quest_giver_id": "[contract_board_or_npc]",
  "starting_location_id": "[location_id]",
  "description": {
    "brief": "[Short bounty/contract description]",
    "full": "[Details about the contract, why it's posted, payment terms]"
  },
  "designer_notes": "Repeatable contract. Cooldown: [X] days.",
  "tags": ["contract", "repeatable", "[type]"],
  "objectives": [
    {
      "id": "obj_accept",
      "description": "Accept the contract",
      "type": "talk_to_npc",
      "objective_category": "primary",
      "target_npc_id": "[npc_id]",
      "dialogue_id": "[dlg]_accept"
    },
    {
      "id": "obj_complete_task",
      "description": "[Task description]",
      "type": "[appropriate_type]",
      "objective_category": "primary"
    },
    {
      "id": "obj_claim_reward",
      "description": "Claim your payment",
      "type": "talk_to_npc",
      "objective_category": "primary",
      "target_npc_id": "[npc_id]",
      "dialogue_id": "[dlg]_complete"
    }
  ],
  "objective_flow": "linear",
  "is_repeatable": true,
  "repeat_cooldown_days": 3,
  "prerequisites": {
    "min_level": 2
  },
  "rewards": {
    "gold": 75,
    "xp": 200
  },
  "dialogues": ["[dlg]_accept", "[dlg]_complete"],
  "journal": {
    "entries": [
      {"trigger": "quest_start", "entry": "Accepted contract: [description]"},
      {"trigger": "quest_complete", "entry": "Contract completed. Payment collected."}
    ],
    "show_tracker": true
  },
  "_metadata": {
    "version": 1,
    "last_modified": "[date]",
    "author": "Quest Designer Skill",
    "validation_status": "not_validated",
    "campaign_id": "[campaign_id]"
  }
}
```

---

## Quest-Dialogue Integration (CRITICAL)

**Every quest MUST have associated dialogues that start and complete it.**

When creating a quest, you MUST also ensure dialogues are created that:
1. **Start the quest** via a `Quest` node with `quest_action: "Start"`
2. **Complete the quest** via a `Quest` node with `quest_action: "Complete"`
3. **Update the quest** (optional) via `Quest` nodes with `quest_action: "Update"`

### Required Dialogue Pattern for Quest Givers

For a quest-giving NPC dialogue, the dialogue MUST include:
- A **Speaker** node where NPC explains the quest
- **Individual Choice** nodes for player responses (NOT a `choices` array!)
- A **Quest** node that triggers `quest_action: "Start"`
- A **Branch** node to check if quest is already complete

**Example Quest-Giver Dialogue Flow:**
```
Start
  ↓
Branch: has_flag("[quest_id]_completed")
  ├── TRUE → Speaker: "Thanks for your help!" → End
  └── FALSE
        ↓
      Speaker: "[Quest explanation]"
        ↓
      ┌─────────────────────────────┐
      │ Multiple Choice nodes:       │
      │ Choice_accept: "I'll help"   │
      │ Choice_reward: "What's in it?│
      │ Choice_decline: "Not now"    │
      └─────────────────────────────┘
        │
      Choice_accept → Quest (Start) → End
```

### ⚠️ CRITICAL: Choice Node Pattern

**DO NOT use `choices` array in dialogue files!**

The dialogue runtime expects individual Choice nodes with their own `text` property:

```json
// ✅ CORRECT - Individual Choice nodes
{"id": "Choice_help", "type": "Choice", "position_x": 0, "position_y": 450, "text": "I'll help you."},
{"id": "Choice_reward", "type": "Choice", "position_x": 200, "position_y": 450, "text": "What's the pay?"},
{"id": "Choice_decline", "type": "Choice", "position_x": 400, "position_y": 450, "text": "Not interested."}
```

```json
// ❌ WRONG - This will show "[1]" instead of text!
{"id": "Choice_options", "type": "Choice", "choices": [
  {"text": "I'll help", "next": "..."},
  {"text": "What's the pay?", "next": "..."}
]}
```

### Quest-Dialogue Reference Table

When creating a quest, list the dialogues it needs:

| Dialogue ID | Purpose | NPC | Quest Action |
|-------------|---------|-----|--------------|
| `dlg_[npc]_quest_start` | Gives the quest | Quest giver | Start |
| `dlg_[npc]_quest_progress` | Mid-quest check-in | Quest giver | Update |
| `dlg_[npc]_quest_complete` | Turns in the quest | Quest giver | Complete |

### After Creating a Quest

**ALWAYS remind the user to create associated dialogues:**

```markdown
### Dependencies to Create

The following dialogues MUST be created for this quest to work:

- [ ] **`dlg_[npc]_[quest]_start`** - Quest giver dialogue (includes Quest → Start node)
- [ ] **`dlg_[npc]_[quest]_complete`** - Quest completion dialogue (includes Quest → Complete node)

Use the `dialogue-designer` skill to create these dialogues.
**Remember:** Use individual Choice nodes, NOT a choices array!
```

---

## Integration with Other Skills

| Skill | Relationship |
|-------|--------------|
| **game-ideator** | Provides design-pillars.md for scope and tone |
| **narrative-architect** | Reads quest-hooks.md for quest seeds |
| **world-builder** | Locations referenced must exist or be created |
| **character-creator** | NPCs/enemies referenced must exist or be created |
| **dialogue-designer** | **Quest dialogues MUST be created** - use Quest nodes to start/complete |
| **encounter-designer** | Quest encounters must be created separately |
| **campaign-creator** | Assembles quests into final campaign |

### Workflow Paths

**Incremental Path (Recommended for D&D Import):**
```
game-ideator → narrative-architect → quest-designer → dialogue-designer
                                                    → encounter-designer
                                   ↓
                            campaign-creator (assembles all)
```

Use this path when:
- Converting a D&D adventure piece by piece
- Creating a campaign from scratch incrementally
- You want full control over each piece of content

**Bulk Path (Rapid Generation):**
```
test-campaign-generator → test-campaign-scaffolder
(creates spec)            (creates all files)
```

Use this path when:
- You need a complete test campaign quickly
- You have a well-defined specification
- You want all content generated at once

---

## Common Patterns

### Quest Chain (Sequential)
```json
{
  "prerequisites": {
    "required_quests": ["previous_quest_id"]
  }
}
```

### Mutually Exclusive Quests
```json
{
  "prerequisites": {
    "blocked_by_quests": ["other_path_quest"]
  }
}
```

### Time-Sensitive Quest
```json
{
  "failure": {
    "time_limit_minutes": 30,
    "behavior": "fail_permanent"
  }
}
```

### Quest with Escort Failure
```json
{
  "fail_on_npc_death": ["escort_npc_id"],
  "failure_behavior": "restart_from_checkpoint"
}
```

---

## Example Invocations

### From Scratch
- "Create a side quest about clearing rats from a cellar"
- "Design main quest MQ03: The Frame from quest-hooks.md"
- "Generate Mira's companion quest about her military past"
- "Create a bounty contract for wolf pelts"
- "I need a faction quest for the Merchant Guild"

### D&D/Tabletop Import
- "Convert the Goblin Arrows quest from Dragons of Icespire Peak"
- "Import the Dwarven Excavation quest from my D&D campaign"
- "Create a CRPG quest from this D&D adventure hook: [description]"
- "Translate the Umbrage Hill quest for the CRPG engine"
- "Import all starting quests from Dragons of Icespire Peak"

---

## Checklist Before Completing

- [ ] Read quest-hooks.md if implementing a documented hook
- [ ] Asked clarifying questions about objectives/rewards/branches
- [ ] Generated valid JSON structure conforming to schema
- [ ] All objectives have unique IDs
- [ ] Objective flow matches intended structure
- [ ] Prerequisites are appropriate for quest difficulty
- [ ] Rewards are balanced for difficulty/length
- [ ] Journal entries cover major quest states
- [ ] **`_metadata.campaign_id` is set** (CRITICAL for editor filtering!)
- [ ] Saved to `data/quests/[id].json`
- [ ] Listed dialogues/encounters that need creation
- [ ] Provided integration notes

---

## Troubleshooting

### Issue: Quest doesn't appear available
**Check:**
1. Prerequisites are met (quests completed, flags set, level)
2. Quest giver NPC has dialogue that starts quest
3. Quest isn't blocked by `blocked_by_quests`

### Issue: Objectives don't complete
**Check:**
1. Objective type matches intended behavior
2. Target IDs (npc_id, location_id, item_id) are correct
3. For custom objectives, condition flag is being set

### Issue: Rewards not granted
**Check:**
1. Quest status changes to "completed"
2. Reward structure is valid (flat or nested, not mixed incorrectly)
3. For outcome-based rewards, outcome is being set

### Issue: Journal not updating
**Check:**
1. Journal trigger strings match exactly (quest_start, obj_[id]_complete)
2. Journal entries array is properly formatted
3. show_tracker is set to true

### Issue: Branches don't work
**Check:**
1. Branch condition flags are being set by dialogues/encounters
2. Branch IDs are unique
3. Objectives reference correct branch conditions
