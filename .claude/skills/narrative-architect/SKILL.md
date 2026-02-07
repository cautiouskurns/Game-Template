---
name: narrative-architect
description: Expand foundation documents into detailed story arcs, character profiles, and narrative beats. Reads from game-ideator outputs and creates detailed narrative specifications for quest and dialogue designers.
domain: design
type: architect
version: 1.0.0
reads:
  - docs/design/world-bible.md
  - docs/design/narrative-bible.md
  - docs/design/design-pillars.md
outputs:
  - docs/narrative/story-arcs.md
  - docs/narrative/character-profiles.md
  - docs/narrative/key-scenes.md
  - docs/narrative/quest-hooks.md
allowed-tools:
  - Read
  - Write
  - Glob
---

# Narrative Architect Skill

This skill takes the **foundational documents** from `game-ideator` and expands them into **detailed narrative specifications** that downstream skills (quest-designer, dialogue-designer, character-creator) can use to create consistent content.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | design-lead |
| **Sprint Phase** | Phase A (Spec) |
| **Directory Scope** | `docs/` |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

---

## Skill Hierarchy Position

```
                    ┌─────────────────────────────┐
                    │      GAME IDEATOR           │
                    │   (Creative Foundation)      │
                    └─────────────────────────────┘
                                 │
                    Reads: docs/design/
                    • world-bible.md
                    • narrative-bible.md
                    • design-pillars.md
                                 │
                                 ▼
                    ┌─────────────────────────────┐
                    │   NARRATIVE ARCHITECT       │  ◄── THIS SKILL
                    │   (Story & Character Detail)│
                    └─────────────────────────────┘
                                 │
                    Outputs: docs/narrative/
                    • story-arcs.md
                    • character-profiles.md
                    • key-scenes.md
                    • quest-hooks.md
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

## CRITICAL: What This Skill Does and Does NOT Do

```
+------------------------------------------+------------------------------------------+
|              THIS SKILL DOES             |          THIS SKILL DOES NOT DO         |
+------------------------------------------+------------------------------------------+
| Read foundation docs from game-ideator   | Create foundation docs (use game-ideator)|
|                                          |                                          |
| Expand story structure into detailed     | Create actual quest/dialogue files       |
| beats, scenes, and character arcs        | (use quest-designer, dialogue-designer)  |
|                                          |                                          |
| Create character profiles with           | Create .char files or JSON data          |
| personality, history, and relationships  | (use character-creator skill)            |
|                                          |                                          |
| Define key narrative scenes and moments  | Write actual dialogue lines              |
| that quests should build toward          | (use dialogue-designer skill)            |
|                                          |                                          |
| Generate quest hooks and narrative seeds | Create campaign specs                    |
| for quest designers to implement         | (use test-campaign-generator)            |
+------------------------------------------+------------------------------------------+
```

---

## Prerequisites

Before running this skill, ensure:

1. **Foundation documents exist** from `game-ideator`:
   - `docs/design/world-bible.md`
   - `docs/design/narrative-bible.md`
   - `docs/design/design-pillars.md`

2. If these don't exist, tell the user:
   > "No foundation documents found. Please run `game-ideator` first to establish the creative vision."

---

## When to Use This Skill

Invoke this skill when the user:
- Says "expand the narrative" or "detail the story"
- Asks to "flesh out the characters"
- Wants to "create story arcs" or "define key scenes"
- Says "use narrative-architect"
- Has completed game-ideator and wants more narrative depth
- Is preparing to create quests and dialogues
- **Has D&D campaign content to translate into detailed specs**
- **Has existing character/story notes to formalize**

---

## Input Modes

**ALWAYS ask which input mode the user wants:**

```markdown
## Narrative Architect Session

How would you like to expand the narrative?

**Input Mode:**
- [ ] **Interactive Q&A** - I'll guide you through questions to expand the story
- [ ] **D&D/Tabletop Content** - I have existing tabletop content (module, adventure notes)
- [ ] **Existing Notes** - I have written material to formalize into structured docs
- [ ] **Foundation Only** - Just extract from game-ideator docs, minimal questions

