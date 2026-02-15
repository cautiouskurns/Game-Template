---
name: feature-spec-generator
description: Generate detailed feature specifications with an optional idea refinement phase. Handles the full pipeline from vague idea to structured spec, using the project's feature spec template, GDD, and roadmap for context.
domain: project
type: generator
version: 2.0.0
allowed-tools:
  - Write
  - Read
  - Glob
---

# Feature Spec Generator Skill

This skill generates comprehensive feature specifications using the project's standardized template, with context from the prototype GDD and development roadmap. It now includes an **Idea Brief** phase for users who start with a rough or vague feature concept, refining it into structured form before producing the full specification.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | design-lead |
| **Sprint Phase** | Phase A (Spec) |
| **Directory Scope** | `docs/features/` |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

---

## When to Use This Skill

Invoke this skill when the user:
- Asks to "create a feature spec" or "generate a feature spec"
- Wants to document a new feature idea
- Says "write up [feature name]"
- Needs planning documentation for a game feature
- Asks to formalize a feature idea
- Has a vague idea: "I want some kind of progression system"
- Knows the problem but not the solution: "Combat feels flat"
- Wants to explore options before committing: "What could a shop system look like?"
- Says "flesh out this idea" or "help me design [feature]"
- Wants a brainstorming session for a specific feature area

---

## Two-Phase Structure

This skill operates in two phases. Users can enter at either phase depending on how well-defined their idea is.

```
Phase 1: Idea Brief (optional)        Phase 2: Full Specification (always)
+---------------------------------+    +---------------------------------+
| Vague idea or rough concept     |    | Structured feature concept      |
| Interactive Q&A refinement      | -> | Comprehensive spec document     |
| Problem/solution exploration    |    | Template-based, all sections    |
| Scope definition                |    | Technical implementation detail |
| Approach selection              |    | Acceptance criteria & testing   |
+---------------------------------+    +---------------------------------+
```

**Skip Phase 1 if:**
- The user already has a clear, well-defined feature concept
- The user provides specific details about what the feature does
- The user says "I know exactly what I want, just spec it out"

**Use Phase 1 if:**
- The idea is vague or exploratory
- The user says "I'm not sure what this should look like"
- The problem is clear but the solution is not
- The user wants to brainstorm approaches before committing

---

## How to Use This Skill

**IMPORTANT: Always announce at the start that you are using the Feature Spec Generator skill.**

Example: "I'm using the **Feature Spec Generator** skill to create a comprehensive feature specification for [feature-name]."

### Overall Workflow

1. **Announce skill invocation**: Explicitly state you are using the Feature Spec Generator skill
2. **Assess clarity**: Determine whether the user's idea needs Phase 1 refinement or can skip to Phase 2
3. **If vague**: Run Phase 1 (Idea Brief) to refine the concept
4. **Gather context documents**: Search for and read GDD, roadmap, design bible
5. **Read the template**: Load from `docs/design templates/feature-spec-template.md`
6. **Generate the spec**: Fill out ALL sections of the template with the Idea Brief embedded as section 1
7. **Save the file**: Write to `docs/features/[feature-name].md`
8. **Confirm completion**: Announce the spec has been generated, provide file location

---

## Phase 1: Idea Brief (Optional)

This phase takes rough, vague feature ideas and refines them through interactive Q&A into a structured concept. When included, the Idea Brief becomes the first section of the output document.

### Step 1.1: Understand the Problem (Required)

**Always start by understanding what problem they're trying to solve:**

```
I'll help you flesh out this feature idea! Let me understand what you're working with:

**1. The Problem**
What issue or gap are you trying to address?
- [ ] Something feels missing from the game
- [ ] An existing system isn't satisfying
- [ ] Players need a new capability
- [ ] Technical/design debt needs addressing
- [ ] Just exploring ideas

**2. Player Experience Goal**
How should players FEEL or what should they be able to DO?
(Example: "Feel powerful", "Make strategic choices", "Have something to spend resources on")

**3. Initial Idea (if any)**
Do you have a rough direction in mind, or are you starting from scratch?
```

