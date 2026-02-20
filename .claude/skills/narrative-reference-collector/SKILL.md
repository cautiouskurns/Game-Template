# Narrative Reference Collector

Analyze a target game's narrative design — story structure, dialogue style, lore delivery, worldbuilding patterns — and produce a narrative direction document that guides content creation and feature spec writing.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | design-lead (or orchestrator during Phase 0) |
| **Sprint Phase** | Phase 0 (after design bible, before/during GDD) |
| **Directory Scope** | `docs/narrative-direction.md` |
| **Downstream** | design-lead (feature specs), content-architect (data files) |

## How to Invoke This Skill

Users can trigger this skill by saying:
- `/narrative-reference-collector`
- "Collect narrative references for [game name]"
- "Set up the narrative direction"
- "I want to replicate [game name]'s storytelling style"

---

## Procedure

### Step 1: Identify the Target Game

Ask the user (or read from context) which game's narrative to reference. Gather:

1. **Game name** — the primary narrative reference
2. **Secondary references** (optional) — other games with similar narrative approaches
3. **What to prioritize** — e.g., "the environmental storytelling more than dialogue" or "the NPC characterization"
4. **Specific narrative moments** (optional) — scenes, dialogues, or lore entries the user particularly admires

### Step 2: Research the Narrative Design

#### 2a: Web Search for Narrative Analysis

Search for deep analysis of the game's storytelling:

```
WebSearch: "[game name] narrative design analysis"
WebSearch: "[game name] story structure breakdown"
WebSearch: "[game name] lore explained"
WebSearch: "[game name] dialogue writing style"
WebSearch: "[game name] environmental storytelling"
WebSearch: "[game name] worldbuilding design"
WebSearch: "[game name] writer interview GDC"
WebSearch: "[game name] quest design analysis"
```

Gather:
- **Writer/narrative designer name(s)** and their influences
- **Story structure** — linear, branching, fragmented, emergent
- **Lore delivery method** — how players discover the story
- **Dialogue philosophy** — verbose vs terse, voiced vs text, player agency
- **Critical consensus** — what reviewers/players praise about the narrative
- **Design talks** — any GDC talks or developer commentary on narrative choices

#### 2b: Analyze Wiki/Lore Sources

Search for fan wikis and lore compilations:

```
WebSearch: "[game name] wiki lore"
WebSearch: "[game name] item descriptions lore"
WebSearch: "[game name] NPC dialogue examples"
```

These reveal:
- How much lore exists (breadth and depth)
- How lore is organized (by location, character, timeline, item)
- The ratio of explicit vs implied storytelling

#### 2c: User-Provided References

If the user provides specific examples (screenshots of dialogue, item descriptions, lore text):
1. Read and analyze them
2. Note specific language patterns, sentence structure, vocabulary level
3. Identify the tone and voice

### Step 3: Analyze the Narrative Style

Document the following dimensions:

#### Story Structure

- **Narrative model:** Linear / branching / fragmented / emergent / cyclical
- **Act structure:** How the story is divided (3-act, chapters, no formal acts)
- **Central conflict:** What drives the plot
- **Player role:** Chosen one / ordinary person / blank slate / defined character
- **Player agency:** How much the player shapes the story (none / cosmetic / meaningful branches / fully emergent)
- **Pacing:** How narrative intensity ebbs and flows relative to gameplay
- **Resolution style:** Definitive ending / ambiguous / multiple endings / ongoing

#### Lore Delivery Methods

Rate each method's prominence in the reference game (primary / secondary / absent):

| Method | Prominence | How It's Used |
|--------|-----------|---------------|
| **Dialogue (NPCs)** | | Direct conversations with characters |
| **Item descriptions** | | Lore embedded in inventory items |
| **Environmental storytelling** | | Visual details, architecture, decay, placement |
| **Discoverable text** | | Books, notes, journals, inscriptions |
| **Cutscenes/cinematics** | | Non-interactive narrative sequences |
| **Audio logs/recordings** | | Found audio that tells backstory |
| **UI/menu lore** | | Bestiary, codex, lore database |
| **NPC ambient dialogue** | | Overheard conversations, barks |
| **Boss/enemy design** | | What enemies communicate through their appearance and behavior |
| **Music/audio cues** | | Musical storytelling, leitmotifs |
| **Level design** | | Progression through space tells a story |
| **Absent information** | | What's deliberately NOT explained |

