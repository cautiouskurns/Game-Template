---
name: lore-generator
description: Generate rich, consistent lore entries for world history, factions, locations, characters, items, creatures, religions, magic systems, cultures, and legends. Ensures consistency with existing lore and project tone.
domain: narrative
type: generator
version: 1.0.0
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Lore Generator Skill

This skill generates comprehensive, consistent lore entries for the game world, maintaining narrative coherence across all lore types while respecting the established tone, timeline, and world rules.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | content-architect |
| **Sprint Phase** | Phase B (Implementation) |
| **Directory Scope** | `data/world/`, `docs/` |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

> **Genre Note:** RPG-biased examples but lore generation applies to any narrative game.

---

## When to Use This Skill

Invoke this skill when the user:
- Says "generate lore" or "create lore entry"
- Asks "write lore for [topic]"
- Wants to document world history, factions, or legends
- Says "expand the lore about [subject]"
- Needs consistent background information for game elements
- Asks to "fill in lore gaps" or "connect lore elements"
- Wants to create discoverable in-game text (books, journals, inscriptions)

---

## Core Principle

**Lore is the soul of the world**:
- Lore entries must be internally consistent
- Every entry should connect to the broader world
- Tone must match the game's atmosphere (dark fantasy for Blood & Gold)
- Lore should feel discoverable, not encyclopedic
- Quality over quantity - fewer rich entries beat many shallow ones
- Living document that grows with the game

---

## Lore Entry Types

### 1. World History
Timeline events, ages, and historical periods that shaped the world.

**Structure:**
```json
{
  "id": "history_founding_of_silvermere",
  "type": "world_history",
  "title": "The Founding of Silvermere",
  "era": "Age of Kingdoms",
  "year": "Year 412 of the Third Age",
  "summary": "Brief 1-2 sentence summary",
  "full_text": "Detailed narrative (200-500 words)",
  "key_figures": ["character_id_1", "character_id_2"],
  "related_locations": ["location_silvermere"],
  "consequences": ["What this event caused"],
  "discovery_level": "common|uncommon|rare|legendary",
  "sources": ["Where players might learn this"]
}
```

### 2. Factions
Organizations, kingdoms, guilds, and groups with their own agendas.

**Structure:**
```json
{
  "id": "faction_ironmark_legion",
  "type": "faction",
  "name": "The Ironmark Legion",
  "motto": "Steel Endures",
  "summary": "Brief description",
  "history": "Origin and key events",
  "beliefs": ["Core tenets and values"],
  "structure": "Leadership and organization",
  "territories": ["location_ids"],
  "allies": ["faction_ids"],
  "enemies": ["faction_ids"],
  "notable_members": ["character_ids"],
  "player_reputation_effects": "How joining/opposing affects gameplay",
  "discovery_level": "common|uncommon|rare|legendary"
}
```

### 3. Locations
Places with history, atmosphere, and secrets.

**Structure:**
```json
{
  "id": "location_thornwood_ruins",
  "type": "location",
  "name": "The Thornwood Ruins",
  "region": "Thornwood",
  "location_type": "dungeon|town|landmark|wilderness",
  "summary": "Brief atmospheric description",
  "history": "What happened here",
  "current_state": "What players find now",
  "inhabitants": ["Who or what lives here"],
  "secrets": ["Hidden information"],
  "connected_quests": ["quest_ids"],
  "discovery_level": "common|uncommon|rare|legendary"
}
```

### 4. Characters (Historical/Legendary)
NPCs, historical figures, and legendary heroes/villains.

**Structure:**
```json
{
  "id": "character_valdric_the_betrayer",
  "type": "character",
  "name": "Valdric the Betrayer",
  "titles": ["Former Knight-Commander", "The Oathbreaker"],
  "status": "alive|dead|unknown|legendary",
  "era": "When they lived/live",
  "summary": "Brief description",
  "background": "Origin and history",
  "personality": "Key traits and motivations",
  "notable_deeds": ["What they're known for"],
  "relationships": {"character_id": "relationship_type"},
  "faction_affiliations": ["faction_ids"],
  "legacy": "How they're remembered",
  "discovery_level": "common|uncommon|rare|legendary"
}
```

