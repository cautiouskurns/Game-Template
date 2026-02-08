---
name: gdd-generator
description: Generate Game Design Documents that scale from prototype to production scope. Reads lifecycle phase to determine appropriate depth.
domain: design
type: generator
version: 1.0.0
trigger: user
allowed-tools:
  - Read
  - Write
---

# GDD Generator Skill

This skill generates Game Design Documents that **automatically scale** based on the current lifecycle phase. It reads `docs/.workflow-state.json` to determine whether the project is in prototype, vertical slice, or production — then adapts its questioning depth, document scope, and output structure accordingly.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | design-lead |
| **Sprint Phase** | Lifecycle start (any phase) |
| **Directory Scope** | `docs/*-gdd.md` |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

---

## When to Use This Skill

Invoke this skill when the user:
- Asks to "create a GDD", "write a design doc", or "document my game idea"
- Says "generate a GDD for [game concept]"
- Asks "expand prototype GDD to vertical slice" or "create production GDD"
- Needs to communicate game design to a team or stakeholders

---

## Lifecycle Detection

**Before starting, read `docs/.workflow-state.json`** to determine the current lifecycle phase.

```json
{ "lifecycle_phase": "prototype" | "vertical_slice" | "production" }
```

If the file does not exist or the field is missing, ask the user which phase they are in. Default to `prototype` if unclear.

**Display the detected phase prominently at the start of interaction:**

```
=== GDD GENERATOR ===
Lifecycle Phase: [PROTOTYPE / VERTICAL SLICE / PRODUCTION]
Scope: [Brief description of what this means for the GDD]
===
```

---

## Phase-Specific Behavior Summary

| Aspect | Prototype | Vertical Slice | Production |
|--------|-----------|----------------|------------|
| **Goal** | Test core questions | Prove final quality | Document complete game |
| **Scope** | Minimum viable features | Polished representative slice | All planned features |
| **Timeline** | Days to weeks | 2-4 weeks | Months to years |
| **Content** | Placeholder/minimal | Polished subset, final art | Complete content plan |
| **Polish** | No juice, basic feedback | Full juice, VFX, audio | Quality bar defined |
| **Monetization** | Not covered | Not covered | Fully documented |
| **Success metric** | "Does mechanic work?" | "Would I buy this?" | "Is this shippable?" |
| **Output file** | `docs/prototype-gdd.md` | `docs/vertical-slice-gdd.md` | `docs/production-gdd.md` |

---

## Core Principle

**Structured documentation enables focused development at every scale.** It forces the designer to articulate what they are testing/proving/building, separates core mechanics from scope creep, defines success criteria before building, and scales naturally as the project matures.

All three phases use an **interactive questioning workflow**: ask questions in phases, wait for user response before proceeding, then generate the full GDD from gathered answers.

**For Claude:** If any answer is vague, ask for specifics. Push back on scope creep. Suggest improvements to weak critical questions. Use examples from similar games to clarify. Match depth to phase.

---

# PROTOTYPE PHASE

## Prototype Questions

### Phase 1: Core Concept

```
**1. Game Concept** — In 1-2 sentences, what is your game?
**2. Elevator Pitch** — 30-second pitch combining genre, core mechanic, and hook.
**3. Design Pillars** — 2-4 core principles that define this game.
**4. Primary Influences** — 2-5 games that inspire this. For each, explain WHAT you're taking.
```

**Wait for user response.**

### Phase 2: Critical Testing Focus

```
**5. Critical Questions** — 3-5 questions this prototype must answer. Format: "Does [mechanic] feel [quality]?"
**6. Success vs Failure** — For each question, what does SUCCESS look like? FAILURE?
**7. Timeline** — Weekend / Week / Two weeks / Month / Other
```

**Wait for user response.**

### Phase 3: Core Mechanics

```
**8. Core Mechanic** — PRIMARY mechanic: how it works step-by-step, inputs, outputs, why interesting.
**9. Supporting Mechanics** — 2-4 supporting mechanics with interactions to core.
**10. Content Scope** — Counts for: abilities/weapons, enemy types, levels, win/lose conditions.
```

**Wait for user response.**

### Phase 4: Scope Definition

```
**11. What's IN** — Minimum features required to test critical questions.
**12. What's OUT** — Explicitly excluded features with WHY for each.
**13. Target Playtime** — Duration of a single playthrough.
```

**Wait for user response.**

### Phase 5: Implementation & Metrics

