# Encounter Designer Skill

This skill creates **encounter data files (.json)** that define combat encounters, boss fights, ambushes, and other challenge events. It generates balanced encounters with appropriate enemies, rewards, and conditions that integrate with quests and the world.

**IMPORTANT:** This skill generates encounter files that conform to the official schema at:
`crpg_engine/schemas/encounter_schema.json`

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
                    │   • character-profiles.md   │
                    │   • quest-hooks.md          │
                    └─────────────────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ WORLD           │    │ CHARACTER       │    │ QUEST           │
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
         │ DIALOGUE        │       │ ENCOUNTER       │  ◄── THIS SKILL
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
             character-creator (enemies) → encounter-designer → ...

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
| Create .json encounter files             | Create enemy character files            |
| Define enemy composition and positioning | (use character-creator for that)        |
|                                          |                                          |
| Set victory/defeat conditions            | Create quest files                      |
| Configure environmental hazards          | (use quest-designer for that)           |
|                                          |                                          |
| Define rewards (gold, XP, loot)          | Create dialogue files                   |
| Set trigger conditions                   | (use dialogue-designer for that)        |
|                                          |                                          |
| Configure boss phases and behaviors      | Create location/worldmap files          |
| Link dialogues for intro/victory scenes  | (use world-map-builder for that)        |
|                                          |                                          |
| Save encounter files to data/encounters/ | Scaffold entire campaigns               |
|                                          | (use test-campaign-scaffolder for that) |
+------------------------------------------+------------------------------------------+
```

---

## When to Use This Skill

Invoke this skill when the user:
- Says "create encounter for [quest/location]" or "design a combat encounter"
- Asks to "generate a boss fight for [enemy/location]"
- Says "use encounter-designer"
- Wants to create ambushes, random encounters, or scripted battles
- Needs combat encounters referenced by quests

**DO NOT use this skill if:**
- User wants to create enemy characters (use character-creator)
- User wants to create quests (use quest-designer)
- User wants to create dialogues (use dialogue-designer)

---

## Prerequisites

Before running this skill, check for:

1. **Enemy characters** (required):
   - Enemy .char files must exist in `data/characters/enemies/`
   - Check for enemy IDs that will be used in the encounter

2. **Quest context** (if quest-linked):
   - Quest file should exist or be planned
   - Know the objective that triggers this encounter

3. **Location context** (recommended):
   - Location ID where encounter occurs
   - Understanding of the environment for hazards/terrain

If enemy characters don't exist, note them as dependencies to be created.

---

## Phase 0: Input Mode Selection

**ALWAYS start by asking how the user wants to provide encounter information:**

```markdown
## Encounter Designer Session

How would you like to define your encounter(s)?

**Input Mode:**
- [ ] **Quest-linked** - Create an encounter for a specific quest objective
- [ ] **Location-based** - Design encounters for a specific location/area
- [ ] **Enemy-focused** - Build an encounter around specific enemies or a boss
- [ ] **Type-based** - Create a specific encounter type (ambush, wave defense, etc.)
- [ ] **D&D/Tabletop Import** - Translate encounters from D&D or other tabletop modules
- [ ] **Random Table** - Generate random encounter tables for a region

Select your preferred input mode to continue.
```

**Wait for user response before proceeding to the appropriate phase.**

---

## Phase 0-DND: D&D/Tabletop Encounter Import

**If user selects D&D/Tabletop Import:**

```markdown
## D&D Encounter Import

I'll help you translate D&D encounters into CRPG engine format.

**Source Information:**
1. What D&D module/adventure are these encounters from?
2. Do you have specific encounter descriptions to translate?
3. What's the expected party level in D&D terms?