### 5. Items (Legendary/Artifact)
Weapons, armor, and artifacts with history and significance.

**Structure:**
```json
{
  "id": "item_blade_of_sundered_oaths",
  "type": "item_lore",
  "name": "The Blade of Sundered Oaths",
  "item_type": "weapon|armor|artifact|relic",
  "summary": "Brief description",
  "appearance": "Physical description",
  "history": "Origin and notable wielders",
  "powers": ["Legendary abilities or curses"],
  "current_location": "Where it might be found",
  "related_quests": ["quest_ids"],
  "discovery_level": "rare|legendary"
}
```

### 6. Creatures
Monsters, beasts, and supernatural beings.

**Structure:**
```json
{
  "id": "creature_ashwalker",
  "type": "creature",
  "name": "Ashwalker",
  "creature_type": "undead|beast|demon|construct|aberration",
  "summary": "Brief description",
  "appearance": "Physical description",
  "behavior": "How they act",
  "origin": "Where they come from",
  "weaknesses": ["What harms them"],
  "habitat": ["Where they're found"],
  "folklore": "What common folk believe",
  "truth": "What's actually true",
  "discovery_level": "common|uncommon|rare|legendary"
}
```

### 7. Religions & Deities
Gods, faiths, and spiritual beliefs.

**Structure:**
```json
{
  "id": "religion_cult_of_the_shattered_sun",
  "type": "religion",
  "name": "The Cult of the Shattered Sun",
  "deity": "The Broken One",
  "domain": "What the faith governs",
  "summary": "Brief description",
  "beliefs": ["Core tenets"],
  "practices": ["Rituals and observances"],
  "clergy": "Structure of priesthood",
  "holy_sites": ["location_ids"],
  "symbols": "Sacred imagery",
  "relationship_to_magic": "How faith interacts with magic",
  "followers": "Who worships and why",
  "discovery_level": "common|uncommon|rare|legendary"
}
```

### 8. Magic Systems
How magic works, schools of magic, and magical phenomena.

**Structure:**
```json
{
  "id": "magic_blood_weaving",
  "type": "magic_system",
  "name": "Blood Weaving",
  "summary": "Brief description",
  "source": "Where the power comes from",
  "practitioners": "Who uses this magic",
  "methods": "How it's performed",
  "costs": "What it requires/risks",
  "limitations": "What it cannot do",
  "history": "Origin and development",
  "public_perception": "How common folk view it",
  "legal_status": "Is it forbidden/regulated",
  "discovery_level": "uncommon|rare|legendary"
}
```

### 9. Cultures
Peoples, traditions, and ways of life.

**Structure:**
```json
{
  "id": "culture_northern_ironborn",
  "type": "culture",
  "name": "The Ironborn of the North",
  "summary": "Brief description",
  "homeland": "Where they live",
  "history": "Origin and development",
  "values": ["What they hold dear"],
  "customs": ["Daily life and traditions"],
  "social_structure": "How society is organized",
  "relations": {"culture_id": "relationship"},
  "language": "How they speak",
  "notable_figures": ["character_ids"],
  "discovery_level": "common|uncommon|rare"
}
```

### 10. Legends & Myths
Stories, prophecies, and folk tales.

**Structure:**
```json
{
  "id": "legend_last_king_prophecy",
  "type": "legend",
  "name": "The Prophecy of the Last King",
  "legend_type": "prophecy|myth|folk_tale|nursery_rhyme",
  "summary": "Brief description",
  "full_text": "The actual story/prophecy text",
  "origin": "Where this story comes from",
  "variations": ["Different versions"],
  "truth_level": "How much is true",
  "related_events": ["history_ids"],
  "related_characters": ["character_ids"],
  "player_relevance": "How it affects the game",
  "discovery_level": "common|uncommon|rare|legendary"
}
```

---

## Discovery Levels

| Level | Meaning | How Players Learn |
|-------|---------|-------------------|
| **Common** | General knowledge | Starting knowledge, basic NPCs, signposts |
| **Uncommon** | Requires some effort | Libraries, scholars, investigation |
| **Rare** | Hidden knowledge | Ancient texts, secret societies, exploration |
| **Legendary** | Almost forgotten | Unique discoveries, main quests, hidden areas |

