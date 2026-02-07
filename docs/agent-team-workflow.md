# Agent Team Workflow

A structured approach to AI-assisted game development using coordinated agent teams. This document defines agent roles, tool ownership, sprint structure, quality gates, and user control points.

---

## Starting a New Project

This workflow is deployed as a **GitHub template repository**. To start a new game project:

### Step 1: Create from Template

```bash
# Option A: Via GitHub CLI
gh repo create my-new-game --template YOUR_USERNAME/godot-agent-team-template --clone
cd my-new-game

# Option B: Via GitHub web UI
# Click "Use this template" on the template repo page, then clone
```

### Step 2: Open in Claude Code

```bash
claude
```

### Step 3: Run Bootstrap

```
/project-bootstrap
```

The bootstrap skill will:
1. Ask for your game's name, resolution, and 2D/3D preference
2. Verify all template files are present (agents, skills, workflow doc, CLAUDE.md)
3. Update `project.godot` and `CLAUDE.md` with your project name
4. Create the full directory structure per the ownership map
5. Remove template git history and initialize a fresh repo
6. Create the initial commit

### Step 4: Begin Phase 0

After bootstrap completes, start the design pipeline:
1. Run `game-concept-generator` (or bring your own concept)
2. Follow the Phase 0 pipeline through to Sprint 1 feature specs
3. Every step pauses for your approval

### What the Template Contains

```
template-repo/
├── .claude/
│   ├── agents/           ← 7 agent role definitions
│   ├── skills/           ← 46 game development skills
│   └── settings.local.json ← MCP permissions (Ludo, Epidemic Sound)
├── docs/
│   └── agent-team-workflow.md ← This document
├── CLAUDE.md             ← Project context (customized by bootstrap)
├── project.godot         ← Godot config (customized by bootstrap)
├── .gitignore
├── .gitattributes
└── .editorconfig
```

### Updating the Template

When you improve the workflow, agents, or skills during a project:
1. Copy the improved files back to the template repo
2. Commit and push to the template
3. Future projects get the improvements automatically

---

## Development Lifecycle

Development progresses through three phases, each ending with a **user go/no-go gate**. Nothing advances to the next phase without explicit user approval.

```
┌─────────────────────┐     GO/NO-GO      ┌──────────────────────┐     GO/NO-GO      ┌─────────────────────┐
│   PROTOTYPE PHASE   │ ──── GATE 1 ────→ │  VERTICAL SLICE PHASE │ ──── GATE 2 ────→ │  PRODUCTION PHASE   │
│   (Prove the idea)  │                    │  (Prove the quality)  │                    │  (Build the game)   │
└─────────────────────┘                    └──────────────────────┘                    └─────────────────────┘
    2-4 sprints                                4-8 sprints                                 8+ sprints
    Ugly but playable                          Polished slice                              Full content
```

### Prototype Phase
**Goal:** Answer the question "Is this fun?" with minimal investment.

| Step | Skill | User Approval Point |
|------|-------|-------------------|
| Concept exploration | `game-concept-generator` | User selects concept direction |
| Feasibility check | `concept-validator` | User reviews risks, decides to proceed |
| Creative vision | `design-bible-updater` | User approves pillars and tone |
| Design document | `prototype-gdd-generator` | User approves GDD before any coding |
| Roadmap | `roadmap-planner` | User approves sprint breakdown |
| Sprint 1..N | Implementation sprints | User reviews each sprint (see Sprint Review below) |

**Prototype deliverable:** A rough but playable build that tests the core loop.

**Gate 1: Prototype Go/No-Go**
User plays the prototype and decides:
- **GO** → Core loop is fun, proceed to vertical slice
- **PIVOT** → Core loop needs fundamental changes, revise GDD and re-prototype
- **KILL** → Concept doesn't work, return to concept generation

### Vertical Slice Phase
**Goal:** Answer the question "Can this be a good game?" by polishing one representative slice.

| Step | Skill | User Approval Point |
|------|-------|-------------------|
| Expand GDD | `vertical-slice-gdd-generator` | User approves expanded scope and quality targets |
| Expanded roadmap | `roadmap-planner` | User approves new sprint breakdown |
| Sprint 1..N | Implementation sprints with polish focus | User reviews each sprint |

**Vertical slice deliverable:** A polished, representative section of the game — final art, audio, UI, and gameplay quality for one complete experience.

**Gate 2: Vertical Slice Go/No-Go**
User plays the vertical slice and decides:
- **GO** → Quality bar is met, proceed to full production
- **ITERATE** → Slice needs more polish, continue refining
- **RESCOPE** → Game is good but too ambitious, reduce production scope
- **KILL** → Quality bar can't be met, stop development

### Production Phase
**Goal:** Build the full game to the quality bar established by the vertical slice.

| Step | Skill | User Approval Point |
|------|-------|-------------------|
| Full GDD | `production-gdd-generator` | User approves full game scope |
| Production roadmap | `roadmap-planner` | User approves phased rollout |
| Sprint 1..N | Full implementation sprints | User reviews each sprint |
| Content complete | All content skills | User approves content lock |
| Polish pass | VFX, audio, UI refinement | User approves quality bar |

---

## User Control Points

**You (the user) are the creative director.** Agents propose, you approve. Nothing ships without your sign-off. Here is every point where the workflow pauses for your input.

### Lifecycle Gates (highest level)

| Gate | When | What You Decide | Options |
|------|------|----------------|---------|
| Concept approval | After `game-concept-generator` | Which concept direction to pursue | Select, modify, or regenerate |
| Feasibility review | After `concept-validator` | Whether risks are acceptable | Proceed, adjust scope, or abandon |
| Design bible approval | After `design-bible-updater` | Whether pillars and tone are right | Approve, revise pillars, or restart |
| GDD approval | After GDD generator | Whether the design is what you want | Approve, request changes, or restart |
| Roadmap approval | After `roadmap-planner` | Whether the sprint breakdown makes sense | Approve, reorder, add/remove sprints |
| Prototype go/no-go | After prototype sprints complete | Whether to proceed to vertical slice | Go, pivot, or kill |
| Vertical slice go/no-go | After VS sprints complete | Whether to proceed to production | Go, iterate, rescope, or kill |

### Sprint Gates (per sprint)

| Gate | When | What You Decide | Options |
|------|------|----------------|---------|
| Spec approval | After design-lead writes feature specs | Whether each spec matches your vision | Approve, request changes, or reject |
| Implementation plan review | After `feature-implementer` generates a plan | Whether the approach is right | Approve or request different approach |
| Sprint review | After all sprint work + QA complete | Whether the sprint meets your expectations | Accept, request fixes, or reject features |
| Next sprint approval | After reviewing sprint + seeing next sprint's proposed specs | Whether to proceed as planned | Proceed, modify next sprint scope, or pause |

