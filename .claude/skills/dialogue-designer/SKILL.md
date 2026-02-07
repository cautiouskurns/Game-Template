# Dialogue Designer Skill

This skill creates **dialogue tree files (.dtree)** that match character voices and support narrative goals. It reads character profiles for voice consistency and generates dialogues that integrate with the game's quest and flag systems.

**IMPORTANT:** This skill generates .dtree files that conform to the official schema at:
`crpg_engine/schemas/dialogue_schema.json`

Always reference this schema for the authoritative node type definitions.

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
                    │   • key-scenes.md           │
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
         │ DIALOGUE        │       │ ENCOUNTER       │
         │ DESIGNER        │  ◄──  │ DESIGNER        │
         │ → .dtree files  │  THIS │ → .json files   │
         └─────────────────┘  SKILL└─────────────────┘
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
             game-ideator → narrative-architect → dialogue-designer → ...

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
| Create .dtree dialogue files             | Create character profiles                |
| Match character voices from profiles     | (use narrative-architect for that)       |
|                                          |                                          |
| Generate branching conversations         | Create quest specifications              |
| with conditions and flags                | (use quest-designer for that)            |
|                                          |                                          |
| Integrate skill checks into dialogue     | Create campaign files                    |
| (persuasion, intimidation, etc.)         | (use test-campaign-scaffolder for that)  |
|                                          |                                          |
| Set flags and trigger quests             | Create foundation documents              |
| from dialogue nodes                      | (use game-ideator for that)              |
|                                          |                                          |
| Save .dtree files to data/dialogue/      | Create .char files for NPCs              |
+------------------------------------------+------------------------------------------+
```

---

## When to Use This Skill

Invoke this skill when the user:
- Says "create dialogue for [NPC]" or "write conversation with [character]"
- Asks to "generate a dialogue tree for [scene/quest]"
- Says "use dialogue-designer"
- Wants dialogue that matches a character's established voice
- Needs to create quest-giving or plot-advancing conversations
- Wants branching dialogue with skill checks or conditions

**DO NOT use this skill if:**
- User wants to create character profiles (use narrative-architect)
- User wants to design quests (use quest-designer)
- User wants to scaffold entire campaigns (use test-campaign-scaffolder)

---

## Prerequisites

Before running this skill, check for:

1. **Character profile** (if writing for established character):
   - `docs/narrative/character-profiles.md` (preferred)
   - Or a .char file for the NPC in `data/characters/npcs/`

2. **Narrative context** (optional but recommended):
   - `docs/narrative/key-scenes.md` (for scene context)
   - `docs/narrative/quest-hooks.md` (for quest integration)
   - `docs/design/narrative-bible.md` (for tone guidelines)

If no character profile exists, the skill can still create dialogue but will ask for voice/personality details.

---

## Interactive Workflow

### Phase 0: Input Mode Selection

**ALWAYS start by asking how the user wants to provide dialogue information:**

```markdown
## Dialogue Designer Session

How would you like to define your dialogue?

**Input Mode:**
- [ ] **D&D/Tabletop Import** - I have D&D NPC dialogue or roleplay notes to convert
- [ ] **Character-focused** - Create dialogue for a specific character
- [ ] **Scene-focused** - Create dialogue for a specific scene
- [ ] **Quest-focused** - Create quest-related dialogue (giving, completing)
- [ ] **Interactive Q&A** - Guide me through the process step by step

Select your preferred input mode to continue.
```

**Wait for user response before proceeding to the appropriate phase.**

---

### Phase 0-DND: D&D/Tabletop Dialogue Import

**If user selects D&D/Tabletop import:**

```markdown
## D&D Dialogue Import

Please provide your D&D dialogue or NPC interaction notes.

**Option 1: Adventure Module NPC**
Which NPC from which adventure?
Example: "Harbin Wester from Dragon of Icespire Peak"

**Option 2: NPC Description**
Paste or describe the NPC and their key dialogue:
- NPC name and role
- Key things they say
- Quest they give (if any)
- Information they provide
- Personality/demeanor

**Option 3: Roleplay Notes**
Paste your DM prep notes for NPC conversations:
- What they know
- What they want
- How they react to players
- Key dialogue beats
```

**Wait for user input, then parse and translate:**

```markdown
## Dialogue Translation: [NPC Name]

I've analyzed your D&D NPC. Here's the CRPG engine translation:

### D&D → CRPG Dialogue Mapping

| D&D Element | CRPG Node Type | Notes |
|-------------|----------------|-------|
| NPC speaks | `Speaker` node | speaker: "[npc_id]" |
| Player options | `Choice` node | Multiple responses |
| Ability check | `SkillCheck` node | DC converted: D&D DC × 5 |
| Give quest | `Quest` node | quest_action: "Start" |
| Give item | `Item` node | item_action: "Give" |
| Check inventory | `Item` node | item_action: "Check" |
| Conditional text | `Branch` node | Based on flags/conditions |

### D&D Skill Check Conversion

| D&D Skill | CRPG Skill | DC Conversion |
|-----------|------------|---------------|
| Persuasion | Persuasion | DC × 5 (DC 10 → 50) |
| Intimidation | Intimidation | DC × 5 |
| Deception | Deception | DC × 5 |
| Insight | Insight | DC × 5 |
| Perception | Perception | DC × 5 |
| Athletics | Athletics | DC × 5 |
| Stealth | Stealth | DC × 5 |
| Other | Custom | DC × 5 |

### Dragons of Icespire Peak NPCs