```
**14. Implementation Phases** — Break timeline into phases (goal, deliverables, test criteria each).
**15. Success Metrics** — Qualitative (playtester observations) + Quantitative (session length, completion rate).
**16. Known Risks** — For each: risk, mitigation, fallback.
```

**Wait for user response, then generate GDD.**

---

## Prototype GDD Template

```markdown
# [GAME TITLE] - Prototype Design Document

**Version:** [Version] - Prototype | **Goal:** [One sentence] | **Timeline:** [X] | **Date:** [Date]

## 1. CONCEPT
- Elevator Pitch, Design Pillars (2-3 sentences each), Primary Influences (what we take + how it applies)

## 2. WHAT WE'RE TESTING
- Critical Questions (numbered, with success/failure criteria per question)
- Decision Threshold: Score 1-5 per question. High = build full game, Medium = iterate, Low = pivot/kill.

## 3. CORE MECHANICS
- Core Mechanic: step-by-step, inputs, system response, interactions
- Supporting Mechanics: specifics and interactions with core

## 4. CONTENT SCOPE
- Content types with specific numbers and details per item

## 5. PROTOTYPE SCOPE
- What's IN (minimum viable) / What's OUT (excluded with rationale per item)

## 6. IMPLEMENTATION PHASES
- Per phase: name, timeline, goal, deliverables, test criteria

## 7. SUCCESS METRICS
- Playtester observations + quantitative targets

## 8. RISK MITIGATION
- Per risk: risk, mitigation, fallback

## 9. POST-PROTOTYPE DECISION TREE
- High score: next steps + timeline to v1.0
- Medium score: issues-to-solutions + iteration timeline
- Low score: exit criteria + pivot options
```

**Save to:** `docs/prototype-gdd.md`

### Prototype Guidelines

- Do not plan full game features; focus on testing core questions only
- Be ruthlessly specific: not "Good controls" but "WASD movement at 200 px/s"
- Define success measurably: not "Players like it" but "Players play 3+ runs in first session"
- Default to LESS. Every feature must answer a critical question. If it does not test core loop, it is OUT.

---

# VERTICAL SLICE PHASE

## Vertical Slice Questions

**First, read the existing prototype GDD** (default: `docs/prototype-gdd.md`).

### Phase 1: Prototype Validation

```
Reading prototype GDD... Found: [X] critical questions, [scope summary]

**1. Validation Results** — For each critical question: PASS / NEEDS ITERATION / FAIL with evidence.
**2. Key Learnings** — What did playtesting reveal? What changes needed?
```

**Wait for user response.**

### Phase 2: Vertical Slice Scope

```
**3. Target Experience Duration** — How long should the polished slice experience be?
**4. Content Expansion** — What expands from prototype? How much content? Any new features?
**5. Quality Bar Reference** — Visual reference game? Audio (music + SFX)? Juice level?
**6. Timeline** — How many weeks? Hours per week availability?
**7. What Is This Slice Proving?** — Core question + who needs convincing?
```

**Wait for user response.**

### Phase 3: Quality Bar Definition

```
**8. Visual Polish** — Replace placeholders? Art style? Reference game quality?
**9. Audio** — Music tracks needed? SFX coverage level?
**10. Game Feel (Juice)** — Screen shake? Particles? Damage numbers? UI animations?
**11. Performance Targets** — FPS target? Max entities on screen?
```

**Wait for user response.**

### Phase 4: Development & New Features

```
**12. Phase Breakdown** — Typical: Week 1 refactor/assets, Week 2 audio/juice, Week 3 balance/content, Week 4 bugfix/polish. Adjust to your timeline.
**13. New Features** — Features added beyond prototype? For each: why, priority, dependencies.
```

**Wait for user response.**

### Phase 5: Success Criteria

```
**14. Validation Questions** — Quality ("finished game?"), Engagement ("pay for more?"), Repeatability ("replay?"), Vision ("proves concept?"). Which matter most?
**15. Quantitative Targets** — Completion rate, retry rate, runs/session, satisfaction rating.
**16. Known Risks** — Art delays? Audio complexity? Performance concerns?
```

**Wait for user response, then generate GDD.**

---

## Vertical Slice GDD Template