---

## Interactive Workflow

### Phase 1: Context Gathering

**Always start by reading existing lore:**

```
I'll help you create lore for [topic]. Let me first check what already exists to ensure consistency.

[Read existing lore files from data/lore/]
[Read design-bible.md for tone and setting]
[Read any relevant GDD sections]
```

**Questions to ask:**
1. What type of lore entry is this? (See 10 types above)
2. How does this connect to existing lore?
3. What discovery level should it have?
4. Is this for a specific quest/location/character?

---

### Phase 2: Consistency Check

**Before generating, verify:**

- **Timeline**: Does this fit the established chronology?
- **Geography**: Is this consistent with the world map?
- **Characters**: Do referenced characters exist and match?
- **Tone**: Does this match the dark fantasy atmosphere?
- **Power Level**: Is this consistent with magic/technology levels?
- **Faction Alignment**: Do faction relationships make sense?

```
**Consistency Check:**
- Timeline: [Fits/Conflicts with X]
- Geography: [Fits/Conflicts with X]
- Characters: [References X, Y, Z - all consistent]
- Tone: [Matches dark fantasy setting]
- Power Level: [Appropriate for world]
- Factions: [Consistent with established relationships]
```

---

### Phase 3: Generation Modes

#### Mode 1: Single Entry
Generate one detailed lore entry with full structure.

```
User: "Create lore for the Ironmark Legion faction"

Output:
- Complete faction JSON structure
- Narrative prose version for in-game books
- Connection map to existing lore
- Suggested discovery locations
```

#### Mode 2: Batch Generation
Generate multiple related entries at once.

```
User: "Create lore entries for all the major factions"

Output:
- Multiple faction entries
- Cross-references between them
- Relationship matrix
- Conflict points for quest hooks
```

#### Mode 3: Gap Analysis
Identify missing lore connections.

```
User: "What lore gaps exist?"

Output:
- List of referenced but undefined elements
- Orphaned connections
- Timeline gaps
- Suggested entries to fill gaps
```

#### Mode 4: Lore Expansion
Expand existing entry with more detail.

```
User: "Expand the lore about Thornwood"

Output:
- Enhanced location entry
- Related history entries
- Character connections
- Creature lore for the area
- Legends associated with the place
```

---

### Phase 4: Output Format

**Generate lore in multiple formats:**

#### 1. JSON Data File
For game integration and data-driven systems.

```json
// Save to: data/lore/factions/ironmark_legion.json
{
  "id": "faction_ironmark_legion",
  "type": "faction",
  "name": "The Ironmark Legion",
  // ... full structure
}
```

#### 2. Narrative Prose
For in-game books, journals, and dialogue.

```markdown
// Save to: data/lore/prose/ironmark_legion.md

# The Ironmark Legion

*From "Chronicles of the Northern Kingdoms" by Scholar Aldric*

In the frozen reaches of the north, where summer is but a memory
whispered by the old, there stands an army that has never known
defeat. They call themselves the Ironmark Legion...
```

#### 3. Discovery Fragments
Short versions for gradual revelation.

```json
// Save to: data/lore/fragments/ironmark_legion_fragments.json
{
  "fragments": [
    {
      "level": 1,
      "text": "The Ironmark Legion guards the northern passes.",
      "source": "common_knowledge"
    },
    {
      "level": 2,
      "text": "Their founder, General Valdric, vanished during the Sundering.",
      "source": "history_book"
    },
    {
      "level": 3,
      "text": "The Legion's true purpose is not defense, but containment.",
      "source": "secret_archives"
    }
  ]
}
```

---

## File Organization