### Ad-Hoc Control (anytime)

You can intervene at any point during development to:
- **Redirect creative direction** → design-lead updates the design bible
- **Modify a feature spec** → design-lead revises before implementation continues
- **Kill a feature mid-sprint** → agents stop work on that feature
- **Add an unplanned feature** → design-lead creates an idea brief and spec
- **Request a playtest build** → agents pause to produce a testable build
- **Change art direction** → asset-artist establishes a new style reference
- **Reprioritize the roadmap** → reorder upcoming sprints

### How Control Points Work in Practice

When an agent reaches a control point, they **stop and present you with**:
1. A summary of what was produced
2. The key decisions or tradeoffs involved
3. Specific questions if any ambiguity exists
4. Clear options: approve, modify, or reject

**You respond with one of:**
- **Approve** → work continues to the next phase
- **Modify** → you provide specific feedback, agent revises
- **Reject** → agent discards and starts over with new direction from you
- **Discuss** → you want to talk through options before deciding

---

## Team Composition (7 Agents)

### design-lead
**Purpose:** Owns creative vision, design documentation, and feature specifications. The single source of truth for *why* we build things and *what* we build.

**Owned Directories:**
- `docs/design-bible.md`
- `docs/*-gdd.md`
- `docs/features/`
- `docs/ideas/`
- `docs/tools/` (tool specs and roadmaps)

**Skills:**
| Skill | When Used |
|-------|-----------|
| `design-bible-updater` | Establishing/updating design pillars, vision, creative direction |
| `prototype-gdd-generator` | Creating the initial Game Design Document through interactive Q&A |
| `vertical-slice-gdd-generator` | Expanding prototype GDD into vertical slice scope |
| `feature-idea-designer` | Refining vague feature ideas into structured Feature Idea Briefs via Q&A |
| `feature-spec-generator` | Writing detailed specs from idea briefs before each sprint's implementation |
| `concept-validator` | Stress-testing feasibility of game concepts and features |
| `game-concept-generator` | Initial ideation and concept exploration |
| `game-ideator` | Deep creative foundation and inspiration when exploring new directions |
| `narrative-architect` | Story and character foundations that inform content-architect's data files |
| `tool-spec-generator` | Writing specifications for development tools, editor plugins, utilities |
| `tool-roadmap-planner` | Breaking tool specs into phased implementation roadmaps |

**Feature Pipeline (design-lead owns the first 3 steps):**
```
Vague idea → feature-idea-designer → Idea Brief (docs/ideas/)
         → feature-spec-generator → Feature Spec (docs/features/)
         → developers implement using feature-implementer
```

**Tool Pipeline (design-lead specs, systems-dev implements):**
```
Tool need → tool-spec-generator → Tool Spec (docs/tools/)
        → tool-roadmap-planner → Tool Roadmap (docs/tools/)
        → systems-dev implements using tool-feature-implementer
```

**Never Touches:** Code files, scene files, asset files, data files.

---

### systems-dev
**Purpose:** Builds the foundational layer that all other developers depend on. Autoloads, managers, core services, and shared utilities. Starts first in each sprint to unblock others. Also implements development tools and editor plugins.

**Owned Directories:**
- `scripts/autoloads/`
- `scripts/systems/`
- `scripts/resources/` (custom Resource class definitions)
- `addons/` (editor plugins and development tools)

**Skills:**
| Skill | When Used |
|-------|-----------|
| `feature-implementer` | Implementing system-level features from specs in `docs/features/` |
| `tool-feature-implementer` | Implementing development tools from specs in `docs/tools/` |
| `error-debugger` | Diagnosing runtime bugs in autoloads and system scripts |
| `gdscript-refactor-executor` | Executing refactoring recommendations from qa-docs reviews |

**Implementation Workflow:**
1. Read the feature spec or tool roadmap from `docs/`
2. `feature-implementer` generates an implementation plan and requests confirmation
3. Creates all necessary scripts, resources, and configurations
4. Produces an implementation report

**Responsibilities:**
- Event bus / signal relay systems
- Game state management
- Save/load systems
- Resource loading and caching
- Input management
- Scene transition management
- Audio management (playback systems, not sourcing audio)
- Any singleton or manager pattern
- Editor plugins and development tools (via `tool-feature-implementer`)

**Never Touches:** Gameplay entity scripts, UI scripts, scene files (except tool-related), asset files, design docs.

---

### gameplay-dev
**Purpose:** Implements game mechanics, entities, physics interactions, and gameplay scenes. Works with Node2D/3D, CharacterBody, Area nodes.

**Owned Directories:**
- `scenes/gameplay/`
- `scripts/entities/`
- `scripts/components/`
- `scenes/levels/`

**Responsibilities:**
- Player controller and movement
- Enemy entities and AI
- Combat mechanics and hitboxes
- Physics interactions
- Gameplay scene composition
- Level/map scene assembly
- VFX integration (particles attached to gameplay entities)

**Skills:**
| Skill | When Used |
|-------|-----------|
| `feature-implementer` | Implementing gameplay features from specs in `docs/features/` |
| `scene-optimizer` | After building complex scenes, checking for structural/performance issues |
| `vfx-generator` | Creating procedural particle effects for gameplay entities |
| `error-debugger` | Diagnosing runtime bugs in gameplay entities and mechanics |
| `gdscript-refactor-executor` | Executing refactoring recommendations from qa-docs reviews |

**Implementation Workflow:**
1. Read the feature spec from `docs/features/`
2. `feature-implementer` reads GDD, design bible, and systems bible for context
3. Generates an implementation plan scoped to gameplay directories only
4. Creates scenes, entity scripts, and component scripts
5. Produces an implementation report

**Never Touches:** UI scenes/scripts, autoloads, asset generation, design docs, data files.

---

### ui-dev
**Purpose:** Builds all user-facing interface elements. Works exclusively with Control nodes and UI scenes.

**Owned Directories:**
- `scenes/ui/`
- `scripts/ui/`
- `resources/themes/`

**Skills:**
| Skill | When Used |
|-------|-----------|
| `feature-implementer` | Implementing UI features from specs in `docs/features/` |
| `scene-optimizer` | After building complex UI scenes, checking for layout/performance issues |
| `error-debugger` | Diagnosing runtime bugs in UI scripts and scenes |
| `gdscript-refactor-executor` | Executing refactoring recommendations from qa-docs reviews |