| D&D NPC | CRPG NPC ID | Location | Key Dialogue |
|---------|-------------|----------|--------------|
| Harbin Wester | `npc_harbin_wester` | Phandalin | Quest board, quest giver, cowardly mayor |
| Toblen Stonehill | `npc_toblen` | Stonehill Inn | Rumors, lodging, local news |
| Adabra Gwynn | `npc_adabra` | Umbrage Hill | Healer, manticore quest giver |
| Falcon | `npc_falcon` | Falcon's Lodge | Hunter, introduces dragon threat |
| Don-Jon Raskin | `npc_donjon` | Dwarven Excavation | Nervous prospector, ochre jelly info |

### Translated Dialogue Structure

**Dialogue ID:** `dlg_[npc_id]`
**Purpose:** [Quest giving/Information/etc.]
**Character Voice:** [Translated from D&D description]

**Key Nodes:**
1. Start → Speaker (greeting based on state)
2. Choice (player responses)
3. [Skill checks if applicable]
4. Quest/Item nodes (if applicable)
5. End

**Dependencies to Create:**
- [ ] NPC: [npc_id] → use character-creator
- [ ] Quest: [quest_id] → use quest-designer (if dialogue gives quest)
- [ ] Items: [list] → referenced in dialogue

**Confirm this translation or provide corrections:**
```

**Wait for user confirmation, then proceed to generate the dialogue file.**

### D&D Voice Translation Guide

When converting D&D NPC descriptions to CRPG dialogue:

| D&D Description | CRPG Speech Pattern | Example |
|-----------------|--------------------|---------|
| "Cowardly", "Nervous" | Hesitant, lots of qualifiers | "W-well, I suppose... if you really must..." |
| "Gruff", "Stern" | Short, direct sentences | "Job's on the board. Take it or leave it." |
| "Helpful", "Friendly" | Warm, offers suggestions | "Oh, you're looking for work? Let me help you!" |
| "Mysterious", "Secretive" | Cryptic, deflects questions | "Some things are better left... undiscovered." |
| "Noble", "Formal" | Proper grammar, titles | "I am honored by your presence, adventurers." |
| "Common folk" | Contractions, simple words | "Ain't seen nothing like it before, I tell ya." |

---

## Input

The skill accepts dialogue requests in several forms:

1. **Character-focused**: "Create dialogue for Mira Ashford"
2. **Scene-focused**: "Write the Battlefield Confession dialogue"
3. **Quest-focused**: "Generate quest-giving dialogue for MQ01"
4. **Freeform**: "I need an innkeeper who gives rumors"

---

## Output

### File Location
`data/dialogue/[dialogue_id].dtree`

### File Format (.dtree)

```json
{
  "version": 1,
  "metadata": {
    "dialogue_id": "[unique_id]",
    "display_name": "[Display Name]",
    "description": "[Description]",
    "location_id": "[location_id]",
    "author": "Dialogue Designer Skill",
    "created_date": "[YYYY-MM-DD]",
    "modified_date": "[YYYY-MM-DD]",
    "campaign_id": "[campaign_id]"
  },
  "canvas": {
    "scroll_offset_x": 0,
    "scroll_offset_y": 0,
    "zoom": 1.0
  },
  "nodes": [...],
  "connections": [...]
}
```

---

## Node Types Reference

**Schema:** `crpg_engine/schemas/dialogue_schema.json`

All node types share base properties:
```json
{
  "id": "UniqueNodeId",
  "type": "NodeType",
  "position_x": 100,
  "position_y": 100
}
```

---

### Start Node
Entry point for dialogue. Every dialogue must have exactly one.
```json
{
  "id": "Start_1",
  "type": "Start",
  "position_x": 100,
  "position_y": 100
}
```

---

### Speaker Node
NPC dialogue line with optional variable interpolation.
```json
{
  "id": "Speaker_greeting",
  "type": "Speaker",
  "position_x": 100,
  "position_y": 250,
  "speaker": "npc_id_or_name",
  "text": "Hello {player.name}, you have {gold} gold. *action descriptions* in asterisks."
}
```
- `speaker`: Character ID or display name (e.g., "Narrator")
- `text`: Supports `{variable.path}` interpolation

---

### Choice Node

**⚠️ CRITICAL: Choice Node Pattern**

The dialogue runtime's `_gather_connected_choices` function looks for the `text` property on **individual Choice nodes**, NOT a `choices` array. Each player response option must be a **separate Choice node** with its own `text` property.

**CORRECT Pattern - Individual Choice Nodes:**
```json
{
  "id": "Choice_help",
  "type": "Choice",
  "position_x": 0,
  "position_y": 450,
  "text": "I'll help you."
}
```

```json
{
  "id": "Choice_reward",
  "type": "Choice",
  "position_x": 200,
  "position_y": 450,
  "text": "What's in it for me?"
}
```

```json
{
  "id": "Choice_decline",
  "type": "Choice",
  "position_x": 400,
  "position_y": 450,
  "text": "Not interested."
}
```

**Connection Pattern:**
A Speaker node connects to MULTIPLE Choice nodes (one connection per choice):
```json
{"from_node": "Speaker_greeting", "from_port": 0, "to_node": "Choice_help", "to_port": 0},
{"from_node": "Speaker_greeting", "from_port": 0, "to_node": "Choice_reward", "to_port": 0},
{"from_node": "Speaker_greeting", "from_port": 0, "to_node": "Choice_decline", "to_port": 0}
```

Each Choice node then connects to its own response:
```json
{"from_node": "Choice_help", "from_port": 0, "to_node": "Speaker_accept", "to_port": 0},
{"from_node": "Choice_reward", "from_port": 0, "to_node": "Speaker_reward_info", "to_port": 0},
{"from_node": "Choice_decline", "from_port": 0, "to_node": "Speaker_decline", "to_port": 0}
```

**WRONG Pattern - DO NOT USE `choices` array:**
```json
// ❌ WRONG - This will show "[1]" instead of text!
{
  "id": "Choice_options",
  "type": "Choice",
  "choices": [
    {"text": "First option", "next": "Speaker_1"},
    {"text": "Second option", "next": "Speaker_2"}
  ]
}
```

- `text`: The display text for this choice (REQUIRED on each Choice node)
- `condition`: Optional expression to show/hide this choice

---

### Branch Node
Conditional branching based on expression evaluation.
```json
{
  "id": "Branch_check_flag",
  "type": "Branch",
  "position_x": 100,
  "position_y": 400,
  "condition_mode": "expression",
  "expression": "has_flag(\"quest_completed\") and reputation >= 50"
}
```
- **Port 0** = condition TRUE
- **Port 1** = condition FALSE
- `condition_mode`: "expression" or "flag"
- `expression`: Supports `has_flag()`, comparisons (`==`, `!=`, `<`, `>`, `<=`, `>=`), logical operators (`and`, `or`, `not`)

---

### SkillCheck Node
Dedicated skill check with success/failure paths.
```json
{
  "id": "SkillCheck_persuade",
  "type": "SkillCheck",
  "position_x": 100,
  "position_y": 500,
  "skill": "Persuasion",
  "difficulty_class": 12
}
```
- **Port 0** = SUCCESS
- **Port 1** = FAILURE
- `skill`: One of `Persuasion`, `Intimidation`, `Deception`, `Insight`, `Perception`, `Athletics`, `Stealth`, `Custom`
- `difficulty_class`: DC 1-30 (default 10)
- `custom_skill`: Required when skill is "Custom"

---

### FlagCheck Node
Check a game flag or variable value.
```json
{
  "id": "FlagCheck_gold",
  "type": "FlagCheck",
  "position_x": 100,
  "position_y": 500,
  "flag_name": "gold",
  "operator": ">=",
  "flag_value": "100"
}
```
- **Port 0** = condition TRUE
- **Port 1** = condition FALSE
- `flag_name`: Variable name to check
- `operator`: `==`, `!=`, `>`, `<`, `>=`, `<=`
- `flag_value`: Value to compare (as string)

---

### FlagSet Node
Set one or more game flags or variables.
```json
{
  "id": "FlagSet_quest_start",
  "type": "FlagSet",
  "position_x": 100,
  "position_y": 500,
  "operations": [
    {
      "variable": "talked_to_elder",
      "operation": "set",
      "value": true
    },
    {
      "variable": "reputation_village",
      "operation": "add",
      "value": 5
    }
  ]
}
```
- `operations[].variable`: Variable name
- `operations[].operation`: `set`, `add`, `subtract`
- `operations[].value`: Boolean, number, or string

---

### Quest Node
Quest state management.
```json
{
  "id": "Quest_start",
  "type": "Quest",
  "position_x": 100,
  "position_y": 600,
  "quest_id": "quest_rats",
  "quest_action": "Start",
  "update_text": "Optional journal update text"
}
```
- `quest_action`: `Start`, `Complete`, `Fail`, `Update`
- `update_text`: Only used when action is "Update"

---

### Item Node
Item management (give, take, or check).
```json
{
  "id": "Item_give_key",
  "type": "Item",
  "position_x": 100,
  "position_y": 600,
  "item_action": "Give",
  "item_id": "cellar_key",
  "quantity": 1
}
```
- `item_action`: `Give`, `Take`, `Check`
- **Check creates branch**: Port 0 = has item, Port 1 = missing
- `quantity`: Number of items (default 1)

---

### Reputation Node
Modify faction reputation.
```json
{
  "id": "Reputation_valdris",
  "type": "Reputation",
  "position_x": 100,
  "position_y": 600,
  "faction": "valdris",
  "amount": 10
}
```
- `faction`: Faction identifier or "Custom"
- `custom_faction`: Required when faction is "Custom"
- `amount`: -100 to 100 (positive or negative)

---

### SetExpression Node
Set variables using expressions.
```json
{
  "id": "SetExpr_calculate",
  "type": "SetExpression",
  "position_x": 100,
  "position_y": 600,
  "assignments": [
    {
      "variable": "total_cost",
      "expression": "base_price * quantity"
    }
  ]
}
```

---

### Comment Node
Designer comment (not exported to runtime).
```json
{
  "id": "Comment_note",
  "type": "Comment",
  "position_x": 50,
  "position_y": 50,
  "text": "This branch handles the peaceful resolution path"
}
```

---

### End Node
Terminates the conversation.
```json
{
  "id": "End_1",
  "type": "End",
  "position_x": 100,
  "position_y": 800
}
```

---

### Connection Format
```json
{
  "from_node": "Speaker_greeting",
  "from_port": 0,
  "to_node": "Choice_response",
  "to_port": 0
}
```

---

### Groups (Optional)
Visual grouping of nodes in editor.
```json
{
  "groups": [
    {
      "id": "group_1",
      "name": "Quest Acceptance Path",
      "color": "#4a90d9",
      "nodes": ["Speaker_quest", "Choice_accept", "Quest_start"]
    }
  ]
}
```

---

## Workflow

### Phase 1: Gather Context

**Step 1.1: Identify the Character**

If dialogue is for an established character:
1. Check `docs/narrative/character-profiles.md` for voice details
2. Extract: speech pattern, verbal tics, topics they discuss/avoid, sample lines
3. Note personality traits and current emotional state

**Step 1.2: Identify the Scene/Purpose**

Ask or determine:
- What is this dialogue for? (quest giving, information, ambient, confrontation)
- Where does it occur? (location_id)
- What quest/flags does it relate to?
- What emotional beat is this? (refer to key-scenes.md if applicable)

**Step 1.3: Identify Requirements**

Gather:
- Does it need branching? How many paths?
- Are there skill checks? Which skills, what difficulty?
- What flags should be set/checked?
- What quests should be started/updated/completed?
- Are there conditions for different dialogue states? (first meeting vs. after quest)

---

### Phase 2: Interactive Design

Ask the user targeted questions:

```markdown
## Dialogue Design: [Character Name]