#### Dialogue Style

- **Voice:** First person / third person / omniscient narrator
- **Vocabulary level:** Simple / moderate / literary / archaic
- **Sentence length:** Terse (1-5 words) / moderate (5-15) / flowing (15+)
- **Tone:** Serious / dry humor / playful / melancholic / stoic
- **Punctuation habits:** Ellipses, em-dashes, exclamations, periods only
- **Character differentiation:** How distinct voices are between characters
- **Player dialogue:** Silent protagonist / dialogue options / voiced protagonist
- **Subtext vs text:** How much is said directly vs implied

Provide **3-5 example lines** that capture the dialogue voice (from web research or user-provided):

```
Example 1: "[dialogue line]" — [character], [context]
Example 2: "[dialogue line]" — [character], [context]
Example 3: "[dialogue line]" — [character], [context]
```

#### Worldbuilding Patterns

- **World scope:** Small/contained vs vast/sprawling
- **History depth:** How far back the lore goes
- **Faction complexity:** Simple good/evil vs nuanced multi-faction
- **Mythology:** Does the world have creation myths, legends, prophecies?
- **Internal consistency:** How strictly the world follows its own rules
- **Mystery vs clarity:** How much is explained vs left ambiguous
- **Naming conventions:** What names sound like (phonetic patterns, cultural influences)

#### Emotional Design

- **Primary emotions targeted:** What the narrative tries to make players feel
- **Emotional arc:** How feelings change over the course of the game
- **Quiet moments:** How the game creates space for reflection
- **Gut punches:** How the game delivers emotional impact (twists, deaths, revelations)
- **Player attachment:** How the game makes players care about characters/world

### Step 4: Create Narrative Pattern Templates

Based on the analysis, create reusable templates that downstream skills can follow:

#### Item Description Template
```
[Item Name]
[1-2 sentences of functional description]
[1-2 sentences of lore/flavor that hints at larger world]
[Optional: cryptic final line that raises a question]
```

With an example from the reference game and a template for this project:
```
REFERENCE: "[actual item description from reference game]"
TEMPLATE FOR THIS PROJECT: "[adapted version showing the same patterns]"
```

#### NPC Dialogue Template
```
[Greeting — establishes character voice in first line]
[Information delivery — what the player needs to know]
[Personal touch — reveals character personality or situation]
[Optional: Hook — hints at something deeper, quest lead, or worldbuilding]
```

#### Lore Entry Template
```
[Title/Subject]
[Opening that grounds the reader in time/place]
[Core information with in-world perspective]
[Detail that connects to broader world or other lore entries]
[Closing that leaves room for mystery or further discovery]
```

#### Environmental Storytelling Checklist
```
For each room/area, consider:
- [ ] What happened here before the player arrived?
- [ ] What physical evidence of that history remains?
- [ ] What can the player infer without any text?
- [ ] Does any discoverable text in this area add a layer?
- [ ] Does this space connect to any known lore?
```

### Step 5: Generate Narrative Direction Document

Create `docs/narrative-direction.md` using this template:

```markdown
# Narrative Direction

## Reference Game
- **Primary:** [game name]
- **Writer(s):** [name(s)]
- **Secondary:** [other references, if any]
- **Target fidelity:** [exact replica / inspired by / loose interpretation]

## Narrative Style Summary
[2-3 sentence description of the overall narrative approach]

## Story Structure
- **Model:** [linear / branching / fragmented / emergent]
- **Player role:** [chosen one / ordinary person / blank slate / defined]
- **Player agency:** [none / cosmetic / meaningful / fully emergent]
- **Central tension:** [what drives the story forward]
- **Resolution style:** [definitive / ambiguous / multiple / ongoing]

## Lore Delivery Hierarchy

Ranked by priority for this project (based on reference game analysis):

1. **[Primary method]** — [how to use it, with example]
2. **[Secondary method]** — [how to use it, with example]
3. **[Tertiary method]** — [how to use it, with example]
4. **[Supporting method]** — [how to use it, with example]

Methods explicitly NOT used: [list any methods the reference avoids and why]

## Dialogue Voice Guide

### Overall Voice
- **Vocabulary:** [simple / moderate / literary / archaic]
- **Sentence length:** [terse / moderate / flowing]
- **Tone:** [serious / dry humor / playful / melancholic]
- **Subtext level:** [everything stated / moderate implication / heavily implied]

### Character Voice Differentiation
[How different characters should sound distinct from each other]

### Example Lines (Reference)
```
"[line 1]" — [character, context]
"[line 2]" — [character, context]
"[line 3]" — [character, context]
```

### Example Lines (Adapted for This Project)
```
"[line 1]" — [character, context]
"[line 2]" — [character, context]
"[line 3]" — [character, context]
```

### Dialogue Don'ts
- [Things to avoid based on what the reference game avoids]
- [Common tropes that would break the tone]

## Worldbuilding Guide

### Naming Conventions
- **Characters:** [phonetic pattern, cultural influence, examples]
- **Locations:** [naming pattern, examples]
- **Items/Artifacts:** [naming pattern, examples]
- **Factions/Groups:** [naming pattern, examples]

### History & Lore Depth
- **Timeline depth:** [how far back lore reaches]
- **Layers:** [what's common knowledge vs hidden vs lost]
- **Mystery budget:** [what percentage should remain unexplained]

### Internal Rules
- [Rule 1 the world follows consistently]
- [Rule 2]
- [Rule 3]

## Emotional Design Targets

### Primary Emotions
| Emotion | When | How |
|---------|------|-----|
| [e.g., Isolation] | [exploration] | [vast empty spaces, rare NPC contact] |
| [e.g., Wonder] | [discovery] | [hidden areas reward with lore and beauty] |
| [e.g., Dread] | [boss approach] | [environmental decay, ominous audio] |

### Pacing Guide
[How narrative intensity should ebb and flow — when to push, when to let the player breathe]

## Templates for Downstream Skills

### Item Description Pattern
```
[template based on analysis]
```

### NPC Dialogue Pattern
```
[template based on analysis]
```

### Lore Entry Pattern
```
[template based on analysis]
```

### Environmental Storytelling Checklist
- [ ] [checklist items based on analysis]

## Notes
[Additional observations, edge cases, things to watch for]
```

### Step 6: Present to User for Approval

Display a summary of:
1. The narrative structure analysis (model, lore delivery hierarchy, dialogue voice)
2. The emotional design targets
3. Key templates created for downstream skills
4. Example adapted lines showing how the style transfers to this project

Use AskUserQuestion:
- **APPROVE** — Accept the narrative direction, proceed
- **MODIFY** — Adjust tone, change lore delivery priorities, add references
- **ADD EXAMPLES** — User wants to provide more dialogue/lore examples before approving

---

## Integration with Downstream Agents

Once approved, the narrative direction feeds into feature specs and content creation:

### design-lead
- References `docs/narrative-direction.md` when writing feature specs that involve narrative elements
- Uses the Story Structure section to inform pacing and emotional targets in specs
- Includes narrative voice guidelines in specs that require text content

### content-architect
- Reads the Dialogue Voice Guide for vocabulary, tone, sentence length in any text data
- Uses naming conventions from Worldbuilding Guide for data file content
- Follows the Lore Delivery Hierarchy to know how narrative is embedded in gameplay data
- Uses the Item Description Pattern for all item/equipment/collectible text

## Integration with Feature Specs

Feature specs should reference the narrative direction:
- "NPC dialogue following `docs/narrative-direction.md` Dialogue Voice Guide"
- "Item descriptions using the Item Description Pattern from narrative direction"
- "Environmental storytelling per the checklist in narrative direction"
- "Lore delivery via [primary method] per narrative direction hierarchy"

---

## Quick Reference

```
# Collect narrative references for a game:
/narrative-reference-collector

# Output:
docs/narrative-direction.md  — full narrative guide with templates and voice examples
```