**Implementation Workflow:**
1. Read the feature spec from `docs/features/`
2. `feature-implementer` reads GDD, design bible, and systems bible for context
3. Generates an implementation plan scoped to UI directories only
4. Creates UI scenes, scripts, and theme resources
5. Produces an implementation report

**Responsibilities:**
- HUD (health bars, score, minimap, status indicators)
- Menus (main menu, pause, settings, inventory)
- Popups and dialogs
- Damage numbers and floating text
- Combat log / message feed
- Theme resources and UI styling
- Screen transitions and UI animations

**Never Touches:** Gameplay scenes, entity scripts, autoloads, asset generation, design docs.

---

### content-architect
**Purpose:** Creates all game content as structured data files. Characters, quests, dialogue, encounters, and world definitions. Owns the campaign-level view that ties content together.

**Owned Directories:**
- `data/characters/`
- `data/quests/`
- `data/dialogue/`
- `data/encounters/`
- `data/campaigns/`
- `data/world/`
- `data/items/`

**Skills:**
| Skill | When Used |
|-------|-----------|
| `character-creator` | Defining NPCs, companions, enemies as structured data |
| `world-builder` | Creating worldmap files with locations and connections |
| `dialogue-designer` | Writing dialogue trees for NPCs |
| `quest-designer` | Designing quest definitions with objectives and rewards |
| `encounter-designer` | Creating combat encounter configurations |
| `campaign-creator` | Tying all content together into playable campaigns |
| `lore-generator` | Creating world lore, history, and background narrative |

**Workflow Pattern:** Uses `campaign-creator` iteratively:
1. MINIMAL mode - create campaign skeleton early
2. UPDATE mode - add content as other data files are created
3. FINALIZE mode - validate all cross-references before milestone

**Never Touches:** Code files, scene files, UI, autoloads, design docs.

---

### asset-artist
**Purpose:** Generates all visual and audio assets using AI tools. Produces files that other agents reference by path.

**Owned Directories:**
- `assets/sprites/`
- `assets/tilesets/`
- `assets/animations/`
- `assets/ui/`
- `assets/backgrounds/`
- `assets/models/`
- `assets/vfx/`
- `music/`
- `sfx/`
- `voice/`

**MCP Tools:**

| Tool | Purpose | Provider |
|------|---------|----------|
| `mcp__ludo__createImage` | Generate sprites, icons, backgrounds, textures, UI assets | Ludo |
| `mcp__ludo__editImage` | Modify existing images (remove backgrounds, recolor, adjust) | Ludo |
| `mcp__ludo__generateWithStyle` | Generate new assets matching a reference image's style | Ludo |
| `mcp__ludo__animateSprite` | Create animated spritesheets from static sprites | Ludo |
| `mcp__ludo__create3DModel` | Generate 3D models if needed | Ludo |
| `mcp__ludo__generatePose` | Generate character poses | Ludo |
| `mcp__ludo__createSpeech` | Generate voice lines for characters | Ludo |
| `mcp__ludo__createVoice` | Create custom voices for characters | Ludo |
| `mcp__epidemic-sound__SearchRecordings` | Find music tracks by mood, genre, BPM | Epidemic Sound |
| `mcp__epidemic-sound__DownloadRecording` | Download selected music tracks | Epidemic Sound |
| `mcp__epidemic-sound__SearchSoundEffects` | Find sound effects by description | Epidemic Sound |
| `mcp__epidemic-sound__DownloadSoundEffect` | Download selected sound effects | Epidemic Sound |
| `mcp__epidemic-sound__EditRecording` | Edit/trim music recordings | Epidemic Sound |

**Style Consistency:** Uses `generateWithStyle` with a reference image to maintain visual coherence across all generated assets. A style reference should be established early and reused.

**Never Touches:** Code files, scene files, data files, design docs.

---

### qa-docs
**Purpose:** Quality gate and documentation. Reviews completed work, identifies issues, maintains living technical documentation. Always operates one sprint behind the implementation agents.

**Owned Directories:**
- `docs/code-reviews/`
- `docs/data-analysis/`
- `docs/systems-bible.md`
- `docs/architecture.md`
- `CHANGELOG.md`

**Skills:**
| Skill | When Used |
|-------|-----------|
| `gdscript-quality-checker` | After each feature is implemented — mandatory quality gate |
| `data-driven-refactor` | After 3+ features, identify hardcoded values to extract |
| `data-extractor` | Execute data extraction recommendations (with confirmation) |
| `systems-bible-updater` | After each sprint — document how systems work |
| `architecture-documenter` | After each sprint — update scene trees, signal maps, structure |
| `system-diagram-generator` | Generate Mermaid/ASCII diagrams of system interactions and architecture |
| `changelog-updater` | After each sprint — record what was added/changed/fixed |
| `version-control-helper` | When git workflow questions arise |

**Never Touches:** Writing new features, making design decisions, creating assets.

---

## Directory Ownership Map

```
project-root/
├── docs/
│   ├── design-bible.md              ← design-lead
│   ├── *-gdd.md                     ← design-lead
│   ├── features/                    ← design-lead
│   ├── ideas/                       ← design-lead
│   ├── tools/                       ← design-lead (specs + roadmaps)
│   ├── code-reviews/                ← qa-docs
│   ├── data-analysis/               ← qa-docs
│   ├── systems-bible.md             ← qa-docs
│   └── architecture.md              ← qa-docs
├── addons/                          ← systems-dev (editor plugins, dev tools)
├── scripts/
│   ├── autoloads/                   ← systems-dev
│   ├── systems/                     ← systems-dev
│   ├── resources/                   ← systems-dev
│   ├── entities/                    ← gameplay-dev
│   ├── components/                  ← gameplay-dev
│   └── ui/                          ← ui-dev
├── scenes/
│   ├── gameplay/                    ← gameplay-dev
│   ├── levels/                      ← gameplay-dev
│   └── ui/                          ← ui-dev
├── data/
│   ├── characters/                  ← content-architect
│   ├── quests/                      ← content-architect
│   ├── dialogue/                    ← content-architect
│   ├── encounters/                  ← content-architect
│   ├── campaigns/                   ← content-architect
│   ├── world/                       ← content-architect
│   └── items/                       ← content-architect
├── assets/
│   ├── sprites/                     ← asset-artist
│   ├── tilesets/                    ← asset-artist
│   ├── animations/                  ← asset-artist
│   ├── ui/                          ← asset-artist
│   ├── backgrounds/                 ← asset-artist
│   └── vfx/                         ← asset-artist
├── resources/
│   └── themes/                      ← ui-dev
├── music/                           ← asset-artist
├── sfx/                             ← asset-artist
├── voice/                           ← asset-artist
└── CHANGELOG.md                     ← qa-docs
```