I found [Character]'s profile with the following voice:
- **Speech Pattern:** [from profile]
- **Verbal Tics:** [from profile]
- **Sample Lines:** [from profile]

**1. Dialogue Purpose**
What is this conversation for?
- [ ] Quest giving (offers a quest)
- [ ] Quest completion (rewards/resolves a quest)
- [ ] Information/lore (shares world knowledge)
- [ ] Ambient/flavor (general NPC chat)
- [ ] Confrontation/conflict (tense scene)
- [ ] Recruitment/companion (asking to join)
- [ ] Merchant/services (shop/services context)

**2. Dialogue States**
Should this dialogue change based on game state?
- [ ] Single state (always the same)
- [ ] Before/after quest completion
- [ ] Multiple states based on flags
- [ ] Relationship-dependent

**3. Branching Complexity**
How much player choice?
- [ ] Linear (NPC talks, player listens)
- [ ] Simple (2-3 response options)
- [ ] Moderate (multiple branches, some rejoining)
- [ ] Complex (many branches, different outcomes)

**4. Skill Checks**
Include skill-based options?
- [ ] None
- [ ] Persuasion (convince, charm)
- [ ] Intimidation (threaten, pressure)
- [ ] Insight (detect lies, read emotions)
- [ ] Knowledge checks (lore, history)
- [ ] Other: _______

