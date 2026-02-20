---
name: roadmap-planner
description: Generate sprint-based implementation roadmaps with "Player can X" playable increments and per-agent breakdowns. Scales from prototype to production.
domain: project
type: planner
version: 1.0.0
trigger: user
allowed-tools:
  - Read
  - Write
  - Glob
---

# Roadmap Planner Skill

This skill reads a GDD and generates a **sprint-based implementation roadmap** organized around **playable increments**. Each sprint produces something the user can playtest, with work broken down per agent and structured through the Phase A/B/C/D flow.

The roadmap automatically scales based on the current lifecycle phase: fewer tighter sprints for prototypes, more expansive sprints for vertical slices and production.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | design-lead |
| **Sprint Phase** | Phase 0 (pre-sprint design pipeline) |
| **Directory Scope** | `docs/` |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

---

## When to Use This Skill

Invoke this skill when the user:
- Says "create roadmap" or "plan implementation"
- Wants to break down a GDD into sprints
- Says "what should I build first?"
- Wants to see how work maps across the agent team
- Asks for a prototype, vertical slice, or production roadmap

---

## Lifecycle Detection

**Before starting, read `docs/.workflow-state.json`** to determine the current lifecycle phase.

```json
{ "lifecycle_phase": "prototype" | "vertical_slice" | "production" }
```

If the file does not exist or the field is missing, ask the user. Default to `prototype` if unclear.

```
=== ROADMAP PLANNER ===
Lifecycle Phase: [PROTOTYPE / VERTICAL SLICE / PRODUCTION]
Sprint Range: [1-4 / 3-6 / 6-12+]
Focus: [Core loop testing / Polish + content expansion / Full game shipping]
===
```

---

## Phase-Specific Behavior Summary

| Aspect | Prototype | Vertical Slice | Production |
|--------|-----------|----------------|------------|
| **Sprint count** | 1-4 | 3-6 | 6-12+ |
| **Focus** | Test core loop, riskiest mechanic first | Polish, content expansion, quality bar | All systems, all content, shipping |
| **GDD input** | `docs/prototype-gdd.md` | `docs/vertical-slice-gdd.md` | `docs/production-gdd.md` |
| **Output file** | `docs/prototype-roadmap.md` | `docs/vertical-slice-roadmap.md` | `docs/production-roadmap.md` |
| **Lifecycle gate** | Go / Pivot / Kill | Go to production / Iterate / Cancel | Alpha / Beta / Release gates |
| **Sprint goal style** | "Player can [test mechanic]" | "Player can [experience polished X]" | "Player can [use complete system]" |

---

## Core Principle

**Sprints are organized into epics around player-facing goals, not systems.**

- Group related sprints into **epics** with a clear player-facing goal (e.g., "Core Movement & Combat")
- Each epic contains 2-4 sprints — enough to achieve the goal, small enough to review
- Build toward "Player can X" — a sentence the user can verify by playing
- Every sprint ends with a mandatory user review gate (Phase D)
- Every epic ends with an **Epic Review** where the user assesses goal achievement
- Within each sprint, follow visible-first ordering
- Agents work in parallel where possible, sequentially where dependencies require

### Epic Sizing by Lifecycle

| Lifecycle Phase | Epics | Sprints per Epic | Focus |
|----------------|-------|-----------------|-------|
| Prototype | 1-2 | 1-2 | Prove core loop works |
| Vertical Slice | 1-3 | 2-3 | Prove quality bar |
| Production | 2-5+ | 2-4 | Build the full game |

---

## Visible-First Ordering (Within Sprints)

```
1. Visual elements (sprites, scenes, UI)    <- See it first
2. Player interaction (input, feedback)     <- Feel it second
3. Core systems (logic, rules)              <- Make it work
4. Data structures (resources, configs)     <- Refine later
5. Polish (juice, effects)                  <- Last
```

**Ordering rules:**
1. Scenes before scripts — visual structure first, behavior second
2. Sprites before data — placeholder sprites immediately, stat Resources later
3. Hardcode before configure — hardcode values first, extract to data files later
4. Input before logic — player clicking/pressing first, game rules second
5. Feedback before polish — show something happened (even ugly), make it pretty later