**Provide encounter details:**
- Copy/paste the encounter description from your module
- OR describe the encounter setup (enemies, location, conditions)
- OR list monster names and quantities
```

### D&D to CRPG Encounter Translation

| D&D Element | CRPG Equivalent | Conversion Notes |
|-------------|-----------------|------------------|
| Monster name | `enemy_id` reference | Create .char file first via character-creator |
| Number of creatures | `count` in enemies array | Direct mapping |
| Challenge Rating (CR) | `difficulty` + level_range | See CR conversion table |
| Lair actions | `environment.hazards` | As periodic effects |
| Legendary actions | `boss.phases[].abilities` | As boss phase abilities |
| Terrain/cover | `environment.terrain_effects` | As modifiers |
| Treasure | `rewards.items` | Convert to CRPG items |
| XP reward | `rewards.experience` | CR × 100 base |

### CR to Difficulty Conversion

| D&D CR | Party Level | CRPG Difficulty | Level Range |
|--------|-------------|-----------------|-------------|
| CR 1/8 - 1/4 | 1 | `trivial` | min: 1, max: 1 |
| CR 1/2 - 1 | 1-2 | `easy` | min: 1, max: 2 |
| CR 2-3 | 2-4 | `normal` | min: 2, max: 4 |
| CR 4-5 | 4-6 | `hard` | min: 4, max: 6 |
| CR 6-8 | 6-8 | `deadly` | min: 5, max: 8 |
| CR 9+ | 8+ | `nightmare` | min: 7, max: 10 |

### D&D Monster to CRPG Enemy Mapping

Common D&D monsters and their CRPG equivalents:

| D&D Monster | CRPG Enemy ID | Type | Notes |
|-------------|---------------|------|-------|
| Skeleton | `enemy_skeleton_warrior` | undead | Basic melee |
| Skeleton Archer | `enemy_skeleton_archer` | undead | Ranged |
| Zombie | `enemy_zombie` | undead | Slow, tough |
| Bandit | `enemy_bandit_thug` | humanoid | Basic melee |
| Bandit Captain | `enemy_bandit_captain` | humanoid | Leader type |
| Orc | `enemy_orc_warrior` | humanoid | Aggressive |
| Orc War Chief | `enemy_orc_warchief` | humanoid | Boss type |
| Wolf | `enemy_wolf` | beast | Pack tactics |
| Dire Wolf | `enemy_dire_wolf` | beast | Larger, tougher |
| Manticore | `enemy_manticore` | monstrosity | Boss, ranged + melee |
| Dragon (Young) | `enemy_young_dragon` | dragon | Major boss |
| Dragon (Adult) | `enemy_adult_dragon` | dragon | End-game boss |

**Note:** If the D&D monster doesn't have a CRPG equivalent, use character-creator first to create the enemy .char file.

### Dragons of Icespire Peak Encounter Examples

| D&D Encounter | CRPG ID | Enemies | Difficulty | Location |
|---------------|---------|---------|------------|----------|
| Dwarven Excavation - Ochre Jellies | `enc_dwarven_excavation_jellies` | 2× ochre_jelly | normal | loc_dwarven_excavation |
| Gnomengarde - Mimics | `enc_gnomengarde_mimics` | 2× mimic | hard | loc_gnomengarde |
| Umbrage Hill - Manticore | `enc_umbrage_hill_manticore` | 1× manticore | hard | loc_umbrage_hill |
| Mountain's Toe - Wererats | `enc_mountains_toe_wererats` | 4× wererat | normal | loc_mountains_toe |
| Axeholm - Banshee | `enc_axeholm_banshee` | 1× banshee | deadly | loc_axeholm |
| Dragon Barrow - Undead | `enc_dragon_barrow_undead` | 6× skeleton, 2× ghoul | hard | loc_dragon_barrow |
| Icespire Hold - Cryovain | `enc_cryovain_boss` | 1× young_white_dragon | deadly | loc_icespire_hold |

### D&D Condition to CRPG Effect Mapping

| D&D Condition | CRPG Effect | Duration |
|---------------|-------------|----------|
| Frightened | `fear` | turns or until save |
| Poisoned | `poison` | turns with damage |
| Paralyzed | `stun` | turns or until save |
| Prone | `knockdown` | until stand action |
| Restrained | `immobilize` | turns or until escape |
| Blinded | `blind` | turns or until cure |

---

## Input

The skill accepts encounter requests in several forms:

1. **Quest-linked**: "Create the ambush encounter for MQ03"
2. **Location-based**: "Design a random encounter for the forest road"
3. **Enemy-focused**: "Create a boss fight with the Shadow Guardian"
4. **Type-based**: "I need a defense encounter with waves of enemies"

---

## Output

### File Location
`data/encounters/[encounter_id].json`

### Naming Conventions
- Quest encounters: `enc_[quest_id]_[description].json`
- Boss encounters: `enc_[boss_name]_boss.json`
- Random encounters: `enc_[location]_random.json`
- Ambush encounters: `enc_[location]_ambush.json`
- Wave/Defense: `enc_[location]_wave_[number].json`

---

## Schema Reference

**Schema:** `crpg_engine/schemas/encounter_schema.json`

### Required Top-Level Fields

```json
{
  "id": "encounter_id",           // Unique identifier (lowercase, underscores)
  "display_name": "Display Name", // Name shown to players
  "encounter_type": "combat"      // Type of encounter
}
```

### Encounter Types

| Type | Use Case | Typical Settings |
|------|----------|------------------|
| `combat` | Standard fight | Normal victory/defeat |
| `boss` | Major enemy battle | Special conditions, phases |
| `ambush` | Surprise attack | Enemy advantage, positioning |
| `trap` | Environmental danger | Hazards, skill checks |
| `puzzle` | Non-combat challenge | Custom victory conditions |
| `event` | Scripted sequence | Dialogue-heavy, choices |
| `scripted` | Cutscene battle | Fixed outcomes possible |
| `environmental` | Nature/hazard focus | Survival conditions |
| `social` | Social confrontation | Dialogue resolution possible |

### Difficulty Levels

| Level | Description | Enemy Strength | Typical Level Range |
|-------|-------------|----------------|---------------------|
| `trivial` | Tutorial/warmup | Very weak | 1 below party |
| `easy` | Low challenge | Slightly weak | Party level |
| `normal` | Standard fight | Balanced | Party level |
| `hard` | Significant challenge | Strong | Party level +1 |
| `deadly` | High risk of failure | Very strong | Party level +2 |
| `nightmare` | Extreme challenge | Overwhelming | Party level +3 |
| `scaled` | Adjusts to party | Dynamic | Varies |

---

## Enemy Entry Definition

```json
{
  "character_id": "enemy_id",      // Reference to .char file
  "count": 3,                      // Fixed count
  "count_range": {"min": 2, "max": 4}, // OR random range
  "level_offset": 0,               // Level adjustment (-2 to +3 typical)
  "position": "front",             // Starting position
  "behavior": "aggressive",        // AI behavior
  "is_leader": false,              // Is this the encounter leader?
  "is_optional": false,            // Required for victory?
  "spawn_condition": {             // Conditional spawn
    "leader_health_below": 0.5
  }
}
```

### Position Values

| Position | Description |
|----------|-------------|
| `front` | Front line, first engaged |
| `back` | Back line, protected |
| `flank_left` | Left flank position |
| `flank_right` | Right flank position |
| `random` | Random placement |
| `ambush` | Hidden until triggered |

### Behavior Values

| Behavior | Description |
|----------|-------------|
| `aggressive` | Prioritizes attacking, pursues |
| `defensive` | Protects self and allies |
| `support` | Focuses on buffs/heals |
| `flee_when_hurt` | Retreats at low HP |
| `protect_leader` | Guards the leader enemy |

---

## Ally Entry Definition

For encounters where NPCs fight alongside the party:

```json
{
  "character_id": "ally_npc_id",
  "permanent": false,              // Joins party permanently after?
  "must_survive": true             // Death causes encounter failure?
}
```

---

## Trigger Conditions

Define when/how the encounter activates:

```json
{
  "trigger_conditions": {
    "quest_active": "quest_id",        // Quest must be active
    "quest_complete": "quest_id",      // Quest must be completed
    "objective_active": "obj_id",      // Specific objective active
    "objective_complete": "obj_id",    // Specific objective complete
    "flag_set": ["flag1", "flag2"],    // Flags that must be set
    "flag_not_set": ["blocked_flag"],  // Flags that must NOT be set
    "time_of_day": ["night", "dusk"],  // Required time
    "weather": ["rain", "storm"],      // Required weather
    "party_size_min": 2,               // Minimum party members
    "party_level_min": 3,              // Minimum average level
    "random_chance": 0.25,             // 25% chance to trigger
    "cooldown": 120,                   // Minutes between repeats
    "max_occurrences": 3               // Maximum times this can occur
  }
}
```

---

## Victory Conditions

```json
{
  "victory": {
    "defeat_all_enemies": true,        // Must kill all enemies
    "defeat_leader": false,            // Only need to kill leader
    "survive_turns": 5,                // Survive X turns to win
    "reach_location": "exit_point",    // Reach map location
    "protect_target": "npc_id",        // Keep NPC alive
    "custom": "script_condition"       // Custom script condition
  }
}
```

### Common Victory Patterns

| Pattern | Configuration |
|---------|---------------|
| Standard combat | `defeat_all_enemies: true` |
| Boss kill | `defeat_leader: true, defeat_all_enemies: false` |
| Survival | `survive_turns: X` |
| Escort | `protect_target: "npc_id"` + reach location |
| Escape | `reach_location: "exit"` |

---

## Defeat Conditions

```json
{
  "defeat": {
    "party_wipe": true,               // All party members fall
    "protagonist_death": false,       // Main character death = loss
    "npc_death": "protected_npc",     // Specific NPC death = loss
    "time_limit": 10,                 // Fail after X turns
    "custom": "script_condition"      // Custom script condition
  }
}
```

---

## Rewards Definition

```json
{
  "rewards": {
    "gold": 150,
    "xp": 400,
    "loot_table": "bandit_loot",       // Random loot table ID
    "guaranteed_items": [
      {"item_id": "boss_key", "quantity": 1},
      {"item_id": "health_potion", "quantity": 2}
    ],
    "reputation": [
      {"faction": "village", "change": 10},
      {"faction": "bandits", "change": -20}
    ],
    "unlock_abilities": ["ability_id"],
    "bonus_conditions": [
      {
        "condition": "no_party_deaths",
        "gold_bonus": 50,
        "xp_bonus": 100,
        "item_bonus": "bonus_item_id"
      },
      {
        "condition": "under_3_turns",
        "xp_bonus": 150
      }
    ]
  }
}
```

### Bonus Condition Types

| Condition | Description |
|-----------|-------------|
| `no_party_deaths` | No party members fell |
| `under_X_turns` | Completed in X turns or less |
| `no_items_used` | No consumables used |
| `no_damage_taken` | Perfect run |
| `stealth_approach` | Started from stealth |

---

## Environment Settings

```json
{
  "environment": {
    "terrain": "difficult",           // Terrain type
    "lighting": "dim",                // Lighting conditions
    "hazards": [
      {
        "type": "fire",
        "damage": 10,
        "interval": 2,
        "positions": ["northwest", "center"]
      }
    ],
    "cover_positions": ["pillar_1", "crate_stack"],
    "escape_route": true              // Can party flee?
  }
}
```

### Terrain Types

| Terrain | Effect |
|---------|--------|
| `normal` | No movement penalty |
| `difficult` | Reduced movement speed |
| `water` | Swimming required, penalties |
| `lava` | Damage when traversed |
| `ice` | Slippery, chance to fall |
| `mud` | Heavy movement penalty |
| `sand` | Light movement penalty |

### Lighting Types

| Lighting | Effect |
|----------|--------|
| `bright` | Full visibility |
| `normal` | Standard visibility |
| `dim` | Reduced perception |
| `dark` | Heavily obscured |
| `magical_darkness` | Darkvision doesn't help |

### Hazard Types

| Hazard | Description |
|--------|-------------|
| `fire` | Burns, damage over time |
| `poison_gas` | Poison damage, debuffs |
| `falling_rocks` | Random falling damage |
| `lightning` | Periodic lightning strikes |
| `freezing` | Cold damage, slow |
| `spikes` | Ground traps |

---

## Dialogue Hooks

Connect dialogues to encounter events:

```json
{
  "dialogue": {
    "intro": "dialogue_id",           // Before combat starts
    "victory": "dialogue_id",         // After winning
    "defeat": "dialogue_id",          // After losing (if not game over)
    "surrender_offer": "dialogue_id", // If enemies can surrender
    "mid_combat": [
      {
        "trigger": "enemy_leader_50_health",
        "dialogue_id": "boss_phase2_dialogue"
      },
      {
        "trigger": "turn_5",
        "dialogue_id": "reinforcements_dialogue"
      }
    ]
  }
}
```

### Mid-Combat Triggers

| Trigger Pattern | Description |
|-----------------|-------------|
| `enemy_leader_50_health` | Leader at 50% HP |
| `enemy_leader_25_health` | Leader at 25% HP |
| `ally_death` | Any ally falls |
| `turn_X` | Specific turn number |
| `enemy_count_X` | X enemies remaining |

---

## Flags

```json
{
  "flags_set_on_complete": [
    "encounter_cleared",
    "boss_defeated"
  ],
  "flags_set_on_defeat": [
    "party_lost_battle"
  ]
}
```

---

## Other Settings

```json
{
  "one_time": true,                   // Can only occur once
  "can_flee": true,                   // Party can attempt escape
  "flee_penalty": {
    "gold_loss": 50,
    "item_loss_chance": 0.1
  },
  "scales_with_level": false,         // Enemy levels scale with party
  "music": "res://audio/music/boss.ogg",
  "ambience": "res://audio/ambient/dungeon.ogg",
  "map_scene": "res://scenes/combat/arena.tscn",
  "tags": ["boss", "undead", "act2"],
  "campaign_id": "campaign_name"
}
```

---

## Workflow

### Phase 1: Gather Context

**Step 1.1: Identify the Purpose**

Determine:
- Is this linked to a quest? Which objective triggers it?
- What's the narrative context? (ambush, boss fight, random encounter)
- Where does it occur? (location_id)

**Step 1.2: Identify Enemies**

Check existing enemies in `data/characters/enemies/`:
- List available enemy character IDs
- Note if new enemies need to be created
- Determine appropriate enemy levels

**Step 1.3: Determine Difficulty**

Based on:
- Quest difficulty
- Story importance
- Player level expectations
- Whether it's optional or required

### Phase 2: Interactive Design

Ask the user targeted questions:

```markdown
## Encounter Design: [Encounter Name]