**5. Key Information**
What must the player learn from this dialogue?
- [List critical information that must be conveyed]

**6. Flags & Triggers**
What should happen as a result?
- Flags to set: [list]
- Quests to affect: [quest_id: action]
- Encounters to trigger: [encounter_id]
```

**Wait for user response before generating.**

---

### Phase 3: Dialogue Generation

**Step 3.1: Plan the Structure**

Before writing, create a flow outline:

```
START
  ↓
[Greeting - varies by state]
  ↓
[Main content branch]
  ├── Option A → [Response] → [Outcome A]
  ├── Option B → [Skill Check] → Success/Fail → [Outcomes]
  └── Option C → [Response] → [Outcome C]
  ↓
[Flag setting / Quest triggers]
  ↓
END
```

**Step 3.2: Write Dialogue Lines**

For each speaker node:
1. **Check character voice** - Match speech patterns from profile
2. **Use sample lines as templates** - Maintain consistency
3. **Include action descriptions** - *actions in asterisks*
4. **Respect topics they avoid** - Don't have them discuss taboo subjects casually

**Voice Matching Guidelines:**

| Character Trait | Dialogue Style |
|-----------------|----------------|
| Formal speech | Full sentences, proper grammar, titles |
| Casual speech | Contractions, slang (period-appropriate), interruptions |
| Military | Clipped, direct, command-like |
| Religious | References to faith, blessings, moral framing |
| Merchant | Value-focused, deals, numbers |
| Traumatized | Hesitations, topic avoidance, deflection |

**Step 3.3: Assign Node Positions**

Layout conventions:
- Start at top (y: 100)
- Flow downward (increment y by 150 per level)
- Branch horizontally (spread x by 200-300 per branch)
- Reconverge branches before end when possible

**Step 3.4: Create Connections**

Ensure every node (except End) has outgoing connections.
Ensure every node (except Start) has incoming connections.

---

### Phase 4: Output

**Step 4.1: Generate .dtree File**

Create the complete JSON structure with:
- Proper metadata
- All nodes with unique IDs
- All connections properly linked
- No orphaned nodes

**Step 4.2: Save File**

Save to: `data/dialogue/[dialogue_id].dtree`

Naming conventions:
- Quest dialogue: `dlg_[quest_id]_[npc].dtree`
- Character dialogue: `dlg_[character_id].dtree`
- Scene dialogue: `dlg_[scene_name].dtree`

**Step 4.3: Report**

```markdown
## Dialogue Created

**File:** `data/dialogue/[dialogue_id].dtree`
**Character:** [Name]
**Purpose:** [Quest/Info/Ambient/etc.]

### Structure
- **Nodes:** [count]
- **Branches:** [count]
- **Skill Checks:** [list or "None"]
- **Flags Set:** [list or "None"]
- **Quests Affected:** [list or "None"]

### Dialogue Flow
```
[Visual flow diagram]
```

### Sample Lines
```
[Key lines showing character voice]
```

### Integration Notes
- Reference this dialogue from: [NPC.char, quest.json, etc.]
- Required flags: [any prerequisite flags]
- Sets flags: [flags this dialogue creates]

