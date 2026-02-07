---
name: game-ideator
description: Establish the foundational creative vision for a game through interactive world-building, narrative design, and design pillar definition. Creates the "source of truth" documents that all other specialized skills reference.
domain: design
type: generator
version: 1.0.0
outputs:
  - docs/design/world-bible.md
  - docs/design/narrative-bible.md
  - docs/design/design-pillars.md
allowed-tools:
  - Write
  - Read
  - Glob
---

# Game Ideator Skill

This skill establishes the **foundational creative vision** for a game through **flexible input methods**, then outputs structured "bible" documents that serve as the **source of truth** for all downstream content creation.

**Key Capability:** Accepts input in multiple formats (structured tables, JSON, bullet lists, conversational Q&A) from multiple sources (reference materials, original creation, templates). The user chooses how they want to provide information.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | design-lead |
| **Sprint Phase** | Pre-sprint / Phase A (Spec) |
| **Directory Scope** | `docs/ideas/` |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

---

## CRITICAL: What This Skill Does and Does NOT Do

```
+------------------------------------------+------------------------------------------+
|              THIS SKILL DOES             |          THIS SKILL DOES NOT DO         |
+------------------------------------------+------------------------------------------+
| Accept input via structured data         | Brainstorm multiple game concepts        |
| (tables, JSON, lists) OR conversation    | (use game-concept-generator for that)    |
|                                          |                                          |
| Import from ANY reference material       | Create campaign content                  |
| (D&D, Pathfinder, homebrew, fiction)     | (use test-campaign-generator for that)   |
|                                          |                                          |
| Create world-bible.md (setting, tone,    | Create quests, dialogues, or NPCs        |
| factions, geography)                     | (use specialized designers for that)     |
|                                          |                                          |
| Create narrative-bible.md (themes,       | Create implementation specs              |
| story structure, arcs, endings)          | (use feature-spec-generator for that)    |
|                                          |                                          |
| Create design-pillars.md (core           | Replace creative direction from humans   |
| principles, constraints, identity)       |                                          |
|                                          |                                          |
| Provide creative foundation for          | Force a specific input format            |
| downstream skills to reference           | (user chooses structured or Q&A)         |
+------------------------------------------+------------------------------------------+
```

---

## Skill Hierarchy Position

```
                    ┌─────────────────────────────┐
                    │      GAME IDEATOR           │  ◄── THIS SKILL
                    │   (Creative Foundation)      │
                    └─────────────────────────────┘
                                 │
                    Outputs: docs/design/
                    • world-bible.md
                    • narrative-bible.md
                    • design-pillars.md
                                 │
                    ┌─────────────────────────────┐
                    │   NARRATIVE ARCHITECT       │
                    │   (Story & Character Detail)│
                    └─────────────────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ WORLD           │    │ CHARACTER       │    │ QUEST           │
│ BUILDER         │    │ CREATOR         │    │ DESIGNER        │
│ (.worldmap.json)│    │ (.char files)   │    │ (.json quests)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │              ┌────────┴────────┐              │
         │              ▼                 ▼              │
         │     ┌─────────────────┐ ┌─────────────────┐   │
         │     │ DIALOGUE        │ │ ENCOUNTER       │   │
         │     │ DESIGNER        │ │ DESIGNER        │   │
         │     │ (.dtree files)  │ │ (.json files)   │   │
         │     └─────────────────┘ └─────────────────┘   │
         │                                               │
         └───────────────────────┬───────────────────────┘
                                 ▼
                    ┌─────────────────────────────┐
                    │     CAMPAIGN CREATOR        │
                    │   (Ties everything together)│
                    │   (data/campaigns/*.json)   │
                    └─────────────────────────────┘
```

---

## When to Use This Skill

Invoke this skill when the user:
- Says "I want to establish the vision for my game"
- Says "let's define the world and narrative foundation"
- Asks to "create the game bibles"
- Wants to "set up the creative direction"
- Says "before we build content, let's define the world"
- Is starting a new game project and needs foundational docs
- Says "use game-ideator"
- **Wants to import a D&D/tabletop campaign** into the CRPG engine
- **Has existing written material** (campaign books, notes, setting documents)

**DO NOT use this skill if:**
- User wants to brainstorm multiple game ideas (use game-concept-generator)
- User already has these documents and wants to create campaigns
- User wants implementation details (use feature-spec-generator)

---

## Input Philosophy

The game-ideator skill accepts input in **two orthogonal dimensions**:

1. **Input Source** - Where does the content come from?
2. **Input Format** - How is the content provided?

This creates a flexible matrix that accommodates any workflow:

```
                         INPUT FORMAT
                 ┌────────────┬────────────┐
                 │ Structured │ Freeform   │
                 │ (Tables,   │ (Q&A,      │
                 │ JSON, Data)│ Prose)     │
     ┌───────────┼────────────┼────────────┤
     │ Reference │ ✓ Tables   │ ✓ Describe │
INPUT│ Material  │   of NPCs, │   setting, │
SOURCE(Book,Doc) │   locations│   answer Qs│
     ├───────────┼────────────┼────────────┤
     │ Original  │ ✓ Provide  │ ✓ Answer   │
     │ Creation  │   specs    │   5 phases │
     │           │   directly │   of Q&A   │
     ├───────────┼────────────┼────────────┤
     │ Template  │ ✓ Modify   │ ✓ Select   │
     │ Based     │   template │   & describe│
     │           │   values   │   changes  │
     └───────────┴────────────┴────────────┘
```

---

## Input Modes

**ALWAYS start by asking which input approach the user wants:**

```markdown
## Game Ideator Session

How would you like to establish your game's creative foundation?

**Input Source - Where does your content come from?**
- [ ] **Reference Material** - I have existing content to import (book, module, notes, campaign docs)
- [ ] **Original Creation** - I'm building a new world from scratch
- [ ] **Template-Based** - Start from a preset and customize

**Input Format - How do you want to provide information?**
- [ ] **Structured** - I'll provide tables, lists, or formatted data directly
- [ ] **Conversational** - Guide me through questions and I'll describe things
- [ ] **Mixed** - Some structured data, some Q&A for gaps

Select your preferred approach to continue.
```

**Wait for user response before proceeding to the appropriate workflow.**

---

## Structured Input Format

**When the user wants to provide structured input, accept ANY of these formats:**

### Format 1: Markdown Tables

```markdown
### Locations
| ID | Name | Type | Description | Services |
|----|------|------|-------------|----------|
| loc_phandalin | Phandalin | settlement | Frontier mining town | shop, inn |
| loc_umbrage | Umbrage Hill | landmark | Windmill with healer | healer |

### Factions
| ID | Name | Alignment | Goals | Attitude |
|----|------|-----------|-------|----------|
| faction_zhentarim | Zhentarim | Neutral Evil | Control trade | hostile |
| faction_townfolk | Townfolk | Neutral | Survive | friendly |

### NPCs
| ID | Name | Role | Location | Dialogue Theme |
|----|------|------|----------|----------------|
| npc_harbin | Harbin Wester | quest_giver | loc_phandalin | Cowardly mayor |
```

### Format 2: JSON/Data Structure

```json
{
  "world": {
    "name": "Sword Coast",
    "era": "Medieval Fantasy",
    "magic_level": "high"
  },
  "locations": [
    {"id": "loc_phandalin", "name": "Phandalin", "type": "settlement"}
  ],
  "factions": [
    {"id": "faction_zhent", "name": "Zhentarim", "goals": "Control trade"}
  ]
}
```

### Format 3: Bulleted Lists

```markdown
**Setting:**
- Era: Medieval fantasy
- Magic: Common, arcane and divine
- Tone: Heroic adventure with dark undertones

**Locations:**
- Phandalin (settlement) - frontier mining town, quest hub
- Umbrage Hill (landmark) - windmill with midwife healer
- Gnomengarde (dungeon) - rock gnome workshop

**Key NPCs:**
- Harbin Wester: Cowardly mayor, gives quests from job board
- Adabra Gwynn: Midwife at Umbrage Hill, threatened by manticore
```

### Format 4: Key-Value Pairs

```
CAMPAIGN_NAME: Dragons of Icespire Peak
SETTING: Sword Coast, Forgotten Realms
ERA: Medieval Fantasy
MAGIC_LEVEL: High
TONE: Heroic adventure
STARTING_LOCATION: Phandalin
```

**All formats are valid. The skill extracts and normalizes the information.**

---

## Input Source: Reference Material

**When user has existing content to import (books, modules, notes, homebrew docs):**

```markdown
## Reference Material Import

I'll help you translate your existing content into CRPG engine format.

**1. Source Type**
What kind of reference material do you have?
- [ ] Published adventure module (D&D, Pathfinder, OSR, etc.)
- [ ] Campaign sourcebook / setting guide
- [ ] Personal notes / homebrew campaign
- [ ] Fiction / worldbuilding documents
- [ ] Mix of published + custom modifications

**2. Material Access**
How will you provide the content?
- [ ] I'll describe it (you ask questions, I answer)
- [ ] I'll paste/type the key information
- [ ] I'll provide structured tables/lists (Structured Format)
- [ ] I'll give you file paths to read
- [ ] I have a map image to analyze

**3. Import Scope**
How much are we importing?
- [ ] Full content (everything)
- [ ] Single adventure/module
- [ ] Specific arc or chapter
- [ ] Just the setting (locations, factions) - new story
- [ ] Specific elements only (just NPCs, just locations, etc.)

**4. Adaptation Level**
How faithful should the translation be?
- [ ] Exact - preserve everything as closely as possible
- [ ] Light adaptation - adjust for CRPG format, keep essence
- [ ] Heavy adaptation - use as inspiration, significant changes OK
- [ ] Setting extraction only - take world, create new story
```

**After receiving mode selection, proceed based on their format choice:**

---

### Reference Material + Structured Format

**If user will provide structured data:**

```markdown
## Structured Reference Import

Please provide your setting information in any structured format (tables, lists, JSON).

I need information in these categories:

**Required:**
1. **World Overview** - name, era, magic level, tone
2. **Locations** - id, name, type, description, connections
3. **Factions** - id, name, goals, attitude toward player

**Recommended:**
4. **Key NPCs** - id, name, role, location, personality
5. **Main Conflicts** - threats, antagonists, stakes
6. **Themes** - what the story is about

**Optional:**
7. **Quests** - objectives, givers, rewards
8. **Encounters** - enemies, locations, difficulty
9. **Items** - notable equipment, treasures

Paste your structured data below, or provide file paths to read:
```

**After receiving structured data:**

```markdown
## Data Extraction Complete

I've parsed your structured input:

### Extracted Successfully:
- ✅ World: [name] ([era], [magic level])
- ✅ Locations: [count] found
- ✅ Factions: [count] found
- ✅ NPCs: [count] found

### Summary:
| Category | Count | Status |
|----------|-------|--------|
| Locations | X | Complete |
| Factions | Y | Complete |
| NPCs | Z | Complete |
| Quests | 0 | Not provided |

### Missing (Optional):
These weren't provided but would enrich the output:
1. Core theme - What is the story "about"?
2. Tone guidelines - How should content feel?
3. Design pillars - What's most important?

Options:
- [ ] Provide missing info now (Q&A or structured)
- [ ] Generate documents with what we have (I'll infer gaps)
- [ ] Skip missing sections (mark as TBD)
```

---

### Reference Material + Conversational Format

**If user wants Q&A style, use the same interactive approach - ONE question at a time:**

Start with: "I'll ask you about your source material. Let's begin with the basics."

**World Overview (ask ONE at a time):**
1. "What's the name of this world or setting?"
2. "What era or technology level is it?" (medieval, renaissance, etc.)
3. "How common and accepted is magic?"
4. "What's the overall tone?" (dark, heroic, mysterious, etc.)
5. "In 1-2 sentences, what's the core premise?"

**Then move through categories:**
- Locations (ask about each key location)
- Factions (ask about each faction)
- Key NPCs (ask about important characters)
- Main Conflicts (ask about threats and stakes)

**Remember:** Acknowledge each answer, then ask the next question naturally. Don't dump all questions at once.

---

## Input Source: Original Creation

**When user is building a new world from scratch:**

### Original + Structured Format

```markdown
## Original World - Structured Input

You can define your world by providing structured data directly.

**Minimum Required:**

```markdown
### World Definition
| Property | Value |
|----------|-------|
| Name | [Your world name] |
| Era | [Medieval/Renaissance/Modern/Sci-Fi/etc.] |
| Magic Level | [None/Low/Medium/High] |
| Tone | [Dark/Heroic/Mysterious/Comedic/etc.] |
| Core Pitch | [One sentence] |