**Wait for user response before proceeding.**

---

### Step 1.2: Gather Context (Research)

**After receiving Step 1.1 answers, gather project context:**

1. **Read the GDD** - Search for `**/*gdd*.md`, `**/*design-bible*.md`
2. **Check the Roadmap** - Search for `**/*roadmap*.md`
3. **Review existing systems** - Understand what's already built

**Then ask:**

```
Thanks! I've reviewed your game design documents. Let me ask a few more questions:

**4. Design Pillar Alignment**
Which of your design pillars should this feature support?
[List pillars from GDD if found]

**5. Existing Systems**
How might this interact with systems you already have?
- Combat system
- Progression/XP
- Inventory
- Economy
- [Other systems found in codebase]

**6. Reference Games**
Any games that do something similar to what you're imagining?
(This helps me understand the "feel" you're going for)
```

**Wait for user response before proceeding.**

---

### Step 1.3: Explore Solutions (Brainstorming)

**After gathering context, present 2-3 possible approaches:**

```
Based on what you've shared, here are some approaches we could take:

## Approach A: [Name]
**Core idea:** [Brief description]
**Pros:** [Benefits]
**Cons:** [Drawbacks]
**Scope:** Small/Medium/Large

## Approach B: [Name]
**Core idea:** [Brief description]
**Pros:** [Benefits]
**Cons:** [Drawbacks]
**Scope:** Small/Medium/Large

## Approach C: [Name] (Hybrid/Alternative)
**Core idea:** [Brief description]
**Pros:** [Benefits]
**Cons:** [Drawbacks]
**Scope:** Small/Medium/Large

**Which direction appeals to you?** Or would you like to combine elements?
```

**Wait for user response before proceeding.**

---

### Step 1.4: Define Scope & Boundaries

**After user picks a direction, clarify scope:**

```
Great choice! Let's nail down the boundaries:

**7. Must-Have Features**
What absolutely MUST be in the first version?
(List 3-5 core elements)

**8. Nice-to-Have Features**
What would be great to add if time permits?
(Polish, extra options, edge cases)

**9. Explicitly Out of Scope**
What should we consciously leave out?
(Prevents scope creep later)

**10. Open Questions**
What decisions can wait until implementation?
(Things that need more research or testing)
```

**Wait for user response before proceeding.**

After receiving scope answers, proceed to Phase 2 with the refined concept.

---

## Phase 2: Full Specification

### Step 2.1: Gather Context Documents

Search for and read the following for context:
- **Prototype GDD**: Look for GDD files (e.g., `*-prototype-gdd.md`, `game-design-document.md`) to understand overall game vision, core mechanics, and design pillars
- **Roadmap**: Look for roadmap files (e.g., `*-roadmap.md`, `development-roadmap.md`) to understand feature priorities, phases, and dependencies
- **Game Design Bible**: Look for design bible files if they exist for high-level design principles
- Use Glob to search: `**/*gdd*.md`, `**/*roadmap*.md`, `**/*design-bible*.md`

If Phase 1 was completed, these may already be read. Skip re-reading if so.

### Step 2.2: Read the Template

Load the template from `docs/design templates/feature-spec-template.md`

### Step 2.3: Generate the Spec

Fill out ALL sections of the template with thoughtful, specific content informed by the context documents. If Phase 1 was completed, include the Idea Brief as the first major section.

### Step 2.4: Save and Confirm

Write to `docs/features/[feature-name].md` using kebab-case naming. Confirm completion with file location.

---

## Output Document Structure

The output document follows this structure. When Phase 1 was used, Section 1 (Idea Brief) is populated. When Phase 1 was skipped, Section 1 is omitted or reduced to a brief problem statement.