---

## Agent Directory Ownership

| Agent | Directories | What They Deliver |
|-------|-------------|-------------------|
| **systems-dev** | `scripts/autoloads/`, `scripts/systems/`, `scripts/resources/` | Autoloads, managers, event buses, Resource classes |
| **gameplay-dev** | `scripts/entities/`, `scripts/components/`, `scenes/gameplay/`, `scenes/levels/` | Player controller, enemies, combat, physics, levels |
| **ui-dev** | `scripts/ui/`, `scenes/ui/`, `resources/themes/` | HUD, menus, popups, damage numbers, themes |
| **content-architect** | `data/` (all subdirectories) | Character data, encounters, items, world data |
| **asset-artist** | `assets/`, `music/`, `sfx/`, `voice/` | Sprites, tilesets, animations, music, SFX |
| **design-lead** | `docs/features/`, `docs/ideas/` | Feature specs, idea briefs |
| **qa-docs** | `docs/code-reviews/` | Code reviews, systems bible, changelog |

Follow directory ownership strictly when assigning tasks. When a deliverable spans multiple agents, split it into agent-scoped tasks.

---

## Sprint Structure: Phase A/B/C/D

Every sprint follows this four-phase flow:

```
Phase A: Spec & Foundation
|- design-lead writes/finalizes feature specs -> USER APPROVES
|- systems-dev implements autoloads, managers, Resource classes
|- asset-artist begins generating assets (parallel)

Phase B: Implementation
|- gameplay-dev implements entities, scenes, mechanics
|- ui-dev implements HUD, menus, screens
|- content-architect creates data files
|- asset-artist continues (parallel)

Phase C: QA & Documentation
|- qa-docs reviews all code, updates systems bible + architecture doc + changelog
|- developers fix critical issues from review
|- design-lead pipelines specs for NEXT sprint (parallel)

Phase D: User Review (ALL AGENTS PAUSED)
|- User playtests the build
|- User decides per feature: accept / request changes / reject
|- User reviews proposed scope for next sprint
|- Next sprint begins ONLY after user approval
```

### Dependency Flow

```
design-lead (specs) -> systems-dev (APIs, Resources) -> gameplay-dev / ui-dev / content-architect -> qa-docs -> USER
asset-artist runs in parallel throughout Phases A and B
```

---

## The 5-Part Task Format

```markdown
#### Task [Agent][Sprint].[Number]: [Clear Action Verb] [Specific Thing]
**What:** One sentence — visible/testable outcome.
**How:** 3-5 implementation steps.
**Acceptance:** 2-4 checkbox criteria.
**Files:** Files to create/modify (within agent's directories).
**Hardcoded Values:** Magic numbers to use now (extract later).
```

**Task size:** 1-3 hours each. Too large = split it. Too small = combine it.

**Detail by type:** Visual tasks focus on appearance/position. Interaction tasks focus on input/feedback. System tasks focus on rules/API surface. Data tasks focus on shape/fields/examples.

---

## Feature-to-Agent Mapping

| GDD Pattern | Agent | Directory |
|-------------|-------|-----------|
| "manager", "autoload", "bus", "state machine", "Resource class" | systems-dev | `scripts/autoloads/`, `scripts/systems/`, `scripts/resources/` |
| "player", "enemy", "entity", "combat", "physics", "level", "component" | gameplay-dev | `scripts/entities/`, `scenes/gameplay/`, `scenes/levels/` |
| "HUD", "menu", "panel", "bar", "button", "screen", "theme" | ui-dev | `scripts/ui/`, `scenes/ui/` |
| "enemy data", "item data", "encounter table", "quest", "dialogue" | content-architect | `data/` |
| "sprite", "tileset", "animation", "music", "sound effect" | asset-artist | `assets/`, `music/`, `sfx/` |
| "feature spec", "idea brief" | design-lead | `docs/features/`, `docs/ideas/` |
| "code review", "systems bible", "changelog" | qa-docs | `docs/code-reviews/` |