### Design Pillars (pick 3-5)
| Priority | Pillar |
|----------|--------|
| 1 | [Meaningful Choices / Tactical Combat / etc.] |
| 2 | [Exploration / Narrative / etc.] |
| 3 | [...] |
```

**Optional but Recommended:**

```markdown
### Starting Geography
| Location | Type | Description |
|----------|------|-------------|
| [...] | [...] | [...] |

### Initial Factions
| Faction | Goals | Player Relationship |
|---------|-------|---------------------|
| [...] | [...] | [...] |
```

Provide your structured data below:
```

---

### Original + Conversational Format

**This uses the existing 5-phase Q&A workflow (see Phase 1-5 sections below).**

---

## Input Source: Template-Based

```markdown
## Template Selection

Choose a template that matches your vision:

**Fantasy Templates:**
- [ ] **Classic Fantasy** - Medieval, high magic, clear good/evil, heroic journey
- [ ] **Dark Fantasy** - Gritty, low magic, moral ambiguity, survival
- [ ] **Sword & Sorcery** - Adventure-focused, exotic locations, treasure hunting

**Other Genre Templates:**
- [ ] **Post-Apocalyptic** - Survival, scarcity, rebuilding
- [ ] **Steampunk** - Victorian era, gadgets, class conflict
- [ ] **Gothic Horror** - Dread, monsters, investigation

**Setting Style Templates:**
- [ ] **High Magic World** - Magic is common, flashy, integrated into society
- [ ] **Low Magic World** - Magic is rare, feared, has heavy costs
- [ ] **No Magic World** - Purely mundane, grounded reality

After selecting, I'll generate base documents. Then tell me what to customize:
- Describe changes in prose (conversational)
- OR provide structured overrides (tables/lists)
```

---

## Existing Document Mode

**If user has written documents to formalize:**

```markdown
## Document Import

Please provide your existing material in one of these ways:

**Option 1: File Path**
Provide the path to your document:
`docs/my-setting.md` or `~/Desktop/campaign-notes.txt`

**Option 2: Paste Content**
Paste your setting/world information directly here.

**Option 3: Multiple Files**
List the files to read:
- `docs/world-overview.md`
- `docs/factions.md`
- `docs/characters.md`

I'll analyze your material and extract:
- Setting details → world-bible.md
- Story/theme elements → narrative-bible.md
- Design constraints → design-pillars.md

After extraction, I'll show you what I found and ask clarifying questions for any gaps.
```

**After reading the material:**

```markdown
## Document Analysis Complete

I've extracted the following from your material:

### Setting Elements Found:
- World/Setting: [extracted]
- Era/Technology: [extracted or "Not specified"]
- Magic System: [extracted or "Not specified"]
- Geography: [list locations found]
- Factions: [list factions found]

### Narrative Elements Found:
- Themes: [extracted or "Not specified"]
- Story Structure: [extracted or "Not specified"]
- Character Archetypes: [list found]
- Conflicts: [list found]

### Gaps to Fill:
The following information was not found in your documents:
1. [Missing element] - Please describe or mark as "Skip"
2. [Missing element] - Please describe or mark as "Skip"

Would you like to:
- [ ] Fill in the gaps now (Q&A or structured data)
- [ ] Generate documents with available info (gaps marked as TBD)
- [ ] Provide additional source material
```

---

## Output Documents

This skill creates THREE foundational documents in `docs/design/`:

### 1. world-bible.md
The definitive source for all world/setting information:
- Setting era, technology level, magic system
- Tone and atmosphere
- Geography and key regions
- Major factions and their relationships
- Cultural elements
- Visual and audio identity guidelines

### 2. narrative-bible.md
The definitive source for story and theme:
- Core themes and what the game is "about"
- Narrative structure (acts, beats)
- Character archetypes
- Conflict types
- Possible endings and what they mean
- Story tone guidelines

### 3. design-pillars.md
The definitive source for design decisions:
- 3-5 core design pillars
- Player fantasy (what players should feel)
- What's IN scope vs OUT of scope
- Quality bar definitions
- Constraints and non-negotiables
- How to resolve design conflicts

---

## Interactive Questioning Workflow

### Interactive Dialogue Approach

**IMPORTANT: For conversational input, ask ONE question at a time.**

The phases below list all questions to cover, but when in conversation:
1. Ask a single question
2. Wait for the user's response
3. Acknowledge their answer briefly
4. Ask the next question
5. Adapt follow-up questions based on their answers

This creates natural dialogue rather than overwhelming the user with forms.

**Conversation Flow Example:**
```
Skill: "What's the working title for your game?"
User: "Shadows of the Sword Coast"
Skill: "Great title! Now, in one sentence, what is this game about?"
User: "A tactical RPG where mercenaries navigate a war-torn frontier"
Skill: "That gives me a clear picture. What should players FEEL when playing -
       powerful, clever, part of an epic story, emotionally moved, or something else?"
...and so on
```

---

### Phase 1: Core Identity (Required)

**Questions to cover (ask ONE at a time):**

1. **Working Title** - "What's the working title for your game?"

2. **One-Sentence Pitch** - "In one sentence, what is this game?"
   - Example prompt: "Like 'A tactical RPG where your choices permanently reshape a dying world'"

3. **Core Fantasy** - "What should players FEEL when playing?"
   - Offer options: powerful, clever/strategic, part of an epic story, challenged, emotionally moved, in control of systems
   - Let them pick or describe their own

4. **Primary Genre** - "What's the primary genre?"
   - CRPG, Action RPG, Turn-based Strategy, Roguelike, Visual Novel, Hybrid

**After each answer:** Briefly acknowledge, then ask the next question.

**After Phase 1 complete:** Summarize what you've learned, then transition to Phase 2.

---

### Phase 2: World & Setting

**Questions to cover (ask ONE at a time):**

5. **Setting Era** - "What era or technology level is this world?"
   - Offer options: Ancient, Medieval Fantasy, Renaissance, Industrial/Steampunk, Modern, Sci-Fi, Hybrid

6. **Magic/Supernatural** - "How does magic work in this world?"
   - Options: High magic (common), Low magic (rare/costly), No magic
   - Follow-up if magic exists: "Who can use it? Is it feared or accepted?"

7. **World State** - "What's the current state of the world?"
   - Options: Stable/Prosperous, Declining, Post-Apocalyptic, At War, On the Brink of change

8. **World History** - "What happened before the game begins?"
   - Ask about: major historical events, fallen empires, recent conflicts
   - "What do people remember? What has been forgotten?"

**Geography Questions (8a-8f):** These questions gather detailed geographic information needed for AI map generation.

8a. **Continental Shape** - "Describe the overall shape and layout of the landmass."
   - Is it an island, peninsula, continent, archipelago?
   - What's the general orientation? (tall and narrow, wide and sprawling, circular)
   - Are there major inland seas or bodies of water?

8b. **Major Geographic Features** - "What are the dominant geographic features?"
   - Mountain ranges: Where are they? Do they form natural barriers?
   - Rivers: Major rivers and where they flow?
   - Forests: Dense ancient woods, scattered groves, or barren?
   - Deserts, swamps, tundra - any unusual terrain?
   - Coastlines: Cliffs, beaches, fjords, marshes?

8c. **Climate Zones** - "How does climate vary across the world?"
   - Is the north cold and the south warm? Or something more unusual?
   - Are there distinct seasonal patterns?
   - Any magical or unnatural weather phenomena?

8d. **Key Regions** - "Tell me about 3-5 key regions players will explore."
   - For each region, gather:
     - Name
     - Geographic character (mountains, plains, forest, coast, swamp)
     - Visual palette (colors, lighting, atmosphere)
     - Tone (dangerous, safe, mysterious, melancholic, vibrant)
     - What makes it visually distinctive?
     - Who lives here?
     - What players do here

8e. **Notable Locations** - "What are the most important specific locations?"
   - Major cities or settlements (name, size, defining feature)
   - Dungeons, ruins, or dangerous areas
   - Sacred sites, landmarks, or natural wonders
   - Trade routes or borders between regions

8f. **Map Visualization** - "If you were to describe this world to an artist painting a map, what would you emphasize?"
   - What should dominate visually? (vast forests, jagged mountains, winding rivers)
   - What style fits? (realistic topography, stylized fantasy, weathered parchment)
   - Are there visual symbols or motifs? (faction colors, magical effects visible on map)
   - What's the overall mood the map should convey?

9. **Factions** - "What major factions or groups exist?"
   - For each faction:
     - Name and type (government, religion, guild, secret society)
     - Goals and motivations
     - Territory or sphere of influence
     - Attitude toward player
     - Visual identity (colors, symbols)
     - Relationship to other factions
   - Ask about 2-4 factions

**Transition:** "Now I have a detailed picture of the world's geography and politics. Let's talk about the story and themes."

---

### Phase 3: Narrative & Theme

**Questions to cover (ask ONE at a time):**

10. **Core Theme** - "What is your game ABOUT thematically? Not plot, but meaning."
    - Give examples: "Power corrupts", "Survival vs. morality", "Found family", "Legacy"
    - Let them articulate what question the game explores

11. **Secondary Themes** - "Any other themes to weave in alongside that?"
    - Suggest options: Redemption, Betrayal, Identity, Order vs. Chaos, Class inequality, Duty vs. Desire
    - 1-2 secondary themes is typical

12. **Narrative Structure** - "How is the story structured? Classic 3 acts, 5 acts, episodic, or open/non-linear?"

13. **Tone & Atmosphere** - "What's the overall tone?"
    - Options: Dark/gritty, Heroic/hopeful, Mysterious, Lighthearted with serious moments, Grimdark, Mixed

14. **Endings** - "How do you want endings to work?"
    - Ask about number of endings (single, 2-3, many)
    - Follow-up: "What makes a 'good' vs 'bad' ending in your game?"

**Transition:** "Great, we have a strong narrative foundation. Now let's talk about design philosophy - the rules that guide all decisions."

---

### Phase 4: Design Philosophy

**Questions to cover (ask ONE at a time):**

15. **Design Pillars** - "What are your top 3-5 design pillars - the principles every decision must support?"
    - Offer examples: Meaningful Choices, Tactical Depth, Character Expression, Narrative Impact, Exploration Reward, Mechanical Mastery, Emergent Gameplay, Emotional Engagement, Accessibility, Challenge
    - Let them pick or describe their own

16. **What's IN Scope** - "What MUST be in this game? List 5-8 non-negotiable features."
    - Help them distinguish "must have" from "nice to have"

17. **What's OUT of Scope** - "What will you explicitly NOT include? This prevents feature creep."
    - Ask for 3-5 things they're intentionally avoiding

18. **Quality Bar** - "What level of polish for each area?"
    - Ask about: Combat, Narrative, Visual art, Audio, UI/UX
    - Options: placeholder/functional/polished for each

19. **Conflict Resolution** - "When two good ideas conflict, what decides?"
    - Ask them to rank: Supports fantasy, Reinforces theme, Keeps scope, Maximizes agency, Feels good mechanically

**Transition:** "Almost done! Just a few final details to round out the vision."

---

### Phase 5: Final Details

**Questions to cover (ask ONE at a time):**

20. **Inspiration & References** - "What games, books, or films inspire this project?"
    - For each reference, ask: "What specifically do you want to take from it? What doesn't fit?"

21. **Player Character** - "Who does the player control?"
    - Options: Custom character, Defined protagonist, Party, Rotating viewpoints
    - Follow-up: "What's their role in the world - mercenary, chosen one, nobody, or something else?"

22. **Companion System** - "Will the player have companions?"
    - Options: No companions, Fixed companions, Recruitable, Party-based

23. **Anything Else** - "Anything else I should capture? Any creative direction, constraints, or vision elements we haven't covered?"

**After Phase 5:**
"That's everything I need! Let me generate your foundational documents now."

---

## Document Templates

### world-bible.md Template