```markdown
# [GAME TITLE] - Vertical Slice GDD

**Version:** [X.Y.Z] | **Based On:** Prototype GDD v[X] | **Goal:** [What slice proves]
**Timeline:** [Weeks] | **Target Completion:** [Date]

## EXECUTIVE SUMMARY
- Prototype Validation Summary: tested questions, results (PASS/ITERATE/FAIL), key learnings
- Vertical Slice Vision: what we are proving, slice scope (duration, content, quality bar)

## 1. WHAT'S IN THE VERTICAL SLICE
- Core Features (from prototype, being polished): per feature — status, enhancements, quality bar
- New Features (additions): per feature — why adding, scope, priority, dependencies, acceptance criteria
- Content Scope: table comparing prototype vs vertical slice volumes per content type

## 2. QUALITY BAR
- Visual Quality: art style, reference game, requirements per category (characters, enemies, UI, VFX)
- Audio Quality: music tracks, SFX categories, reference quality
- Game Feel (Juice): per-action polish requirements, interaction feel, UI polish

## 3. TECHNICAL REQUIREMENTS
- Performance Targets (FPS, load time, memory, build size)
- Code Quality (refactoring checklist, standards)

## 4. SCOPE BOUNDARIES
- What's IN (gameplay, polish, screens with specifics) / What's OUT (excluded with rationale)

## 5. DEVELOPMENT PHASES
- Per phase: name, timeline, goal, tasks, deliverable

## 6. SUCCESS CRITERIA
- Validation Questions (quality, engagement, repeatability, vision with specific criteria)
- Quantitative Targets (completion rate, retry rate, FPS, bug targets)

## 7. RISK ASSESSMENT
- Risks from Prototype (known issues + how slice addresses them)
- New Risks (risk, impact, mitigation, fallback per item)

## 8. POST-SLICE DECISION TREE
- Succeeds: next steps toward production / Needs Iteration: fix plan / Fails: pivot options

## 9. BUDGET & RESOURCES
- Time budget breakdown (programming, art, audio, design, polish hours)
- Asset production needs
```

**Save to:** `docs/vertical-slice-gdd.md`

### Vertical Slice Guidelines

- Narrow scope, deep polish — final game quality for everything included
- Build on prototype evidence — every decision references validation results
- Do not redesign validated mechanics, polish them
- Define quality bar precisely: name a reference game, specify exact requirements per interaction

---

# PRODUCTION PHASE

## Production Questions

**If a prototype or vertical slice GDD exists, read it first.**

### Phase 1: Vision & Scope

```
**1. Vision Statement** — What is this game and why does it exist? (1 paragraph)
**2. Target Audience** — Demographics, player motivations, comparable audiences.
**3. Unique Selling Points** — 3 things that make this game worth buying.
**4. Core Pillars** — 3-4 design pillars with in-game manifestation.
**5. Target Platforms & Release** — Platforms, release quarter, team size.
**6. Monetization Model** — Premium / F2P / Subscription? Revenue streams?
```

**Wait for user response.**

### Phase 2: Core Systems

```
**7. Core Loop** — Minute-to-minute, session-to-session, and long-term loops.
**8. Primary Mechanics** — Per mechanic: description, input, response, feedback, depth, example.
**9. All Game Systems** — Every major system with purpose, components, interactions, balance levers.
**10. System Interactions** — How systems connect, key interaction points.
```

**Wait for user response.**

### Phase 3: Content & Progression

```
**11. Total Content Scope** — Numbers for: levels, enemies, abilities, bosses, narrative, cinematics.
**12. Progression Design** — Levels, XP curve, rewards, skill tree, unlock sequence.
**13. Economy Design** — Currencies (earn rate, sinks, sources, caps). Resource flow.
**14. Player Experience** — FTUE, difficulty curve, session design, return hooks.
**15. Narrative & World** — Story, setting, factions, characters, narrative-gameplay integration.
**16. Art & Audio Direction** — Visual style, palette, UI, music, SFX, voice acting.
```

**Wait for user response.**

### Phase 4: Production & Business

```
**17. Technical Requirements** — Engine, platforms, performance, architecture, saves, pipeline.
**18. Development Phases** — Pre-prod, vertical slice, production, alpha, beta, release milestones.
**19. Team Structure** — Roles, responsibilities, headcount.
**20. Success Metrics (KPIs)** — Engagement, monetization, quality metrics with targets.
**21. Post-Launch Plan** — Update cadence, content drops, events, Year 1 roadmap.
**22. Risk Assessment** — Major risks with likelihood, impact, mitigation.
```

**Wait for user response, then generate GDD.**

---

## Production GDD Template