### Testing
1. Ensure NPC references this dialogue_id
2. Test all branches
3. Verify flags are set correctly
4. Check quest triggers work
```

---

## Dialogue Templates

### Template: Quest Giver (Simple)

```json
{
  "version": 1,
  "metadata": {
    "dialogue_id": "dlg_[npc]_[quest]",
    "display_name": "[NPC Name] - [Quest Name]",
    "description": "[NPC] offers the player a quest",
    "location_id": "[location]",
    "author": "Dialogue Designer Skill",
    "created_date": "[date]",
    "modified_date": "[date]"
  },
  "canvas": {"scroll_offset_x": 0, "scroll_offset_y": 0, "zoom": 1.0},
  "nodes": [
    {"id": "Start_1", "type": "Start", "position_x": 300, "position_y": 50},

    {"id": "Branch_quest_state", "type": "Branch", "position_x": 300, "position_y": 150,
     "condition_mode": "expression", "expression": "has_flag(\"[quest]_completed\")"},

    {"id": "Speaker_greeting", "type": "Speaker", "position_x": 100, "position_y": 300,
     "speaker": "[npc_id]", "text": "[Greeting when quest not started]"},

    {"id": "Speaker_completed", "type": "Speaker", "position_x": 500, "position_y": 300,
     "speaker": "[npc_id]", "text": "[Thanks for completing quest]"},

    {"id": "Choice_help", "type": "Choice", "position_x": 0, "position_y": 450,
     "text": "I'll help you."},

    {"id": "Choice_reward", "type": "Choice", "position_x": 200, "position_y": 450,
     "text": "What's in it for me?"},

    {"id": "Choice_decline", "type": "Choice", "position_x": 400, "position_y": 450,
     "text": "Not interested."},

    {"id": "Speaker_accept", "type": "Speaker", "position_x": 0, "position_y": 600,
     "speaker": "[npc_id]", "text": "[Grateful response, quest details]"},

    {"id": "Quest_start", "type": "Quest", "position_x": 0, "position_y": 750,
     "quest_id": "[quest_id]", "quest_action": "Start"},

    {"id": "Speaker_reward", "type": "Speaker", "position_x": 200, "position_y": 600,
     "speaker": "[npc_id]", "text": "[Explains reward]"},

    {"id": "Speaker_decline", "type": "Speaker", "position_x": 400, "position_y": 600,
     "speaker": "[npc_id]", "text": "[Disappointed but understanding]"},

    {"id": "End_1", "type": "End", "position_x": 300, "position_y": 900}
  ],
  "connections": [
    {"from_node": "Start_1", "from_port": 0, "to_node": "Branch_quest_state", "to_port": 0},
    {"from_node": "Branch_quest_state", "from_port": 1, "to_node": "Speaker_greeting", "to_port": 0},
    {"from_node": "Branch_quest_state", "from_port": 0, "to_node": "Speaker_completed", "to_port": 0},
    {"from_node": "Speaker_greeting", "from_port": 0, "to_node": "Choice_help", "to_port": 0},
    {"from_node": "Speaker_greeting", "from_port": 0, "to_node": "Choice_reward", "to_port": 0},
    {"from_node": "Speaker_greeting", "from_port": 0, "to_node": "Choice_decline", "to_port": 0},
    {"from_node": "Choice_help", "from_port": 0, "to_node": "Speaker_accept", "to_port": 0},
    {"from_node": "Choice_reward", "from_port": 0, "to_node": "Speaker_reward", "to_port": 0},
    {"from_node": "Choice_decline", "from_port": 0, "to_node": "Speaker_decline", "to_port": 0},
    {"from_node": "Speaker_accept", "from_port": 0, "to_node": "Quest_start", "to_port": 0},
    {"from_node": "Quest_start", "from_port": 0, "to_node": "End_1", "to_port": 0},
    {"from_node": "Speaker_reward", "from_port": 0, "to_node": "End_1", "to_port": 0},
    {"from_node": "Speaker_decline", "from_port": 0, "to_node": "End_1", "to_port": 0},
    {"from_node": "Speaker_completed", "from_port": 0, "to_node": "End_1", "to_port": 0}
  ]
}
```

### Template: Confrontation with Skill Checks

```json
{
  "version": 1,
  "metadata": {
    "dialogue_id": "dlg_[scene]_confrontation",
    "display_name": "[Character] - Confrontation",
    "description": "Tense confrontation with multiple resolution paths",
    "location_id": "[location]",
    "author": "Dialogue Designer Skill",
    "created_date": "[date]",
    "modified_date": "[date]"
  },
  "canvas": {"scroll_offset_x": 0, "scroll_offset_y": 0, "zoom": 1.0},
  "nodes": [
    {"id": "Start_1", "type": "Start", "position_x": 300, "position_y": 50},

    {"id": "Speaker_threat", "type": "Speaker", "position_x": 300, "position_y": 200,
     "speaker": "[antagonist]", "text": "[Threatening opening]"},

    {"id": "Choice_intimidate", "type": "Choice", "position_x": 100, "position_y": 350,
     "text": "[Intimidate] Back down, or else."},

    {"id": "Choice_persuade", "type": "Choice", "position_x": 300, "position_y": 350,
     "text": "[Persuade] Let's talk about this."},

    {"id": "Choice_fight", "type": "Choice", "position_x": 500, "position_y": 350,
     "text": "I have no choice but to fight."},

    {"id": "SkillCheck_intimidate", "type": "SkillCheck", "position_x": 100, "position_y": 500,
     "skill": "Intimidation", "difficulty_class": 14},

    {"id": "Speaker_intimidate_success", "type": "Speaker", "position_x": 0, "position_y": 650,
     "speaker": "[antagonist]", "text": "*backs away nervously* Fine! I don't want trouble."},

    {"id": "Speaker_intimidate_fail", "type": "Speaker", "position_x": 200, "position_y": 650,
     "speaker": "[antagonist]", "text": "*laughs* You don't scare me. Guards!"},

    {"id": "SkillCheck_persuade", "type": "SkillCheck", "position_x": 300, "position_y": 500,
     "skill": "Persuasion", "difficulty_class": 12},

    {"id": "Speaker_persuade_success", "type": "Speaker", "position_x": 300, "position_y": 650,
     "speaker": "[antagonist]", "text": "*sighs* Perhaps you're right. There may be another way."},

    {"id": "Speaker_persuade_fail", "type": "Speaker", "position_x": 400, "position_y": 650,
     "speaker": "[antagonist]", "text": "Pretty words won't save you. Attack!"},

    {"id": "Speaker_fight", "type": "Speaker", "position_x": 500, "position_y": 500,
     "speaker": "[antagonist]", "text": "Then you've chosen death!"},

    {"id": "FlagSet_peaceful", "type": "FlagSet", "position_x": 150, "position_y": 800,
     "operations": [{"variable": "resolved_peacefully", "operation": "set", "value": true}]},

    {"id": "FlagSet_combat", "type": "FlagSet", "position_x": 400, "position_y": 800,
     "operations": [{"variable": "trigger_encounter", "operation": "set", "value": "[encounter_id]"}]},

    {"id": "End_1", "type": "End", "position_x": 300, "position_y": 950}
  ],
  "connections": [
    {"from_node": "Start_1", "from_port": 0, "to_node": "Speaker_threat", "to_port": 0},
    {"from_node": "Speaker_threat", "from_port": 0, "to_node": "Choice_intimidate", "to_port": 0},
    {"from_node": "Speaker_threat", "from_port": 0, "to_node": "Choice_persuade", "to_port": 0},
    {"from_node": "Speaker_threat", "from_port": 0, "to_node": "Choice_fight", "to_port": 0},
    {"from_node": "Choice_intimidate", "from_port": 0, "to_node": "SkillCheck_intimidate", "to_port": 0},
    {"from_node": "Choice_persuade", "from_port": 0, "to_node": "SkillCheck_persuade", "to_port": 0},
    {"from_node": "Choice_fight", "from_port": 0, "to_node": "Speaker_fight", "to_port": 0},
    {"from_node": "SkillCheck_intimidate", "from_port": 0, "to_node": "Speaker_intimidate_success", "to_port": 0},
    {"from_node": "SkillCheck_intimidate", "from_port": 1, "to_node": "Speaker_intimidate_fail", "to_port": 0},
    {"from_node": "SkillCheck_persuade", "from_port": 0, "to_node": "Speaker_persuade_success", "to_port": 0},
    {"from_node": "SkillCheck_persuade", "from_port": 1, "to_node": "Speaker_persuade_fail", "to_port": 0},
    {"from_node": "Speaker_intimidate_success", "from_port": 0, "to_node": "FlagSet_peaceful", "to_port": 0},
    {"from_node": "Speaker_persuade_success", "from_port": 0, "to_node": "FlagSet_peaceful", "to_port": 0},
    {"from_node": "Speaker_intimidate_fail", "from_port": 0, "to_node": "FlagSet_combat", "to_port": 0},
    {"from_node": "Speaker_persuade_fail", "from_port": 0, "to_node": "FlagSet_combat", "to_port": 0},
    {"from_node": "Speaker_fight", "from_port": 0, "to_node": "FlagSet_combat", "to_port": 0},
    {"from_node": "FlagSet_peaceful", "from_port": 0, "to_node": "End_1", "to_port": 0},
    {"from_node": "FlagSet_combat", "from_port": 0, "to_node": "End_1", "to_port": 0}
  ],
  "groups": []
}
```

**Note:** The schema doesn't define an "Action" node type for combat. Instead, use `FlagSet` to set a `trigger_encounter` variable that the game engine reads to start combat after dialogue ends.

### Template: Companion Conversation (Emotional)

```json
{
  "version": 1,
  "metadata": {
    "dialogue_id": "dlg_[companion]_personal",
    "display_name": "[Companion Name] - Personal Conversation",
    "description": "Emotional conversation exploring companion's background",
    "location_id": "camp",
    "author": "Dialogue Designer Skill",
    "created_date": "[date]",
    "modified_date": "[date]"
  },
  "canvas": {"scroll_offset_x": 0, "scroll_offset_y": 0, "zoom": 1.0},
  "nodes": [
    {"id": "Start_1", "type": "Start", "position_x": 300, "position_y": 50},

    {"id": "FlagCheck_trust", "type": "FlagCheck", "position_x": 300, "position_y": 150,
     "flag_name": "[companion]_trust", "operator": ">=", "flag_value": "50"},

    {"id": "Speaker_distant", "type": "Speaker", "position_x": 500, "position_y": 300,
     "speaker": "[companion]", "text": "*looks away* I don't want to talk about it."},

    {"id": "Speaker_opens_up", "type": "Speaker", "position_x": 100, "position_y": 300,
     "speaker": "[companion]", "text": "*sighs deeply* You want to know about my past? Very well. You've earned that much."},

    {"id": "Speaker_backstory", "type": "Speaker", "position_x": 100, "position_y": 450,
     "speaker": "[companion]", "text": "[Emotional backstory revelation]"},

    {"id": "Choice_supportive", "type": "Choice", "position_x": 0, "position_y": 600,
     "text": "I understand. You're not alone anymore."},

    {"id": "Choice_analytical", "type": "Choice", "position_x": 200, "position_y": 600,
     "text": "That explains a lot about you."},

    {"id": "Choice_pragmatic", "type": "Choice", "position_x": 400, "position_y": 600,
     "text": "The past is past. Focus on now."},

    {"id": "Speaker_supported", "type": "Speaker", "position_x": 0, "position_y": 750,
     "speaker": "[companion]", "text": "*eyes glisten* Thank you. That... means more than you know."},

    {"id": "FlagSet_deepened", "type": "FlagSet", "position_x": 0, "position_y": 900,
     "operations": [
       {"variable": "[companion]_trust", "operation": "add", "value": 15},
       {"variable": "[companion]_personal_revealed", "operation": "set", "value": true}
     ]},

    {"id": "Speaker_analytical", "type": "Speaker", "position_x": 200, "position_y": 750,
     "speaker": "[companion]", "text": "*nods slowly* Yes. I suppose it does."},

    {"id": "Speaker_pragmatic", "type": "Speaker", "position_x": 400, "position_y": 750,
     "speaker": "[companion]", "text": "*hardens* You're right. Dwelling on it helps no one."},

    {"id": "End_1", "type": "End", "position_x": 300, "position_y": 1050}
  ],
  "connections": [
    {"from_node": "Start_1", "from_port": 0, "to_node": "FlagCheck_trust", "to_port": 0},
    {"from_node": "FlagCheck_trust", "from_port": 0, "to_node": "Speaker_opens_up", "to_port": 0},
    {"from_node": "FlagCheck_trust", "from_port": 1, "to_node": "Speaker_distant", "to_port": 0},
    {"from_node": "Speaker_distant", "from_port": 0, "to_node": "End_1", "to_port": 0},
    {"from_node": "Speaker_opens_up", "from_port": 0, "to_node": "Speaker_backstory", "to_port": 0},
    {"from_node": "Speaker_backstory", "from_port": 0, "to_node": "Choice_supportive", "to_port": 0},
    {"from_node": "Speaker_backstory", "from_port": 0, "to_node": "Choice_analytical", "to_port": 0},
    {"from_node": "Speaker_backstory", "from_port": 0, "to_node": "Choice_pragmatic", "to_port": 0},
    {"from_node": "Choice_supportive", "from_port": 0, "to_node": "Speaker_supported", "to_port": 0},
    {"from_node": "Choice_analytical", "from_port": 0, "to_node": "Speaker_analytical", "to_port": 0},
    {"from_node": "Choice_pragmatic", "from_port": 0, "to_node": "Speaker_pragmatic", "to_port": 0},
    {"from_node": "Speaker_supported", "from_port": 0, "to_node": "FlagSet_deepened", "to_port": 0},
    {"from_node": "FlagSet_deepened", "from_port": 0, "to_node": "End_1", "to_port": 0},
    {"from_node": "Speaker_analytical", "from_port": 0, "to_node": "End_1", "to_port": 0},
    {"from_node": "Speaker_pragmatic", "from_port": 0, "to_node": "End_1", "to_port": 0}
  ],
  "groups": []
}
```

### Template: Item Exchange (Give/Check)

```json
{
  "version": 1,
  "metadata": {
    "dialogue_id": "dlg_[npc]_item_exchange",
    "display_name": "[NPC Name] - Item Exchange",
    "description": "NPC requests an item, dialogue branches based on possession",
    "location_id": "[location]",
    "author": "Dialogue Designer Skill",
    "created_date": "[date]",
    "modified_date": "[date]"
  },
  "canvas": {"scroll_offset_x": 0, "scroll_offset_y": 0, "zoom": 1.0},
  "nodes": [
    {"id": "Start_1", "type": "Start", "position_x": 300, "position_y": 50},

    {"id": "Speaker_request", "type": "Speaker", "position_x": 300, "position_y": 200,
     "speaker": "[npc_id]", "text": "Do you have the [item_name]? I need it urgently."},

    {"id": "Item_check", "type": "Item", "position_x": 300, "position_y": 350,
     "item_action": "Check", "item_id": "[item_id]", "quantity": 1},

    {"id": "Choice_give_item", "type": "Choice", "position_x": 100, "position_y": 500,
     "text": "Here it is."},

    {"id": "Choice_keep_item", "type": "Choice", "position_x": 300, "position_y": 500,
     "text": "I have it, but I'm keeping it."},

    {"id": "Speaker_no_item", "type": "Speaker", "position_x": 500, "position_y": 500,
     "speaker": "[npc_id]", "text": "Please find it and bring it to me."},

    {"id": "Item_give", "type": "Item", "position_x": 100, "position_y": 650,
     "item_action": "Take", "item_id": "[item_id]", "quantity": 1},

    {"id": "Speaker_thanks", "type": "Speaker", "position_x": 100, "position_y": 800,
     "speaker": "[npc_id]", "text": "Thank you! This means everything to me."},

    {"id": "Item_reward", "type": "Item", "position_x": 100, "position_y": 950,
     "item_action": "Give", "item_id": "[reward_id]", "quantity": 1},

    {"id": "Speaker_refuse", "type": "Speaker", "position_x": 300, "position_y": 650,
     "speaker": "[npc_id]", "text": "*disappointment* I... I understand."},

    {"id": "End_1", "type": "End", "position_x": 300, "position_y": 1100}
  ],
  "connections": [
    {"from_node": "Start_1", "from_port": 0, "to_node": "Speaker_request", "to_port": 0},
    {"from_node": "Speaker_request", "from_port": 0, "to_node": "Item_check", "to_port": 0},
    {"from_node": "Item_check", "from_port": 0, "to_node": "Choice_give_item", "to_port": 0},
    {"from_node": "Item_check", "from_port": 0, "to_node": "Choice_keep_item", "to_port": 0},
    {"from_node": "Item_check", "from_port": 1, "to_node": "Speaker_no_item", "to_port": 0},
    {"from_node": "Choice_give_item", "from_port": 0, "to_node": "Item_give", "to_port": 0},
    {"from_node": "Choice_keep_item", "from_port": 0, "to_node": "Speaker_refuse", "to_port": 0},
    {"from_node": "Item_give", "from_port": 0, "to_node": "Speaker_thanks", "to_port": 0},
    {"from_node": "Speaker_thanks", "from_port": 0, "to_node": "Item_reward", "to_port": 0},
    {"from_node": "Item_reward", "from_port": 0, "to_node": "End_1", "to_port": 0},
    {"from_node": "Speaker_refuse", "from_port": 0, "to_node": "End_1", "to_port": 0},
    {"from_node": "Speaker_no_item", "from_port": 0, "to_node": "End_1", "to_port": 0}
  ],
  "groups": []
}
```

---

## Voice Matching Examples

### From Sellswords Character Profiles

**Mira Ashford (Veteran)**
- Speech: Clipped, military precision, softens only with trusted people
- Verbal tics: "Orders are orders" (bitter), "I've seen this before" (warning)
- Avoid: The village, her family, hope

```
GOOD: "Check your blade. Check it again. A dull sword gets you killed."
GOOD: "I know what happens next. I've been the one giving these orders."
BAD:  "Oh, I'm so happy to see you! Let me tell you about my feelings!"
```

**Brother Aldous (Idealist)**
- Speech: Formal when nervous, warm when comfortable
- Verbal tics: "The Saints teach..." (sincere), "There must be another way" (pleading)
- Avoid: Violence he's committed, doubts he won't voice

```
GOOD: "Let me look at that wound. No arguing—I can see you limping."
GOOD: "We are more than what this war makes us. We have to be."
BAD:  "Kill them all! The Saints demand blood!"
```

**Silas Crane (Opportunist)**
- Speech: Fast, charming, deflects with humor, drops act when serious
- Verbal tics: "Here's the thing..." (about to con), "Purely business" (defensive)
- Avoid: His past, why he was blacklisted, his family

```
GOOD: "I know a guy who knows a guy. It'll cost, but I can get it."
GOOD: "Look, I'm the first to admit I'm a bastard. But I'm YOUR bastard."
BAD:  "I don't care about money. Let me tell you about my feelings..."
```

---

## Common Patterns

### Multi-State Dialogue

For NPCs with different dialogue based on game state:

```
START
  ↓