```markdown
# World Bible: [Game Title]

> **Purpose:** This document is the definitive source for all world/setting information.
> All content creation should reference this document for consistency.
>
> **Last Updated:** [Date]
> **Version:** 1.0

---

## Setting Overview

### The World in One Paragraph
[Write a rich, evocative paragraph that captures the essence of this world. Describe what it looks like, what it feels like to live there, what sounds fill the air, and what mood pervades. This should be visceral and immediate - a reader should be able to close their eyes and see this world.]

### The World in Detail
[Expand on the overview with 2-3 paragraphs. Cover:
- The natural beauty and/or harshness of the landscape
- The state of civilization - are cities thriving or crumbling?
- The relationship between people and the land
- What makes this world different from generic fantasy
- The emotional truth of the setting]

### Era & Technology
- **Era:** [Medieval/Renaissance/Industrial/etc.]
- **Technology Level:** [Detailed description of what exists and what doesn't]
- **Weapons & Warfare:** [Common weapons, military tactics, siege technology]
- **Transportation:** [How people travel - horses, ships, magical means]
- **Communication:** [How news travels, literacy rates, written records]
- **Medicine:** [State of healing, herbs, magical healing availability]
- **Notable Tech:** [Any unique inventions or magical-technological hybrid]
- **Lost Technology:** [What existed before that no longer works or is forgotten]

### Magic & Supernatural

#### Magic System Overview
[2-3 paragraphs describing how magic fundamentally works in this world. What is its source? How does it feel to use? What are the costs?]

#### Magic Details
- **Prevalence:** [How common is magic? Can ordinary people use it?]
- **Source:** [Where does magical power come from?]
- **Types of Magic:** [Different schools, traditions, or approaches]
- **Who Can Use It:**
  - [User type 1] - [Description and limitations]
  - [User type 2] - [Description and limitations]
- **Learning Magic:** [How does one become a magic user?]
- **Costs & Dangers:** [What are the risks of using magic?]
- **Public Perception:** [How do ordinary people view magic users?]
- **Magical Creatures:** [What supernatural beings exist?]
- **Divine Magic vs Arcane:** [If applicable, how do they differ?]

#### Hard Limitations
Things magic absolutely CANNOT do in this world:
1. [Limitation 1 - e.g., cannot resurrect the dead]
2. [Limitation 2 - e.g., cannot read minds perfectly]
3. [Limitation 3 - e.g., cannot create something from nothing]

### World State

#### Current Era
- **Name:** [The Age of X / The Y Period / etc.]
- **How Long:** [How long has this era lasted?]
- **Defining Characteristic:** [What makes this era distinct?]

#### Overall Condition
[Detailed paragraph about the state of the world - is it prosperous, declining, rebuilding, at war? Include nuance - different regions may be in different states.]

#### Major Tensions
1. **[Tension 1]:** [Description of conflict and who it affects]
2. **[Tension 2]:** [Description]
3. **[Tension 3]:** [Description]

#### Recent History (Last 50 Years)
| Event | When | Impact |
|-------|------|--------|
| [Major event] | [Years ago] | [How it changed the world] |
| [Major event] | [Years ago] | [Impact] |
| [Major event] | [Years ago] | [Impact] |

#### Ancient History
[Brief overview of major historical periods that shaped the current world. Include fallen empires, legendary heroes, cataclysms, or golden ages that people remember.]

---

## Geography

### World Map Overview
[Detailed description of the overall landmass - its shape, major features, and how different regions connect. This should paint a picture of the whole map.]

### Continental Structure
- **Landmass Type:** [Single continent, archipelago, multiple continents, etc.]
- **Approximate Size:** [In terms players can understand - "about the size of Western Europe"]
- **Orientation:** [North-south stretch, east-west span, compact, sprawling]
- **Major Bodies of Water:** [Oceans, seas, major lakes, significant rivers]
- **Natural Barriers:** [Mountain ranges, deserts, forests that divide regions]

### Climate & Seasons
- **Climate Pattern:** [How does weather vary across the map?]
- **Northern Regions:** [Cold, temperate, etc.]
- **Central Regions:** [Climate type]
- **Southern Regions:** [Warmer, tropical, etc.]
- **Unusual Weather:** [Magical storms, eternal fog, unnatural phenomena]
- **Seasons:** [Do they exist? How pronounced? Any unusual patterns?]

### Key Regions

#### [Region 1 Name]

**Overview:**
[2-3 sentences capturing the essence of this region - what players will remember most]

**Geography:**
- **Terrain:** [Detailed terrain - rolling hills, jagged peaks, dense forest, etc.]
- **Climate:** [Weather patterns, temperature, precipitation]
- **Key Features:** [Rivers, mountains, forests, ruins that define the landscape]
- **Flora:** [Notable plants, crops, magical herbs]
- **Fauna:** [Wildlife, monsters, domesticated animals]

**Atmosphere:**
- **Visual Palette:** [Dominant colors - "muted golds and grays" or "deep greens and shadow"]
- **Lighting:** [Bright and clear? Overcast? Dappled through trees? Perpetual twilight?]
- **Sounds:** [What does this place sound like? Wind, birds, silence, distant thunder?]
- **Smell:** [What are the characteristic scents?]
- **Emotional Tone:** [What feeling should this region evoke?]

**Civilization:**
- **Settlements:** [Major towns, villages, their character]
- **Population:** [Who lives here? Density?]
- **Economy:** [What do people do for a living?]
- **Culture:** [Local customs, accent, traditions]
- **Power Structure:** [Who rules? What faction dominates?]

**For Players:**
- **What Players Do Here:** [Combat, exploration, political intrigue, etc.]
- **Danger Level:** [Safe, moderate, dangerous, deadly]
- **Notable Quests/Content:** [Types of stories told in this region]

---

#### [Region 2 Name]

[Same detailed structure as Region 1]

---

#### [Region 3 Name]

[Same detailed structure as Region 1]

---

#### [Region 4 Name] (if applicable)

[Same detailed structure]

---

### Notable Locations

#### Major Settlements

| Settlement | Region | Size | Character | Significance |
|------------|--------|------|-----------|--------------|
| [Name] | [Region] | [Metropolis/City/Town/Village] | [2-3 word feel] | [Why it matters to story] |

**[Settlement 1 Name]:**
[Paragraph describing this settlement - its appearance, atmosphere, notable features, and what brings players here]

**[Settlement 2 Name]:**
[Same detailed description]

#### Dungeons & Dangerous Areas

| Location | Region | Type | Threat Level | Contents |
|----------|--------|------|--------------|----------|
| [Name] | [Region] | [Ruin/Cave/etc.] | [Easy/Medium/Hard/Deadly] | [What players find] |

**[Dungeon 1 Name]:**
[Paragraph about this dangerous area - its history, appearance, what lurks there, and what draws adventurers]

#### Landmarks & Wonders

| Landmark | Region | Type | Significance |
|----------|--------|------|--------------|
| [Name] | [Region] | [Natural wonder/Monument/Sacred site] | [Why it matters] |

### Travel & Routes

**Major Roads:**
- **[Road Name]:** Connects [A] to [B] via [landmarks]. [Safety level, travel time, notable waypoints]

**Sea Routes:**
- [If applicable, major shipping lanes and ports]

**Dangerous Passages:**
- [Mountain passes, bandit-infested roads, monster territories]

---

## 🗺️ World Map AI Generation Prompt

> **Purpose:** This section provides a detailed prompt suitable for AI image generation tools (Midjourney, DALL-E, Stable Diffusion, etc.) to create a visual map of this world.

### Map Generation Prompt

```
[Style description], [view type] fantasy map of [world name]:

**Landmass Shape:**
[Detailed description of the continental shape, coastlines, and overall form. Be specific - "a roughly crescent-shaped continent curving from northwest to southeast, with a large inland sea in the central-eastern portion" or "a main landmass resembling a jagged triangle pointing south, with an archipelago of islands trailing off the western coast"]

**Geographic Features (North to South, West to East):**
- [Northern region]: [Terrain type, dominant features - "snow-capped mountain range forming a natural barrier, peaks shrouded in perpetual mist"]
- [Northwestern area]: [Description]
- [Central-west]: [Description]
- [Central region]: [Description - this is often the heart of the map]
- [Central-east]: [Description]
- [Southwestern area]: [Description]
- [Southern region]: [Description]
- [Any islands or separate landmasses]: [Description]

**Major Features to Emphasize:**
1. [Most prominent feature] - [Location and visual description]
2. [Second feature] - [Location and visual description]
3. [Third feature] - [Location and visual description]
4. [Fourth feature] - [Location and visual description]
5. [Fifth feature] - [Location and visual description]

**Water Features:**
- Ocean/Sea: [Name and characteristics - "dark, storm-tossed waters" or "calm azure sea"]
- Major Rivers: [Names, where they originate, where they flow to, approximate paths]
- Lakes: [Names, sizes, locations]
- Coastline Style: [Cliffs, beaches, fjords, marshland, etc.]

**Settlements to Mark:**
- [Capital/Major city]: [Location, symbol suggestion]
- [Second city]: [Location]
- [Other notable settlements]: [Locations]

**Visual Style:**
- Map Style: [Parchment/weathered paper/clean/illustrated/painted/cartographic]
- Color Palette: [e.g., "muted earth tones with deep forest greens and mountain grays" or "warm sepia with gold accents"]
- Artistic Approach: [Realistic topographic/stylized fantasy/medieval manuscript/hand-drawn/painterly]
- Border Style: [Ornate/simple/none/themed to setting]
- Labels: [Stylized fantasy font/clean readable/no labels]

**Mood & Atmosphere:**
[What feeling should the map convey? "A sense of a vast, dying world with beauty in its decay" or "An epic fantasy realm full of adventure and wonder" or "A dark, dangerous land where civilization clings to small safe havens"]

**Special Visual Elements:**
- [Any magical phenomena visible on map - glowing areas, dark corruption, unusual colors]
- [Faction territories or borders to show]
- [Trade routes, roads, or paths to indicate]
- [Compass rose style]
- [Scale indicator if desired]
- [Decorative elements - sea monsters, heraldry, illustrations in margins]
```

### Simplified One-Paragraph Prompt

For quick generation, use this condensed version:

```
[Style] fantasy world map: [Shape description] with [dominant northern features], [central features], and [southern features]. [Major water bodies]. Key locations: [settlement list]. Style: [artistic approach] with [color palette]. Mood: [emotional tone]. [Any special elements].
```

### Example Prompt (Fill in for your world):

```
Weathered parchment fantasy map of [World Name]: A [shape] continent stretching [direction], dominated by [major feature] in the [location]. The [region name] spreads across the [direction], characterized by [terrain]. [Another region] occupies the [location], marked by [distinctive features]. Rivers including the [River Name] flow from [source] to [destination]. The [Sea/Ocean Name] borders the [direction] coast with [coastline character]. Mark the cities of [City 1] ([location]), [City 2] ([location]), and [City 3] ([location]). Style: [artistic style] with [color description]. Include [decorative elements]. Convey a sense of [mood/tone].
```

---

## Factions

### Political Landscape Overview
[2-3 paragraphs describing the overall political situation. Who holds power? What alliances exist? What tensions simmer beneath the surface? This should read like the "state of the world" that any educated person would know.]

### Major Factions

#### [Faction 1 Name]

**Overview:**
[Paragraph describing this faction's place in the world, their reputation, and what they represent thematically]

**Details:**
- **Type:** [Government/Guild/Religion/Military Order/Secret Society/etc.]
- **Philosophy:** [Core beliefs and values]
- **Goals:** [What they're actively working toward]
- **Methods:** [How they pursue their goals - honorable, ruthless, subtle, overt]
- **Resources:** [Military strength, wealth, influence, magical power]

**Leadership:**
- **Current Leader:** [Name, title, brief description]
- **Leadership Structure:** [Monarchy, council, elected, hereditary, etc.]
- **Notable Figures:** [2-3 other important members]

**Territory & Presence:**
- **Headquarters:** [Location]
- **Controlled Regions:** [Where they hold power]
- **Sphere of Influence:** [Where they have presence but not control]

**Identity:**
- **Symbol:** [Description of their emblem/heraldry]
- **Colors:** [Primary and secondary colors]
- **Motto/Creed:** [If they have one]
- **Recognizable Features:** [Uniforms, tattoos, mannerisms that mark members]

**Player Relationship:**
- **Initial Attitude:** [Friendly/Neutral/Hostile/Unknown]
- **What They Want from Player:** [Potential quests, asks, demands]
- **Reputation Mechanics:** [How player standing changes]
- **Benefits of High Standing:** [What players gain from alliance]
- **Consequences of Opposition:** [What happens if players become enemies]

**Thematic Role:**
[How does this faction relate to the game's themes? What do they represent in the story?]

---

#### [Faction 2 Name]

[Same detailed structure]

---

#### [Faction 3 Name]

[Same detailed structure]

---

#### [Faction 4 Name] (if applicable)

[Same detailed structure]

---

### Faction Relationships

```
                    [Faction A]
                    /         \
              allied          hostile
                /               \
        [Faction B] ──tense── [Faction C]
                \               /
              neutral        wary
                  \           /
                   [Faction D]
