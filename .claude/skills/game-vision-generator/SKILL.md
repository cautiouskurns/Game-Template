---
name: game-vision-generator
description: Generate a comprehensive Full Game Vision document capturing every mechanic, system, content layer, and feature across all lifecycle phases. Creates the master scope map that GDDs pull from.
domain: design
type: generator
version: 1.0.0
trigger: user
allowed-tools:
  - Read
  - Write
  - AskUserQuestion
---

# Game Vision Generator Skill

This skill creates a **Full Game Vision** document — a comprehensive, high-level blueprint of the complete game. It captures every mechanic, system, content layer, progression element, and polish target the game could have at its most fully realized.

The vision document serves as the **north star** for all lifecycle phases. Each phase-specific GDD (Prototype, Vertical Slice, Production) scopes down from this vision rather than inventing scope on the fly.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | design-lead (orchestrator acts as design-lead in Phase 0) |
| **Sprint Phase** | Phase 0, Step 0.4 — after Design Bible and Reference Collection, before GDD |
| **Directory Scope** | `docs/game-vision.md` |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

---

## When to Use This Skill

- Phase 0, Step 0.4 (invoked by the orchestrator)
- User says "create a game vision" or "plan the full game"
- User wants to see the complete scope before committing to a lifecycle phase
- Starting a new project where the full game should be mapped out before prototyping

---

## Core Philosophy

The Game Vision answers: **"What is this game when it's done?"**