BRANCH: Check primary flag
  ├── TRUE (quest complete)  → [Completion dialogue] → END
  └── FALSE (quest active or not started)
        ↓
      BRANCH: Check quest started
        ├── TRUE (in progress) → [Progress dialogue] → END
        └── FALSE (not started) → [Initial dialogue] → END
```

### Skill Check with Fallback

```
CHOICE: [Skill Check Option]
  ↓
BRANCH: skill_check("skill", DC)
  ├── SUCCESS → [Positive outcome]
  └── FAILURE → [Negative but not catastrophic]
                    ↓
                 [Alternative path still available]
```

### Information Gating

```
BRANCH: has_flag("knows_secret")
  ├── TRUE → [Dialogue references the secret]
  └── FALSE → [Generic dialogue, hint at mystery]
```

---

## Integration with Other Skills

| Skill | Relationship |
|-------|--------------|
| **game-ideator** | Provides narrative-bible.md for tone guidelines |
| **narrative-architect** | Reads character-profiles.md for voice |
| **world-builder** | Locations referenced in dialogue metadata |
| **character-creator** | NPCs reference dialogue IDs in .char files |
| **quest-designer** | Dialogues may start/complete quests |
| **encounter-designer** | Dialogues may trigger encounters via flags |
| **campaign-creator** | Assembles dialogues into final campaign |

### Workflow Paths

**Incremental Path (Recommended for D&D Import):**
```
game-ideator → narrative-architect → character-creator → dialogue-designer
                                                              ↓
                                                    campaign-creator