```

**Key Relationships Explained:**
- **[Faction A] + [Faction B]:** [Why they're allied, history, how stable]
- **[Faction A] vs [Faction C]:** [Source of conflict, how it manifests]
- **[Faction B] & [Faction C]:** [Their complicated relationship]

### Minor Factions & Groups

| Group | Type | Region | Brief Description |
|-------|------|--------|-------------------|
| [Name] | [Type] | [Where] | [One-line description] |

---

## Culture & Society

### Social Structure

#### Classes & Hierarchy
- **Nobility/Elite:** [Description, privileges, how one becomes noble]
- **Middle Class:** [Merchants, skilled workers, their status]
- **Common Folk:** [Farmers, laborers, their lives]
- **Outsiders:** [Who exists outside the hierarchy? How are they treated?]

#### Social Mobility
[Can people change their station? How? What barriers exist?]

### Economy

#### Currency
- **Primary Currency:** [Name, denominations, what they're worth]
- **Barter:** [How common? In what regions?]
- **Wealth Distribution:** [Are riches concentrated or spread?]

#### Trade
- **Major Trade Goods:** [What's valuable? What's exported/imported?]
- **Trade Routes:** [Key mercantile paths]
- **Economic Centers:** [Where commerce happens]

### Religion & Beliefs

#### Major Faith(s)
**[Religion/Faith Name]:**
- **Deity/Deities:** [Names, domains, relationships]
- **Core Beliefs:** [What followers believe]
- **Practices:** [Rituals, holidays, requirements]
- **Clergy:** [Organization, power, role in society]
- **Symbols:** [Holy symbols, sacred places]

#### Folk Beliefs & Superstitions
- [Common superstition and its origin]
- [Folk tradition]
- [Belief about death/afterlife]

### Daily Life

#### Food & Drink
- **Common Foods:** [What do people eat?]
- **Regional Specialties:** [Food by region]
- **Alcohol/Beverages:** [What do people drink?]

#### Housing & Settlement
- **Architecture:** [Common building styles]
- **Urban vs Rural:** [How do city and country differ?]
- **Notable Structures:** [What buildings are common? Distinctive?]

#### Family & Relationships
- **Family Structure:** [Nuclear, extended, clan-based?]
- **Marriage Customs:** [Arranged, free choice, any unusual traditions?]
- **Gender Roles:** [If any specific to this setting]

### Common Knowledge

Things EVERY person in this world knows:
1. [Universal fact about magic/religion]
2. [Historical event everyone remembers]
3. [Geographic fact everyone knows]
4. [Political reality everyone understands]
5. [Cultural norm everyone follows]

### Taboos & Customs

**Respected/Honored:**
- [Behavior that earns respect]
- [Social expectation]
- [Traditional value]

**Forbidden/Taboo:**
- [Serious taboo and consequence]
- [Lesser social faux pas]
- [Region-specific prohibition]

**Greetings & Etiquette:**
- [How people greet each other]
- [Hospitality customs]
- [Formality norms by class]

---

## Visual & Audio Identity

### Visual Guidelines

#### Color Palette
- **Primary Colors:** [List with hex codes if specific - what they represent]
- **Secondary Colors:** [Supporting colors]
- **Region-Specific Palettes:**
  - [Region 1]: [Colors dominant here]
  - [Region 2]: [Colors dominant here]
- **Emotional Color Associations:** [What colors mean in this world]

#### Architecture
- **Dominant Style:** [Gothic, classical, organic, etc.]
- **Building Materials:** [Stone, wood, adobe, etc.]
- **Distinctive Features:** [Spires, domes, living trees, etc.]
- **State of Repair:** [Well-maintained, crumbling, mixed?]
- **Regional Variations:**
  - [Region 1]: [Architectural character]
  - [Region 2]: [Architectural character]

#### Fashion
- **Common Clothing:** [What ordinary people wear]
- **Elite Fashion:** [What nobles/wealthy wear]
- **Military/Guard:** [Uniforms, armor styles]
- **Faction-Specific:** [How faction members dress]
- **Regional Variations:** [How dress differs by region]

#### Nature
- **Trees & Plants:** [Dominant vegetation, any unusual flora]
- **Animals:** [Common wildlife, domesticated animals]
- **Weather Visuals:** [How weather manifests - fog, rain, snow]
- **Magical Manifestations:** [How magic looks when used]

### Audio Guidelines

#### Music
- **Overall Tone:** [Melancholic, epic, tense, hopeful, etc.]
- **Instruments:** [What sounds define this world?]
- **Regional Themes:**
  - [Region 1]: [Musical character]
  - [Region 2]: [Musical character]
- **Faction Themes:** [If factions have musical identities]

#### Ambient Sound
- **Settlement Sounds:** [Marketplaces, taverns, streets]
- **Wilderness Sounds:** [Forests, mountains, coasts]
- **Weather Sounds:** [Wind, rain, storms]
- **Magical Sounds:** [How magic sounds]

#### Combat Audio
- **Weapon Sounds:** [Style - weighty, quick, brutal]
- **Magic Combat:** [How spells sound]
- **Overall Feel:** [Impactful, tactical, chaotic]

---

## Language & Naming

### Naming Conventions

#### People
- **Common Name Structure:** [First name only? Family names? Titles?]
- **Regional Patterns:**
  - [Region 1]: [Naming style, example names]
  - [Region 2]: [Naming style, example names]
- **Class Differences:** [How noble names differ from common]

#### Places
- **Settlement Names:** [Patterns, what they reference]
- **Geographic Features:** [How rivers, mountains, forests are named]
- **Historical Names:** [Old names vs new names]

### In-World Terms

| Our Word | In-World Equivalent | Notes |
|----------|---------------------|-------|
| Magic | [Term used] | [Context] |
| Warrior | [Term used] | [Context] |
| Money | [Currency name] | [Context] |

---

## Consistency Rules

When creating content for this world:

1. **Geography:** Always check region descriptions before placing content
2. **Factions:** Verify relationship dynamics before NPC interactions
3. **Magic:** Respect hard limitations - no exceptions without major story justification
4. **Tone:** Match region-specific atmosphere in all descriptions
5. **Names:** Follow naming conventions for the appropriate region/culture
6. **History:** Reference established timeline for any historical mentions
7. **Visual:** Use appropriate color palettes for each region
8. **When uncertain:** Consult the map prompt and region descriptions

---

## Glossary

| Term | Definition | Context |
|------|------------|---------|
| [Term] | [What it means in this world] | [When/how it's used] |
| [Term] | [Definition] | [Context] |
| [Term] | [Definition] | [Context] |

---

## Appendices

### Appendix A: Timeline

| Era/Period | Dates | Major Events |
|------------|-------|--------------|
| [Ancient Era] | [Date range] | [Key events] |
| [Middle Era] | [Date range] | [Key events] |
| [Recent Era] | [Date range] | [Key events] |
| [Current] | [Now] | [Present situation] |

### Appendix B: Deity/Pantheon Reference (if applicable)

| Deity | Domain | Symbol | Worship |
|-------|--------|--------|---------|
| [Name] | [What they govern] | [Holy symbol] | [How worshipped] |

### Appendix C: Creature Reference

| Creature | Region | Threat | Notes |
|----------|--------|--------|-------|
| [Name] | [Where found] | [Danger level] | [Brief description] |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | [Date] | Initial creation via game-ideator |
```

### narrative-bible.md Template

```markdown
# Narrative Bible: [Game Title]

> **Purpose:** This document is the definitive source for all narrative/story information.
> Quest designers, dialogue writers, and character creators should reference this.
>
> **Last Updated:** [Date]
> **Version:** 1.0

---

## Thematic Foundation

### Core Theme

**[Theme Name]:** [One sentence description]

#### What This Theme Means

[2-3 paragraphs explaining what this theme means, why it matters, and what questions it asks. This should be the philosophical heart of your game - the "about" that isn't the plot.]

**The Central Question:** [The question players should be wrestling with by the end]

#### How This Theme Manifests

| Game System | How Theme Appears | Example |
|-------------|-------------------|---------|
| Combat | [How fighting reinforces or explores the theme] | [Specific example: "Combat is survival, not glory - reinforcing that power has costs"] |
| Dialogue | [How conversations explore the theme] | [Example: "Characters share philosophies, not just information"] |
| Quests | [How objectives reflect the theme] | [Example: "Most quests have no 'right' answer - only trade-offs"] |
| World Design | [How the environment embodies the theme] | [Example: "Beautiful things in decay - sunset, not grave"] |
| Progression | [How player growth relates to the theme] | [Example: "Growing influence, not raw power"] |
| Endings | [How conclusions comment on the theme] | [Example: "Different answers to the central question, none 'correct'"] |

#### Thematic Do's and Don'ts

**DO:**
- [Action that supports the theme - e.g., "Show beauty alongside decline"]
- [Action that explores the theme - e.g., "Let NPCs articulate different philosophical positions"]
- [Action that reinforces the theme - e.g., "Make choices feel meaningful even when outcomes are uncertain"]

**DON'T:**
- [Action that undermines the theme - e.g., "Don't offer obvious 'right answers' that resolve moral complexity"]
- [Action that contradicts the theme - e.g., "Don't make the protagonist a power fantasy hero"]
- [Action that trivializes the theme - e.g., "Don't use grimdark for shock value"]

---

### Secondary Themes

#### [Secondary Theme 1 Name]

**What it means:** [Explanation of this theme]

**How it connects to core theme:** [How this theme weaves with and supports the core theme]

**Where it appears:**
- [Location/system/character where this theme is prominent]
- [Another appearance]

**Exploration through:** [Which characters, quests, or systems primarily explore this theme]

#### [Secondary Theme 2 Name]

**What it means:** [Explanation]

**How it connects to core theme:** [Connection]

**Where it appears:**
- [Appearances]

**Exploration through:** [Vehicles for this theme]

#### [Secondary Theme 3 Name]

[Same structure]

---

### Thematic Questions

Questions the player should be asking themselves throughout the game:

| Question | When It Arises | How It's Explored |
|----------|----------------|-------------------|
| [Question 1]? | [Act/moment when this becomes prominent] | [Through which characters, quests, choices] |
| [Question 2]? | [Timing] | [Exploration method] |
| [Question 3]? | [Timing] | [Exploration method] |
| [Question 4]? | [Timing] | [Exploration method] |

**The Final Question:** [The question that the ending(s) answer - or deliberately leave open]

---

## Narrative Structure

### Story Summary

[2-3 paragraphs summarizing the entire plot arc from beginning to end, hitting the major beats. This is the "what happens" overview that contextualizes everything below.]

### Overall Arc Visualization

```
ACT 1: [Name]                    ACT 2: [Name]                    ACT 3: [Name]
(Beginning)                      (Middle)                         (End)
─────────────────────            ─────────────────────            ─────────────────────
[One-line description]           [One-line description]           [One-line description]

Key Beats:                       Key Beats:                       Key Beats:
• [Beat 1]                       • [Beat 1]                       • [Beat 1]
• [Beat 2]                       • [Beat 2]                       • [Beat 2]
• [Beat 3]                       • [Beat 3]                       • [Beat 3]
• Inciting Incident              • Point of No Return             • Climax

Emotional Arc:                   Emotional Arc:                   Emotional Arc:
[Establishing] → [Invested]      [Conflicted] → [Committed]       [Determined] → [Resolved]

