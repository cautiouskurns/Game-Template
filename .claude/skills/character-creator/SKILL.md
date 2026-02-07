# Character Creator Skill

> **RPG Pipeline Only** — This skill creates structured character data files using a CRPG engine schema (`.char` format with stats, factions, tiers). For non-RPG games, the content-architect should create simpler JSON character definitions suited to the game's needs. The interactive workflow and data organization principles still apply.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | content-architect |
| **Sprint Phase** | Phase B (Implementation) — parallel with developer agents |
| **Directory Scope** | `data/characters/` |
| **Genre** | RPG / CRPG only |
| **Schema Dependency** | Requires `crpg_engine/schemas/character_schema.json` |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

This skill creates **character data files** (`.char`) for the CRPG Engine. It defines NPCs, companions, enemies, and player characters with their identity, appearance, personality, stats, and relationships.

**Schema Reference:** `crpg_engine/schemas/character_schema.json`

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
│ BUILDER         │    │ CREATOR         │◄── │ DESIGNER        │
│ .worldmap.json  │    │ .char files     │    │ quest .json     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                               │ │
                      THIS SKILL│
                               │ │
               ┌───────────────┴─┴───────────────┐
               ▼                                 ▼
      ┌─────────────┐                   ┌─────────────┐
      │ DIALOGUE    │                   │ ENCOUNTER   │
      │ DESIGNER    │                   │ DESIGNER    │
      │ .dtree      │                   │ enc .json   │
      └─────────────┘                   └─────────────┘
               │                                 │
               └─────────────────────────────────┘
                                │
                   ┌─────────────────────────────┐
                   │     CAMPAIGN CREATOR        │
                   │   (Ties everything together)│
                   │   data/campaigns/*.json     │
                   └─────────────────────────────┘
```

**This skill creates:** `data/characters/**/*.char` files for NPCs, companions, enemies, and player characters.

---

## CRITICAL: What This Skill Does and Does NOT Do

```
+------------------------------------------+------------------------------------------+
|              THIS SKILL DOES             |          THIS SKILL DOES NOT DO         |
+------------------------------------------+------------------------------------------+
| Create character files (.char)           | Create dialogue trees                   |
| Define identity (name, titles, aliases)  | Create quests                           |
| Define classification (role, tier, tags) | Create encounters                       |
| Define appearance (portrait, sprite)     | Place characters in worldmaps           |
| Define personality (traits, motivation)  | Create combat stat resources (.tres)    |
| Define stats (attributes, level)         | Generate sprite artwork                 |
| Define relationships to other characters | Modify existing characters              |
| Output to data/characters/               | Create ability definitions              |
+------------------------------------------+------------------------------------------+
```

---

## When to Use This Skill

Invoke this skill when the user:
- Wants to create a new NPC, companion, or enemy
- Says "create a character" or "design an NPC"
- Asks to "make a merchant" or "create a boss enemy"
- Wants to "add a new companion to the game"
- Needs to define a character for quests or dialogues
- Says "use character-creator"

---

## Prerequisites

Before running this skill:

1. **Narrative documents should exist** (recommended for context):
   - `docs/design/world-bible.md` - For faction info and world context
   - `docs/narrative/character-profiles.md` - For deep character specifications

2. **For dialogue references**:
   - Dialogue tree ID should be known (or noted for later creation)

---

## Schema Reference

### Complete Character Structure

The authoritative schema is at `crpg_engine/schemas/character_schema.json`.

```json
{
  "version": 1,
  "id": "character_id",
  "identity": {
    "display_name": "Character Name",
    "titles": ["Title 1", "Title 2"],
    "aliases": ["Alias 1"]
  },
  "classification": {
    "role": "companion",
    "factions": ["Faction Name"],
    "tier": 1,
    "tags": ["tag1", "tag2"]
  },
  "appearance": {
    "portrait": "res://assets/sprites/characters/[category]/[name]/base/south.png",
    "sprite_project": "res://assets/sprites/characters/[category]/[name]",
    "description": "Physical description of the character"
  },
  "personality": {
    "traits": ["brave", "loyal", "stubborn"],
    "motivation": "Character's core goal or drive",
    "speech_pattern": "How they speak",
    "voice_notes": "Notes for voice acting"
  },
  "stats": {
    "base": {
      "strength": 10,
      "agility": 10,
      "vitality": 10,
      "intelligence": 10,
      "wisdom": 10,
      "charisma": 10
    },
    "level": 1,
    "xp": 0
  },
  "dialogue_ref": "dialogue_tree_id",
  "inventory_ref": "shop_inventory_id",
  "relationships": [
    {
      "target": "other_character_id",
      "type": "ally",
      "notes": "Relationship context"
    }
  ],
  "notes": {
    "design": "Designer notes about this character",
    "todos": [
      {"text": "Todo item", "completed": false}
    ],
    "history": ["Change history entries"]
  },
  "metadata": {
    "version": 1,
    "created": "2026-01-27T00:00:00Z",
    "modified": "2026-01-27T00:00:00Z",
    "author": "Character Creator",
    "is_template": false,
    "template_name": ""
  }
}
```

### Required Fields

| Field | Description |
|-------|-------------|
| `id` | Unique identifier (lowercase, underscores, max 64 chars) |
| `identity.display_name` | Name shown to players |
| `classification.role` | Character role (see roles below) |
| `classification.tier` | Importance tier (1-4) |

---

## Character Roles (from schema)

| Role | String Value | Integer | Description |
|------|--------------|---------|-------------|
| Companion | `"companion"` | `0` | Recruitable party member |
| Major NPC | `"major_npc"` | `1` | Important story character |
| Minor NPC | `"minor_npc"` | `2` | Background character with dialogue |
| Enemy | `"enemy"` | `3` | Combat opponent |
| Referenced | `"referenced"` | `4` | Mentioned but never seen |

**Note:** Both string and integer values are valid for backwards compatibility.

---

## Character Tiers (from schema)

| Tier | Name | Requirements |
|------|------|--------------|
| `1` | Hero | Full content: portrait, stats, dialogue, personality, relationships |
| `2` | Supporting | Stats, portrait, dialogue, basic personality |
| `3` | Minor | Basic stats, portrait, minimal dialogue |
| `4` | Background | Name only, minimal data |

**Tier Validation:**
- Tier 1 characters should have ALL fields populated
- Tier 4 characters can have minimal data
- The Character Creator editor validates based on tier

---

## Relationship Types (from schema)

| Type | Description |
|------|-------------|
| `ally` | Fighting on the same side |
| `enemy` | Hostile relationship |
| `family` | Blood or adoptive family |
| `romantic` | Love interest |
| `business` | Professional relationship |
| `rival` | Competitive rivalry |
| `neutral` | No strong feelings |
| `friend` | Close friendship |
| `acquaintance` | Know each other casually |
| `mentor` | Teacher/guide relationship |
| `student` | Learning from another |

---

## Base Stats (from schema)

| Stat | Range | Description |
|------|-------|-------------|
| `strength` | 1-100 | Physical power, melee damage |
| `agility` | 1-100 | Speed, evasion, ranged accuracy |
| `vitality` | 1-100 | Health, stamina |
| `intelligence` | 1-100 | Magic power, skill points |
| `wisdom` | 1-100 | Mana pool, magic defense |
| `charisma` | 1-100 | Dialogue options, prices, morale |

**Default value:** 10 for each stat

---

## File Organization

Characters are stored in subdirectories based on role:

```
data/characters/
├── companions/          # Recruitable party members
│   └── ser_aldric.char
├── npcs/                # Major and minor NPCs
│   ├── merchant_willem.char
│   └── elder_miriam.char
├── enemies/             # Combat opponents
│   ├── bandit_thug.char
│   └── orc_warlord.char
└── player/              # Player character templates
    └── player.char