**1. Basic Info**
- Display Name: [name shown to player]
- Type: combat / boss / ambush / trap / event / environmental / social
- Difficulty: trivial / easy / normal / hard / deadly / nightmare
- Level Range: min [X] - max [Y]

**2. Location & Trigger**
- Location ID: [where this occurs]
- Quest Link: [quest_id if applicable]
- Objective Trigger: [objective_id if applicable]
- Other Conditions: [flags, time of day, random chance]

**3. Enemy Composition**
What enemies should appear?
| Enemy ID | Count | Position | Behavior | Leader? |
|----------|-------|----------|----------|---------|
| [enemy_id] | [1-5] | [position] | [behavior] | [yes/no] |

**4. Victory Conditions**
How does the player win?
- [ ] Defeat all enemies
- [ ] Defeat the leader only
- [ ] Survive X turns
- [ ] Reach a location
- [ ] Protect an NPC
- [ ] Custom condition

**5. Defeat Conditions**
What causes failure?
- [ ] Party wipe (default)
- [ ] Protagonist death
- [ ] NPC death
- [ ] Time limit (turns)
- [ ] Custom condition

**6. Environment**
Any special conditions?
- Terrain: normal / difficult / water / etc.
- Lighting: bright / normal / dim / dark
- Hazards: [describe any environmental dangers]
- Can flee? [yes/no]