```

Use this path when:
- Converting D&D NPC dialogue piece by piece
- Creating dialogue with careful voice matching
- You want control over individual conversations

**Bulk Path (Rapid Generation):**
```
test-campaign-generator → test-campaign-scaffolder
(creates spec with       (creates .dtree files
 dialogue outlines)       from outlines)
```

Use this path when:
- You need many dialogues generated quickly
- Dialogue structure is straightforward
- You have a complete specification

---

## Example Invocations

### From Scratch
- "Create dialogue for Mira Ashford at camp"
- "Write the battlefield confession scene dialogue"
- "Generate quest-giving dialogue for Elder Thom and the rat cellar quest"
- "I need confrontation dialogue with Baron Blackwood"
- "Create companion dialogue for when Aldous discovers church corruption"

### D&D/Tabletop Import
- "Convert Harbin Wester's quest board dialogue from Dragons of Icespire Peak"
- "Import the dialogue with Adabra Gwynn at Umbrage Hill"
- "Create CRPG dialogue from this D&D NPC: [description]"
- "Translate Toblen Stonehill's tavern rumors into a dialogue tree"
- "Convert my DM notes for the encounter with Falcon the hunter"

---

## Checklist Before Completing

- [ ] Read character profile for voice consistency
- [ ] Asked clarifying questions about purpose/branches/flags
- [ ] Generated valid .dtree JSON structure
- [ ] All nodes have unique IDs
- [ ] All connections are valid (no orphans)
- [ ] Dialogue matches character voice
- [ ] Appropriate flags set
- [ ] Quest triggers included if relevant
- [ ] Saved to `data/dialogue/[id].dtree`
- [ ] Provided integration notes

---

## Troubleshooting

### Issue: Dialogue doesn't appear in game
**Check:**
1. NPC's .char file references correct dialogue_id
2. dialogue_id in metadata matches filename
3. File is in `data/dialogue/` directory

### Issue: Character sounds wrong
**Check:**
1. Review character-profiles.md for voice guidelines
2. Compare generated lines to sample lines
3. Check for topics they should avoid

### Issue: Branches don't work
**Check:**
1. Branch node has correct expression syntax
2. Port 0 = TRUE condition, Port 1 = FALSE
3. Flag names match exactly (case-sensitive)

### Issue: Orphaned nodes warning
**Check:**
1. Every node except End has outgoing connection
2. Every node except Start has incoming connection
3. All connection from_node/to_node IDs exist