---

## Sprint Structure

Each sprint delivers a **playable vertical slice increment** — a small but complete piece of the game that can be tested.

### Sprint Phases

```
Phase A: Spec & Foundation (systems-dev + design-lead)
├── design-lead writes feature specs for this sprint (feature-spec-generator)
├── USER APPROVES each feature spec before implementation begins
├── systems-dev reads specs, implements system-level features (feature-implementer)
├── systems-dev builds/extends autoloads and services needed
└── asset-artist begins generating assets for this sprint (parallel)

Phase B: Implementation (gameplay-dev + ui-dev + content-architect)
├── gameplay-dev reads specs, implements gameplay features (feature-implementer)
├── ui-dev reads specs, implements UI features (feature-implementer)
├── content-architect creates data files
└── asset-artist continues generating assets (parallel)

Phase C: QA & Documentation (qa-docs)
├── qa-docs reviews all code from this sprint (gdscript-quality-checker)
├── qa-docs updates systems bible, architecture, changelog
├── developers fix critical issues identified in review
└── design-lead pipelines: refines ideas and writes specs for NEXT sprint

Phase D: Sprint Review (USER — all agents paused)
├── USER receives: sprint summary, QA reports, implementation reports, changelog
├── USER playtests the build in Godot
├── USER decides for each feature: accept, request changes, or reject
├── USER reviews proposed specs for next sprint
├── USER approves, modifies, or reorders next sprint scope
└── Only after USER approval does the next sprint begin
```

**Phase D is mandatory.** Agents do not begin the next sprint until the user has reviewed and approved. This is the primary creative control mechanism.

### Sprint Review Format (Phase D)

At Phase D, the team lead compiles and presents a structured sprint summary. This is the standard format:

```markdown
# Sprint N Review: "[Deliverable Slice Name]"

## Completed Features
For each feature:
- **Feature name** — status: COMPLETE | PARTIAL | BLOCKED
- What was built (1-2 sentences)
- Files created/modified (list)
- Deviations from spec (if any, with justification)

## QA Summary
- Critical issues found: [count] — [list with severity]
- Performance warnings: [count]
- Code quality suggestions: [count]
- All critical issues resolved: YES/NO

## Assets Produced
- Sprites: [list with paths]
- Audio: [list with paths]
- Style consistency: maintained / new reference needed

## Content Produced
- Data files created: [list with paths]
- Campaign status: [skeleton/updated/validated]
- Cross-reference validation: PASS/FAIL

## Documentation Updated
- Systems bible: YES/NO (what sections)
- Architecture doc: YES/NO (what changed)
- Changelog: YES/NO

## Metrics
- Features planned: [N] | Completed: [N] | Carried over: [N]
- New issues discovered: [list]

## Next Sprint Preview
- Proposed deliverable: "[Player can Z]"
- Feature specs ready: [list in docs/features/]
- Key risks or dependencies: [list]

## Questions for User
- [Any decisions needed, ambiguities, or creative direction questions]
```

**How to use this:** The user reads the summary, playtests the build in Godot, then responds with:
- Per-feature decisions: accept / request changes (with specifics) / reject
- Next sprint: approve / modify scope / reorder
- Overall direction: continue / pause / pivot

### Feature Implementation Flow (per feature, per agent)

Every developer agent follows the same `feature-implementer` workflow:

```
1. Read feature spec from docs/features/
2. Read project context (GDD, design bible, systems bible)
3. Check for dependency systems (autoloads, signals)
4. Generate implementation plan → request confirmation
5. Implement within owned directories ONLY
6. Produce implementation report
```

This ensures consistent code structure and documentation across all three dev agents, even though they write to different directories.

### Sprint Timeline (within a single sprint)

```
                    Phase A      Phase B         Phase C      Phase D
design-lead:        ████████░░░░░░░░░░░░░░░░░░░░████████░░  (spec → next spec)
systems-dev:        ████████████░░░░░░░░░░░░░░░░░░░░░░░░░░  (foundation first)
asset-artist:       ████████████████████████████░░░░░░░░░░░  (continuous)
gameplay-dev:       ░░░░░░░░░░░░████████████████████░░░░░░░  (after systems)
ui-dev:             ░░░░░░░░░░░░████████████████████░░░░░░░  (after systems)
content-architect:  ░░░░░░████████████████████████░░░░░░░░░  (after specs ready)
qa-docs:            ████████████████████████████████████░░░░  (reviewing prev + current)
USER:               ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██████  (approve specs → sprint review)
                                                        ▲
                                                   ALL AGENTS PAUSE
                                                   User reviews + approves
```

### Sprint Dependencies

```
design-lead (feature specs)
    ↓
systems-dev (autoload APIs)
    ↓
┌───────────────────┬──────────────────┐
gameplay-dev        ui-dev             content-architect
(mechanics)         (interface)        (data files)
└───────────────────┴──────────────────┘
    ↓
qa-docs (review + documentation)
```

---

## Team Orchestration

### How Agents Are Spawned

Not all 7 agents run at all times. Spawn only the agents needed for the current phase to minimize coordination overhead and cost.

**Phase 0 (Pre-Sprint):** Single agent only
```
Spawn: design-lead
Purpose: Run the full design pipeline (concept → bible → GDD → roadmap → specs)
No team needed — this is sequential, interactive work with the user
```

**Phase A (Spec & Foundation):** 2-3 agents
```
Spawn: design-lead, systems-dev, asset-artist
- design-lead: writes/refines feature specs (if not done in Phase 0)
- systems-dev: implements foundation systems from approved specs
- asset-artist: begins generating assets based on spec requirements
```

**Phase B (Implementation):** 4-5 agents
```
Spawn: gameplay-dev, ui-dev, content-architect, asset-artist
Keep running: (systems-dev only if still needed)
- gameplay-dev: implements gameplay features
- ui-dev: implements UI features
- content-architect: creates data files
- asset-artist: continues generating assets
```

**Phase C (QA & Documentation):** 2-3 agents
```
Spawn: qa-docs
Keep running: developers (to fix critical issues from review)
- qa-docs: runs quality checks, updates documentation
- developers: fix any critical issues flagged by qa-docs
- design-lead: pipelines specs for next sprint (can run in parallel)
```

**Phase D (Sprint Review):** No agents — user only
```
All agents paused
User reviews sprint summary, playtests, makes decisions
```

### Spawning Commands

To create the team and spawn agents for a sprint:

```
# Create the team (once per project)
TeamCreate: team_name="sprint-1", description="Sprint 1: Player can move through a world"

# Phase A — spawn foundation agents
Task: name="design-lead", subagent_type="general-purpose", team_name="sprint-1"
Task: name="systems-dev", subagent_type="general-purpose", team_name="sprint-1"
Task: name="asset-artist", subagent_type="general-purpose", team_name="sprint-1"

# Phase B — spawn implementation agents (after systems-dev signals completion)
Task: name="gameplay-dev", subagent_type="general-purpose", team_name="sprint-1"
Task: name="ui-dev", subagent_type="general-purpose", team_name="sprint-1"
Task: name="content-architect", subagent_type="general-purpose", team_name="sprint-1"

# Phase C — spawn QA (after implementation completes)
Task: name="qa-docs", subagent_type="general-purpose", team_name="sprint-1"
```

Each agent's prompt should reference its agent definition file:
```
"You are the systems-dev agent. Read .claude/agents/systems-dev.md for your full role definition,
then read CLAUDE.md and docs/agent-team-workflow.md for project context.
Your task for this sprint is: [specific task from sprint plan]"
```

### Task Assignment Pattern

Use TaskCreate to define sprint work, then assign to agents:

```
TaskCreate: "Implement EventBus autoload" → assign to systems-dev
TaskCreate: "Implement PlayerController" → assign to gameplay-dev
TaskCreate: "Build HUD health bar" → assign to ui-dev
TaskCreate: "Create goblin enemy data" → assign to content-architect
TaskCreate: "Generate player walk spritesheet" → assign to asset-artist
TaskCreate: "Review Sprint 1 code" → assign to qa-docs (Phase C)
```

Tasks should include:
- Which feature spec to read (`docs/features/[name].md`)
- Which sprint phase this belongs to (A, B, or C)
- Dependencies on other tasks (e.g., "blocked by EventBus implementation")

### Phase Transitions

The team lead (you or the coordinator agent) manages phase transitions:

1. **A → B:** When systems-dev messages "foundation APIs ready" and user has approved all specs
2. **B → C:** When all Phase B tasks are marked complete
3. **C → D:** When qa-docs finishes reviews and developers fix critical issues
4. **D → next sprint A:** When user approves the sprint review

Between sprints, shut down the current team and create a fresh one:
```
SendMessage: type="shutdown_request" to each agent
TeamDelete
TeamCreate: team_name="sprint-2", description="Sprint 2: ..."
```

---

## Quality Gates

### Mandatory Checkpoints

**User approval gates (workflow pauses for user):**

| When | What | Who | Blocks |
|------|------|-----|--------|
| Phase 0 | Each design document (bible, GDD, roadmap) | USER | Entire project |
| Before any coding | Feature spec reviewed and approved | USER | All implementation of that feature |
| Before implementation begins | `feature-implementer` plan reviewed | USER | That feature's code |
| End of each sprint (Phase D) | Sprint review: playtest, accept/reject | USER | Next sprint |
| End of prototype phase | Go/no-go: proceed to vertical slice? | USER | Vertical slice phase |
| End of vertical slice phase | Go/no-go: proceed to production? | USER | Production phase |

**Agent quality gates (automated, no user pause):**

| When | What | Who | Blocks |
|------|------|-----|--------|
| After systems-dev finishes | Autoload APIs are defined and documented | systems-dev | gameplay-dev, ui-dev |
| After each feature implemented | `gdscript-quality-checker` review | qa-docs | Next sprint |
| After 3+ features accumulated | `data-driven-refactor` analysis | qa-docs | Nothing (advisory) |
| End of each sprint | `changelog-updater` run | qa-docs | Nothing (record-keeping) |
| End of each sprint | `systems-bible-updater` run | qa-docs | Nothing (documentation) |
| Before milestones | `architecture-documenter` run | qa-docs | Nothing (documentation) |
| When design questions arise mid-sprint | Check design bible pillars | design-lead | Disputed decision |

### Code Review Standards

qa-docs runs `gdscript-quality-checker` with focus on:
1. **Critical issues** — must fix before next sprint
2. **Performance warnings** — fix if in hot path
3. **Code quality suggestions** — address in refactoring sprints
4. **Duplication analysis** — extract when pattern repeats 3+ times

---

## Error Recovery

Things will go wrong. Here's how to handle each failure mode.

### Feature Fails QA Review

```
qa-docs finds critical issues
    ↓
qa-docs writes review to docs/code-reviews/[feature]_review.md
    ↓
qa-docs sends review summary to the implementing agent (direct message)
    ↓
implementing agent reads review, fixes critical issues ONLY
    ↓
implementing agent messages qa-docs: "fixes applied, ready for re-review"
    ↓
qa-docs re-runs gdscript-quality-checker on modified files
    ↓
If PASS → feature proceeds to sprint review
If FAIL again → escalate to user in sprint review with both the issue and attempted fix
```

**Rule:** Only critical issues block. Performance warnings and suggestions are logged but don't block the sprint. They accumulate and get addressed in dedicated refactoring sprints.

### Feature Doesn't Match Spec

```
qa-docs or user notices implementation deviates from spec
    ↓
Severity check:
    ├── MINOR (naming, structure differences) → log it, fix in next sprint
    ├── MODERATE (missing acceptance criteria) → implementing agent fixes in Phase C
    └── MAJOR (wrong behavior, wrong approach) → see below
```

**Major spec deviation recovery:**
1. Implementing agent stops work on the feature
2. Agent messages design-lead: "Implementation X doesn't match spec because [reason]"
3. Two possible outcomes:
   - **Spec was wrong/unclear** → design-lead revises the spec, user approves revision, agent re-implements
   - **Implementation was wrong** → agent reverts their changes and re-implements from the spec
4. If the fix can't happen within the current sprint, the feature is **carried over** to the next sprint and flagged in the sprint review

### Agent Writes Outside Owned Directories

```
Agent accidentally creates/modifies files outside its owned directories
    ↓
qa-docs flags the boundary violation in review
    ↓
Offending files are moved or deleted
    ↓
Correct agent recreates them in the right location
    ↓
If a pattern emerges, review whether directory ownership needs updating
```

**Prevention:** Each agent definition in `.claude/agents/` explicitly lists owned directories and "Never Touches" boundaries. The `feature-implementer` skill also scopes its plan to the agent's directories.

### Autoload API Changes Mid-Sprint

```
systems-dev needs to change an autoload API that gameplay-dev or ui-dev already depends on
    ↓
systems-dev DOES NOT change the API silently
    ↓
systems-dev messages affected agents: "Need to change [signal/method] because [reason]"
    ↓
Options:
    ├── Add new API alongside old (non-breaking) → preferred
    ├── Coordinate simultaneous change → both agents update in same Phase C
    └── Defer to next sprint → if change is large
```