```

---

## Sprite Path Conventions

**Portrait Path:**
```
res://assets/sprites/characters/[category]/[sprite_name]/base/south.png
```

**Sprite Project Path:**
```
res://assets/sprites/characters/[category]/[sprite_name]
```

**Available Sprite Categories:**

| Category | Path | Examples |
|----------|------|----------|
| Companions | `companions/` | `warrior`, `mage`, `rogue` |
| Quest Givers | `npcs/quest_givers/` | `village_elder`, `priest`, `mysterious_stranger` |
| Merchants | `npcs/merchants/` | `merchant`, `blacksmith`, `herbalist` |
| Townsfolk | `npcs/townsfolk/` | `innkeeper`, `farmer` |
| Guards | `npcs/guards/` | `guard`, `guard_captain` |
| Bandits | `enemies/bandits/` | `bandit_thug`, `bandit_archer`, `bandit_captain` |
| Undead | `enemies/undead/` | `skeleton_warrior`, `ghost`, `wraith` |
| Beasts | `enemies/beasts/` | `wolf`, `bear` |
| Bosses | `enemies/bosses/` | `bandit_chief`, `orc_warlord` |

---

## Interactive Workflow

### Phase 0: Input Mode Selection

**ALWAYS start by asking how the user wants to provide character information:**

```markdown
## Character Creation Session