**7. Rewards**
- Gold: [amount]
- XP: [amount]
- Guaranteed Items: [list]
- Loot Table: [table_id or none]
- Bonus Conditions: [special achievement rewards]

**8. Dialogue Hooks**
Any dialogue during this encounter?
- Intro dialogue: [dialogue_id or none]
- Victory dialogue: [dialogue_id or none]
- Mid-combat triggers: [describe or none]

**9. Flags**
What flags should this set?
- On Victory: [list flags]
- On Defeat: [list flags]
```

**Wait for user response before generating.**

### Phase 3: Encounter Generation

**Step 3.1: Validate Dependencies**

Before generating:
- Verify enemy character_ids exist (or note as dependencies)
- Verify location_id exists (or note as dependency)
- Note any dialogues that need creation

**Step 3.2: Generate Encounter File**

Create the complete JSON structure following the schema.

**Step 3.3: Save File**

Save to: `data/encounters/[encounter_id].json`

### Phase 4: Output Report

```markdown
## Encounter Created

**File:** `data/encounters/[encounter_id].json`
**Type:** [Encounter Type]
**Difficulty:** [Difficulty] (Level [X]-[Y])

### Summary
- **Enemies:** [count] total ([breakdown by type])
- **Leader:** [leader enemy or "none"]
- **Victory:** [condition]
- **Can Flee:** [yes/no]