Player Freedom:                  Player Freedom:                  Player Freedom:
[Linear/Moderate/Open]           [Linear/Moderate/Open]           [Linear/Moderate/Open]
```

---

### Act 1: [Act Name]

#### Overview
- **Purpose:** [What this act accomplishes narratively - establishing world, characters, stakes]
- **Player Goal:** [What the player is trying to achieve]
- **Emotional Journey:** [Starting emotion] → [Mid-act emotion] → [End emotion]
- **Approximate Length:** [Percentage of game / hours / quest count]

#### Key Beats

##### Beat 1.1: [Opening - Scene Name]
- **What Happens:** [Description of this story beat]
- **Player Experience:** [What the player does, sees, feels]
- **Characters Involved:** [Who's present]
- **Information Revealed:** [What player learns]
- **Choices Available:** [If any - or "None - establishing scene"]
- **Emotional Goal:** [How player should feel]

##### Beat 1.2: [Inciting Incident - Scene Name]
- **What Happens:** [The disruption that starts the journey]
- **Player Experience:** [Description]
- **Characters Involved:** [Who's present]
- **Information Revealed:** [What player learns]
- **Choices Available:** [Player agency in this moment]
- **Emotional Goal:** [How player should feel]
- **Why It Matters:** [How this connects to theme]

##### Beat 1.3: [First Threshold - Scene Name]
[Same structure]

##### Beat 1.4: [Act 1 Climax - Scene Name]
[Same structure, plus:]
- **Transition to Act 2:** [What happens that moves us forward]

#### Act 1 Player Choices

| Choice Point | Options | Immediate Consequence | Long-term Ripple |
|--------------|---------|----------------------|------------------|
| [Decision] | A: [Option] / B: [Option] | [What changes now] | [How this affects Act 2/3] |
| [Decision] | A / B / C | [Immediate] | [Later] |

#### Act 1 Companion Moments

| Companion | When They Join | Introduction Scene | First Impression |
|-----------|----------------|-------------------|------------------|
| [Name] | [Timing] | [How they're introduced] | [What player learns about them] |

---

### Act 2: [Act Name]

#### Overview
- **Purpose:** [What Act 2 accomplishes - escalation, complication, character development]
- **Player Goal:** [What's driving the player forward]
- **Emotional Journey:** [Emotion arc]
- **Approximate Length:** [Percentage/hours/quest count]

#### Key Beats

##### Beat 2.1: [New Status Quo - Scene Name]
[Same structure as Act 1 beats]

##### Beat 2.2: [Rising Complications - Scene Name]
[Same structure]

##### Beat 2.3: [Midpoint Revelation - Scene Name]
- **What Happens:** [The information/event that changes everything]
- **What Player Learns:** [The revelation]
- **How This Changes Things:** [Why this matters]
- **Emotional Goal:** [Shock, realization, determination, etc.]

##### Beat 2.4: [Point of No Return - Scene Name]
- **What Happens:** [The decision/event that commits the player]
- **Player Experience:** [Description]
- **Choices Available:** [The defining choice(s) of the game]
- **Why It Matters:** [How this determines ending paths]

#### Act 2 Branching Points

| Decision | When | Options | Path Determination |
|----------|------|---------|-------------------|
| [Major choice] | [Beat timing] | A: [Path] / B: [Path] / C: [Path] | [Which ending(s) this enables/locks] |

#### Act 2 Companion Confrontations

| Companion | Confrontation Trigger | What's At Stake | Possible Outcomes |
|-----------|----------------------|-----------------|-------------------|
| [Name] | [What causes this moment] | [Relationship/loyalty] | [How it can resolve] |

---

### Act 3: [Act Name]

#### Overview
- **Purpose:** [Resolution, consequences, closure]
- **Player Goal:** [Completing their chosen path]
- **Emotional Journey:** [Final emotional arc]
- **Approximate Length:** [Percentage/hours/quest count]

#### Key Beats

##### Beat 3.1: [Marshalling - Scene Name]
- **What Happens:** [Preparing for the final confrontation]
- **Emotional Goal:** [Building to climax]

##### Beat 3.2: [The Approach - Scene Name]
[Same structure]

##### Beat 3.3: [Climax - Scene Name]
- **What Happens:** [The final confrontation/decision/event]
- **Player Experience:** [What player does]
- **Emotional Goal:** [Peak emotional moment]
- **Branching:** [How different paths experience this differently]

##### Beat 3.4: [Resolution - Scene Name]
- **What Happens:** [Immediate aftermath]
- **Emotional Goal:** [Coming down from climax]

##### Beat 3.5: [Epilogue]
- **What Happens:** [Future glimpse, closure]
- **Variation by Ending:** [How epilogue differs per ending]

---

## The Protagonist

### Identity

**Role in the World:** [Commander, wanderer, chosen one, nobody, etc.]
**Starting Situation:** [Where they are when the game begins]
**What They Want:** [Initial goal/motivation]
**What They Need:** [Deeper need they may not recognize]

### Character Arc Framework

**Starting State:**
- Personality: [How they act at the start]
- Beliefs: [What they believe about [theme-related topic]]
- Relationships: [How they relate to others]

**Arc Catalyst:** [What challenges their starting state]

**Possible Ending States:**

| Arc Direction | Ending State | Triggered By |
|---------------|--------------|--------------|
| Growth | [Who they become if they grow] | [Choices that lead here] |
| Stagnation | [Who they remain if unchanged] | [Choices/non-choices that lead here] |
| Fall | [Who they become if they fail/corrupt] | [Choices that lead here] |

### Protagonist Voice

**Speech Pattern:**
- [Formal/Casual/Military/Scholarly/etc.]
- [Verbose or terse]
- [How emotion affects their speech]

**Verbal Characteristics:**
- [Any recurring phrases or speech patterns]
- [How they address different types of people]

**Topics They Discuss:**
- [What they talk about freely]
- [What they discuss reluctantly]

**Topics They Avoid:**
- [What they won't discuss]
- [What makes them change the subject]

**Sample Lines:**

```
[Professional]: "[Example line showing their default professional demeanor]"

[Emotional]: "[Example line when they're emotionally affected]"

[Philosophical]: "[Example line when discussing the game's themes]"

[Angry]: "[Example line when provoked]"

[Vulnerable]: "[Example line in a rare moment of openness]"
```

---

## Companions

### Companion Overview

| Name | Archetype | Join Point | Core Conflict | Arc Direction |
|------|-----------|------------|---------------|---------------|
| [Name] | [The Believer/The Pragmatist/etc.] | [When they join] | [Their struggle] | [How they can change] |

---

### [Companion 1 Name]

#### Basic Information
- **Full Name:** [Name]
- **Age:** [Age or range]
- **Background:** [Brief history]
- **Role in Party:** [Combat role, narrative role]
- **Archetype:** [Which character archetype from your defined list]

#### Personality Profile

**Core Traits:**
- [Trait 1] - [How this manifests]
- [Trait 2] - [How this manifests]
- [Trait 3] - [How this manifests]

**Strengths:**
- [What they're good at]
- [What they bring to the group]

**Flaws:**
- [What holds them back]
- [What causes conflict]

**Fear:** [Their deepest fear]
**Desire:** [What they want most]
**Need:** [What they actually need, which may differ from desire]

#### Philosophy and Beliefs

**Position on Core Theme:** [How they relate to the game's central theme]

**Philosophy in Their Own Words:** "[A quote that captures their worldview]"

**What They Believe About:**
- [Theme-related topic 1]: [Their belief]
- [Theme-related topic 2]: [Their belief]
- [The protagonist]: [Initial view, how it can change]

#### Voice and Dialogue

**Speech Pattern:**
- [Formal/casual/clipped/verbose/etc.]
- [Accent or dialect notes if any]
- [How they speak when calm vs. stressed]

**Verbal Tics:**
- "[Recurring phrase 1]" - [When they say it]
- "[Recurring phrase 2]" - [Context]

**Topics They Discuss:** [What they talk about willingly]
**Topics They Avoid:** [What makes them deflect]

**Sample Lines:**

```
[Casual/Banter]: "[Example]"

[Serious/Philosophical]: "[Example]"

[Emotional/Vulnerable]: "[Example]"

[Angry/Confrontational]: "[Example]"

[To Protagonist - Early]: "[How they speak to PC initially]"

[To Protagonist - Loyal]: "[How they speak when relationship is strong]"
```

#### Character Arc

**Starting State:** [Who they are when met]

**Central Conflict:** [The internal/external struggle that defines their arc]

**Arc Catalyst:** [What forces them to confront their conflict]

**Resolution Paths:**

| Resolution | What Happens | Requirements | Impact on Ending |
|------------|--------------|--------------|------------------|
| [Growth] | [How they change positively] | [Player choices needed] | [How this affects endings] |
| [Stagnation] | [They don't change] | [Ignoring their arc] | [Impact] |
| [Fall] | [Negative change] | [Bad choices] | [Impact] |

**Personal Quest:**
- **Hook:** [What initiates their personal quest]
- **Core Conflict:** [What they must confront]
- **Stakes:** [What they could gain/lose]
- **Resolution Options:** [How it can end]

#### Relationships

**With Protagonist:**
- **Initial Dynamic:** [How relationship starts]
- **Growth Path:** [How it can deepen]
- **Potential Tensions:** [What could cause conflict]
- **Breaking Point:** [What would make them leave/betray]

**With Other Companions:**

| Companion | Dynamic | Tension Points | Possible Evolution |
|-----------|---------|----------------|-------------------|
| [Name] | [Friendship/Rivalry/Respect/etc.] | [What they disagree about] | [How relationship can change] |

**With Factions:**
- [Faction]: [Relationship and why]

#### Loyalty System

**Approval Triggers:**
- [Action that gains approval] (+[amount])
- [Action that gains approval] (+[amount])
- [Decision alignment] (+[amount])

**Disapproval Triggers:**
- [Action that loses approval] (-[amount])
- [Action that loses approval] (-[amount])
- [Decision that conflicts with values] (-[amount])

**Key Thresholds:**
- **Breaking Point:** [Approval level where they leave/betray]
- **Loyalty Lock:** [Approval level where they become committed]
- **Personal Quest Unlock:** [Level needed to access their quest]

---

### [Companion 2 Name]

[Same detailed structure]

---

### [Companion 3 Name]

[Same detailed structure]

---

## Antagonists

### Antagonist Overview

| Name | Type | Motivation | First Appearance | Final Confrontation |
|------|------|------------|------------------|---------------------|
| [Name] | [Primary/Secondary/Faction Leader] | [What drives them] | [When player first encounters] | [How conflict resolves] |

---

### [Primary Antagonist Name]

#### Basic Information
- **Full Name:** [Name and titles]
- **Position:** [Their role in the world]
- **Faction:** [Who they lead/serve]
- **First Appearance:** [When/how player encounters them]

#### Motivation and Goals

**What They Want:** [Their stated/obvious goal]
**Why They Want It:** [The deeper motivation]
**What They Believe:** [Their justification - they're the hero of their own story]

**Philosophy in Their Own Words:** "[A quote that shows their perspective]"

#### Connection to Theme

**How They Embody the Theme:** [How they represent one answer to the central question]
**How They Challenge the Player:** [What their existence/actions force the player to consider]
**The Mirror:** [How they reflect what the protagonist could become]

#### Methods and Actions

**How They Pursue Their Goals:**
- [Method 1 - and what it reveals about them]
- [Method 2]
- [Method 3]

**Lines They Cross:** [What terrible things they're willing to do]
**Lines They Won't Cross:** [If any - what they won't do, and why]

#### Voice and Presence

**Speech Pattern:** [How they communicate]

**Sample Lines:**

```
[Threatening]: "[Example]"

[Philosophical]: "[Example showing their worldview]"

[To Protagonist]: "[How they address the player character]"