```markdown
# [Feature Name]

**Status:** 🔴 Planned | 🟡 In Progress | 🟢 Implemented
**Priority:** 🔥 Critical | ⬆️ High | ➡️ Medium | ⬇️ Low
**Estimated Time:** X hours/days/weeks
**Dependencies:** [Other features needed first, or "None"]
**Assigned To:** [Your name / AI assistant / contractor]

---

## 1. Idea Brief

> This section captures the original problem exploration and design decisions
> that led to this specification. Skip to Section 2 if you just need the spec.

### Problem Statement

**The Problem:**
[1-2 sentences describing what issue this addresses]

**Why It Matters:**
[Why this problem is worth solving for the game]

**Current State:**
[How things work now / what's missing]

### Player Experience Goal

**Players should feel:**
[Emotional/experiential goals]

**Players should be able to:**
[Concrete capabilities they gain]

**Success looks like:**
[Observable outcomes when feature works well]

### Design Pillar Alignment

| Pillar | How This Feature Supports It |
|--------|------------------------------|
| [Pillar 1] | [Explanation] |
| [Pillar 2] | [Explanation] |

### Chosen Approach

**Direction:** [Chosen approach name]

**Core Concept:**
[2-3 paragraph description of how this feature works at a high level]

**Key Elements:**
1. [Element 1] - [Brief description]
2. [Element 2] - [Brief description]
3. [Element 3] - [Brief description]

**Player Flow:**
1. [Step 1 - What triggers/enters the feature]
2. [Step 2 - What the player does]
3. [Step 3 - What happens as a result]
4. [Step 4 - How they exit/continue]

### Scope Definition

**In Scope (Must-Have):**
- [ ] [Core feature 1]
- [ ] [Core feature 2]
- [ ] [Core feature 3]

**Nice-to-Have (Stretch):**
- [ ] [Polish item 1]
- [ ] [Extra feature 1]

**Explicitly Out of Scope:**
- [Thing we're NOT doing 1]
- [Thing we're NOT doing 2]

### Alternatives Considered

| Alternative | Why Not Chosen |
|-------------|----------------|
| [Alternative A] | [Reason] |
| [Alternative B] | [Reason] |

### Open Questions

These need resolution during implementation:
1. **[Question 1]** - [Context]
2. **[Question 2]** - [Context]

### Reference Games

| Game | What to Study |
|------|---------------|
| [Game 1] | [Specific mechanic or feel] |
| [Game 2] | [Specific mechanic or feel] |

---

## 2. Purpose

**Why does this feature exist?**
[1-2 sentences explaining the problem this solves]

**What does it enable?**
[What can players do that they couldn't before?]

**Success criteria:**
[How will you know this feature works?]

---

## 3. How It Works

### Overview
[2-3 paragraph explanation of the feature behavior]

### User Flow
```
1. Player does [X]
2. System responds with [Y]
3. Player sees [Z]
4. Result: [Outcome]
```

### Rules & Constraints
- [Rule 1]
- [Rule 2]
- [Rule 3]

### Edge Cases
- What happens if [unusual scenario]?
- What happens if [error condition]?

---

## 4. User Interaction

### Controls
- [Input method 1]: [Action]
- [Input method 2]: [Action]

### Visual Feedback
- [What player sees during interaction]
- [How system state is communicated]

### Audio Feedback (if applicable)
- [Sound effects]
- [Music changes]

---

## 4b. Asset & Narrative Requirements

> **Before writing this section**, check if these direction docs exist and reference them:
> - `docs/art-direction.md` — style anchors, palette, reference images
> - `docs/audio-direction.md` — music search anchors, SFX style, mood targets
> - `docs/narrative-direction.md` — dialogue templates, lore delivery patterns, voice/tone

### Visual Assets Needed
| Asset | Description | Style Reference | Fallback |
|-------|-------------|-----------------|----------|
| [Asset name] | [What it looks like] | [Reference from art-direction.md] | [ColorRect/placeholder] |

### Audio Assets Needed
| Asset | Description | Search Anchor | Fallback |
|-------|-------------|---------------|----------|
| [Music/SFX name] | [Mood, context] | [From audio-direction.md] | [Silence/placeholder] |

### Narrative Content Needed
| Content | Description | Template/Pattern | Source Doc |
|---------|-------------|------------------|-----------|
| [Dialogue, lore, UI text] | [Context and purpose] | [From narrative-direction.md] | [Which direction doc] |

---

## 5. Visual Design

### Layout
[Description of UI layout]

### Components
- [UI element 1]: [Purpose]
- [UI element 2]: [Purpose]

### Visual Style
- Colors: [Palette]
- Fonts: [Typography]
- Animations: [Movement/transitions]

### States
- **Default:** [Appearance]
- **Hover:** [Appearance]
- **Active:** [Appearance]
- **Disabled:** [Appearance]
- **Error:** [Appearance]

---

## 6. Technical Implementation

### Scene Structure
```
[Scene Name]
├── [Node 1]
│   └── [Child Node]
├── [Node 2]
└── [Node 3]
```

### Script Responsibilities
- **[ScriptName].gd:** [What it does]
- **[ScriptName].gd:** [What it does]

### Integration Points
- Connects to: [Other system]
- Emits signals: [Signal list]
- Listens for: [Signal list]
- Modifies: [Affected game state]

### Scene Instantiation Map
Where each new scene gets added to the game:
- **[scene_name.tscn]** → instantiated by: [parent scene or script that loads/instances it]
- **[ui_scene.tscn]** → added to: [existing scene, e.g., hud.tscn] at node path [path]
- **[level_scene.tscn]** → loaded by: [e.g., RoomManager.transition_to_room()]

> **Why this matters:** Every scene created must be referenced somewhere. Orphaned scenes (created but never instantiated) are a recurring integration bug. If a scene is dynamically loaded, specify which script calls `load()` or `preload()`. If it's a child of an existing scene, specify which `.tscn` file gets the new `instance=ExtResource()` entry.

### Spatial Dimensions
If this feature creates rooms, levels, UI panels, or any spatial content:
- Reference player sprite size: [e.g., 256x256]
- Reference viewport size: [e.g., 1920x1080]
- Room/area dimensions: [width x height, justified relative to player size]
- Key entity positions: [where spawns, triggers, etc. go relative to room bounds]

> **Why this matters:** Check `docs/known-patterns.md` Reference Dimensions section for the project's established scale. All spatial content must be proportional to the player sprite and viewport.

### Asset Fallbacks
For each visual/audio asset this feature needs:
- **[Asset name]**: Primary source: [Ludo MCP / Epidemic Sound / hand-drawn]. Fallback: [ColorRect with color X and size Y / procedural VFX / placeholder SFX]

> **Why this matters:** Asset generation tools may be unavailable. Every asset must have a concrete fallback so the feature is playable without real art.

### Configuration
- JSON data: [File location]
- Tunable constants: [Where defined]

---

## 7. Acceptance Criteria

Feature is complete when:

- [ ] [Specific testable criterion 1]
- [ ] [Specific testable criterion 2]
- [ ] [Specific testable criterion 3]
- [ ] [Specific testable criterion 4]
- [ ] [Specific testable criterion 5]

---

## 8. Testing Checklist

### Functional Tests
- [ ] [Test case 1]: [Expected behavior]
- [ ] [Test case 2]: [Expected behavior]
- [ ] [Test case 3]: [Expected behavior]

### Edge Case Tests
- [ ] [Edge case 1]: [Expected behavior]
- [ ] [Edge case 2]: [Expected behavior]

### Integration Tests
- [ ] Works with [Other Feature]
- [ ] Doesn't break [Existing Feature]

### Polish Tests
- [ ] Animations smooth
- [ ] Sounds play correctly
- [ ] Visual feedback clear
- [ ] Performance acceptable (60 FPS)

---

## 9. Implementation Notes

*(For AI assistant or future you)*

- [Important detail about approach]
- [Gotcha to watch out for]
- [Alternative approach considered but rejected because...]
```