---

# PROTOTYPE ROADMAP

## Prototype Workflow

### Step 1: Read Prototype GDD

Find `docs/prototype-gdd.md`. Extract: critical questions (Section 2), core mechanics (Section 3), content scope (Section 4), prototype scope (Section 5), implementation phases (Section 6), success metrics (Section 7), risks (Section 8).

### Step 2: Identify Epics and Playable Increments

First, identify **epics** — player-facing goals that group related sprints. Then decompose each epic into sprint-level playable increments.

**Epic identification rules:**
- Each epic has a player-facing goal (e.g., "Core Movement & Combat")
- Prototype: 1-2 epics (often just one covering the core loop)
- Group sprints by related mechanics or player capabilities

**Sprint identification rules (within epics):**
- Each sprint produces something playable
- Early sprints test the riskiest mechanic first
- Later sprints integrate, add content, polish
- Final sprint answers the GDD's critical questions

### Step 3: Determine Sprint Count

| Scope | Epics | Sprints | Reasoning |
|-------|-------|---------|-----------|
| Single mechanic test | 1 | 1-2 | Build + polish |
| Core loop (2-3 mechanics) | 1 | 2-3 | One per mechanic + integration |
| Full prototype | 1-2 | 3-4 | Mechanics + content + polish |

Do not exceed 4 sprints for a prototype.

### Step 4: Per-Agent Breakdown

For each sprint ask: What autoloads/managers (systems-dev)? What entities/scenes (gameplay-dev)? What UI (ui-dev)? What data (content-architect)? What assets (asset-artist)?

### Prototype Lifecycle Gate

```
After all sprints:
- [ ] User plays full prototype build
- [ ] Critical questions scored 1-5 each
- [ ] Decision: GO (vertical slice) / PIVOT (revise + retest) / KILL (abandon)
```

**Save to:** `docs/prototype-roadmap.md`

---

# VERTICAL SLICE ROADMAP

## Vertical Slice Workflow

### Step 1: Read Vertical Slice GDD

Find `docs/vertical-slice-gdd.md`. Extract: prototype validation results, features being polished, new features, content expansion, quality bar definitions, technical requirements, development phases, success criteria.

### Step 2: Identify Epics and Playable Increments

Vertical slice epics focus on proving different quality dimensions:

Example epic structure:
- Epic 1: "Refined Core Experience" — sprints refactoring and stabilizing prototype
- Epic 2: "Content & Features" — sprints adding new features and expanded content
- Epic 3: "Polish & Feel" — sprints for art, audio, juice, VFX, balance

**Rules:**
- Early epics refactor and stabilize prototype codebase
- Middle epics add features and expand content
- Later epics focus on polish (art, audio, juice, VFX)
- Final sprint is balance + bug fixing
- Quality bar references guide every polish task

### Step 3: Determine Sprint Count

| Scope | Epics | Sprints | Reasoning |
|-------|-------|---------|-----------|
| Light polish | 1-2 | 3 | Refactor + expand + polish |
| Standard slice | 2-3 | 4-5 | Refactor + features + content + polish + balance |
| Deep slice | 2-3 | 5-6 | Multiple content passes + extensive polish |

### Step 4: Quality Bar Integration

For every polish task, reference the GDD's quality bar: name reference game, specify VFX/juice per interaction, list audio requirements, include performance targets as acceptance criteria.

### Vertical Slice Lifecycle Gate

```
After all sprints:
- [ ] User plays complete vertical slice
- [ ] Validation questions scored (quality, engagement, repeatability, vision)
- [ ] Quantitative targets assessed
- [ ] Decision: GO (production) / ITERATE (fix + retest) / CANCEL
```

**Save to:** `docs/vertical-slice-roadmap.md`

---

# PRODUCTION ROADMAP

## Production Workflow

### Step 1: Read Production GDD

Find `docs/production-gdd.md`. Extract: all game systems, progression/economy, content scope, player experience, narrative, art/audio direction, technical requirements, monetization, production plan, KPIs.