It is NOT:
- A GDD (it doesn't specify implementation details or sprint-level scope)
- A roadmap (it doesn't sequence work into sprints)
- A design bible (it doesn't establish pillars or tone — it builds ON the bible)

It IS:
- A complete catalog of everything the game could contain
- A scope map showing what belongs in each lifecycle phase
- A reference document that prevents scope creep AND scope blindness
- A living document updated at each lifecycle gate

### Why Vision Before GDD?

Without a vision document, each GDD is created in isolation — the Prototype GDD invents prototype scope, and when it's time for Vertical Slice, you invent VS scope from scratch. This leads to:
- Mechanics introduced in VS that should have been tested in prototype
- Prototype features that don't serve the final game
- Scope surprises at every lifecycle gate

With a vision document, each GDD is a **scoping exercise** — you already know the full game, and you're choosing what to prove at each phase.

---

## Input Requirements

Before running this skill, the following should exist:
- `docs/ideas/game-concepts.md` (selected concept from Step 0.1)
- `docs/design-bible.md` (approved design pillars from Step 0.3)
- Optionally: `docs/art-direction.md`, `docs/audio-direction.md`, `docs/narrative-direction.md`

---

## Process

### Phase 1: Context Gathering

Read the existing design documents to understand the foundation:
1. Read `docs/design-bible.md` for pillars, vision, tone
2. Read `docs/ideas/game-concepts.md` for the selected concept
3. Read any reference collection docs that exist (art, audio, narrative)

Synthesize the key constraints:
- Design pillars (non-negotiable qualities)
- Core fantasy (the feeling the game delivers)
- What the game is NOT (boundaries from the bible)

### Phase 2: Interactive Visioning

Work through each section of the vision document with the user. For each section, present your initial ideas based on the design docs, then refine with the user.

**IMPORTANT:** This is a collaborative process. Don't just generate — propose and refine. Use AskUserQuestion for major branching decisions, and free-form Q&A for details.

#### Section 1: Game Identity

Ask/confirm:
- Elevator pitch (extend from concept)
- Target audience and play context (when/where/how long do people play?)
- Comparable games (what does the game sit next to?)
- Core emotional arc of a session

#### Section 2: Mechanics Catalog

This is the largest section. For each category, brainstorm with the user:

**Core Mechanics** (the fundamental loop):
- What does the player do every second?
- What creates tension?
- What creates release?

**Secondary Mechanics** (variety within the loop):
- What new elements appear over time?
- What changes the player's approach?
- What adds depth without complexity?

**Meta Mechanics** (between sessions):
- What carries over between runs/sessions?
- What gives the player goals beyond "play again"?
- What creates a sense of mastery?

**Social Mechanics** (optional):
- How do players compare? (leaderboards, replays)
- How do players share? (screenshots, challenges)
- Is there any multiplayer?

For each mechanic identified, capture:
- Name and brief description
- Target lifecycle phase (prototype / vertical slice / production)
- Priority (must-have / should-have / nice-to-have)
- Dependencies on other mechanics

#### Section 3: Content Vision

Ask/confirm:
- Environments/themes (how many? what variety?)
- Entities/characters (player variations, enemy types, NPCs)
- Collectibles/items (types, purposes, variety)
- Narrative elements if applicable (story, lore, dialogue)
- Audio layers (music themes, SFX categories, voice)

#### Section 4: Progression & Economy

Ask/confirm:
- Within-session progression (how does a single session escalate?)
- Between-session progression (unlocks, mastery, persistent upgrades)
- Economy (currencies, earn rates, costs)
- Difficulty model (how does the game get harder? adaptive? fixed?)

#### Section 5: Game Modes

Ask/confirm:
- Primary mode (the default experience)
- Secondary modes (variants, challenges, special rules)
- Time-limited content (daily challenges, events, seasons)

#### Section 6: Polish & Feel Targets

Ask/confirm:
- Visual effects targets (particles, screen shake, transitions)
- Animation quality targets (sprite animation, UI animation)
- Audio design targets (adaptive music, spatial audio, feedback layers)
- UI/UX quality bar (menu flow, accessibility, responsiveness)

#### Section 7: Platform & Distribution

Ask/confirm:
- Target platforms (desktop, mobile, web, console)
- Control schemes per platform
- Accessibility features (colorblind modes, input remapping, difficulty options)
- Monetization model (free, premium, with IAP, ad-supported)
- Release strategy (early access, full launch, post-launch updates)

### Phase 3: Scope Map

The most important deliverable. Create a table mapping every identified feature/mechanic to its target lifecycle phase:

```markdown
| Feature / Mechanic | Prototype | Vertical Slice | Production | Priority |
|-------------------|:---------:|:--------------:|:----------:|----------|
| [mechanic name]   | X         |                |            | Must-have |
| [mechanic name]   |           | X              |            | Should-have |
| [mechanic name]   |           |                | X          | Nice-to-have |
```

Rules for the scope map:
- **Prototype** features prove the core loop is fun (minimum viable fun)
- **Vertical Slice** features add polish, depth, and representative content
- **Production** features complete the content, add variety, and ship-ready quality
- Every mechanic gets exactly ONE primary phase (when it's first introduced)
- Dependencies must be in an earlier or same phase as the dependent mechanic

### Phase 4: Compile Document

Write the complete vision document to `docs/game-vision.md` using this template:

---

## Output Template

```markdown
# [Game Name] — Full Game Vision

**Version:** 1.0 | **Created:** [date] | **Design Bible:** docs/design-bible.md

---

## 1. Game Identity

**Elevator Pitch:** [1-2 sentences]

**Genre:** [genre/subgenre]
**Target Audience:** [who plays this and why]
**Session Structure:** [how long, how often, what context]
**Core Fantasy:** [the feeling the game delivers]

**Comparable Games:** [2-4 reference points with what aspect is similar]

**Core Emotional Arc:**
[Describe the emotional journey of a single session — e.g., "calm start → rising tension → flow state → crisis → triumph or death → immediate urge to retry"]

---

## 2. Mechanics Catalog

### Core Mechanics (The Loop)

| Mechanic | Description | Phase | Priority |
|----------|-------------|-------|----------|
| [name] | [what it does and why it matters] | [P/VS/Prod] | [Must/Should/Nice] |

### Secondary Mechanics (Variety)

| Mechanic | Description | Phase | Priority |
|----------|-------------|-------|----------|
| [name] | [what it does and why it matters] | [P/VS/Prod] | [Must/Should/Nice] |

### Meta Mechanics (Between Sessions)

| Mechanic | Description | Phase | Priority |
|----------|-------------|-------|----------|
| [name] | [what it does and why it matters] | [P/VS/Prod] | [Must/Should/Nice] |

### Social Mechanics

| Mechanic | Description | Phase | Priority |
|----------|-------------|-------|----------|
| [name] | [what it does and why it matters] | [P/VS/Prod] | [Must/Should/Nice] |

---

## 3. Content Vision

### Environments & Themes
[Describe all planned environments, visual themes, and how they vary]

### Entities & Characters
[Player variations, enemy types, NPCs, bosses — everything that lives in the game]

### Collectibles & Items
[Types, purposes, variety across the game]

### Narrative Elements
[Story, lore, dialogue — or "None (pure mechanics)" if applicable]

### Audio Layers
[Music themes per context, SFX categories, voice if applicable]

---

## 4. Progression & Economy

### Within-Session Progression
[How a single session escalates — difficulty, new elements, pacing]

### Between-Session Progression
[Unlocks, mastery systems, persistent state — or "None (pure skill)" if applicable]

### Economy
[Currencies, earn rates, costs — or "None" if no economy]

### Difficulty Model
[How the game gets harder — fixed curve, adaptive, player-chosen, etc.]

---

## 5. Game Modes

### Primary Mode
[The default experience — what you play when you launch the game]

### Secondary Modes
[Variants, challenges, special rules — or "None planned"]

### Time-Limited Content
[Daily challenges, events, seasons — or "None planned"]

---

## 6. Polish & Feel Targets

### Visual Effects
[Particles, screen shake, transitions, feedback effects]

### Animation
[Sprite animation quality, UI animation, cutscenes]

### Audio Design
[Adaptive music, spatial audio, layered SFX, feedback sounds]

### UI/UX Quality Bar
[Menu flow, responsiveness, accessibility, platform conventions]

---

## 7. Platform & Distribution

**Target Platforms:** [list]
**Control Schemes:** [per platform]
**Accessibility:** [colorblind, remapping, difficulty options, etc.]
**Monetization:** [model]
**Release Strategy:** [early access, full launch, post-launch plan]

---

## 8. Scope Map

| Feature / Mechanic | Prototype | Vertical Slice | Production | Priority | Dependencies |
|-------------------|:---------:|:--------------:|:----------:|----------|-------------|
| [each row maps a feature to its lifecycle phase] |

### Phase Summaries

**Prototype Scope:** [N] features — proves [what]
**Vertical Slice Scope:** [N] features — demonstrates [what]
**Production Scope:** [N] features — completes [what]

---

## 9. Open Questions

[List any unresolved design questions that will be answered during development]

---

## 10. Revision History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | [date] | Initial vision document |
```

---

## Updating the Vision

The Game Vision is a **living document**. It should be updated at each lifecycle gate:

- **After Prototype Gate (GO):** Update based on prototype learnings — what worked, what didn't, what to cut or add
- **After Vertical Slice Gate (GO):** Update based on VS learnings — refine production scope
- **During Production:** Update as features are completed or cut

When updating, add a revision history entry and adjust the Scope Map columns.

---

## Quality Checklist

Before presenting to user for approval:
- [ ] Every mechanic from brainstorming is captured in the catalog
- [ ] Every mechanic has a target lifecycle phase and priority
- [ ] Scope map has no dependency violations (dependent features in later phases)
- [ ] Prototype scope is minimal — only what's needed to prove the core loop
- [ ] Design bible pillars are reflected in the vision (no contradictions)
- [ ] Open questions are documented, not silently ignored

---

## Example Invocations

- "Create the full game vision"
- "Map out the complete game"
- "What should the finished game look like?"
- "Plan all features across lifecycle phases"
- `/game-vision-generator`