How would you like to create this character?

**Input Mode:**
- [ ] **D&D/Tabletop Character** - I have a D&D NPC/monster to translate
- [ ] **Structured Data** - I have character details prepared (table, text, or statblock)
- [ ] **Reference Document** - Extract from character-profiles.md or narrative docs
- [ ] **Interactive Q&A** - Guide me through the process step by step

Select your preferred input mode to continue.
```

**Wait for user response before proceeding.**

---

### Phase 0-DND: D&D/Tabletop Character Input

**If user selects D&D/Tabletop Character input:**

```markdown
## D&D Character Translation

I'll help you translate a D&D character into the CRPG format.

**1. Character Source**
Where is this character from?
- [ ] **D&D Module** - NPC from an official adventure (e.g., "Sildar Hallwinter from LMoP")
- [ ] **Monster Manual** - Standard creature/enemy (e.g., "Goblin", "Orc Warchief")
- [ ] **Custom Character** - Your own D&D character with a statblock
- [ ] **Text Description** - I'll paste or describe the character

**2. Character Information**
Provide as much as you have:
- **Name:** (D&D name)
- **Race/Type:** (e.g., Human, Orc, Undead)
- **Class/Role:** (e.g., Fighter 3, Commoner, CR 1/4 Goblin)
- **Alignment:** (e.g., Lawful Good, Chaotic Evil)
- **Location:** (Where in the adventure they appear)

**3. D&D Stats (if available)**
| Stat | Score | Modifier |
|------|-------|----------|
| STR | __ | __ |
| DEX | __ | __ |
| CON | __ | __ |
| INT | __ | __ |
| WIS | __ | __ |
| CHA | __ | __ |

**Paste your character info:**
```

**Wait for user response.**

#### D&D to CRPG Stat Conversion

Use this formula to convert D&D stats (1-20) to CRPG stats (1-100):

```
CRPG_stat = D&D_stat * 5

Example:
D&D STR 16 → CRPG Strength 80
D&D DEX 14 → CRPG Agility 70
D&D CON 12 → CRPG Vitality 60
```

**Stat Mapping:**
| D&D Stat | CRPG Stat | Notes |
|----------|-----------|-------|
| Strength | strength | Direct conversion |
| Dexterity | agility | Direct conversion |
| Constitution | vitality | Direct conversion |
| Intelligence | intelligence | Direct conversion |
| Wisdom | wisdom | Direct conversion |
| Charisma | charisma | Direct conversion |

**Level Conversion:**
| D&D Level/CR | CRPG Level |
|--------------|------------|
| CR 1/8 - 1/4 | Level 1 |
| CR 1/2 - 1 | Level 2 |
| CR 2-3 | Level 3-4 |
| CR 4-5 | Level 5-6 |
| Level 1-4 | Level 1-3 |
| Level 5-10 | Level 4-7 |
| Level 11+ | Level 8-10 |

#### D&D Role to CRPG Role Mapping

| D&D Type | CRPG Role | Tier |
|----------|-----------|------|
| Main villain/BBEG | enemy | 1 |
| Major NPC (quest giver, ally) | major_npc | 1-2 |
| Companion NPC | companion | 1 |
| Minor NPC (shopkeeper, innkeeper) | minor_npc | 3 |
| Background NPC | minor_npc | 4 |
| Boss monster | enemy | 1 |
| Elite monster | enemy | 2 |
| Standard monster | enemy | 3 |
| Minion/fodder | enemy | 4 |

#### D&D Character Analysis Template

After receiving D&D character info, present analysis:

```markdown
## D&D Character Analysis: [Character Name]