### Enemy Composition
| Enemy | Count | Position | Behavior |
|-------|-------|----------|----------|
| [name] | [count] | [position] | [behavior] |

### Rewards
- Gold: [amount]
- XP: [amount]
- Items: [list]
- Bonuses: [conditions]

### Dependencies (May Need Creation)
- [ ] Enemy: [enemy_id] - [if doesn't exist]
- [ ] Dialogue: [dialogue_id] - [if referenced]
- [ ] Location: [location_id] - [if doesn't exist]

### Integration Notes
- Triggered by: [quest/objective or conditions]
- Sets flags: [list]
- Link from quest: Add to quest's `encounters` array

### Testing Checklist
1. Verify all enemies load correctly
2. Test victory condition triggers
3. Test defeat condition triggers
4. Verify rewards are granted
5. Check flags are set
6. Test flee mechanics (if enabled)
```

---

## Encounter Templates

### Template: Simple Combat

```json
{
  "_meta": {
    "created": "[date]",
    "modified": "[date]",
    "author": "Encounter Designer Skill",
    "campaign_id": "[campaign_id]",
    "notes": "[design notes]"
  },
  "id": "enc_[name]",
  "display_name": "[Display Name]",
  "description": "[Narrative description of the encounter]",
  "encounter_type": "combat",
  "difficulty": "normal",
  "level_range": {
    "min": 2,
    "max": 4
  },
  "location_id": "[location_id]",
  "enemies": [
    {
      "character_id": "[enemy_id]",
      "count": 3,
      "position": "front",
      "behavior": "aggressive",
      "is_leader": false,
      "is_optional": false
    }
  ],
  "victory": {
    "defeat_all_enemies": true
  },
  "defeat": {
    "party_wipe": true
  },
  "rewards": {
    "gold": 50,
    "xp": 150,
    "loot_table": "[loot_table_id]"
  },
  "one_time": true,
  "can_flee": true,
  "scales_with_level": false,
  "flags_set_on_complete": ["[encounter_id]_cleared"],
  "trigger_conditions": {
    "quest_active": "[quest_id]"
  }
}
```

**CRITICAL:** The `campaign_id` field in `_meta` is REQUIRED for editor filtering. Without it, the encounter won't appear in the Encounter Designer when filtering by campaign.

### Template: Boss Encounter

```json
{
  "_meta": {
    "created": "[date]",
    "modified": "[date]",
    "author": "Encounter Designer Skill",
    "campaign_id": "[campaign_id]",
    "notes": "Boss encounter with phases"
  },
  "id": "enc_[boss_name]_boss",
  "display_name": "[Boss Display Name]",
  "description": "[Epic description of the boss confrontation]",
  "encounter_type": "boss",
  "difficulty": "hard",
  "level_range": {
    "min": 5,
    "max": 8
  },
  "location_id": "[boss_arena_location]",
  "map_scene": "res://scenes/combat/[boss_arena].tscn",
  "enemies": [
    {
      "character_id": "[boss_enemy_id]",
      "count": 1,
      "position": "back",
      "behavior": "aggressive",
      "is_leader": true,
      "is_optional": false
    },
    {
      "character_id": "[minion_enemy_id]",
      "count": 2,
      "position": "front",
      "behavior": "protect_leader",
      "is_leader": false,
      "is_optional": true
    },
    {
      "character_id": "[reinforcement_id]",
      "count_range": {"min": 2, "max": 3},
      "position": "flank_left",
      "behavior": "aggressive",
      "is_optional": true,
      "spawn_condition": {
        "leader_health_below": 0.5
      }
    }
  ],
  "victory": {
    "defeat_leader": true,
    "defeat_all_enemies": false
  },
  "defeat": {
    "party_wipe": true,
    "protagonist_death": true
  },
  "environment": {
    "lighting": "dim",
    "terrain": "normal",
    "hazards": [
      {
        "type": "[hazard_type]",
        "damage": 10,
        "interval": 3,
        "positions": ["northwest", "southeast"]
      }
    ],
    "escape_route": false
  },
  "dialogue": {
    "intro": "[boss_intro_dialogue]",
    "victory": "[boss_victory_dialogue]",
    "mid_combat": [
      {
        "trigger": "enemy_leader_50_health",
        "dialogue_id": "[boss_phase2_dialogue]"
      }
    ]
  },
  "rewards": {
    "gold": 500,
    "xp": 1000,
    "guaranteed_items": [
      {"item_id": "[boss_drop_1]", "quantity": 1},
      {"item_id": "[boss_drop_2]", "quantity": 1}
    ],
    "bonus_conditions": [
      {
        "condition": "no_party_deaths",
        "xp_bonus": 250,
        "item_bonus": "[bonus_item]"
      }
    ]
  },
  "one_time": true,
  "can_flee": false,
  "scales_with_level": false,
  "music": "res://audio/music/boss_battle.ogg",
  "flags_set_on_complete": ["[boss_id]_defeated", "[area]_cleared"],
  "trigger_conditions": {
    "quest_active": "[quest_id]",
    "objective_active": "[objective_id]"
  }
}
```

### Template: Ambush Encounter

```json
{
  "_meta": {
    "created": "[date]",
    "modified": "[date]",
    "author": "Encounter Designer Skill",
    "campaign_id": "[campaign_id]",
    "notes": "Surprise attack encounter"
  },
  "id": "enc_[location]_ambush",
  "display_name": "[Ambush Name]",
  "description": "[Description of the ambush scenario]",
  "encounter_type": "ambush",
  "difficulty": "normal",
  "level_range": {
    "min": 3,
    "max": 5
  },
  "location_id": "[location_id]",
  "enemies": [
    {
      "character_id": "[ambusher_id]",
      "count": 2,
      "position": "ambush",
      "behavior": "aggressive",
      "is_leader": false,
      "is_optional": false
    },
    {
      "character_id": "[ambusher_leader_id]",
      "count": 1,
      "position": "back",
      "behavior": "defensive",
      "is_leader": true,
      "is_optional": false
    }
  ],
  "victory": {
    "defeat_all_enemies": true
  },
  "defeat": {
    "party_wipe": true
  },
  "rewards": {
    "gold": 75,
    "xp": 200,
    "loot_table": "[ambusher_loot]"
  },
  "one_time": true,
  "can_flee": true,
  "flee_penalty": {
    "gold_loss": 25,
    "item_loss_chance": 0.15
  },
  "scales_with_level": false,
  "flags_set_on_complete": ["[ambush_id]_survived"],
  "trigger_conditions": {
    "quest_active": "[quest_id]",
    "flag_not_set": ["[ambush_id]_avoided"]
  }
}
```

### Template: Random/Repeatable Encounter

```json
{
  "_meta": {
    "created": "[date]",
    "modified": "[date]",
    "author": "Encounter Designer Skill",
    "campaign_id": "[campaign_id]",
    "notes": "Random encounter for [area]"
  },
  "id": "enc_[location]_random_[type]",
  "display_name": "[Encounter Name]",
  "description": "[Description of the random encounter]",
  "encounter_type": "combat",
  "difficulty": "easy",
  "level_range": {
    "min": 1,
    "max": 5
  },
  "location_id": "[location_id]",
  "enemies": [
    {
      "character_id": "[common_enemy_id]",
      "count_range": {"min": 2, "max": 4},
      "position": "random",
      "behavior": "aggressive",
      "is_leader": false,
      "is_optional": false
    }
  ],
  "victory": {
    "defeat_all_enemies": true
  },
  "defeat": {
    "party_wipe": true
  },
  "rewards": {
    "xp": 75,
    "loot_table": "[random_loot]"
  },
  "one_time": false,
  "can_flee": true,
  "scales_with_level": true,
  "trigger_conditions": {
    "random_chance": 0.2,
    "time_of_day": ["dusk", "night"],
    "cooldown": 60,
    "max_occurrences": 5
  }
}
```

### Template: Defense/Wave Encounter

```json
{
  "_meta": {
    "created": "[date]",
    "modified": "[date]",
    "author": "Encounter Designer Skill",
    "campaign_id": "[campaign_id]",
    "notes": "Wave-based defense encounter"
  },
  "id": "enc_[location]_defense",
  "display_name": "[Defense Encounter Name]",
  "description": "[Description of what's being defended and why]",
  "encounter_type": "combat",
  "difficulty": "hard",
  "level_range": {
    "min": 4,
    "max": 7
  },
  "location_id": "[location_id]",
  "enemies": [
    {
      "character_id": "[wave1_enemy]",
      "count": 3,
      "position": "front",
      "behavior": "aggressive",
      "is_optional": false,
      "spawn_condition": {"wave": 1}
    },
    {
      "character_id": "[wave2_enemy]",
      "count": 4,
      "position": "flank_left",
      "behavior": "aggressive",
      "is_optional": false,
      "spawn_condition": {"wave": 2, "turn": 3}
    },
    {
      "character_id": "[wave3_leader]",
      "count": 1,
      "position": "back",
      "behavior": "aggressive",
      "is_leader": true,
      "is_optional": false,
      "spawn_condition": {"wave": 3, "turn": 6}
    }
  ],
  "allies": [
    {
      "character_id": "[defended_npc]",
      "permanent": false,
      "must_survive": true
    }
  ],
  "victory": {
    "defeat_all_enemies": true,
    "protect_target": "[defended_npc]"
  },
  "defeat": {
    "party_wipe": true,
    "npc_death": "[defended_npc]"
  },
  "rewards": {
    "gold": 200,
    "xp": 500,
    "guaranteed_items": [
      {"item_id": "[defense_reward]", "quantity": 1}
    ],
    "bonus_conditions": [
      {
        "condition": "no_party_deaths",
        "gold_bonus": 100,
        "xp_bonus": 150
      }
    ]
  },
  "one_time": true,
  "can_flee": false,
  "scales_with_level": false,
  "flags_set_on_complete": ["[location]_defended"],
  "flags_set_on_defeat": ["[location]_fell"],
  "trigger_conditions": {
    "quest_active": "[quest_id]",
    "objective_active": "[defense_objective]"
  }
}
```

### Template: Escort Encounter

```json
{
  "_meta": {
    "created": "[date]",
    "modified": "[date]",
    "author": "Encounter Designer Skill",
    "campaign_id": "[campaign_id]",
    "notes": "Encounter during escort quest"
  },
  "id": "enc_[escort]_attack",
  "display_name": "[Attack on Escort]",
  "description": "[Description of enemies attacking the escorted NPC]",
  "encounter_type": "ambush",
  "difficulty": "normal",
  "level_range": {
    "min": 3,
    "max": 5
  },
  "location_id": "[route_location]",
  "enemies": [
    {
      "character_id": "[attacker_id]",
      "count": 3,
      "position": "ambush",
      "behavior": "aggressive",
      "is_optional": false
    }
  ],
  "allies": [
    {
      "character_id": "[escort_npc]",
      "permanent": false,
      "must_survive": true
    }
  ],
  "victory": {
    "defeat_all_enemies": true,
    "protect_target": "[escort_npc]"
  },
  "defeat": {
    "party_wipe": true,
    "npc_death": "[escort_npc]"
  },
  "rewards": {
    "xp": 175,
    "loot_table": "[attacker_loot]"
  },
  "one_time": true,
  "can_flee": false,
  "flags_set_on_complete": ["escort_attack_repelled"],
  "flags_set_on_defeat": ["[escort_npc]_killed"],
  "trigger_conditions": {
    "quest_active": "[escort_quest]",
    "objective_active": "[escort_objective]"
  }
}
```

---

## Integration with Other Skills

| Skill | Relationship |
|-------|--------------|
| **game-ideator** | Provides tone/setting context from world-bible.md |
| **narrative-architect** | Provides enemy concepts from character-profiles.md |
| **character-creator** | Enemy characters must exist in data/characters/enemies/ |
| **quest-designer** | Quests reference encounters in `encounters` array |
| **dialogue-designer** | Encounter dialogues (intro, victory) need creation |
| **world-builder** | Locations reference encounters in custom_data.encounter |
| **campaign-creator** | Assembles all content into final campaign |
| **test-campaign-scaffolder** | References generated encounters for bulk creation |

### Workflow Paths

**Incremental Content Creation (Piece by Piece):**
```
1. character-creator → Create enemy .char files
2. encounter-designer → Create encounter .json files (THIS SKILL)
3. quest-designer → Create quests that reference encounters
4. dialogue-designer → Create intro/victory dialogues
5. world-builder → Create locations that reference encounters
6. campaign-creator → Assemble into final campaign
```

**Bulk Content Creation (From Specification):**
```
1. test-campaign-generator → Create campaign specification
2. test-campaign-scaffolder → Generate all files including encounters
```

**D&D/Tabletop Import Path:**
```
1. Use Phase 0-DND to translate D&D encounters
2. character-creator → Create missing enemy types
3. encounter-designer → Generate CRPG encounter files
4. Continue with quest/dialogue as needed
```

---

## Balancing Guidelines

### Enemy Count by Difficulty

| Difficulty | vs Party Size 1 | vs Party Size 2 | vs Party Size 3 | vs Party Size 4 |
|------------|-----------------|-----------------|-----------------|-----------------|
| Trivial | 1-2 weak | 2-3 weak | 3-4 weak | 4-5 weak |
| Easy | 2-3 | 3-4 | 4-5 | 5-6 |
| Normal | 3-4 | 4-5 | 5-6 | 6-8 |
| Hard | 4-5 + leader | 5-6 + leader | 6-8 + leader | 8-10 + leader |
| Deadly | 5+ strong | 6+ strong | 8+ strong | 10+ strong |

### Reward Scaling

| Difficulty | Gold (base) | XP (base) |
|------------|-------------|-----------|
| Trivial | 10-25 | 25-50 |
| Easy | 25-50 | 50-100 |
| Normal | 50-100 | 100-200 |
| Hard | 100-250 | 200-400 |
| Deadly | 250-500 | 400-800 |
| Boss | 300-1000 | 500-1500 |

---

## Example Invocations

**Standard Encounters:**
- "Create an encounter for the cellar rats quest"
- "Design a boss fight with the Shadow Guardian"
- "Generate a random wolf encounter for the forest"
- "I need an ambush encounter on the road to the village"
- "Create a wave defense encounter for the bridge"

**D&D/Tabletop Import:**
- "Translate the Manticore encounter from Umbrage Hill"
- "Import the Cryovain dragon fight from Dragons of Icespire Peak"
- "Create CRPG encounters from my D&D module's Chapter 2"
- "Convert this D&D encounter: 4 orcs and 1 orc war chief, CR 3"
- "Translate the Gnomengarde mimic encounters"

---

## Checklist Before Completing

- [ ] Identified purpose and quest link (if applicable)
- [ ] Verified enemy character IDs exist (or noted as dependencies)
- [ ] Asked clarifying questions about composition/rewards/conditions
- [ ] Generated valid JSON structure conforming to schema
- [ ] **`_meta.campaign_id` is set** (CRITICAL for editor filtering!)
- [ ] All enemy entries have valid character_ids
- [ ] Victory and defeat conditions are appropriate
- [ ] Rewards are balanced for difficulty
- [ ] Trigger conditions are correct
- [ ] Saved to `data/encounters/[id].json`
- [ ] Listed dialogues/enemies that need creation
- [ ] Provided integration notes for quest linking

---

## Troubleshooting

### Issue: Encounter doesn't trigger
**Check:**
1. Trigger conditions are met (quest active, flags set)
2. Location_id matches where player is
3. For random encounters, random_chance and cooldown settings
4. max_occurrences hasn't been reached

### Issue: Enemies don't appear
**Check:**
1. character_id matches existing .char file exactly
2. Enemy .char file is in data/characters/enemies/
3. spawn_condition (if used) can be met
4. count or count_range is valid

### Issue: Victory doesn't trigger
**Check:**
1. Victory conditions match actual situation
2. If defeat_leader is true, is_leader is set on an enemy
3. If protect_target set, ally exists with that ID
4. For survive_turns, turn count is correct

### Issue: Rewards not granted
**Check:**
1. rewards object is properly structured
2. Item IDs in guaranteed_items exist
3. loot_table reference is valid
4. bonus_conditions have valid condition strings

### Issue: Dialogue doesn't play
**Check:**
1. dialogue_id references exist in data/dialogue/
2. mid_combat triggers use valid trigger strings
3. Dialogue hooks are in correct format