---

## Phase 1 Questioning Guidelines

### Good Questions to Ask

- **Vague problems:** "What feels wrong or missing?" / "When do players get frustrated?"
- **Unclear scope:** "If you could only have ONE thing?" / "What's the simplest valuable version?"
- **Design alignment:** "How does this support [design pillar]?" / "Is this vertical slice or future?"
- **Technical clarity:** "How would this interact with [existing system]?" / "What triggers this?"

### Questions to Avoid

- Leading questions that assume a solution
- Yes/no questions that don't explore
- Technical implementation questions (save for Phase 2)
- Questions already answered in GDD/roadmap

---

## Quality Criteria

### Every Idea Brief Must Have:
1. **Clear Problem** - What issue this solves
2. **Player Goal** - How players benefit
3. **Pillar Alignment** - Connection to design vision
4. **Defined Scope** - Clear IN/OUT boundaries
5. **Integration Points** - How it connects to existing systems
6. **Open Questions** - What still needs deciding

### Every Spec Must Have:
1. **All template sections** completed with concrete details (no leftover placeholder brackets)
2. **Context alignment** with GDD and roadmap
3. **Godot-specific** terminology (nodes, scenes, signals)
4. **Realistic scope** for the project timeline
5. **Testable acceptance criteria** (5+ items)
6. **Clear integration points** with existing systems
7. **Scene Instantiation Map** — every new `.tscn` must specify where it gets instantiated
8. **Spatial Dimensions** (if applicable) — room/level sizes justified relative to Reference Dimensions in `docs/known-patterns.md`
9. **Asset Fallbacks** — every visual/audio asset must have a concrete placeholder fallback