### Source Information
- **D&D Name:** [Name]
- **D&D Type:** [Race/Class/CR]
- **Alignment:** [Alignment]
- **Adventure:** [Module name if applicable]

### CRPG Translation

| D&D Field | CRPG Field | Value |
|-----------|------------|-------|
| Name | display_name | "[Translated name]" |
| Race/Class | tags | ["race", "class", "type"] |
| CR/Level | level | [Converted level] |
| STR → strength | base.strength | [D&D x 5] |
| DEX → agility | base.agility | [D&D x 5] |
| CON → vitality | base.vitality | [D&D x 5] |
| INT → intelligence | base.intelligence | [D&D x 5] |
| WIS → wisdom | base.wisdom | [D&D x 5] |
| CHA → charisma | base.charisma | [D&D x 5] |

### Suggested CRPG Classification

| Field | Value | Reasoning |
|-------|-------|-----------|
| role | [role] | [Why this role] |
| tier | [1-4] | [Why this tier] |
| factions | [list] | [Based on D&D allegiances] |

### Personality Translation

| D&D | CRPG | Notes |
|-----|------|-------|
| Alignment | traits | [LG → honorable, loyal; CE → cruel, chaotic] |
| Ideal | motivation | [D&D ideal → CRPG motivation] |
| Bond | relationships | [D&D bond → relationship entries] |
| Flaw | traits | [D&D flaw as negative trait] |

---

**Confirm this translation or provide corrections:**
```

**Wait for user confirmation, then generate the .char file.**

---

### Phase 1: Character Basics

```markdown
## Character Creation Session

Let's create a new character for your game.

**1. Character ID**
Enter a unique identifier (lowercase, underscores allowed):
Example: `merchant_willem`, `ser_aldric`, `bandit_chief_rook`

**2. Display Name**
What name is shown to players?
Example: "Willem the Trader", "Ser Aldric the Bold"

**3. Role**
What is this character's role?
- [ ] companion - Recruitable party member
- [ ] major_npc - Important story character
- [ ] minor_npc - Background character with dialogue
- [ ] enemy - Combat opponent
- [ ] referenced - Mentioned but never seen

**4. Importance Tier**
How important is this character?
- [ ] Tier 1 (Hero) - Full content required
- [ ] Tier 2 (Supporting) - Stats, portrait, dialogue
- [ ] Tier 3 (Minor) - Basic stats, portrait
- [ ] Tier 4 (Background) - Name only
```

**Wait for user response before proceeding.**

---

### Phase 2: Identity Details

```markdown
## Identity Details

**5. Titles**
List any titles or honorifics:
(Leave empty if none)
Example: "Knight of the Silver Order", "Champion of Easthold"

**6. Aliases**
Other names this character is known by:
(Leave empty if none)
Example: "The Lion of the East", "Old Willem"

**7. Factions**
What factions does this character belong to?
(Leave empty if none)
Example: "Merchant Guild", "Silver Order", "Eastern Orc Tribes"

**8. Tags**
Tags for filtering and organization:
Example: merchant, vendor, friendly, boss, enemy, warrior
```

**Wait for user response before proceeding.**

---

### Phase 3: Appearance

```markdown
## Appearance

**9. Physical Description**
Describe the character's appearance:
Example: "A tall, broad-shouldered knight with steel-grey eyes and a distinctive scar across his left cheek."

**10. Sprite Selection**
Choose a sprite or describe for later creation:

**Available sprites:**
| Category | Options |
|----------|---------|
| Companions | warrior, mage, rogue |
| Quest Givers | village_elder, priest, mysterious_stranger |
| Merchants | merchant, blacksmith, herbalist |
| Townsfolk | innkeeper, farmer |
| Guards | guard, guard_captain |
| Bandits | bandit_thug, bandit_archer, bandit_captain |
| Undead | skeleton_warrior, ghost, wraith |
| Beasts | wolf |
| Bosses | bandit_chief, orc_warlord |

Enter sprite path or "custom" for placeholder:
```

**Wait for user response before proceeding.**

---

### Phase 4: Personality

```markdown
## Personality

**11. Personality Traits**
List 3-5 personality traits:
Example: brave, loyal, honorable, stubborn

**12. Motivation**
What drives this character? What do they want?
Example: "To protect the innocent and uphold the code of his order."

**13. Speech Pattern**
How does this character speak?
Example: "Formal and measured, with occasional archaic phrases."

**14. Voice Notes** (optional)
Notes for voice acting or text-to-speech:
Example: "Deep baritone, commanding presence"
```

**Wait for user response before proceeding.**

---

### Phase 5: Stats (if applicable)

```markdown
## Character Stats

**For combat-capable characters (companions, enemies, some NPCs):**

**15. Base Stats**
Assign values (1-100, default 10):

| Stat | Value | Description |
|------|-------|-------------|
| Strength | [___] | Physical power, melee damage |
| Agility | [___] | Speed, evasion, ranged |
| Vitality | [___] | Health, stamina |
| Intelligence | [___] | Magic power |
| Wisdom | [___] | Mana, magic defense |
| Charisma | [___] | Dialogue, prices |

**Suggested archetypes:**
| Archetype | STR | AGI | VIT | INT | WIS | CHA |
|-----------|-----|-----|-----|-----|-----|-----|
| Fighter | 16 | 10 | 14 | 8 | 10 | 12 |
| Rogue | 10 | 16 | 10 | 12 | 10 | 14 |
| Mage | 8 | 10 | 10 | 16 | 14 | 12 |
| Tank | 14 | 8 | 18 | 8 | 12 | 10 |
| Merchant | 8 | 8 | 10 | 12 | 10 | 16 |
| Civilian | 10 | 10 | 10 | 10 | 10 | 10 |

**16. Level**
Starting level (1-20):

**17. XP**
Starting experience points (default 0):
```

**Wait for user response before proceeding.**

---

### Phase 6: Relationships & References

```markdown
## Relationships & References

**18. Relationships**
Does this character have relationships with other characters?

| Target ID | Type | Notes |
|-----------|------|-------|
| [character_id] | [type] | [context] |

**Relationship types:** ally, enemy, family, romantic, business, rival, neutral, friend, acquaintance, mentor, student

**19. Dialogue Reference**
If this character has dialogue, what's the dialogue tree ID?
(Leave empty if dialogue will be created later)
Example: `dlg_merchant_willem`, `aldric_recruitment`

**20. Inventory Reference** (for merchants)
If this is a merchant, what's the shop inventory ID?
(Leave empty if not a merchant)
Example: `shop_general_goods`, `shop_weapons`
```

**Wait for user response before proceeding.**

---

### Phase 7: Designer Notes

```markdown
## Designer Notes

**21. Design Notes**
Any notes about this character for the design team:
Example: "Primary tank companion. His personal quest involves confronting Baron Blackwood."

**22. Todos**
Any tasks remaining for this character?
Example:
- [ ] Add combat voice lines
- [x] Design recruitment quest