### Step 2: Identify Epics

Group features into player-facing goal clusters (epics). Production typically has 2-5+ epics:

Example epic structure:
- Epic 1: "Core Foundation" (sprints 1-2) — core systems and basic loop
- Epic 2: "Systems Completion" (sprints 3-4) — all major mechanics
- Epic 3: "Content Production" (sprints 5-6) — all content
- Epic 4: "Progression & Balance" (sprints 7-8) — full game progression
- Epic 5: "Polish & Ship" (sprints 9+) — polish, bug fixing, release

### Step 3: Create Feature Inventory

Extract ALL features into a flat list. For each assign:
- **Type:** Core System | Content | UI | Polish | Integration | Technical
- **Priority:** Critical | High | Medium | Low
- **Effort:** S (1-2 days) | M (3-5 days) | L (1-2 weeks) | XL (2+ weeks)
- **Dependencies:** What must exist first

### Step 4: Identify Playable Increments

```
Sprint 1-2:  Core Foundation — "Player can [play basic core loop]"
Sprint 3-4:  Systems Completion — "Player can [use all major mechanics]"
Sprint 5-6:  Content Production — "Player can [experience all content]"
Sprint 7-8:  Progression & Balance — "Player can [progress through full game]"
Sprint 9-10: Polish & Juice — "Player can [enjoy polished experience]"
Sprint 11+:  Testing & Ship — "Player can [play stable release build]"
```

**Rules:**
- Core systems before content that uses them
- Playable milestone at each sprint end
- Polish after functionality works
- Front-load uncertain/risky features
- Each sprint still produces something evaluable

### Step 5: Determine Sprint Count

| Scope | Epics | Sprints | Reasoning |
|-------|-------|---------|-----------|
| Small indie (1-3 months) | 2-3 | 6-8 | Foundation + systems + content + polish + ship |
| Medium indie (3-6 months) | 3-4 | 8-12 | More content passes, deeper polish |
| Large indie (6+ months) | 4-5+ | 12+ | Full content pipeline, extensive testing |

### Step 6: Enhanced Task Format

Production tasks add Type, Priority, Effort, Requirements, and Implementation Notes to the standard 5-part format.

### Step 7: Asset Schedule & Risk Register

**Asset Schedule:** table with category, count, sprint needed, assigned agent.
**Risk Register:** table with risk, impact, mitigation strategy, sprint affected.

### Production Lifecycle Gates

```
Alpha (systems complete):
- [ ] All gameplay systems functional
- [ ] All content placeholder-complete
- [ ] No critical bugs

Beta (content complete):
- [ ] All content final, all art/audio integrated
- [ ] Performance targets met

Release:
- [ ] Zero critical bugs, minimal minor
- [ ] Platform requirements met
```

**Save to:** `docs/production-roadmap.md`

---

# ROADMAP OUTPUT STRUCTURE (ALL PHASES)

```markdown
# [GAME TITLE] -- [Phase] Implementation Roadmap

**Based On:** [Phase] GDD v[X.Y] | **Lifecycle:** [Phase] | **Epics:** [N] | **Sprints:** [N]
**Target:** [Core question / quality proof / shipping goal] | **Created:** [Date]

---

## Quick Start
Critical path to first playable: Sprint 1 delivers "[Player can X]"
Key agents: [relevant agents]

---

## Epic 1: "[Player-Facing Goal]"

### Sprint 1: "Player can [ACTION]"

**Playable Increment:** [What user can do and test]
**Acceptance Criteria:**
- [ ] [Observable criterion 1]
- [ ] [Observable criterion 2]

#### Phase A: Spec & Foundation
**Feature Specs (design-lead):** [spec file list]
**Systems Work (systems-dev):** [tasks in 5-part format]
**Assets Work (asset-artist):** [tasks in 5-part format]

#### Phase B: Implementation
**Gameplay Work (gameplay-dev):** [tasks with dependencies noted]
**UI Work (ui-dev):** [tasks with dependencies noted]
**Content Work (content-architect):** [tasks]

#### Phase C: QA & Documentation
qa-docs reviews all sprint code, updates bible/architecture/changelog

#### Phase D: User Review
**Playtest checklist:** [acceptance criteria user verifies by playing]
**User decides:** per feature accept/changes/reject, next sprint scope approve/modify

---

### Sprint 2: "Player can [NEXT ACTION]"
[Same structure]

---

### Epic 1 Review
**Goal:** [What the epic set out to achieve]
**User decides:** proceed to next epic / iterate / pause

---

## Epic 2: "[Next Player-Facing Goal]"
[Same structure with sprints]

---

[Continue for all epics]

---

## Lifecycle Gate: [Phase-Specific]
[Gate criteria and decision framework]

---

## Risk Mitigation
Per risk: risk, mitigation (assigned to sprint + agent), fallback

## Content & Asset Checklist
Assets (asset-artist), Data (content-architect), Systems (systems-dev) — each with sprint assignment and file path
```