**Rule:** Autoload APIs are contracts. Breaking changes require coordination, not silent updates.

### Asset Generation Doesn't Match Vision

```
asset-artist generates assets that don't match the art direction
    ↓
Options:
    ├── Use mcp__ludo__editImage to adjust existing assets
    ├── Regenerate with more specific prompts
    ├── Update the style reference (assets/style_reference.png) with user approval
    └── User provides reference images or more detailed direction
```

**Prevention:** Establish the style reference early. All subsequent assets use `generateWithStyle` with that reference.

### Feature Blocked by Missing Dependency

```
Agent can't start because a dependency isn't ready
    ↓
Agent messages the blocking agent directly: "I need [X] to proceed"
    ↓
If blocker is in same phase → blocker prioritizes the dependency
If blocker is in a later phase → feature is deferred to next sprint
If blocker is the user → user is asked to unblock (approve spec, make decision, etc.)
```

**Prevention:** The sprint plan should identify dependencies upfront. Use `addBlockedBy` in TaskCreate to make dependencies explicit.

### Sprint Carries Over Incomplete Work

When features aren't finished within a sprint:

1. **In sprint review (Phase D):** Clearly list carried-over features with reason
2. **User decides:**
   - Carry to next sprint (add to next sprint's scope)
   - Deprioritize (move to backlog, may never be built)
   - Kill (feature isn't worth completing)
3. **Next sprint plan** accounts for carried-over work in its scope estimate

**Rule:** Never silently drop features. If it was planned and didn't ship, it appears in the sprint review for user decision.

### Debugging Runtime Issues

When features are implemented but have runtime bugs:

```
Bug discovered (during testing or qa-docs review)
    ↓
error-debugger skill diagnoses the issue (any dev agent can use this)
    ↓
Fix is scoped to the owning agent's directories
    ↓
If bug spans multiple agents' code → agents coordinate via messages
    ↓
qa-docs re-reviews the fix
```

---

## Communication Protocols

### Handoff Contracts

Each agent communicates with others through **files, not messages** wherever possible:

| From | To | Contract |
|------|-----|----------|
| design-lead | developers | Feature spec in `docs/features/` (input to `feature-implementer`) |
| design-lead | developers | Idea briefs in `docs/ideas/` (context for understanding intent) |
| design-lead | systems-dev | Tool specs + roadmaps in `docs/tools/` (input to `tool-feature-implementer`) |
| design-lead | content-architect | GDD + feature specs define what content is needed |
| design-lead | asset-artist | Feature specs describe visual requirements |
| systems-dev | gameplay-dev, ui-dev | Autoload scripts with public API (methods + signals) |
| developers | qa-docs | Implementation reports from `feature-implementer` inform review focus |
| qa-docs | developers | Code review reports in `docs/code-reviews/` |
| content-architect | gameplay-dev | Data files in `data/` that gameplay loads |
| asset-artist | gameplay-dev, ui-dev | Asset files in `assets/`, `music/`, `sfx/` referenced by path |

### When Direct Messages Are Needed

Use `SendMessage` only for:
- **Blocking issues** — "I need X autoload to exist before I can continue"
- **Clarification requests** — "The feature spec doesn't specify behavior for edge case Y"
- **Completion signals** — "Sprint N systems are ready, gameplay-dev and ui-dev can start"
- **Design decisions** — "Should this enemy have ranged or melee attacks?"

Avoid broadcasting. Default to direct messages to the specific agent who can help.

---

## Deliverable Slice Roadmap Template

Sprints are organized around **playable increments**, not systems. Each sprint produces something testable.

```
Sprint 1: "[Player can X]"
  ├── Feature Specs: [list from design-lead]
  ├── Systems Needed: [autoloads/managers from systems-dev]
  ├── Gameplay Work: [scenes/entities from gameplay-dev]
  ├── UI Work: [screens/HUD elements from ui-dev]
  ├── Content Needed: [data files from content-architect]
  ├── Assets Needed: [sprites/audio from asset-artist]
  ├── Acceptance Criteria: [from feature spec]
  └── 🔒 USER REVIEW: playtest, approve/reject features, approve next sprint

Sprint 2: "[Player can Y]"
  ...

[LIFECYCLE GATE after final sprint in phase]
  └── 🚦 GO/NO-GO: User decides whether to advance to next lifecycle phase
```

### Example Roadmap (RPG)

**PROTOTYPE PHASE** (prove the core loop is fun)

```
Sprint 1: "Player can move through a world"
  ├── Systems: InputManager, GameState, SceneManager
  ├── Gameplay: PlayerController, Camera, TileMap scene
  ├── UI: Debug overlay, FPS counter
  ├── Content: First worldmap, starting location
  ├── Assets: Player sprite + walk animation, first tileset, ambient music
  ├── Criteria: Player moves with WASD, camera follows, world renders
  └── 🔒 USER REVIEW: Does movement feel good? Is the world readable?

Sprint 2: "Player can encounter and fight an enemy"
  ├── Systems: CombatManager, EventBus (damage signals)
  ├── Gameplay: EnemyEntity, HitboxComponent, combat scene
  ├── UI: Health bar, damage numbers, combat log
  ├── Content: First enemy definition, test encounter
  ├── Assets: Enemy sprite + attack animation, combat SFX, battle music
  ├── Criteria: Player enters combat, can attack, enemy dies or player dies
  └── 🔒 USER REVIEW: Is combat satisfying? Does the core loop work?

🚦 PROTOTYPE GO/NO-GO: Is the core loop fun enough to invest in polish?
```

**VERTICAL SLICE PHASE** (prove the quality bar)

```
Sprint 3: "Player can talk to an NPC and receive a quest"
  ├── Systems: DialogueManager, QuestTracker
  ├── Gameplay: NPCEntity, interaction zones
  ├── UI: Dialogue box, quest journal, notification toast
  ├── Content: First NPC, dialogue tree, starter quest
  ├── Assets: NPC sprite (polished), UI sounds, dialogue blips
  ├── Criteria: Player talks to NPC, receives quest, quest appears in journal
  └── 🔒 USER REVIEW: Does dialogue feel natural? Is quest tracking clear?

Sprint 4: "Player can complete a quest and be rewarded"
  ├── Systems: InventoryManager, RewardSystem
  ├── Gameplay: ItemPickup, quest objective triggers
  ├── UI: Inventory screen, reward popup, quest complete notification
  ├── Content: Quest completion data, reward items, updated campaign
  ├── Assets: Item sprites (polished), reward fanfare SFX, chest animation
  ├── Criteria: Player completes objective, returns to NPC, receives reward
  └── 🔒 USER REVIEW: Does the full loop (explore → fight → talk → quest → reward) feel complete?

Sprint 5: "Polish pass on the complete slice"
  ├── Systems: Performance optimization, bug fixes
  ├── Gameplay: Tuning, game feel, juice
  ├── UI: Visual polish, transitions, feedback
  ├── Content: Balance pass on all data
  ├── Assets: Final art quality, audio mix, VFX polish
  ├── Criteria: Slice represents target quality for full game
  └── 🔒 USER REVIEW: Does this represent the game you want to build?

🚦 VERTICAL SLICE GO/NO-GO: Is quality bar met? Proceed to full production?
```

**PRODUCTION PHASE** (build the full game)

```
Sprint 6+: Expand from the validated vertical slice...
  ├── New content, new systems, new areas
  ├── Each sprint follows the same Phase A-D structure
  ├── Each sprint ends with USER REVIEW
  └── Scope informed by what was proven in the vertical slice
```

---

## Phase 0: Pre-Sprint Setup

Before sprints begin, design-lead runs the design pipeline. **Every step pauses for user approval.**

```
1. game-concept-generator     → Explore concepts
   🔒 USER CHOOSES concept direction

2. concept-validator           → Validate feasibility and risks
   🔒 USER REVIEWS risks, decides to proceed or adjust

3. design-bible-updater        → Establish pillars, vision, tone
   🔒 USER APPROVES design pillars (these guide ALL future decisions)

4. prototype-gdd-generator     → Create the GDD through Q&A WITH USER
   🔒 USER APPROVES final GDD

5. roadmap-planner             → Break GDD into deliverable slices
   🔒 USER APPROVES sprint breakdown, can reorder/add/remove

6. feature-idea-designer       → Refine Sprint 1 features into Idea Briefs
   🔒 USER REVIEWS each idea brief for alignment with vision

7. feature-spec-generator      → Convert Idea Briefs into full Feature Specs
   🔒 USER APPROVES specs before any implementation begins
```

Only after this pipeline completes — with user approval at every step — does Sprint 1 begin.

### Ongoing Feature Pipeline (during sprints)

While developers implement Sprint N, design-lead pipelines Sprint N+1:

```
Vague idea or GDD reference
    ↓
feature-idea-designer           → docs/ideas/[feature]-idea.md
    ↓                              (interactive Q&A to refine scope, approach, tradeoffs)
    🔒 USER REVIEWS idea brief
    ↓
feature-spec-generator          → docs/features/[feature].md
    ↓                              (full spec with implementation details, acceptance criteria)
    🔒 USER APPROVES spec before it enters any sprint
    ↓
developers (feature-implementer) → implementation plan presented
    🔒 USER CONFIRMS implementation plan
    ↓
developers (feature-implementer) → implementation in owned directories
    ↓                               (builds within owned dirs, produces report)
qa-docs (gdscript-quality-checker) → docs/code-reviews/[feature]_review.md
    ↓
    🔒 USER REVIEWS in Sprint Review (Phase D)
```

### Tool Development Pipeline (as needed)

When development tools or editor plugins are needed:

```
Tool need identified
    ↓
design-lead (tool-spec-generator)         → docs/tools/[tool]-spec.md
    🔒 USER APPROVES tool spec
    ↓
design-lead (tool-roadmap-planner)        → docs/tools/[tool]-roadmap.md
    🔒 USER APPROVES roadmap phases       (phased: MVP → Workflow → Polish)
    ↓
systems-dev (tool-feature-implementer)    → addons/[tool]/
    ↓                                        (implements one phase at a time)
qa-docs (gdscript-quality-checker)        → docs/code-reviews/[tool]_review.md
```

---

## Team Scaling by Lifecycle Phase

The team composition changes as the project grows. Not all 7 agents are needed at all phases, and some roles split when volume warrants it.

### Prototype Phase (7 agents)

```
design-lead, systems-dev, gameplay-dev, ui-dev, content-architect, asset-artist, qa-docs
```
All roles as defined above. asset-artist handles both visual and audio.

### Vertical Slice Phase (8 agents — asset-artist splits)

When polish matters and asset volume increases, split asset-artist into two:

| Agent | Tools | Directories |
|-------|-------|-------------|
| **visual-artist** | Ludo MCP (createImage, editImage, generateWithStyle, animateSprite, create3DModel, generatePose) | `assets/` (all subdirectories) |
| **audio-artist** | Epidemic Sound MCP (SearchRecordings, SearchSoundEffects, Download*) + Ludo (createSpeech, createVoice) | `music/`, `sfx/`, `voice/` |

**Why this works:** Completely different MCP tools, zero file overlap, independent creative processes.

**Why not earlier:** During prototype, audio needs are minimal — a handful of placeholder sounds isn't enough work for a dedicated agent.

### Production Phase (8 agents)

Same as vertical slice. Consider whether content-architect needs help if content volume is very high — but don't split due to campaign-creator's cross-reference requirements.

---

## Skill Genre Compatibility

**Important:** Many skills in this template were originally designed for a CRPG editor project. Not all are suitable for every game genre. Before starting a new project, review which skills apply.

### Fully Generic (any game genre)

These skills work for platformers, puzzles, shooters, RPGs, strategy — anything:

| Skill | Used By | Notes |
|-------|---------|-------|
| `concept-validator` | design-lead | Genre-agnostic feasibility testing |
| `game-concept-generator` | design-lead | Explicitly supports all genres |
| `design-bible-updater` | design-lead | Universal design pillars framework |
| `prototype-gdd-generator` | design-lead | Process-focused, genre-neutral |
| `vertical-slice-gdd-generator` | design-lead | Generic process, slight action bias in examples |
| `feature-spec-generator` | design-lead | Template is generic, examples lean action |
| `feature-idea-designer` | design-lead | Framework generic, examples lean RPG |
| `feature-implementer` | all dev agents | Godot-generic, examples lean RPG |
| `gdscript-quality-checker` | qa-docs | Language-level analysis, fully generic |
| `gdscript-refactor-executor` | dev agents | Code refactoring, fully generic |
| `data-driven-refactor` | qa-docs | Code analysis, fully generic |
| `data-extractor` | qa-docs | Data extraction, fully generic |
| `scene-optimizer` | gameplay-dev, ui-dev | Godot scene analysis, fully generic |
| `vfx-generator` | gameplay-dev | Procedural particles, any genre |
| `error-debugger` | dev agents | Debugging, fully generic |
| `systems-bible-updater` | qa-docs | Technical docs, fully generic |
| `architecture-documenter` | qa-docs | Structure docs, fully generic |
| `system-diagram-generator` | qa-docs | Diagrams, fully generic |
| `changelog-updater` | qa-docs | Changelog, fully generic |
| `version-control-helper` | qa-docs | Git workflows, fully generic |
| `tool-spec-generator` | design-lead | Tool specs, fully generic |
| `tool-roadmap-planner` | design-lead | Tool planning, fully generic |
| `tool-feature-implementer` | systems-dev | Tool building, fully generic |

### RPG/Narrative Content Pipeline (RPG and narrative games only)

These skills assume quest-based progression, NPC dialogue, D&D-style stats, and campaign structures. **Skip these entirely for non-narrative games:**

| Skill | Used By | Genre Limitation |
|-------|---------|-----------------|
| `campaign-creator` | content-architect | CRPG-specific: quest chains, chapters, NPC recruitment |
| `character-creator` | content-architect | CRPG-specific: D&D stats (STR/DEX/CON), companion tiers |
| `quest-designer` | content-architect | CRPG-specific: quest types, "talk_to_npc" objectives |
| `dialogue-designer` | content-architect | CRPG-specific: dialogue trees, Persuasion/Intimidation checks |
| `encounter-designer` | content-architect | CRPG-specific: D&D CR difficulty, combat encounters |
| `narrative-architect` | design-lead | RPG-biased: quest hooks, companion arcs |
| `lore-generator` | content-architect | Mostly generic but examples assume fantasy RPG |
| `world-builder` | content-architect | RPG-biased: settlements, services (shop/inn/blacksmith) |
| `game-ideator` | design-lead | RPG-biased: D&D module import, tabletop conversion |
| `production-gdd-generator` | design-lead | CRPG/live-service: economy, monetization, meta-progression |

### Impact on Team by Genre

| Game Genre | content-architect | design-lead changes | Notes |
|-----------|------------------|-------------------|-------|
| **CRPG / RPG** | Full role, all skills | Add `narrative-architect`, `game-ideator` | All skills apply |
| **Action / Roguelike** | Partial — use for enemy data, level configs | Drop `campaign-creator`, `dialogue-designer` | Encounters may apply, quests likely don't |
| **Platformer** | Minimal — level data, enemy configs | Drop all RPG content skills | content-architect creates JSON level/enemy definitions |
| **Puzzle** | Minimal — puzzle configs, level data | Drop all RPG content skills | content-architect creates puzzle definition files |
| **Strategy** | Partial — `world-builder` may apply | Drop quest/dialogue skills | Location system adaptable to strategy maps |
| **Narrative / Visual Novel** | Partial — dialogue + characters apply | Keep `narrative-architect` | Skip encounters, quests may not apply |

### Adapting for Non-RPG Games

For non-RPG genres, content-architect still creates data files but uses **generic JSON schemas** instead of the CRPG-specific skills:

```
Platformer content-architect might create:
  data/levels/level_01.json          (layout, spawn points, collectibles)
  data/enemies/goomba.json           (behavior, speed, damage)
  data/powerups/double_jump.json     (duration, effect)

Puzzle content-architect might create:
  data/puzzles/chapter_1/puzzle_01.json  (grid size, rules, solution)
  data/difficulty/curve.json              (progression tuning)

Tower Defense content-architect might create:
  data/towers/archer_tower.json      (range, damage, cost, upgrades)
  data/waves/wave_01.json            (enemy types, spawn timing, paths)
  data/maps/forest_map.json          (paths, tower slots)
```

The directory ownership (`data/`) and the role (structured game data) remain the same — only the skills and schemas change.

### Skill Audit Log

**Audit date:** 2026-02-07

#### Removed Skills

| Skill | Reason |
|-------|--------|
| `figma-prompt-generator` | Redundant — built-in Figma MCP `implement-design` skill handles this |
| `figma-visual-updater` | Redundant — built-in Figma MCP `implement-design` skill handles this |
| `godot-project-setup` | Superseded by `project-bootstrap` skill |
| `PIXELART_PIPELINE_CONTEXT.md` | Documentation file, not a skill; CRPG-engine-specific |

#### Conformance Updates

All remaining skills now include a **Workflow Context** header specifying:
- Agent assignment (which agent uses the skill)
- Sprint phase (when in the workflow the skill is invoked)
- Directory scope (what directories the skill operates on)
- Workflow reference (link to this document)

RPG-pipeline skills additionally include a **genre warning banner** clearly marking them as CRPG-specific with guidance on what to use instead for non-RPG games.

#### Future Revisions (Nice-to-Have)

These generic skills would benefit from diversified examples but work fine as-is:

| Skill | Issue | Recommended Fix |
|-------|-------|----------------|
| `feature-implementer` | Examples assume combat/RPG systems | Diversify examples (add platformer, puzzle scenarios) |
| `feature-idea-designer` | Examples reference inventory, economy, parts | Add non-RPG example flows |
| `production-gdd-generator` | Assumes economy, monetization, live-ops | Make these sections conditional, not mandatory |
| `game-ideator` | D&D module import dominates | Add non-tabletop ideation modes |
| `world-builder` | Location services hardcoded (shop/inn/blacksmith) | Make services configurable per genre |

These revisions are not blocking — the generic skills work fine for any game. The RPG pipeline skills simply won't be invoked for non-RPG projects.

---

## Conventions

### File Naming
- Scripts: `snake_case.gd` (e.g., `player_controller.gd`)
- Scenes: `snake_case.tscn` (e.g., `main_menu.tscn`)
- Resources: `snake_case.tres` (e.g., `default_theme.tres`)
- Data: `snake_case.json` (e.g., `goblin_warrior.json`)
- Assets: `snake_case.png` (e.g., `player_idle.png`)

### Commit Messages
Follow Conventional Commits:
- `feat:` new feature
- `fix:` bug fix
- `refactor:` code restructuring
- `docs:` documentation only
- `asset:` new or updated assets
- `content:` new or updated data files

### Branch Strategy
- `main` — stable, playable builds only
- `sprint/N-description` — sprint work branch
- Feature branches off sprint branch if needed

### Git Initialization
Git is initialized automatically by the `project-bootstrap` skill. The initial commit includes all template files. Each sprint should work on a `sprint/N-description` branch merged to `main` at the end of each sprint review (Phase D), after user approval.

---

## Modifying This Document

This is a living document. Update it when:
- A new agent role is needed
- Directory ownership changes
- Sprint structure needs adjustment
- New quality gates are added
- New MCP tools become available

Keep changes minimal and justified. Document the reason for each change.