[Vulnerable moment - if any]: "[Example]"
```

#### Arc and Confrontation

**Introduction:** [How player first encounters them]
**Escalation:** [How threat/conflict grows]
**Possible Resolutions:**

| Resolution | How It Happens | Requirements | Thematic Statement |
|------------|----------------|--------------|-------------------|
| [Defeat] | [Combat/confrontation] | [What player must do] | [What this ending says] |
| [Redemption] | [If possible - how] | [Requirements] | [Thematic meaning] |
| [Escape] | [If they can get away] | [Circumstances] | [What this sets up] |

---

### [Secondary Antagonist / Faction Leader]

[Similar structure, scaled appropriately]

---

## Conflict Architecture

### The Central Conflict

**Type:** [Person vs Person / Person vs Society / Person vs Self / Person vs Nature / Ideological]

**Description:** [What the conflict actually is]

**Why It Matters:** [Connection to theme]

**Stakes:**
- **Personal:** [What the protagonist personally risks]
- **Relational:** [What companions/relationships are at stake]
- **World:** [What the world risks]

**Can It Be Resolved?:** [Yes/No/Partially - and what that means]

---

### Secondary Conflicts

#### [Conflict Name 1]
- **Type:** [Conflict type]
- **Parties Involved:** [Who's in conflict]
- **Description:** [What's happening]
- **Stakes:** [What's at risk]
- **Player Role:** [How player engages with this conflict]
- **Possible Resolutions:** [How it can end]

#### [Conflict Name 2]
[Same structure]

---

### Internal Conflicts

Struggles within characters that drive drama:

| Character | Internal Conflict | How It Manifests | Possible Resolution |
|-----------|-------------------|------------------|---------------------|
| Protagonist | [Conflict - e.g., "Duty vs. Personal desire"] | [How we see this struggle] | [How it can resolve] |
| [Companion] | [Their internal struggle] | [Manifestation] | [Resolution options] |
| [Antagonist] | [Their internal contradiction] | [How we see it] | [Resolution] |

---

## Endings

### Ending Philosophy

[1-2 paragraphs explaining what endings mean in this game. Are they rewards? Consequences? Different but equal answers to the central question? Can there be a "good" ending?]

**What Determines Endings:**
- [Primary factor - e.g., "Major choice in Act 2"]
- [Secondary factor - e.g., "Faction reputation balance"]
- [Tertiary factor - e.g., "Companion loyalty and survival"]

---

### Ending Determination

| Factor | Weight | How It's Measured |
|--------|--------|-------------------|
| [Factor 1 - e.g., "Faction Alignment"] | [High/Medium/Low] | [Preserver vs. Ashen standing] |
| [Factor 2 - e.g., "Key Choices"] | [Weight] | [Which choices at which moments] |
| [Factor 3 - e.g., "Companion Status"] | [Weight] | [Loyalty, survival, arc completion] |

---

### Ending: [Ending 1 Name]

#### Requirements
- **Primary:** [Main requirement]
- **Secondary:** [Additional requirement]
- **Companion Status:** [Required companion states]

#### The Ending

**Final Scene:**
[Description of the climactic scene for this ending]

**Resolution:**
[What happens immediately after]

**Epilogue Elements:**
- **Protagonist:** [What happens to them]
- **Companions:** [Fate of each companion in this ending]
- **World:** [State of the world]
- **Factions:** [What happens to major factions]

#### Thematic Meaning

**What This Ending Says:** [The thematic statement this ending makes]

**Answer to Central Question:** [How this ending answers the game's central thematic question]

**Emotional Tone:** [How player should feel]

---

### Ending: [Ending 2 Name]

[Same detailed structure]

---

### Ending: [Ending 3 Name]

[Same detailed structure]

---

### Ending Comparison

| Aspect | [Ending 1] | [Ending 2] | [Ending 3] |
|--------|------------|------------|------------|
| **Tone** | [Hopeful/Bittersweet/Tragic] | | |
| **Theme Resolution** | [Affirmed/Questioned/Subverted] | | |
| **Protagonist Fate** | [Summary] | | |
| **World State** | [Better/Changed/Worse] | | |
| **Companion Fates** | [Summary] | | |
| **Player Feeling** | [What they should feel] | | |

---

## Tone Guidelines

### Overall Tone

**Primary Tone:** [e.g., "Melancholic but beautiful"]

**Tone Description:** [2-3 sentences describing what this tone feels like]

**Tonal Range:** [What variations are acceptable - e.g., "Quiet sorrow to fierce moments of life to gentle hope"]

**What This Tone Is NOT:**
- NOT [Misinterpretation - e.g., "Grimdark or nihilistic"]
- NOT [Misinterpretation - e.g., "Heroic adventure"]
- NOT [Misinterpretation - e.g., "Relentlessly bleak"]

---

### Tone by Context

| Context | Tone | Guidelines | Example |
|---------|------|------------|---------|
| Main Quests | [Tone] | [How to achieve it] | [Brief example] |
| Side Quests | [Tone] | [Guidelines] | [Example] |
| Combat | [Tone] | [Guidelines] | [Example] |
| Exploration | [Tone] | [Guidelines] | [Example] |
| NPC Dialogue | [Tone] | [Guidelines] | [Example] |
| Companion Banter | [Tone] | [Guidelines] | [Example] |
| Quiet Moments | [Tone] | [Guidelines] | [Example] |

---

### Tone by Region

| Region | Tone | Description |
|--------|------|-------------|
| [Region 1] | [Tone] | [What this region should feel like] |
| [Region 2] | [Tone] | [Description] |
| [Region 3] | [Tone] | [Description] |

---

### Tone Do's and Don'ts

**DO:**
- [Specific guidance - e.g., "Show beauty in decline - golden light, quiet moments"]
- [Specific guidance - e.g., "Let characters laugh, love, argue - life continues"]
- [Specific guidance - e.g., "Make choices feel meaningful even if the world doesn't change"]
- [Specific guidance - e.g., "Include moments of genuine warmth and connection"]

**DON'T:**
- [Specific prohibition - e.g., "Make it unrelentingly bleak - this isn't grimdark"]
- [Specific prohibition - e.g., "Trivialize the stakes"]
- [Specific prohibition - e.g., "Make one philosophy clearly 'correct'"]
- [Specific prohibition - e.g., "Remove player agency even when outcomes are uncertain"]

---

### Humor Guidelines

**Acceptable Humor:**
- [Type - e.g., "Dry wit"]
- [Type - e.g., "Gallows humor"]
- [Type - e.g., "The absurdity of powerful people"]

**Avoid:**
- [Type - e.g., "Zany or slapstick humor"]
- [Type - e.g., "Jokes that undermine stakes"]
- [Type - e.g., "Meta or fourth-wall breaking"]

**When Humor Works:**
- [Context - e.g., "Moments of respite between tension"]
- [Context - e.g., "Companion banter while traveling"]
- [Context - e.g., "Dark comedy of bureaucracy and power"]

**Humor Examples:**

```
[Good - Dry wit]: "[Example line]"

[Good - Gallows humor]: "[Example line]"

[Bad - Too light]: "[Example of what NOT to write]"
```

---

## Dialogue Guidelines

### Overall Voice Philosophy

[Paragraph describing how dialogue should feel in this game - grounded, heightened, poetic, etc.]

---

### NPC Voice Consistency

**All NPCs Should:**
- [Speak in ways grounded in their situation]
- [Have opinions on major themes/conflicts]
- [React to player reputation/actions]
- [Feel like they exist beyond the player]

**Regional Speech Patterns:**

| Region | Speech Characteristics | Example |
|--------|------------------------|---------|
| [Region 1] | [Patterns - formal, dialect, metaphors used] | "[Sample phrase]" |
| [Region 2] | [Patterns] | "[Sample]" |
| [Region 3] | [Patterns] | "[Sample]" |

**Class-Based Speech:**

| Class | Speech Characteristics | Example |
|-------|------------------------|---------|
| Nobility | [Patterns] | "[Sample]" |
| Common Folk | [Patterns] | "[Sample]" |
| Military | [Patterns] | "[Sample]" |
| Religious | [Patterns] | "[Sample]" |
| Merchants | [Patterns] | "[Sample]" |

---

### Exposition Rules

**Rule 1: Show Through Detail**
- [Guideline - e.g., "Reveal world state through small details, not explanations"]
- [Example of good exposition]
- [Example of bad exposition to avoid]

**Rule 2: Let NPCs Have Opinions**
- [Guideline - e.g., "Everyone has a take on the central conflict"]
- [Example]

**Rule 3: Don't Over-Explain**
- [Guideline - e.g., "Mystery and uncertainty are acceptable"]
- [What to leave unexplained]

**Rule 4: Make Philosophy Personal**
- [Guideline - e.g., "Beliefs tied to character experience, not abstract"]
- [Example of grounded vs. abstract philosophy]

---

### Dialogue Do's and Don'ts

**DO:**
- [e.g., "Use subtext - what characters DON'T say matters"]
- [e.g., "Let conversations reveal character, not just convey information"]
- [e.g., "Give players meaningful response options that reflect different approaches"]
- [e.g., "Allow silence and deflection as valid responses"]

**DON'T:**
- [e.g., "Use modern slang or anachronistic references"]
- [e.g., "Have characters explain things they would both already know"]
- [e.g., "Make all information easily accessible - some things are earned"]
- [e.g., "Give players only 'flavor' options that all lead to the same place"]

---

## Narrative Consistency Rules

When creating narrative content:

1. **Theme Check:** Does this content explore or reinforce the core theme?
2. **Character Consistency:** Do characters act according to their established personalities and motivations?
3. **Choice Meaning:** If there's a choice, do the options have meaningfully different consequences?
4. **Tone Alignment:** Does the tone match the context guidelines for this situation?
5. **World Logic:** Does this fit the established rules of the world?
6. **Faction Coherence:** Are faction reactions consistent with their established values?
7. **Consequence Tracking:** Does this acknowledge relevant past player choices?
8. **Emotional Arc:** Does this fit the intended emotional journey for this act/moment?

---

## Inspirations

### Primary Narrative Inspirations

| Source | What We Take | What We Leave |
|--------|--------------|---------------|
| [Game/Book/Film] | [Specific element - be precise] | [What doesn't fit our vision] |
| [Source] | [Element] | [What we avoid] |
| [Source] | [Element] | [What we avoid] |

### Anti-Inspirations

Sources that do things we explicitly DON'T want:

| Source | What to Avoid | Why |
|--------|---------------|-----|
| [Source] | [Specific element] | [Why it doesn't fit] |
| [Source] | [Element] | [Why] |

---

## Appendix: Story Beat Checklist

### Act 1 Beats
- [ ] Opening establishes world and protagonist
- [ ] Player understands the status quo before it's disrupted
- [ ] Inciting incident creates urgent motivation
- [ ] Major factions and themes introduced
- [ ] At least one meaningful choice with consequences
- [ ] Companion introductions feel organic
- [ ] Act ends with clear forward momentum

### Act 2 Beats
- [ ] Stakes escalate meaningfully
- [ ] Midpoint revelation changes understanding
- [ ] Companion arcs develop significantly
- [ ] Player faces consequences of Act 1 choices
- [ ] Point of no return requires commitment
- [ ] Themes are explored through conflict
- [ ] Multiple paths remain viable

### Act 3 Beats
- [ ] Climax addresses central conflict
- [ ] Player choices matter to outcome
- [ ] Character arcs resolve (growth/stagnation/fall)
- [ ] Thematic question receives answer (or deliberate non-answer)
- [ ] Ending feels earned, not arbitrary
- [ ] Epilogue provides closure
- [ ] Emotional impact is appropriate to the journey

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | [Date] | Initial creation via game-ideator |
```

### design-pillars.md Template