```
data/lore/
├── world_history/
│   ├── ages/
│   │   ├── first_age.json
│   │   └── age_of_sundering.json
│   └── events/
│       ├── founding_of_silvermere.json
│       └── the_great_betrayal.json
├── factions/
│   ├── ironmark_legion.json
│   └── cult_of_the_shattered_sun.json
├── locations/
│   ├── regions/
│   │   ├── ironmark.json
│   │   └── thornwood.json
│   └── landmarks/
│       └── thornwood_ruins.json
├── characters/
│   ├── historical/
│   │   └── valdric_the_betrayer.json
│   └── legendary/
│       └── the_first_king.json
├── items/
│   └── artifacts/
│       └── blade_of_sundered_oaths.json
├── creatures/
│   ├── undead/
│   │   └── ashwalker.json
│   └── beasts/
│       └── thornwood_stalker.json
├── religions/
│   └── cult_of_the_shattered_sun.json
├── magic/
│   └── blood_weaving.json
├── cultures/
│   └── northern_ironborn.json
├── legends/
│   ├── prophecies/
│   │   └── last_king_prophecy.json
│   └── folk_tales/
│       └── the_weeping_bride.json
├── prose/
│   ├── books/
│   │   └── chronicles_of_the_north.md
│   └── journals/
│       └── valdrics_diary.md
├── fragments/
│   └── ironmark_legion_fragments.json
└── index.json  # Master index of all lore
```

---

## Consistency Rules

### Timeline Rules
- The current era is the "Age of Ashes" (post-Sundering)
- Major ages must be referenced consistently
- Character lifespans must be realistic (or explained if not)

### Geography Rules
- Locations must fit the established map
- Travel times should be consistent
- Climate should match region

### Character Rules
- Characters referenced must exist or be created
- Relationships must be bidirectional (if A knows B, B knows A)
- Titles and names must be consistent across entries

### Tone Rules
- Dark fantasy setting - gritty, morally gray
- Magic is rare and has costs
- Hope exists but is hard-won
- History repeats; cycles of rise and fall

### Power Level Rules
- No world-breaking artifacts without severe limitations
- Magic users are rare and feared
- Divine intervention is subtle or absent
- Martial skill matters more than magic in most conflicts

### Faction Rules
- Every faction has enemies AND allies
- Internal conflicts exist within factions
- No faction is purely good or evil
- Power struggles are constant

---

## Example Interactions

### Creating a New Faction

```
User: "Create lore for a thieves guild in Silvermere"

Skill Response:
1. Read existing Silvermere location lore
2. Check for existing criminal organizations
3. Verify faction slot available
4. Ask clarifying questions:
   - What's their specialty? (Heists, smuggling, information)
   - Are they old or newly formed?
   - How do they relate to city authorities?
5. Generate faction entry with connections to existing lore
6. Create leader character entry
7. Add discovery fragments for gradual revelation
8. Save all files to appropriate locations
```

### Expanding Existing Lore

```
User: "Tell me more about the Sundering event"

Skill Response:
1. Read existing Sundering references
2. Identify gaps in the narrative
3. Generate expanded history entry
4. Create related character entries (key figures)
5. Add prophecy/legend that foretold it
6. Create aftermath entries showing consequences
7. Update timeline index
```

### Gap Analysis

```
User: "What lore needs to be written?"

Skill Response:
1. Scan all existing lore files
2. Build reference graph
3. Identify:
   - Characters mentioned but not defined
   - Locations referenced without entries
   - Events alluded to without detail
   - Factions missing key information
4. Prioritize by story importance
5. Present gap report with recommendations
```

---

## Integration with Other Skills

### With `quest-designer`
- Provide lore context for quest narratives
- Ensure quest references match existing lore
- Create lore entries for quest-specific elements

### With `dialogue-designer`
- Supply character backgrounds for dialogue writing
- Provide faction tones and speaking styles
- Offer historical references for NPC knowledge

### With `world-builder`
- Ensure location lore matches map data
- Provide region histories and atmospheres
- Connect landmarks to legends

### With `character-creator`
- Supply faction affiliations and backgrounds
- Provide cultural context for character design
- Link NPCs to historical figures

### With `design-bible-updater`
- Lore supports design pillars
- World tone matches design vision
- Power levels align with game balance

---

## Quality Checklist

Before saving any lore entry:

- [ ] ID follows naming convention (type_name_in_snake_case)
- [ ] Summary is 1-2 sentences, captures essence
- [ ] All referenced IDs exist or are flagged for creation
- [ ] Discovery level is appropriate
- [ ] Tone matches dark fantasy setting
- [ ] No world-breaking elements without limitations
- [ ] Connections to existing lore are valid
- [ ] Timeline is consistent
- [ ] Geography makes sense
- [ ] File saved to correct directory