Select your preferred input mode to continue.
```

**Wait for user response before proceeding.**

---

### Input Mode: D&D/Tabletop Content

**If user has D&D content to translate:**

```markdown
## D&D/Tabletop Narrative Extraction

I'll help you extract narrative structure from your tabletop content.

**Source Material:**
Please provide or describe your content. I need:

**1. Adventure Structure**
- What's the adventure/campaign called?
- How many main chapters/acts?
- What's the overall story arc (beginning → end)?

**2. Key NPCs**
List the important NPCs from your campaign:
| NPC Name | Role | Location | Key Information They Provide |
|----------|------|----------|------------------------------|
| [e.g., Toblen Stonehill] | [Quest giver] | [Stonehill Inn] | [Rumors about orcs] |

**3. Companions (if applicable)**
Are there companion characters the player can recruit?
| Companion | How They Join | Personal Quest/Conflict |
|-----------|---------------|------------------------|
| [Name] | [Circumstances] | [Their story] |

**4. Antagonists/Villains**
| Antagonist | Motivation | Connection to Plot |
|------------|------------|-------------------|
| [e.g., Cryovain] | [Dragon wants territory] | [Main threat] |

**5. Key Scenes/Encounters**
What are the memorable/critical moments?
| Scene Name | Location | What Happens | Player Choices |
|------------|----------|--------------|----------------|
| [e.g., Dragon Attack] | [Phandalin] | [Dragon attacks, chaos] | [Fight, flee, negotiate] |

**6. Quest Structure**
List the main quests:
| Quest Name | Giver | Objective | Outcome |
|------------|-------|-----------|---------|
| [e.g., Dwarven Excavation] | [Job Board] | [Clear undead] | [Reward + info] |
```

**After receiving this information, generate the four narrative documents from it.**

---

### Input Mode: Existing Notes

**If user has existing written material:**

```markdown
## Existing Notes Import

Please provide your notes in one of these ways:

**Option 1: File Path**
`docs/my-story-notes.md` or paste content directly.

**Option 2: Describe What You Have**
- Story outline: [yes/no]
- Character descriptions: [yes/no]
- Quest ideas: [yes/no]
- Scene descriptions: [yes/no]

I'll extract what's available and ask clarifying questions for gaps.
```

---

### Input Mode: Foundation Only

**If user wants minimal interaction:**

```markdown
## Foundation Extraction

I'll read your game-ideator documents and generate expanded narrative specs
with minimal additional questions.

Reading:
- docs/design/world-bible.md
- docs/design/narrative-bible.md
- docs/design/design-pillars.md

I'll make reasonable assumptions based on these documents.
Any critical gaps will be flagged for your review in the output.
```

---

## Output Documents

This skill creates FOUR narrative specification documents in `docs/narrative/`:

### 1. story-arcs.md
Detailed breakdown of each act with:
- Scene-by-scene plot progression
- Player choice points and branches
- Emotional beats and pacing
- Transition triggers between acts

### 2. character-profiles.md
Deep profiles for all major characters:
- Companions (personality, history, arc, relationships)
- Antagonists (motivation, methods, connection to theme)
- Key NPCs (role in story, information they provide)
- Character voice samples

### 3. key-scenes.md
The pivotal moments that define the experience:
- Opening scene
- Major revelations
- Companion confrontations
- Choice culminations
- Ending variations

### 4. quest-hooks.md
Narrative seeds for quest designers:
- Main quest beats (what must happen)
- Side quest opportunities (optional stories)
- Companion quest outlines
- Faction quest frameworks

---

## Workflow

### Phase 0: Read Foundation Documents

**ALWAYS start by reading the foundation documents:**

```
Reading foundation documents...
- docs/design/world-bible.md
- docs/design/narrative-bible.md
- docs/design/design-pillars.md