**23. Campaign ID** (optional)
If this character belongs to a specific test campaign:
Example: `haunted_crypt`, `blood_and_gold`
```

---

## Output Format

Save character files to: `data/characters/[category]/[character_id].char`

**Category mapping:**
| Role | Directory |
|------|-----------|
| companion | `data/characters/companions/` |
| major_npc | `data/characters/npcs/` |
| minor_npc | `data/characters/npcs/` |
| enemy | `data/characters/enemies/` |
| referenced | `data/characters/npcs/` |

---

## Templates

### Template 1: Companion Character (Tier 1)

```json
{
  "version": 1,
  "id": "companion_name",
  "identity": {
    "display_name": "Companion Display Name",
    "titles": ["Title if any"],
    "aliases": ["Alias if any"]
  },
  "classification": {
    "role": "companion",
    "factions": ["Faction Name"],
    "tier": 1,
    "tags": ["companion", "warrior"]
  },
  "appearance": {
    "portrait": "res://assets/sprites/characters/companions/warrior/base/south.png",
    "sprite_project": "res://assets/sprites/characters/companions/warrior",
    "description": "Detailed physical description."
  },
  "personality": {
    "traits": ["brave", "loyal", "stubborn"],
    "motivation": "Character's driving goal.",
    "speech_pattern": "How they speak.",
    "voice_notes": "Voice acting notes"
  },
  "stats": {
    "base": {
      "strength": 14,
      "agility": 12,
      "vitality": 14,
      "intelligence": 10,
      "wisdom": 10,
      "charisma": 12
    },
    "level": 1,
    "xp": 0
  },
  "dialogue_ref": "dlg_companion_name",
  "relationships": [
    {
      "target": "related_character",
      "type": "friend",
      "notes": "Context of relationship"
    }
  ],
  "notes": {
    "design": "Design notes about role in the story.",
    "todos": [],
    "history": ["Created via character-creator skill"]
  },
  "metadata": {
    "version": 1,
    "created": "2026-01-27T00:00:00Z",
    "modified": "2026-01-27T00:00:00Z",
    "author": "Character Creator"
  }
}
```

---

### Template 2: Quest Giver NPC (Tier 2)

```json
{
  "version": 1,
  "id": "npc_quest_giver",
  "identity": {
    "display_name": "Quest Giver Name",
    "titles": [],
    "aliases": []
  },
  "classification": {
    "role": "major_npc",
    "factions": [],
    "tier": 2,
    "tags": ["quest_giver", "friendly"]
  },
  "appearance": {
    "portrait": "res://assets/sprites/characters/npcs/quest_givers/village_elder/base/south.png",
    "sprite_project": "res://assets/sprites/characters/npcs/quest_givers/village_elder",
    "description": "Brief physical description."
  },
  "personality": {
    "traits": ["wise", "concerned"],
    "motivation": "Protect their village/family/etc.",
    "speech_pattern": "Speaks with urgency.",
    "voice_notes": ""
  },
  "stats": {
    "base": {
      "strength": 8,
      "agility": 8,
      "vitality": 10,
      "intelligence": 12,
      "wisdom": 14,
      "charisma": 12
    },
    "level": 1,
    "xp": 0
  },
  "dialogue_ref": "dlg_quest_giver",
  "relationships": [],
  "notes": {
    "design": "Gives quest X to the player.",
    "todos": [],
    "history": ["Created via character-creator skill"]
  },
  "metadata": {
    "created": "2026-01-27T00:00:00Z",
    "modified": "2026-01-27T00:00:00Z"
  }
}
```

---

### Template 3: Merchant NPC (Tier 3)

```json
{
  "version": 1,
  "id": "merchant_name",
  "identity": {
    "display_name": "Merchant Name",
    "titles": [],
    "aliases": ["Nickname"]
  },
  "classification": {
    "role": "minor_npc",
    "factions": ["Merchant Guild"],
    "tier": 3,
    "tags": ["merchant", "vendor", "friendly"]
  },
  "appearance": {
    "portrait": "res://assets/sprites/characters/npcs/merchants/merchant/base/south.png",
    "sprite_project": "res://assets/sprites/characters/npcs/merchants/merchant",
    "description": "Brief description."
  },
  "personality": {
    "traits": ["friendly", "greedy"],
    "motivation": "Making gold.",
    "speech_pattern": "Enthusiastic salesman.",
    "voice_notes": ""
  },
  "stats": {
    "base": {
      "strength": 8,
      "agility": 8,
      "vitality": 10,
      "intelligence": 12,
      "wisdom": 10,
      "charisma": 16
    },
    "level": 1,
    "xp": 0
  },
  "dialogue_ref": "dlg_merchant_generic",
  "inventory_ref": "shop_general_goods",
  "relationships": [],
  "notes": {
    "design": "Sells basic goods.",
    "todos": [],
    "history": ["Created via character-creator skill"]
  },
  "metadata": {
    "created": "2026-01-27T00:00:00Z",
    "modified": "2026-01-27T00:00:00Z"
  }
}
```

---

### Template 4: Basic Enemy (Tier 3)

```json
{
  "version": 1,
  "id": "enemy_type",
  "identity": {
    "display_name": "Enemy Name",
    "titles": [],
    "aliases": []
  },
  "classification": {
    "role": "enemy",
    "factions": [],
    "tier": 3,
    "tags": ["enemy", "combat"]
  },
  "appearance": {
    "portrait": "res://assets/sprites/characters/enemies/bandits/bandit_thug/base/south.png",
    "sprite_project": "res://assets/sprites/characters/enemies/bandits/bandit_thug",
    "description": "Brief description."
  },
  "personality": {
    "traits": ["aggressive"],
    "motivation": "",
    "speech_pattern": "",
    "voice_notes": ""
  },
  "stats": {
    "base": {
      "strength": 12,
      "agility": 10,
      "vitality": 12,
      "intelligence": 8,
      "wisdom": 8,
      "charisma": 6
    },
    "level": 1,
    "xp": 0
  },
  "relationships": [],
  "notes": {
    "design": "Basic combat enemy.",
    "todos": [],
    "history": ["Created via character-creator skill"]
  },
  "metadata": {
    "created": "2026-01-27T00:00:00Z",
    "modified": "2026-01-27T00:00:00Z"
  }
}
```

---

### Template 5: Boss Enemy (Tier 1)

```json
{
  "version": 1,
  "id": "boss_name",
  "identity": {
    "display_name": "Boss Display Name",
    "titles": ["Impressive Title"],
    "aliases": ["Fearsome Nickname"]
  },
  "classification": {
    "role": "enemy",
    "factions": ["Enemy Faction"],
    "tier": 1,
    "tags": ["boss", "enemy", "leader"]
  },
  "appearance": {
    "portrait": "res://assets/sprites/characters/enemies/bosses/bandit_chief/base/south.png",
    "sprite_project": "res://assets/sprites/characters/enemies/bosses/bandit_chief",
    "description": "Imposing physical description."
  },
  "personality": {
    "traits": ["brutal", "cunning", "proud"],
    "motivation": "Character's villainous goal.",
    "speech_pattern": "How they speak to enemies.",
    "voice_notes": "Menacing voice"
  },
  "stats": {
    "base": {
      "strength": 18,
      "agility": 12,
      "vitality": 16,
      "intelligence": 12,
      "wisdom": 10,
      "charisma": 14
    },
    "level": 5,
    "xp": 0
  },
  "dialogue_ref": "dlg_boss_confrontation",
  "relationships": [
    {
      "target": "ally_character",
      "type": "ally",
      "notes": "Secret alliance"
    }
  ],
  "notes": {
    "design": "Act X boss. Drops key item Y.",
    "todos": [],
    "history": ["Created via character-creator skill"]
  },
  "metadata": {
    "created": "2026-01-27T00:00:00Z",
    "modified": "2026-01-27T00:00:00Z"
  }
}
```

---

### Template 6: Background NPC (Tier 4)

```json
{
  "version": 1,
  "id": "npc_background",
  "identity": {
    "display_name": "NPC Name",
    "titles": [],
    "aliases": []
  },
  "classification": {
    "role": "minor_npc",
    "factions": [],
    "tier": 4,
    "tags": ["background", "townsfolk"]
  },
  "appearance": {
    "portrait": "",
    "sprite_project": "",
    "description": "Brief description."
  },
  "personality": {
    "traits": [],
    "motivation": "",
    "speech_pattern": "",
    "voice_notes": ""
  },
  "relationships": [],
  "notes": {
    "design": "Background character, minimal interaction.",
    "todos": [],
    "history": ["Created via character-creator skill"]
  },
  "metadata": {
    "created": "2026-01-27T00:00:00Z",
    "modified": "2026-01-27T00:00:00Z"
  }
}
```

---

## Integration with Other Skills

| Skill | Relationship | Direction |
|-------|--------------|-----------|
| **narrative-architect** | Provides character-profiles.md with deep specifications | Reads from |
| **world-builder** | References NPCs in location `custom_data.npcs` | Works with |
| **dialogue-designer** | Creates dialogue trees referenced by `dialogue_ref` | Provides to |
| **encounter-designer** | References enemy characters in combat | Provides to |
| **quest-designer** | References characters as quest givers, targets | Provides to |
| **campaign-creator** | Includes characters in campaign starting_npcs | Provides to |
| **test-campaign-generator** | Specs character requirements for scaffolding | Alternative path |
| **test-campaign-scaffolder** | Creates characters from campaign specs | Alternative path |

### Skill Workflow Paths

**Incremental Path (this skill):**
```
narrative-architect → CHARACTER-CREATOR → dialogue-designer / encounter-designer
                           ↓
                      .char files