---

## Invocation Examples

User: "Generate lore for a haunted battlefield"
User: "Create a legendary sword with dark history"
User: "Write the creation myth for this world"
User: "Expand the backstory of the Northern kingdoms"
User: "What legends would peasants tell about dragons?"
User: "Create lore entries for all the major religions"
User: "Fill in the lore gaps for Thornwood region"
User: "Write an in-game book about the Age of Kings"

---

## Workflow Summary

1. **Receive request** for lore creation/expansion
2. **Gather context** from existing lore files, design bible, GDD
3. **Ask clarifying questions** if needed (type, discovery level, connections)
4. **Check consistency** with timeline, geography, characters, tone
5. **Generate lore entry** following appropriate structure
6. **Create related entries** (characters, locations, fragments)
7. **Save files** to correct directories
8. **Update index** if applicable
9. **Report** what was created and any new gaps identified

---

## Project Context Discovery

**The skill automatically gathers project-specific context by reading:**

1. **Design Bible** (`docs/design-bible.md`, `docs/*design-bible*.md`)
   - Tone and atmosphere
   - Design pillars
   - World setting
   - What's allowed/forbidden

2. **World Bible** (`docs/world-bible.md`, `docs/*world-bible*.md`)
   - World history and timeline
   - Geographic regions and climate
   - Political structures and kingdoms
   - Races, peoples, and cultures
   - Magic system rules and limitations

3. **Narrative Bible** (`docs/narrative-bible.md`, `docs/*narrative-bible*.md`)
   - Story arcs and plot threads
   - Character relationships
   - Themes and motifs
   - Dramatic beats and pacing
   - Player character arc

3b. **Narrative Direction** (`docs/narrative-direction.md`, if it exists)
   - Dialogue voice and tone templates
   - Lore delivery patterns (environmental, collectible, dialogue)
   - Naming conventions for characters, places, items
   - Prose style guidelines for in-game text

4. **Game Pillars** (`docs/game-pillars.md`, `docs/*pillars*.md`)
   - Core design pillars
   - Player fantasy
   - Experience goals
   - What makes the game unique

5. **GDD Files** (`docs/*gdd*.md`, `docs/*prototype*.md`, `docs/*vertical-slice*.md`)
   - World regions and geography
   - Timeline and eras
   - Faction relationships
   - Scope boundaries

6. **Systems Bible** (`docs/systems-bible.md`)
   - Technical architecture
   - Game systems and mechanics
   - Data structures

7. **Existing Lore** (`data/lore/**/*.json`)
   - Established characters, locations, events
   - Naming conventions
   - Timeline references
   - Faction dynamics

8. **World Data** (`data/world/*.json`)
   - Location definitions
   - Region information
   - Map geography

**This ensures the skill adapts to ANY project's setting and tone rather than assuming a specific world.**

---

## Context Gathering Template

When invoked, the skill should:

```
1. Search for design bible and pillars:
   Glob: docs/*design-bible*.md, docs/*pillars*.md

2. Search for world bible:
   Glob: docs/*world-bible*.md, docs/*world*.md

3. Search for narrative bible:
   Glob: docs/*narrative-bible*.md, docs/*narrative*.md, docs/*story*.md

4. Search for GDD:
   Glob: docs/*gdd*.md, docs/*prototype*.md, docs/*vertical-slice*.md

5. Search for systems bible:
   Glob: docs/*systems-bible*.md, docs/*systems*.md

6. Search for existing lore:
   Glob: data/lore/**/*.json

7. Search for world data:
   Glob: data/world/*.json

8. Extract from these files:
   - Setting name and tone
   - Design pillars and player fantasy
   - Current era/timeline
   - Major regions and geography
   - Established factions and relationships
   - Character backgrounds and arcs
   - Magic system rules
   - Tone guidelines
   - Forbidden elements (if defined)
```

---

This skill ensures your world has depth, consistency, and mystery - making every discovered lore fragment feel like uncovering real history while adapting to your specific project's setting.