```markdown
# [GAME TITLE] - Game Design Document

**Version:** [X.Y.Z] | **Status:** [In Production / Pre-Production / Planning]
**Lead Designer:** [Name] | **Team Size:** [N] | **Platforms:** [X] | **Release:** [Q Year]

## EXECUTIVE SUMMARY
- Vision Statement, Elevator Pitch, Target Audience, USPs, Core Pillars

## 1. CORE GAMEPLAY
- Core Loop (minute/session/long-term breakdowns)
- Primary Mechanics (per mechanic: description, input, response, feedback, depth, example)
- Secondary Mechanics

## 2. GAME SYSTEMS
- Per system: purpose, components, player interactions, progression, balance levers, edge cases, visual design, technical requirements

## 3. PROGRESSION & ECONOMY
- Player Progression (level curve, skill tree, unlock sequence)
- Economy Design (currencies, resource flow, monetization integration)

## 4. CONTENT SCOPE
- Content Breakdown (total volumes), Production Plan (per type), Content Roadmap (month-by-month)

## 5. PLAYER EXPERIENCE
- FTUE (onboarding goals, tutorial flow, pacing)
- Difficulty Curve (philosophy, progression, options)
- Session Design (length, goals, stopping points, return hooks)

## 6. NARRATIVE & WORLD
- Story, world design, characters, narrative integration

## 7. ART & AUDIO DIRECTION
- Visual Style (direction, palette, UI) / Audio (music, SFX, voice acting)

## 8. TECHNICAL DESIGN
- Engine, platforms, performance, architecture, save system, tools/pipeline

## 9. MONETIZATION & LIVE OPS
- Monetization Model (revenue streams, IAPs, battle pass)
- Live Operations (updates, content drops, events, community)

## 10. PRODUCTION PLAN
- Development Phases with milestones, Team Structure, Risk Assessment

## 11. SUCCESS METRICS
- KPIs (engagement, monetization, quality), Post-Launch Support Plan

## APPENDICES
- Feature Specs, Balance Sheets, Narrative Bible, Art Bible, Technical Docs
```

**Save to:** `docs/production-gdd.md`

### Production Guidelines

- Cover ALL systems but prioritize detail on core systems; link external docs for deep dives
- Living document: update as design evolves, version control major changes, track rationale
- Write for the whole team (designers, programmers, artists) in clear, unambiguous language
- Include enough detail for implementation; define KPIs; document risks

---

# CROSS-PHASE REFERENCE

## Output File Naming

| Phase | Output File |
|-------|-------------|
| Prototype | `docs/prototype-gdd.md` |
| Vertical Slice | `docs/vertical-slice-gdd.md` |
| Production | `docs/production-gdd.md` |

## Quality Checklist

**All Phases:**
- [ ] Lifecycle phase detected and displayed at document start
- [ ] All Q&A phases completed with user responses
- [ ] Document follows correct phase-specific template
- [ ] All sections use specific numbers/details (not vague descriptions)
- [ ] Risks have both mitigation AND fallback plans
- [ ] Document saved to correct `docs/[phase]-gdd.md` path

**Prototype:** Every mechanic maps to a critical question; success criteria are observable behaviors; scope has clear IN/OUT with justifications; decision tree has numerical thresholds.

**Vertical Slice:** Based on validated prototype; quality bar defined with game references; content scope table comparing prototype vs slice; budget accounts for art/audio time.

**Production:** All game systems documented; complete content scope with production plan; progression and economy designed; monetization documented; KPIs defined; post-launch plan included.

## Workflow Summary

1. Read `docs/.workflow-state.json` to detect lifecycle phase
2. Display phase header so user knows which scope is active
3. Run phase-appropriate Q&A (prototype: 5 phases, vertical slice: 5 phases, production: 4 phases)
4. Wait for user response between each Q&A phase
5. Generate complete GDD following the phase-specific template
6. Save to `docs/[phase]-gdd.md`
7. Confirm file location and suggest next steps (roadmap planner)

## Integration with Other Skills

- **Feeds Into:** `roadmap-planner` (creates sprint-based roadmap from GDD), `feature-spec-generator` (detailed specs per feature)
- **Works With:** `design-bible-updater` (pillars feed into bible), `changelog-updater` (track GDD versions)

---

This skill transforms game ideas into structured, phase-appropriate design documents. The interactive workflow ensures the designer thinks critically about what they are building, why, and how to know if it works.