```markdown
# Design Pillars: [Game Title]

> **Purpose:** This document defines the core design principles that guide ALL design decisions.
> When in doubt, consult these pillars. When features conflict, these pillars decide.
>
> **Last Updated:** [Date]
> **Version:** 1.0

---

## The Elevator Pitch

**[Game Title]** is a [genre] where [core hook].

Players will feel **[core fantasy]** as they **[primary activity]**.

### The Extended Pitch

[2-3 paragraph description of the game that captures its essence, unique selling points, and emotional promise. This should be compelling enough to explain the game to someone unfamiliar with it.]

### Key Differentiators

What makes this game stand out from similar games:

1. **[Differentiator 1]:** [Why this matters]
2. **[Differentiator 2]:** [Why this matters]
3. **[Differentiator 3]:** [Why this matters]

---

## Core Design Pillars

These pillars are the non-negotiable principles that guide every design decision. They are listed in priority order - when pillars conflict, the higher-numbered pillar wins.

---

### Pillar 1: [Pillar Name]

**Statement:** [One sentence principle that captures the essence]

#### What This Pillar Means

[Paragraph explaining this pillar in depth - what it means philosophically, why it matters to the game, and how it shapes the player experience]

#### Concrete Implications

- [Specific implication 1 - how this affects design]
- [Specific implication 2 - what this requires]
- [Specific implication 3 - what this prioritizes]
- [Specific implication 4 - what this de-prioritizes]

#### Systems That Support This Pillar

| System | How It Supports This Pillar |
|--------|----------------------------|
| [System 1 - e.g., Combat] | [How this system embodies the pillar] |
| [System 2 - e.g., Dialogue] | [How this system embodies the pillar] |
| [System 3 - e.g., Progression] | [How this system embodies the pillar] |

#### Design Decisions Derived From This Pillar

- [Decision 1 - e.g., "Choices have consequences that ripple through the narrative"]
- [Decision 2 - e.g., "No obvious 'right' answers - trade-offs and grey areas"]
- [Decision 3 - specific design choice tied to this pillar]

#### Red Flags (Violating This Pillar)

Signs that a design is violating this pillar:

- [Violation example 1 - e.g., "Choices that are obviously good/evil with no trade-off"]
- [Violation example 2 - e.g., "Decisions that have no observable consequence"]
- [Violation example 3 - specific anti-pattern]

#### Pillar 1 Quick Check

Before adding any feature, ask: **[Key question derived from this pillar]?**

---

### Pillar 2: [Pillar Name]

**Statement:** [One sentence principle]

#### What This Pillar Means

[Explanation paragraph]

#### Concrete Implications

- [Implication 1]
- [Implication 2]
- [Implication 3]
- [Implication 4]

#### Systems That Support This Pillar

| System | How It Supports This Pillar |
|--------|----------------------------|
| [System] | [How] |
| [System] | [How] |

#### Design Decisions Derived From This Pillar

- [Decision 1]
- [Decision 2]
- [Decision 3]

#### Red Flags (Violating This Pillar)

- [Violation 1]
- [Violation 2]
- [Violation 3]

#### Pillar 2 Quick Check

Before adding any feature, ask: **[Key question]?**

---

### Pillar 3: [Pillar Name]

[Same detailed structure as above]

---

### Pillar 4: [Pillar Name] (if applicable)

[Same detailed structure]

---

### Pillar 5: [Pillar Name] (if applicable)

[Same detailed structure]

---

## Player Fantasy

### The Core Fantasy

**Players should feel like:** [Detailed description of the fantasy - what power, role, or experience the player should embody]

**This is NOT:**
- NOT [Common misinterpretation - e.g., "an unstoppable hero"]
- NOT [Another misinterpretation - e.g., "a puzzle-solver with no emotional stakes"]
- NOT [Misinterpretation to avoid]

#### Fantasy Breakdown

| Aspect | What Players Should Feel | What They Should NOT Feel |
|--------|-------------------------|--------------------------|
| **Agency** | [e.g., "Their choices matter"] | [e.g., "Railroaded or irrelevant"] |
| **Competence** | [e.g., "Capable but challenged"] | [e.g., "Overpowered or helpless"] |
| **Challenge** | [e.g., "Tested, but fairly"] | [e.g., "Punished or bored"] |
| **Narrative** | [e.g., "Part of an unfolding story"] | [e.g., "Observer or interruption"] |
| **Emotional** | [e.g., "Invested in outcomes"] | [e.g., "Detached or numb"] |

### How Systems Deliver The Fantasy

| System | How It Delivers Fantasy | Example |
|--------|------------------------|---------|
| **Combat** | [How fighting makes them feel the fantasy] | [Specific example] |
| **Dialogue** | [How conversations reinforce the fantasy] | [Specific example] |
| **Progression** | [How growth supports the fantasy] | [Specific example] |
| **Exploration** | [How discovery serves the fantasy] | [Specific example] |
| **Companions** | [How relationships embody the fantasy] | [Specific example] |
| **World State** | [How the world reinforces the fantasy] | [Specific example] |

### Fantasy Consistency Checklist

For any new feature, ask:

1. ✅ Does this make the player feel **[core fantasy]**?
2. ✅ If not, does it at least NOT detract from the core fantasy?
3. ✅ Can this be redesigned to better support the fantasy?
4. ✅ Does this feel like something a [protagonist type] would do/experience?
5. ✅ Would the target audience recognize this as fitting the fantasy?

If any answer is NO, reconsider or redesign the feature.

---

## Scope Definition

### What's IN Scope

#### Must Have (Non-Negotiable)

These features are the core of the experience. Without them, the game fails to deliver its promise.

| # | Feature | Pillar It Serves | Why It's Essential |
|---|---------|------------------|-------------------|
| 1 | **[Feature]** | Pillar [X] | [Specific reason tied to pillars/fantasy] |
| 2 | **[Feature]** | Pillar [X] | [Reason] |
| 3 | **[Feature]** | Pillar [X] | [Reason] |
| 4 | **[Feature]** | Pillar [X] | [Reason] |
| 5 | **[Feature]** | Pillar [X] | [Reason] |
| 6 | **[Feature]** | Pillar [X] | [Reason] |
| 7 | **[Feature]** | Pillar [X] | [Reason] |

#### Should Have (Important)

These features significantly enhance the experience but aren't strictly required for the core loop.

| # | Feature | Pillar It Serves | Impact If Cut |
|---|---------|------------------|---------------|
| 1 | [Feature] | Pillar [X] | [What we lose] |
| 2 | [Feature] | Pillar [X] | [What we lose] |
| 3 | [Feature] | Pillar [X] | [What we lose] |
| 4 | [Feature] | Pillar [X] | [What we lose] |

#### Nice to Have (If Time)

These would be wonderful additions but the core experience is complete without them.

| # | Feature | Why It Would Be Nice | Estimated Effort |
|---|---------|---------------------|------------------|
| 1 | [Feature] | [Benefit] | [Low/Medium/High] |
| 2 | [Feature] | [Benefit] | [Effort] |
| 3 | [Feature] | [Benefit] | [Effort] |

---

### What's OUT of Scope

#### Explicitly NOT Including

These features have been deliberately excluded. This list prevents scope creep and maintains focus.

| Feature | Why It's Out | Pillar It Would Violate | Common Request? |
|---------|--------------|------------------------|-----------------|
| **[Feature]** | [Specific reason - scope, pillar conflict, focus] | [Which pillar or "N/A - just out of scope"] | [Yes/No] |
| **[Feature]** | [Reason] | [Pillar] | [Yes/No] |
| **[Feature]** | [Reason] | [Pillar] | [Yes/No] |
| **[Feature]** | [Reason] | [Pillar] | [Yes/No] |
| **[Feature]** | [Reason] | [Pillar] | [Yes/No] |
| **[Feature]** | [Reason] | [Pillar] | [Yes/No] |

#### Scope Creep Detection

**Warning Phrases That Indicate Scope Creep:**
- "What if we also added..."
- "Other games have..."
- "It would be cool if..."
- "Since we're already doing X, we could easily add Y..."
- "Players will expect..."
- "It's just a small addition..."

**Response Protocol:**

When these phrases come up:
1. Check if the feature supports any pillar
2. Check if it's already on the OUT list
3. If it truly supports pillars and isn't on the OUT list, evaluate properly
4. If it doesn't support pillars, politely decline
5. If unclear, add to "Parking Lot" for future consideration

#### The Parking Lot

Ideas that have merit but aren't in scope for this version:

| Idea | Why It's Interesting | Why It's Not Now | Reconsider When |
|------|---------------------|------------------|-----------------|
| [Idea] | [Merit] | [Reason for deferral] | [Condition to revisit] |

---

## Quality Bar

### Quality Philosophy

[Paragraph explaining the overall quality approach - where is quality non-negotiable, where is "good enough" acceptable, what's the balance between polish and scope]

**Our Priority:** [Quality over quantity / Breadth over depth / Specific areas get polish]

---

### Quality by Area

#### Combat Quality Bar

| Aspect | Target Level | What This Means Specifically |
|--------|-------------|------------------------------|
| **Feel** | [Placeholder/Functional/Polished] | [e.g., "Responsive controls, impactful feedback, readable animations"] |
| **Depth** | [Shallow/Moderate/Deep] | [e.g., "Multiple viable strategies, positioning matters, ability synergies"] |
| **Balance** | [Rough/Reasonable/Tuned] | [e.g., "Encounters feel fair, difficulty curve is intentional"] |
| **Visual** | [Functional/Good/Polished] | [e.g., "Clear visual feedback, effects support readability"] |

#### Narrative Quality Bar

| Aspect | Target Level | What This Means Specifically |
|--------|-------------|------------------------------|
| **Writing** | [Minimal/Standard/Deep] | [e.g., "Rich character voices, thematic consistency, memorable moments"] |
| **Branching** | [Linear/Light/Heavy] | [e.g., "Major choices have visible consequences, NPC memory"] |
| **Characters** | [Functional/Developed/Deep] | [e.g., "Companions have arcs, antagonists have understandable motivations"] |
| **Worldbuilding** | [Minimal/Present/Rich] | [e.g., "Consistent lore, discoverable details, environmental storytelling"] |

#### Art Quality Bar

| Aspect | Target Level | What This Means Specifically |
|--------|-------------|------------------------------|
| **Style** | [Placeholder/Stylized/Detailed] | [e.g., "Consistent aesthetic, reads clearly at gameplay distance"] |
| **Animation** | [Minimal/Functional/Polished] | [e.g., "Key actions animated, personality in movement"] |
| **Environment** | [Basic/Atmospheric/Immersive] | [e.g., "Supports mood, readable navigation, memorable locations"] |
| **UI** | [Functional/Clean/Polished] | [e.g., "Clear information hierarchy, consistent patterns"] |

#### Audio Quality Bar

| Aspect | Target Level | What This Means Specifically |
|--------|-------------|------------------------------|
| **Music** | [Minimal/Ambient/Full Score] | [e.g., "Contextual music, reinforces mood, memorable themes"] |
| **SFX** | [Basic/Complete/Polished] | [e.g., "All actions have appropriate feedback"] |
| **Ambience** | [None/Basic/Rich] | [e.g., "Locations have distinct soundscapes"] |
| **Voice** | [None/Partial/Full] | [e.g., "Key moments voiced, barks for combat/exploration"] |

#### Technical Quality Bar

| Aspect | Target Level | What This Means Specifically |
|--------|-------------|------------------------------|
| **Performance** | [Acceptable/Good/Optimized] | [e.g., "Stable framerate, reasonable load times"] |
| **Stability** | [Playable/Stable/Polished] | [e.g., "No crashes, saves work reliably, no progression blockers"] |
| **UX** | [Functional/Good/Polished] | [e.g., "Clear feedback, reasonable onboarding, accessibility options"] |

---

### Quality vs. Scope Trade-offs

When time is limited, prioritize in this order:

1. **Never Cut:** [Core quality area - e.g., "Core combat feel and narrative moments"]
2. **Protect:** [Important quality area - e.g., "Character writing and major choice consequences"]
3. **Reduce Before Cutting:** [Can scale down - e.g., "Side content depth, environment detail"]
4. **First to Cut:** [Nice-to-have polish - e.g., "Extended epilogues, optional areas"]

**The Cut Order:**

1. Nice to Have features
2. Polish on Should Have features
3. Should Have features (if desperate)
4. NEVER: Must Have features or core quality

---

## Design Conflict Resolution

### The Decision Framework

When two good ideas conflict, resolve using this priority order:

| Priority | Criterion | Question to Ask |
|----------|-----------|-----------------|
| 1 | **Pillar Alignment** | Which option better supports the design pillars (in priority order)? |
| 2 | **Theme Reinforcement** | Which option better reinforces the core theme? |
| 3 | **Fantasy Consistency** | Which option better serves the player fantasy? |
| 4 | **Scope Feasibility** | Which option is more achievable within constraints? |
| 5 | **Polish Potential** | Which option can we execute better? |

---

### Conflict Resolution Process

When facing a design conflict:

1. **Identify the conflict clearly** - What are the mutually exclusive options?
2. **Map to pillars** - Which pillars does each option support/violate?
3. **Check theme alignment** - Which option better explores/reinforces the theme?
4. **Evaluate scope impact** - What does each option cost?
5. **Consider the fantasy** - Which option serves the player experience better?
6. **Make the call** - Use the priority order above
7. **Document the decision** - Record why this choice was made

---

### Example Conflict Resolutions

#### Example 1: [Specific Conflict Name]

**Conflict:** [Description of the conflict]

**Option A:** [First option and what it offers]
**Option B:** [Second option and what it offers]

**Analysis:**
- Option A supports Pillar [X]: [How]
- Option B supports Pillar [Y]: [How]
- Theme consideration: [Which aligns better]
- Scope consideration: [Feasibility comparison]

**Resolution:** Choose **Option [X]** because:
- [Primary reason tied to pillar priority]
- [Secondary supporting reason]

**Lesson:** [What this teaches about similar conflicts]

---

#### Example 2: [Another Conflict Name]

[Same structure]

---

## Anti-Patterns

### Design Smells

These patterns suggest we're going off-track. If you notice these, stop and reconsider.

| Anti-Pattern | Why It's Bad | Which Pillar It Violates | What To Do Instead |
|--------------|--------------|--------------------------|-------------------|
| **[Pattern 1]** | [Why this is problematic] | Pillar [X] | [Alternative approach] |
| **[Pattern 2]** | [Why problematic] | Pillar [X] | [Alternative] |
| **[Pattern 3]** | [Why problematic] | Pillar [X] | [Alternative] |
| **[Pattern 4]** | [Why problematic] | Pillar [X] | [Alternative] |
| **[Pattern 5]** | [Why problematic] | Pillar [X] | [Alternative] |

---

### Problem-Indicating Questions

If you're asking these questions, something is wrong:

| Question | What It Indicates | What To Do |
|----------|-------------------|------------|
| "How do we explain this to the player?" | Design is too complex | Simplify the mechanic, not the explanation |
| "Can we just add a tutorial for this?" | UX is unintuitive | Redesign for clarity |
| "What if players don't find this?" | Discoverability problem | Make it more visible or remove it |
| "We can patch this later" | Quality compromise | Fix it now or scope it out |
| "Just add an option for it" | Avoiding design decisions | Make a choice and commit |
| "Players will figure it out" | Insufficient feedback | Add clearer feedback |
| "It works in [other game]" | Context-blind copying | Evaluate for YOUR game |

---

### Common Traps

#### Trap 1: [Trap Name]

**What It Looks Like:** [Description of the trap]
**Why It's Tempting:** [Why people fall into this]
**The Problem:** [What goes wrong]
**The Solution:** [How to avoid or escape]

#### Trap 2: [Trap Name]

[Same structure]

---

## Reference Games

### Primary Inspirations

| Game | What We Take | What We Leave | How We Adapt It |
|------|--------------|---------------|-----------------|
| **[Game 1]** | [Specific element] | [What doesn't fit] | [How we make it our own] |
| **[Game 2]** | [Specific element] | [What doesn't fit] | [Adaptation] |
| **[Game 3]** | [Specific element] | [What doesn't fit] | [Adaptation] |

### Secondary Inspirations

| Game | Specific Inspiration | Notes |
|------|---------------------|-------|
| [Game] | [Narrow element] | [Context] |
| [Game] | [Narrow element] | [Context] |

### Anti-Inspirations

Games that do things we explicitly DON'T want to do:

| Game | What to Avoid | Why It Doesn't Fit Our Pillars |
|------|---------------|-------------------------------|
| **[Game 1]** | [Specific element to avoid] | [Which pillar it violates] |
| **[Game 2]** | [Element to avoid] | [Why it's wrong for us] |
| **[Game 3]** | [Element to avoid] | [Why it's wrong for us] |

---

## The Gut Checks

### Feature Gut Check

Before implementing any feature, ask:

1. ✅ Does this support at least ONE design pillar?
2. ✅ Does this reinforce the core player fantasy?
3. ✅ Is this IN scope (not on the OUT list)?
4. ✅ Does this meet our quality bar for the relevant area?
5. ✅ Would cutting this hurt the core experience?
6. ✅ Can we execute this well within constraints?
7. ✅ Does this feel consistent with the game's tone?

**If any answer is NO, reconsider the feature.**

---

### Content Gut Check

Before adding any piece of content (quest, dialogue, character), ask:

1. ✅ Does this explore or reinforce the theme?
2. ✅ Does this fit the established tone?
3. ✅ Is this consistent with established world rules?
4. ✅ Does this serve a purpose (story, gameplay, worldbuilding)?
5. ✅ Would the game be worse without this?

**If any answer is NO, reconsider the content.**

---

### "Should We Add This?" Decision Tree

```
                     Does it support a pillar?
                           /          \
                         YES           NO
                          |             |
              Is it in scope?      Is it on the OUT list?
                  /      \              /        \
                YES       NO          YES         NO
                 |         |           |           |
         Can we execute  Add to     Decline     Evaluate
         it well?       parking lot  firmly     carefully
            /    \
          YES     NO
           |       |
        Do it    Scale it
                 back or
                 defer