---

## Quality Checklist

**Epic Structure:**
- [ ] Sprints are grouped into epics with player-facing goals
- [ ] Each epic has 2-4 sprints (within lifecycle guidelines)
- [ ] Each epic ends with an Epic Review checkpoint

**Sprint Structure:**
- [ ] Each sprint has a "Player can X" playable increment
- [ ] Each sprint has Phase A/B/C/D breakdown
- [ ] Each sprint ends with user review gate
- [ ] Acceptance criteria are observable and testable

**Per-Agent Breakdown:**
- [ ] Work assigned by directory ownership
- [ ] Dependencies between agents marked explicitly
- [ ] systems-dev in Phase A; gameplay-dev, ui-dev, content-architect in Phase B

**Task Quality:**
- [ ] Tasks use 5-part format
- [ ] Tasks follow visible-first ordering
- [ ] File paths match agent directory ownership

**Phase-Specific:**
- Prototype: 1-4 sprints, riskiest mechanic in Sprint 1, Go/Pivot/Kill gate
- Vertical Slice: 3-6 sprints, quality bar refs in polish tasks, Go/Iterate/Cancel gate
- Production: 6-12+ sprints, full feature inventory, asset schedule, Alpha/Beta/Release gates

---

## Workflow Summary

1. Read `docs/.workflow-state.json` to detect lifecycle phase
2. Display phase header with sprint range and focus
3. Find and read the phase-appropriate GDD
4. Extract features, mechanics, content scope
5. **Group features into epics** (player-facing goals)
6. Identify playable increments ("Player can X" milestones) within each epic
7. Determine sprint count based on phase guidelines
8. Break each increment into per-agent work by directory ownership
9. Map dependencies between agents within each sprint
10. Write full roadmap with epics containing Phase A/B/C/D sprints
11. Add epic reviews, lifecycle gate, risks, asset checklist
12. Save to `docs/[phase]-roadmap.md`

## Integration with Other Skills

- **Reads From:** `gdd-generator` (input GDD for current phase)
- **Feeds Into:** `feature-spec-generator` (Sprint 1 features need specs before Phase A)
- **Works With:** `changelog-updater`, `systems-bible-updater`, `version-control-helper`, `code-reviewer`

---

## Key Principles

**DO:** Group sprints into epics with player-facing goals; organize around playable increments; per-agent work by directory ownership; Phase A/B/C/D every sprint; mandatory user review gates; epic reviews between epics; visible-first ordering; explicit dependencies; 5-part task format; riskiest mechanic early; scale sprints to phase.

**DO NOT:** Organize by system layer; create day-by-day solo schedules; skip review gates or epic reviews; assign work outside agent directories; create non-playable sprints; make tasks too large or too small; ignore dependencies; add tasks not in GDD; create epics with more than 4 sprints.

---

This skill transforms a GDD at any lifecycle phase into a sprint-based, agent-team roadmap where every sprint delivers a playable increment, work is distributed by directory ownership, and the user retains creative control through mandatory review gates.