```

**Bulk Path (test campaigns):**
```
test-campaign-generator → test-campaign-scaffolder → (creates characters automatically)
```

**D&D Import Path:**
```
D&D NPC/Monster → CHARACTER-CREATOR (D&D mode) → .char file
                        ↓
              dialogue-designer → encounter-designer → campaign-creator
```

---

## Troubleshooting

### Common Issues

**Character not appearing in game:**
- Check file is in correct directory (npcs/, enemies/, companions/)
- Verify `id` matches the filename (without .char extension)
- Check worldmap location references correct `npc_id`

**Portrait not displaying:**
- Verify `appearance.portrait` path exists
- Path should end with `/base/south.png`
- Check for typos in sprite category/name

**Stats not working in combat:**
- Ensure `stats.base` object has all six attributes
- Check `stats.level` is set (minimum 1)
- For enemies, verify they're referenced in encounter files

**Relationships not showing:**
- Target character ID must exist as a .char file
- Relationship `type` must be valid enum value
- Both characters should reference each other for bidirectional relationships

**Dialogue not triggering:**
- Verify `dialogue_ref` matches a .dtree file ID
- Check dialogue file exists in `data/dialogue/`
- Ensure NPC is placed in worldmap location

---

## Validation Checklist

Before completing, verify:

- [ ] `id` is unique, lowercase, uses underscores only
- [ ] `identity.display_name` is set
- [ ] `classification.role` is valid (companion/major_npc/minor_npc/enemy/referenced)
- [ ] `classification.tier` matches content completeness (1-4)
- [ ] Sprite paths are valid for `appearance.portrait` and `appearance.sprite_project`
- [ ] For Tier 1-2: personality fields are populated
- [ ] For combat characters: stats.base has all six attributes
- [ ] `dialogue_ref` points to existing or planned dialogue tree
- [ ] Relationship targets are valid character IDs
- [ ] File saved to correct directory based on role
- [ ] JSON is valid (no syntax errors)

---

## Example Invocations

### Standard Invocations
- "Create a merchant NPC named Helena"
- "Design a tier 1 companion warrior"
- "Make a bandit boss for the ambush encounter"
- "Create a quest giver for the village"
- "Add an enemy wolf character"
- "Use character-creator to make a mysterious stranger NPC"

### D&D/Tabletop Invocations
- "Convert Sildar Hallwinter from Lost Mine of Phandelver"
- "Create a goblin enemy based on the Monster Manual statblock"
- "Translate this D&D NPC to a CRPG character: [statblock]"
- "I need to convert Harbin Wester from Dragons of Icespire Peak"
- "Create an orc warchief enemy - I have the D&D stats"
- "Translate my D&D campaign's villain to the CRPG format"
- "Convert this party of D&D characters to companions"