```

---

## Development Process Guidelines

### Phase 1: Foundation
**Focus:** Core systems, placeholder content, prove the fun
**Quality Bar:** Functional
**What's Cut First:** Polish, edge cases, nice-to-haves

### Phase 2: Content
**Focus:** All Must-Have content, Should-Have content begins
**Quality Bar:** Good
**What's Cut First:** Should-Have features that aren't working

### Phase 3: Polish
**Focus:** Quality bar across all areas, Should-Have completion
**Quality Bar:** Target levels from Quality Bar section
**What's Cut First:** Nice-to-Have, then Should-Have scope

### Phase 4: Ship
**Focus:** Bug fixing, balance, final polish
**Quality Bar:** Shippable
**What's Cut First:** Anything that introduces risk

---

## Playtesting Guidelines

### What We're Testing For

| Playtest Phase | Primary Questions | How We Measure |
|----------------|-------------------|----------------|
| Early | Is the core loop fun? | Observation, feel |
| Mid | Do pillars come through? | Direct questions, behavior |
| Late | Is quality bar met? | Polish issues, confusion points |
| Final | Is it shippable? | Blockers, critical issues |

### Pillar-Specific Playtest Questions

**For Pillar 1 ([Name]):**
- [Question to ask players]
- [Behavior to observe]

**For Pillar 2 ([Name]):**
- [Question to ask]
- [Behavior to observe]

[Continue for each pillar]

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | [Date] | Initial creation via game-ideator |

---

## Quick Reference Card

### The Pillars (in priority order)
1. **[Pillar 1 Name]:** [One-line summary]
2. **[Pillar 2 Name]:** [One-line summary]
3. **[Pillar 3 Name]:** [One-line summary]

### The Core Fantasy
**Players feel like:** [Brief description]

### The Must-Haves
1. [Feature 1]
2. [Feature 2]
3. [Feature 3]

### The Hard No's
- [OUT item 1]
- [OUT item 2]
- [OUT item 3]

### When In Doubt
Ask: "Does this support a pillar and serve the fantasy?"
If NO: Don't do it.
If UNCLEAR: Check the conflict resolution process.
```

---

## Post-Generation Actions

After generating all three documents:

1. **Save to docs/design/**
   - `docs/design/world-bible.md`
   - `docs/design/narrative-bible.md`
   - `docs/design/design-pillars.md`

2. **Offer next steps:**

```markdown
## Foundation Documents Created

I've created your game's foundational documents:

- ✅ `docs/design/world-bible.md` - Setting, factions, geography
- ✅ `docs/design/narrative-bible.md` - Themes, structure, endings
- ✅ `docs/design/design-pillars.md` - Core principles, scope

### What These Documents Do

All downstream content creation skills will read these documents to ensure consistency:

| Skill | What It Reads | What It Creates (Actual Files) |
|-------|---------------|--------------------------------|
| narrative-architect | All three | docs/narrative/*.md (story arcs, character profiles) |
| world-builder | All three | data/world/*.worldmap.json |
| character-creator | All three | data/characters/**/*.char |
| quest-designer | All three | data/quests/*.json |
| dialogue-designer | All three | data/dialogue/*.dtree |
| encounter-designer | All three | data/encounters/*.json |
| campaign-creator | All three + all content | data/campaigns/*.json |

### Recommended Next Steps

**Path A: Incremental Content Creation**
1. **Review the documents** - Ensure they capture your vision
2. **Use narrative-architect** - Expand story and character details
3. **Create content piece by piece** - Use individual designer skills
4. **Tie together with campaign-creator** - Create the campaign file

**Path B: Bulk Generation (for testing)**
1. **Review the documents** - Ensure they capture your vision
2. **Use test-campaign-generator** - Create a spec for all content
3. **Use test-campaign-scaffolder** - Generate all files at once

Would you like me to:
- [ ] Review/edit any of these documents
- [ ] Start the incremental path with narrative-architect
- [ ] Start the bulk path with test-campaign-generator
- [ ] Explain the difference between the two paths
```

---

## Skill Integration

### How Downstream Skills Use These Documents

When other skills run, they should:

```markdown
## Phase 1: Read Foundation Documents

Before generating content, read:
1. `docs/design/world-bible.md` - For setting consistency
2. `docs/design/narrative-bible.md` - For tone and theme
3. `docs/design/design-pillars.md` - For scope and quality

Extract:
- Faction names and relationships
- Tone guidelines
- What's IN/OUT of scope
- Quality bar expectations
- Thematic questions to explore
```

### Document Dependency Map

```
game-ideator outputs:
├── world-bible.md
│   └── Used by: narrative-architect, world-builder, character-creator,
│                quest-designer, dialogue-designer, encounter-designer,
│                campaign-creator, test-campaign-generator
├── narrative-bible.md
│   └── Used by: narrative-architect, quest-designer, dialogue-designer,
│                character-creator, campaign-creator
└── design-pillars.md
    └── Used by: ALL downstream skills (for scope/quality checks)

Content Creation Skills (create actual game files):
├── world-builder         → data/world/*.worldmap.json
├── character-creator     → data/characters/**/*.char
├── quest-designer        → data/quests/*.json
├── dialogue-designer     → data/dialogue/*.dtree
├── encounter-designer    → data/encounters/*.json
└── campaign-creator      → data/campaigns/*.json (ties everything together)
```

---

## Example Invocations

**Reference Material Import:**
- "I want to import my D&D campaign into the CRPG engine"
- "Help me translate Dragons of Icespire Peak"
- "Convert my tabletop homebrew to CRPG format"
- "I have a Pathfinder adventure to adapt"

**With Structured Input:**
- "Here's a table of my locations and NPCs" [provides tables]
- "I'll give you the data as JSON"
- "Let me provide the setting info as bullet points"

**With Conversational Input:**
- "I have campaign notes I want to formalize - ask me questions"
- "Let's do world-building for my RPG"
- "Guide me through defining my world"

**Original Creation:**
- "Set up the creative foundation for my game"
- "Create the game bibles for a new project"
- "I want to define my game's vision before building content"
- "Use game-ideator to establish my world"

**Template-Based:**
- "Start from a dark fantasy template"
- "Give me a base setting I can customize"

---

## Workflow Summary

### Understanding the Two Dimensions

The game-ideator skill operates on two orthogonal dimensions:

| Dimension | Options | Description |
|-----------|---------|-------------|
| **Input Source** | Reference Material, Original, Template | Where content comes from |
| **Input Format** | Structured, Conversational, Mixed | How content is provided |

### Workflow: Reference Material + Structured

**Fastest path for D&D/module imports with prepared data**

1. **Ask for input approach** → User selects Reference + Structured
2. **Request structured data** (tables, JSON, lists)
3. **User provides data in any structured format**
4. **Parse and normalize data**
5. **Show extraction summary**
6. **Ask about gaps** (Q&A or skip)
7. **Generate all three documents**
8. **Save to docs/design/**
9. **Offer next steps**

### Workflow: Reference Material + Conversational

**Best for describing source material interactively**

1. **Ask for input approach** → User selects Reference + Conversational
2. **Ask about source type** (published, homebrew, scope)
3. **Wait for response**
4. **Ask focused questions per category** (world, locations, factions, NPCs)
5. **Wait for responses**
6. **Generate documents from conversation**
7. **Save to docs/design/**
8. **Offer next steps**

### Workflow: Original + Conversational (5-Phase Q&A)

**Default for building new worlds from scratch**

1. **Ask for input approach** → User selects Original + Conversational
2. **Phase 1: Core Identity** - Ask ONE question at a time (title, pitch, fantasy, genre)
3. Summarize Phase 1, transition to Phase 2
4. **Phase 2: World & Setting** - Ask ONE question at a time (era, magic, world state, geography, factions)
5. Summarize Phase 2, transition to Phase 3
6. **Phase 3: Narrative & Theme** - Ask ONE question at a time (theme, secondary themes, structure, tone, endings)
7. Summarize Phase 3, transition to Phase 4
8. **Phase 4: Design Philosophy** - Ask ONE question at a time (pillars, scope in/out, quality bar, conflict resolution)
9. Summarize Phase 4, transition to Phase 5
10. **Phase 5: Final Details** - Ask ONE question at a time (references, player character, companions, anything else)
11. **Generate all three documents**
12. **Save to docs/design/**
13. **Offer next steps**

**Key principle:** Each question is its own conversational turn. Acknowledge answers, then ask the next question naturally.

### Workflow: Original + Structured

**For users who know exactly what they want**

1. **Ask for input approach** → User selects Original + Structured
2. **Request structured world definition**
3. **User provides tables/lists with world, locations, factions**
4. **Parse data**
5. **Ask about missing design elements** (pillars, themes)
6. **Generate documents**
7. **Save to docs/design/**
8. **Offer next steps**

### Workflow: Template-Based

**Quickest start, then customize**

1. **Ask for input approach** → User selects Template
2. **Show template options**
3. **User selects template**
4. **Generate base documents from template**
5. **Ask what to customize** (structured overrides or Q&A)
6. **Apply customizations**
7. **Save to docs/design/**
8. **Offer next steps**

### Workflow: Document Import

**For existing written material**

1. **User provides file paths or pastes content**
2. **Read and analyze material**
3. **Show extraction summary**
4. **Identify gaps**
5. **Fill gaps (structured data or Q&A)**
6. **Generate documents**
7. **Save to docs/design/**
8. **Offer next steps**

---

## Checklist Before Completing

- [ ] Asked for input approach (Source + Format)
- [ ] Identified input source (Reference Material / Original / Template)
- [ ] Identified input format (Structured / Conversational / Mixed)
- [ ] Gathered all necessary information via appropriate workflow
- [ ] For structured input: Accepted tables, JSON, lists, or key-value pairs
- [ ] For conversational input: Completed relevant Q&A phases
- [ ] Created `docs/design/world-bible.md`
- [ ] Created `docs/design/narrative-bible.md`
- [ ] Created `docs/design/design-pillars.md`
- [ ] All documents follow templates
- [ ] Offered next steps (both incremental and bulk paths)
- [ ] Documents are consistent with each other
- [ ] For reference imports: Source material properly attributed