### Red Flags to Avoid

- **Vague problems:** "Make the game better"
- **No player benefit:** Pure technical feature with no experience goal
- **Unbounded scope:** "Everything players could want"
- **Solution without problem:** Jumped to "what" without "why"
- **Missing context:** Spec written without reading GDD/roadmap

---

## Important Guidelines

1. **Use Context Documents**: Always read the prototype GDD and roadmap first to ensure alignment with the overall game vision, design pillars, and project roadmap
2. **Be Specific**: Replace ALL placeholder text with concrete details
3. **Match Project Context**: Reference existing systems in the codebase and ensure feature fits within the game's scope and architecture
4. **Align with Design Pillars**: Ensure the feature supports the game's core design pillars and mechanics as defined in the GDD
5. **Check Roadmap Dependencies**: Reference the roadmap to understand where this feature fits in the development timeline and what dependencies exist
6. **GDScript/Godot Focus**: Use Godot-specific terminology (nodes, scenes, signals, etc.)
7. **Prototyping Scope**: Keep estimates realistic for the project timeline
8. **Test-Driven**: Ensure acceptance criteria are clear and testable
9. **Phase 1 is optional**: If the user has a clear idea, skip straight to Phase 2
10. **Single output file**: The Idea Brief is section 1 of the spec, not a separate document

---

## Example Interactions

**With Phase 1 (vague idea):** User says "I want some kind of shop system." Skill runs Step 1.1 (problem/goal), reads GDD in Step 1.2 (context/pillars/systems), presents 3 approaches in Step 1.3, defines scope in Step 1.4, then generates full spec with Idea Brief as section 1.

**Skipping Phase 1 (clear idea):** User says "Create a feature spec for damage numbers -- floating numbers above enemies, color-coded by type, size scaled by amount." Skill announces invocation, gathers context documents, generates full spec directly with a brief problem statement in section 1.

---

## Output

Always save the generated feature spec to:
```
docs/features/[feature-name].md
```

Use kebab-case for the filename (e.g., `shop-system.md`, `damage-numbers.md`, `level-up-screen.md`). If a roadmap ID is known, prefix it (e.g., `1.1-weapon-rule-system.md`).

After generating, confirm the file location and ask if the user wants any sections expanded or modified.

---

## Workflow Summary

1. **Announce skill invocation**
2. **Assess idea clarity** -- does the user need Phase 1?
3. **If vague: Run Phase 1** (problem, context, approaches, scope) -- 4 interactive steps
4. **Gather context documents** (GDD, roadmap, design bible)
5. **Read the template** from `docs/design templates/feature-spec-template.md`
6. **Generate the full spec** with Idea Brief as section 1 (if Phase 1 was used)
7. **Save to** `docs/features/[feature-name].md`
8. **Confirm completion** and offer to expand or modify sections