Extracting key information:
- Setting: [summary]
- Theme: [core theme]
- Structure: [act count]
- Protagonist: [role]
- Companions: [list from narrative-bible]
- Tone: [tone guidelines]
```

**If documents don't exist, stop and tell the user to run game-ideator first.**

---

### Phase 1: Story Arc Expansion

After reading foundations, ask about story details:

```markdown
## Story Arc Details

I've read your foundation documents for [Game Title].

Let's expand the [X]-act structure into detailed story arcs.

**Act 1: [Name from narrative-bible]**

**1. Opening Scene**
How does the game begin? What's the first thing the player experiences?
- [ ] In medias res - mid-action, catching up later
- [ ] Cold open - quiet moment before the storm
- [ ] Tutorial framing - training/test that becomes real
- [ ] Flashback structure - start at end, explain how we got here

**2. Inciting Incident**
The narrative-bible mentions [inciting incident]. Let's detail it:
- What exactly happens?
- Who is involved?
- What does the player learn?
- What choice (if any) does the player make?

**3. Act 1 Companion Introductions**
When and how do companions join?
| Companion | When They Join | Circumstances | Player Choice? |
|-----------|---------------|---------------|----------------|
| [Name] | [Timing] | [How] | [Yes/No] |
```

**Wait for user response before proceeding.**

---

### Phase 2: Character Expansion

For each character type, gather details:

```markdown
## Character Profiles

Let's flesh out the major characters.

**The Protagonist: [Role from narrative-bible]**

**4. Protagonist Background Options**
What background elements can the player choose/discover?
- [ ] Origin story (where they came from)
- [ ] Defining past event (what shaped them)
- [ ] Hidden secret (revealed over time)
- [ ] All of the above

**5. Protagonist Voice**
How does the protagonist speak?
- [ ] Silent protagonist (player projects)
- [ ] Voiced with personality
- [ ] Choice of personality types
- [ ] Defined personality, player chooses actions

**Companions**
For each companion from the narrative-bible:

**[Companion 1 Name/Archetype]**
- **Full Name:**
- **Age/Background:**
- **Why They're Here:** (motivation to join)
- **Personal Conflict:** (what they struggle with)
- **Arc Resolution:** (how their story can end)
- **Relationship with PC:** (how it starts, how it can grow)
- **Loyalty Triggers:** (what strengthens/weakens bond)
```

**Wait for user response before proceeding.**

---

### Phase 3: Key Scenes Definition

Identify the pivotal moments:

```markdown
## Key Scenes

Every great RPG has moments players remember. Let's define yours.

**6. The "Holy Shit" Moments**
What revelations or twists occur?
- Act 1 Twist:
- Act 2 Twist:
- Act 3 Revelation:

**7. Companion Confrontation Scenes**
When does each companion have their crucial moment?
| Companion | Scene | Stakes | Possible Outcomes |
|-----------|-------|--------|-------------------|
| [Name] | [What happens] | [What's at risk] | [How it can go] |

**8. The Final Choice**
The design-pillars emphasize meaningful choices. What's the final, defining choice?
- What are the options?
- What does each represent thematically?
- What are the consequences of each?

**9. Ending Scenes**
For each ending from the narrative-bible, describe:
- The final scene
- What the player sees
- How it reflects their journey
```

**Wait for user response before proceeding.**

---

### Phase 4: Quest Hooks Generation

Create seeds for quest designers:

```markdown
## Quest Hooks

Let's define narrative seeds that quest designers will implement.

**10. Main Quest Beats**
What MUST happen in each act? (Non-optional story progression)

**Act 1 Required Beats:**
1. [Beat] - Player must [action]
2. [Beat] - Player learns [information]
3. [Beat] - Player chooses [decision]

**Act 2 Required Beats:**
[Same structure]

**Act 3 Required Beats:**
[Same structure]

**11. Side Quest Opportunities**
What optional stories could exist?
| Hook | Location | Theme Connection | Reward |
|------|----------|------------------|--------|
| [Name] | [Where] | [How it relates] | [What player gains] |

**12. Companion Quests**
Each companion should have a personal quest:
| Companion | Quest Hook | What's Resolved | Impact on Relationship |
|-----------|------------|-----------------|----------------------|
| [Name] | [Setup] | [Resolution] | [Bond change] |

**13. Faction Quests**
What quests arise from faction relationships?
| Faction | Quest Type | Moral Complexity | Cross-faction Impact |
|---------|------------|------------------|---------------------|
| [Name] | [Type] | [Grey area] | [How it affects others] |
```

**Wait for user response before proceeding.**

---

## Document Templates

### story-arcs.md Template

```markdown
# Story Arcs: [Game Title]

> **Purpose:** Detailed breakdown of narrative structure for quest designers.
> Reference this when creating main quest content.
>
> **Foundation:** Based on docs/design/narrative-bible.md
> **Last Updated:** [Date]
> **Version:** 1.0

---

## Narrative Overview

**Core Theme:** [From narrative-bible]
**Structure:** [X] Acts
**Protagonist:** [Role]
**Tone:** [Guidelines]

---

## Act 1: [Act Name]

### Purpose
[What this act accomplishes narratively]

### Opening Scene: [Scene Name]

**Setting:** [Where it takes place]
**Characters Present:** [Who's there]

**What Happens:**
1. [Beat 1]
2. [Beat 2]
3. [Beat 3]

**Player Agency:** [What choices exist]
**Emotional Goal:** [How player should feel]

**Transition to:** [Next scene]

---

### Scene 1.2: [Scene Name]

[Same structure]

---

### Act 1 Branching Points

| Decision | Option A | Option B | Long-term Impact |
|----------|----------|----------|------------------|
| [Choice] | [Path] | [Path] | [How it matters later] |

---

### Act 1 → Act 2 Transition

**Trigger:** [What causes act change]
**Player State:** [What player knows/has done]
**Emotional Beat:** [How player should feel entering Act 2]

---

## Act 2: [Act Name]

[Same structure as Act 1]

---

## Act 3: [Act Name]

[Same structure, plus ending details]

---

## Ending Branches

### How Endings Are Determined

| Factor | Weight | Measured By |
|--------|--------|-------------|
| [Factor] | [High/Medium/Low] | [How it's tracked] |

### Ending: [Name]

**Requirements:**
- [Condition 1]
- [Condition 2]

**Final Scene:**
[Description]

**Epilogue Elements:**
- [What happens to protagonist]
- [What happens to companions]
- [What happens to world]

[Repeat for each ending]

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | [Date] | Initial creation |
```

### character-profiles.md Template

```markdown
# Character Profiles: [Game Title]

> **Purpose:** Detailed character specifications for dialogue and quest designers.
> Reference this when writing character dialogue or creating character-focused content.
>
> **Foundation:** Based on docs/design/narrative-bible.md and world-bible.md
> **Last Updated:** [Date]
> **Version:** 1.0

---

## The Protagonist

### Identity
- **Role:** [From narrative-bible]
- **Starting State:** [Personality/situation at game start]
- **Background Options:** [If player can choose/influence]

### Voice & Personality
- **Speech Pattern:** [How they talk]
- **Personality Traits:** [Core characteristics]
- **Internal Conflict:** [What they struggle with]

### Character Arc
- **Start:** [Who they are at beginning]
- **Challenge:** [What forces them to change]
- **Possible Ends:** [Who they can become]

### Sample Lines
```
[Confident]: "I've seen worse odds. We move at dawn."
[Uncertain]: "I don't know if this is right... but it's what we have to do."
[Dark]: "Everyone has a price. I just found yours."
```

---

## Companions

### [Companion 1 Name]

#### Basic Info
- **Full Name:** [Name]
- **Role:** [Archetype from narrative-bible]
- **Age:** [Age]
- **Background:** [Origin and history]

#### Personality
- **Core Traits:** [3-5 defining traits]
- **Strengths:** [What they're good at]
- **Flaws:** [What holds them back]
- **Fear:** [What they're afraid of]
- **Desire:** [What they want most]

#### Voice
- **Speech Pattern:** [How they talk - formal/casual/accent]
- **Verbal Tics:** [Recurring phrases or patterns]
- **Topics They Discuss:** [What they talk about]
- **Topics They Avoid:** [What makes them uncomfortable]

#### Sample Lines
```
[Casual]: "[Example dialogue]"
[Serious]: "[Example dialogue]"
[Emotional]: "[Example dialogue]"
```

#### Arc
- **Starting State:** [Who they are when met]
- **Personal Conflict:** [What they struggle with]
- **Resolution Options:**
  - **Growth:** [Positive arc if player helps]
  - **Stagnation:** [Neutral if player ignores]
  - **Fall:** [Negative if player corrupts/fails]

#### Relationships
- **With Protagonist:** [How relationship starts and can evolve]
- **With Other Companions:** [Dynamics with each other companion]
- **With Factions:** [Past/present faction connections]

#### Loyalty System
- **Approval Triggers:** [What makes them like protagonist more]
- **Disapproval Triggers:** [What makes them like protagonist less]
- **Breaking Point:** [What would make them leave]
- **Deepening Point:** [What would cement their loyalty]

#### Personal Quest
- **Hook:** [What draws them into their quest]
- **Stakes:** [What they stand to gain/lose]
- **Resolution Options:** [How it can end]

---

### [Companion 2 Name]

[Same structure]

---

## Antagonists

### [Primary Antagonist Name]

#### Basic Info
- **Full Name:** [Name]
- **Role:** [Archetype from narrative-bible]
- **Position:** [Their place in the world]

#### Motivation
- **Goal:** [What they want]
- **Justification:** [Why they believe they're right]
- **Methods:** [How they pursue their goal]
- **Line They Won't Cross:** [If any - or note they have none]

#### Connection to Theme
- **Embodies:** [How they represent the theme]
- **Challenges:** [How they challenge player's values]
- **Mirror:** [How they reflect a possible path for protagonist]

#### Voice
- **Speech Pattern:** [How they talk]
- **Sample Lines:**
```
[Threatening]: "[Example]"
[Philosophical]: "[Example]"
[Vulnerable]: "[Example - if applicable]"
```

#### Arc
- **Introduction:** [How player first encounters them]
- **Escalation:** [How conflict intensifies]
- **Resolution Options:** [How confrontation can end]

---

## Key NPCs

### [NPC Name]

- **Role:** [What function they serve]
- **Location:** [Where they're found]
- **Information They Provide:** [What player learns from them]
- **Voice:** [Brief personality note]
- **Sample Line:** "[Example]"

[Repeat for significant NPCs]

---

## Character Relationship Web

```
                    PROTAGONIST
                    /    |    \
                   /     |     \
        [Companion 1]  [Companion 2]  [Companion 3]
              |            |              |
         [tension]    [respect]      [rivalry]
              |            |              |
        [Antagonist 1]     |        [Faction Leader]
              |            |
              └────────────┘
                 [conflict]
```

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | [Date] | Initial creation |
```

### key-scenes.md Template

```markdown
# Key Scenes: [Game Title]

> **Purpose:** The pivotal narrative moments that define the player experience.
> Quest and dialogue designers should build toward these scenes.
>
> **Foundation:** Based on story-arcs.md and character-profiles.md
> **Last Updated:** [Date]
> **Version:** 1.0

---

## Scene Classification

| Type | Description | Example |
|------|-------------|---------|
| **Story Beat** | Plot-critical moment | The assassination reveal |
| **Character Moment** | Companion-focused scene | Confronting a companion's past |
| **Choice Culmination** | Major decision point | Choosing sides in final battle |
| **Revelation** | Information that changes everything | Learning the truth about the war |
| **Emotional Peak** | Maximum emotional impact | Sacrifice or triumph |

---

## Act 1 Key Scenes

### Scene: [Opening - Scene Name]

**Type:** Story Beat
**Act:** 1 (Opening)
**Location:** [Where]

**Setup:**
[What leads to this scene]

**The Scene:**
[What happens, beat by beat]

**Player Agency:**
- [Choice 1]: [Consequence]
- [Choice 2]: [Consequence]
- [No choice - witness only]

**Emotional Goal:**
[How player should feel during/after]

**Connects To:**
- Sets up: [Future plot points]
- References: [World-bible elements]
- Character focus: [Who's highlighted]

---

### Scene: [Inciting Incident]

[Same structure]

---

## Act 2 Key Scenes

### Scene: [Major Revelation]

**Type:** Revelation
**Act:** 2 (Midpoint)
**Location:** [Where]

[Same structure, emphasis on what's revealed and impact]

---

### Scene: [Companion Confrontation - Name]

**Type:** Character Moment
**Act:** 2
**Location:** [Where]

**Setup:**
[What's led to this confrontation]

**The Confrontation:**
[The emotional exchange that occurs]

**Possible Outcomes:**
| Choice | Immediate Result | Long-term Impact |
|--------|------------------|------------------|
| [Support] | [What happens] | [Relationship/story impact] |
| [Challenge] | [What happens] | [Relationship/story impact] |
| [Abandon] | [What happens] | [Relationship/story impact] |

---

## Act 3 Key Scenes

### Scene: [The Final Choice]

**Type:** Choice Culmination
**Act:** 3 (Climax)
**Location:** [Where]

**Setup:**
[Everything that's led to this moment]

**The Choice:**
[What the player must decide]

**Options:**
| Choice | Theme Statement | Ending Path |
|--------|-----------------|-------------|
| [Option A] | [What it means] | [Which ending] |
| [Option B] | [What it means] | [Which ending] |
| [Option C] | [What it means] | [Which ending] |

**Why This Scene Matters:**
[Connection to design pillars and themes]

---

### Scene: [Ending - Name]

**Type:** Emotional Peak
**Act:** 3 (Resolution)
**Ending:** [Which ending this belongs to]

[Description of the ending scene]

---

## Companion-Specific Scenes

### [Companion Name] - Personal Quest Climax

**Type:** Character Moment
**Timing:** [When in the game]

[Scene details focused on this companion's arc resolution]

---

## Scene Pacing Map

```
ACT 1                    ACT 2                    ACT 3
─────                    ─────                    ─────
[Opening]                [Revelation]             [Final Choice]
    ↓                        ↓                        ↓
[Companion Meet]         [Betrayal]               [Confrontation]
    ↓                        ↓                        ↓
[Inciting Incident]      [Point of No Return]     [Ending Scene]
    ↓                        ↓
    └────────────────────────┘
         Rising tension
```

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | [Date] | Initial creation |
```

### quest-hooks.md Template

```markdown
# Quest Hooks: [Game Title]

> **Purpose:** Narrative seeds for quest designers to implement.
> Each hook provides the story context; quest designers add mechanical details.
>
> **Foundation:** Based on story-arcs.md and character-profiles.md
> **Last Updated:** [Date]
> **Version:** 1.0

---

## Main Quest Framework

### Critical Path

These quests MUST be completed to finish the game:

| Quest ID | Name | Act | Purpose | Leads To |
|----------|------|-----|---------|----------|
| MQ01 | [Name] | 1 | [Story purpose] | MQ02 |
| MQ02 | [Name] | 1 | [Story purpose] | MQ03 |
| ... | ... | ... | ... | ... |

---

### MQ01: [Quest Name]

**Act:** 1
**Story Purpose:** [What this advances narratively]

**Hook:**
[How the player gets this quest - what draws them in]

**The Situation:**
[What's happening, who's involved, what's at stake]

**Key Beats:**
1. [First thing player does/discovers]
2. [Second thing]
3. [Climax/decision point]
4. [Resolution]

**Player Choices:**
| Choice | Immediate Outcome | Ripple Effects |
|--------|-------------------|----------------|
| [Option A] | [Result] | [Later impact] |
| [Option B] | [Result] | [Later impact] |

**NPCs Involved:**
- [NPC]: [Role in quest]
- [NPC]: [Role in quest]

**Connects To:**
- Requires: [Prerequisites]
- Unlocks: [What becomes available]
- Affects: [What changes based on resolution]

---

### MQ02: [Quest Name]

[Same structure]

---

## Companion Quests

Each companion has a personal quest that deepens their arc.

### CQ01: [Companion Name] - [Quest Name]

**Companion:** [Name]
**Timing:** [When this becomes available]
**Trigger:** [What starts this quest]

**Hook:**
[What draws the companion into this personal matter]

**The Situation:**
[Their personal conflict made concrete]

**Key Beats:**
1. [Discovery/trigger]
2. [Investigation/journey]
3. [Confrontation with past]
4. [Resolution choice]

**Resolution Options:**
| Resolution | Impact on Companion | Impact on Relationship |
|------------|--------------------|-----------------------|
| [Help them grow] | [Arc outcome] | [Loyalty change] |
| [Enable their flaw] | [Arc outcome] | [Loyalty change] |
| [Ignore their need] | [Arc outcome] | [Loyalty change] |

**Theme Connection:**
[How this quest explores game themes]

---

## Side Quest Hooks

Optional quests that enrich the world and offer player choice.

### Category: [War Stories]

Quests that show the human cost of war.

#### SQ01: [Quest Name]

**Location:** [Where]
**Trigger:** [How discovered]
**Tone:** [Matches which tone from narrative-bible]

**Hook:**
[Brief setup - what draws player in]

**The Situation:**
[What's happening]

**Theme Connection:**
[How this explores game themes]

**Resolution Options:**
- [Option with trade-offs]
- [Option with different trade-offs]

**Rewards:**
- Narrative: [What player learns/experiences]
- Mechanical: [Suggested rewards - quest designer finalizes]

---

### Category: [Faction Entanglements]

Quests that deepen faction relationships.

#### SQ05: [Quest Name]

**Faction:** [Primary faction involved]
**Cross-faction Impact:** [How it affects standing with others]

[Same structure as above, emphasis on faction dynamics]

---

### Category: [Mysteries]

Quests that reveal world lore and secrets.

#### SQ10: [Quest Name]

**Mystery:** [What secret is uncovered]
**Connection to Main Plot:** [How it enriches understanding]

[Same structure]

---

## Quest Dependency Map

```
                         MQ01
                          ↓
                    ┌─────┴─────┐
                    ↓           ↓
                  MQ02        CQ01
                    ↓           ↓
              ┌─────┴─────┐     │
              ↓     ↓     ↓     │
            SQ01  MQ03  SQ02    │
                    ↓           │
                  MQ04 ←────────┘
                    ↓
                [ACT 2]
```

---

## Quest Design Guidelines

When implementing these hooks:

1. **Reference character-profiles.md** for NPC voices
2. **Check story-arcs.md** for timing and pacing
3. **Align with design-pillars.md** for meaningful choices
4. **Maintain tone from narrative-bible.md**

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | [Date] | Initial creation |
```

---

## Post-Generation Actions

After generating all four documents:

1. **Ensure docs/narrative/ directory exists**
2. **Save all documents**
3. **Offer next steps:**

```markdown
## Narrative Architecture Complete

I've created detailed narrative specifications:

- ✅ `docs/narrative/story-arcs.md` - Scene-by-scene plot structure
- ✅ `docs/narrative/character-profiles.md` - Deep character specifications
- ✅ `docs/narrative/key-scenes.md` - Pivotal moments defined
- ✅ `docs/narrative/quest-hooks.md` - Seeds for quest designers

### What These Documents Do

| Document | Used By | Creates |
|----------|---------|---------|
| story-arcs.md | quest-designer | data/quests/*.json |
| character-profiles.md | dialogue-designer, character-creator | data/dialogue/*.dtree, data/characters/**/*.char |
| key-scenes.md | quest-designer, encounter-designer | Pivotal quest moments, boss encounters |
| quest-hooks.md | quest-designer | Starting points for quest content |

### Recommended Next Steps

**Path A: Incremental Content Creation**
1. **Review the documents** - Ensure they capture your narrative vision
2. **Build the world** - Use world-builder to create the worldmap
3. **Create characters** - Use character-creator with character-profiles.md
4. **Write dialogues** - Use dialogue-designer with voice guidelines
5. **Create quests** - Use quest-designer with quest-hooks.md
6. **Design encounters** - Use encounter-designer for combat
7. **Tie together** - Use campaign-creator to create the campaign file

**Path B: Bulk Generation (for testing)**
1. **Review the documents** - Ensure they capture your narrative vision
2. **Use test-campaign-generator** - Create a spec for all content
3. **Use test-campaign-scaffolder** - Generate all files at once

Would you like me to:
- [ ] Review/edit any of these documents
- [ ] Start the incremental path (world-builder next)
- [ ] Start the bulk path (test-campaign-generator)
- [ ] Create a specific piece of content (character, quest, dialogue)
```

---

## Example Session Flow

```
User: "Use narrative-architect"

Skill: [Reads foundation documents]
       "I've read your foundation documents for Sellswords.
        Let me expand the narrative structure..."

       [Asks Phase 1 questions about story arcs]

User: [Answers about opening, inciting incident, etc.]

Skill: [Asks Phase 2 questions about characters]

User: [Provides companion details, antagonist specifics]

Skill: [Asks Phase 3 questions about key scenes]

User: [Defines pivotal moments]

Skill: [Asks Phase 4 questions about quest hooks]

User: [Approves quest seeds]

Skill: [Generates all four documents]
       "Narrative architecture complete. Here's what was created..."
```

---

## Skill Integration

### Documents This Skill Reads

| Document | What It Extracts |
|----------|------------------|
| world-bible.md | Setting, factions, geography, tone |
| narrative-bible.md | Theme, structure, archetypes, endings |
| design-pillars.md | Pillars for choice design, scope constraints |

### Documents This Skill Creates

| Document | Who Uses It |
|----------|-------------|
| story-arcs.md | quest-designer, test-campaign-generator |
| character-profiles.md | dialogue-designer, character-creator |
| key-scenes.md | quest-designer (for pacing) |
| quest-hooks.md | quest-designer (as starting points) |

---

## Example Invocations

- "Expand the narrative for my game"
- "Flesh out the characters and story"
- "Use narrative-architect"
- "Create detailed story arcs"
- "I need character profiles for my companions"
- **"Extract narrative from my D&D module"**
- **"I have Dragons of Icespire Peak - create character profiles"**
- **"Formalize my campaign notes into proper specs"**
- **"Translate my tabletop NPCs into character profiles"**

---

## Workflow Summary

1. **Read foundation documents** (world-bible, narrative-bible, design-pillars)
2. **Extract key narrative info** (theme, structure, archetypes)
3. **Ask Phase 1 questions** (story arc expansion)
4. **Wait for response**
5. **Ask Phase 2 questions** (character expansion)
6. **Wait for response**
7. **Ask Phase 3 questions** (key scenes)
8. **Wait for response**
9. **Ask Phase 4 questions** (quest hooks)
10. **Wait for response**
11. **Generate all four documents**
12. **Save to docs/narrative/**
13. **Offer next steps**

---

## Checklist Before Completing

- [ ] Asked for input mode (Q&A, D&D Content, Existing Notes, Foundation Only)
- [ ] Read all foundation documents
- [ ] Gathered information appropriate to chosen input mode
- [ ] Created `docs/narrative/story-arcs.md`
- [ ] Created `docs/narrative/character-profiles.md`
- [ ] Created `docs/narrative/key-scenes.md`
- [ ] Created `docs/narrative/quest-hooks.md`
- [ ] All documents reference foundation docs
- [ ] Offered next steps (incremental vs bulk path)
- [ ] For D&D imports: Properly translated tabletop content
