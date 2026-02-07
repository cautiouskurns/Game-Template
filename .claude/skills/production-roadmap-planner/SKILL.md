---
name: production-roadmap-planner
description: Read a production GDD and generate a phased implementation roadmap with feature specs for each feature. Designed for indie games with 1-6 month timelines. Organized by phases (not time), with mid-detail feature specifications.
domain: project
type: planner
version: 1.0.0
allowed-tools:
  - Read
  - Write
  - Glob
---

# Production Roadmap Planner Skill

This skill reads a production GDD and generates a comprehensive implementation roadmap for indie game development. It organizes work into logical phases, lists all features per phase, and provides mid-detail specifications for each feature—enough to start implementing without needing a separate feature spec document.

---

## When to Use This Skill

Invoke this skill when the user:
- Says "create production roadmap" or "plan production phases"
- Has a production GDD and needs an implementation plan
- Wants to break down a full game into actionable phases
- Says "what do I need to build?" or "what's the implementation order?"
- Needs a roadmap for a 1-6 month indie game project
- Says "generate roadmap from GDD"

---

## Core Principles

**Production roadmaps bridge design and implementation:**
- ✅ Extract ALL features from production GDD
- ✅ Organize into logical phases by dependency and priority
- ✅ Each feature gets a mid-detail spec (implementable without separate doc)
- ✅ Phases have clear purposes and deliverables
- ✅ Roadmap is actionable—developer can start coding from it
- ✅ Designed for solo devs or small indie teams

---

## Difference from Other Roadmap Skills

| Aspect | Prototype Roadmap | Vertical Slice Roadmap | **Production Roadmap** |
|--------|-------------------|------------------------|------------------------|
| **Input** | Prototype GDD | Vertical Slice GDD | Production GDD |
| **Timeline** | Days to weeks | 2-4 months | 1-6 months |
| **Organization** | Hour-by-hour tasks | Feature-level phases | Phase → Feature → Spec |
| **Feature Detail** | Task checklists | High-level description | Mid-detail specification |
| **Purpose** | Test core questions | Polish a slice | Ship complete game |
| **Audience** | Rapid prototyping | Pre-production | Full production |

---

## Phase Structure Philosophy

### Standard Phase Progression

Production games typically follow this phase order:

```
PHASE 1: CORE FOUNDATION
├── Core gameplay loop playable
├── Essential systems working
├── Placeholder content acceptable
└── Goal: "The game exists and is playable"

PHASE 2: SYSTEMS COMPLETION
├── All major systems implemented
├── Systems integrated and working together
├── Balance framework in place
└── Goal: "All mechanics work correctly"

PHASE 3: CONTENT PRODUCTION
├── All levels/missions/content created
├── All enemies/items/abilities implemented
├── Narrative content written and integrated
└── Goal: "All content exists"

PHASE 4: PROGRESSION & BALANCE
├── Progression systems tuned
├── Difficulty curve implemented
├── Economy balanced
└── Goal: "Game feels right to play"

PHASE 5: POLISH & JUICE
├── Visual effects and feedback
├── Audio integration
├── UI polish
├── Animations and transitions
└── Goal: "Game feels good to play"

PHASE 6: TESTING & SHIP
├── Bug fixing
├── Performance optimization
├── Platform requirements
├── Release preparation
└── Goal: "Game is ready to ship"
```

### Phase Assignment Rules

When assigning features to phases:

1. **Dependencies First:** If Feature B requires Feature A, Feature A goes in an earlier phase
2. **Core Before Content:** Systems before the content that uses them
3. **Playable Milestones:** Each phase should end with something playable/testable
4. **Polish Last:** Visual/audio polish after functionality works
5. **Risk Front-Loading:** Uncertain/risky features early to allow iteration

---

## Feature Specification Format

Each feature in the roadmap gets a **mid-detail specification**—more than a one-liner, less than a full feature spec document.

### Feature Spec Template

```markdown
### [Feature Name]

**Type:** Core System | Content | UI | Polish | Integration
**Priority:** Critical | High | Medium | Low
**Dependencies:** [What must exist first]
**Estimated Effort:** S (1-2 days) | M (3-5 days) | L (1-2 weeks) | XL (2+ weeks)

**Description:**
[2-4 sentences explaining what this feature is and why it matters]

**Requirements:**
- [Specific requirement 1]
- [Specific requirement 2]
- [Specific requirement 3]
- [Continue as needed]

**Implementation Notes:**
- [Key technical consideration or approach]
- [Important edge case or constraint]
- [Suggested pattern or reference]

**Acceptance Criteria:**
- [ ] [Testable criterion 1]
- [ ] [Testable criterion 2]
- [ ] [Testable criterion 3]

**Files/Scenes:**
- `[path/to/file]` - [purpose]
- `[path/to/scene]` - [purpose]
```

### Detail Level Guidelines

**Include:**
- What the feature does (clear description)
- Specific requirements (not vague)
- Key technical notes (how to approach)
- Acceptance criteria (how to know it's done)
- File structure hints (where code goes)

**Don't Include:**
- Full code implementations
- Exhaustive edge cases
- Balance numbers (those go in data files)
- Detailed UI mockups (reference GDD)
- Alternative approaches (pick one)

### Example Feature Specs by Type

#### Core System Feature
```markdown
### Guard Patrol System

**Type:** Core System
**Priority:** Critical
**Dependencies:** Grid movement, Guard entity
**Estimated Effort:** M (3-5 days)

**Description:**
Guards follow predetermined patrol routes, moving between waypoints in a loop. Routes are visible to the player as dotted lines. Guards pause at waypoints before continuing. This is the foundation of stealth puzzle gameplay.

**Requirements:**
- Guards move along defined waypoint paths
- Paths loop continuously (last waypoint → first waypoint)
- Optional pause duration at each waypoint
- Patrol routes visible as dotted lines when player observes
- Guards face movement direction
- Configurable movement speed per guard

**Implementation Notes:**
- Use Path2D + PathFollow2D for smooth movement along routes
- Store waypoints as Vector2 array in guard data
- Pause timer at each waypoint (default 0, configurable)
- Draw route using Line2D with dotted pattern

**Acceptance Criteria:**
- [ ] Guard moves between waypoints smoothly
- [ ] Guard pauses at waypoints for configured duration
- [ ] Patrol route visible as dotted line
- [ ] Guard faces direction of movement
- [ ] Route loops infinitely

**Files/Scenes:**
- `scripts/stealth/patrol_route.gd` - Route data and drawing
- `scripts/enemies/guard_patrol_ai.gd` - Movement along route
- `scenes/enemies/Guard.tscn` - Guard with patrol component
```

#### Content Feature
```markdown
### Act 1 Missions (10 Missions)

**Type:** Content
**Priority:** High
**Dependencies:** Mission system, Guard patrol, Stealth mechanics, Combat system
**Estimated Effort:** XL (2+ weeks)

**Description:**
The first 10 missions serve as tutorial and introduction. Each mission teaches a specific mechanic while providing satisfying stealth/combat gameplay. Difficulty scales from 2 guards to 4 guards. Uses Corridor, Courtyard, and Tower templates.

**Requirements:**
- Mission 1-3: Tutorial missions (movement, vision cones, first combat)
- Mission 4-7: Apply mechanics (timing puzzles, multiple routes)
- Mission 8-10: Combine mechanics (synchronized patrols, environmental hazards)
- 2-4 guards per mission
- Each mission has stealth AND combat solution
- Mission briefings written for each

**Implementation Notes:**
- Use TileMap for level layout
- Place guards with patrol routes defined in editor
- Objective markers for player guidance
- Save/load mission progress to campaign state

**Acceptance Criteria:**
- [ ] All 10 missions playable start to finish
- [ ] Each mission completable via stealth (⭐⭐⭐ rating)
- [ ] Each mission completable via combat (⭐ rating)
- [ ] Mission briefings display before each mission
- [ ] Progression unlocks next mission on completion

**Files/Scenes:**
- `scenes/missions/act1/mission_01.tscn` through `mission_10.tscn`
- `data/missions/act1_briefings.json` - Mission text content
- `scripts/missions/mission_manager.gd` - Loading and completion
```

#### UI Feature
```markdown
### Loadout Screen

**Type:** UI
**Priority:** High
**Dependencies:** Spell system, Equipment system, Progression data
**Estimated Effort:** M (3-5 days)

**Description:**
Pre-mission screen where player selects their spell loadout (5 of available spells) and equipment (robe, amulet, ring). Shows currently unlocked items and their effects. Confirms loadout before starting mission.

**Requirements:**
- Display all unlocked spells with icons and names
- Allow selecting exactly 5 spells (visual feedback on selection)
- Display equipment slots with dropdown/selection for each
- Show spell/equipment descriptions on hover
- Show currently active passives (read-only)
- Confirm button to start mission with loadout

**Implementation Notes:**
- Use ItemList or custom grid for spell selection
- OptionButton for equipment dropdowns
- Load available items from ProgressionManager
- Save loadout to PlayerData before mission start

**Acceptance Criteria:**
- [ ] Can select exactly 5 spells from available pool
- [ ] Can equip one item per equipment slot
- [ ] Descriptions visible on hover/select
- [ ] Confirm starts mission with selected loadout
- [ ] Locked items shown but not selectable

**Files/Scenes:**
- `scenes/ui/loadout_screen.tscn` - Main UI scene
- `scripts/ui/loadout_screen.gd` - Selection logic
- `scripts/ui/spell_button.gd` - Individual spell display
```

#### Polish Feature
```markdown
### Combat Spell VFX

**Type:** Polish
**Priority:** Medium
**Dependencies:** Combat system, All spells implemented
**Estimated Effort:** L (1-2 weeks)

**Description:**
Visual effects for all combat spells. Each spell has cast animation, projectile/effect, and impact. Effects should be readable (clear what happened) and satisfying (feel impactful).

**Requirements:**
- Fireball: Orange projectile, explosion on impact, lingering flames
- Chain Lightning: Electric arc between targets, bounce effect
- Ice Lance: Blue projectile, freeze effect on target
- Death Nova: Radial burst from player, knockback visual
- Meteor Strike: Shadow indicator, falling rock, large explosion
- Vortex: Swirling pull effect toward center
- Arcane Shield: Shimmering barrier around player
- Time Stop: Desaturation + frozen enemy indicators

**Implementation Notes:**
- Use GPUParticles2D for most effects
- AnimationPlayer for timing/sequencing
- Reusable impact effect scene
- Keep particle counts reasonable for performance

**Acceptance Criteria:**
- [ ] All 8 combat spells have visual effects
- [ ] Effects clearly communicate what happened
- [ ] Effects feel impactful and satisfying
- [ ] No significant frame drops during effects
- [ ] Effects match spell behavior (AOE shows area, etc.)

**Files/Scenes:**
- `scenes/vfx/spells/fireball_vfx.tscn`
- `scenes/vfx/spells/chain_lightning_vfx.tscn`
- `scenes/vfx/impacts/explosion_impact.tscn`
- `scripts/vfx/vfx_manager.gd` - Spawning and pooling
```

---

## Roadmap Output Structure

```markdown
# [GAME TITLE] - Production Implementation Roadmap

**Based On:** Production GDD v[X.Y.Z]
**Total Timeline:** [X weeks/months]
**Team Size:** [Solo / Small Team]
**Created:** [Date]

---

## Roadmap Overview

| Phase | Name | Features | Purpose |
|-------|------|----------|---------|
| 1 | [Name] | [Count] | [One-line purpose] |
| 2 | [Name] | [Count] | [One-line purpose] |
| 3 | [Name] | [Count] | [One-line purpose] |
| ... | ... | ... | ... |

**Total Features:** [Count]

---

## Phase 1: [Phase Name]

**Purpose:** [What this phase accomplishes - 2-3 sentences]

**Phase Deliverable:** [What should be working/playable after this phase]

**Features in This Phase:**

### [Feature 1 Name]
[Full feature spec using template above]

---

### [Feature 2 Name]
[Full feature spec using template above]

---

[Continue for all features in phase]

---

**Phase 1 Checklist:**
- [ ] [Feature 1] complete
- [ ] [Feature 2] complete
- [ ] Phase deliverable achieved: [description]
- [ ] Ready for Phase 2

---

## Phase 2: [Phase Name]

[Same structure as Phase 1]

---

[Continue for all phases]

---

## Asset Production Schedule

**Art Assets:**
| Asset Category | Count | Phase Needed |
|----------------|-------|--------------|
| [Category] | [X] | Phase [N] |

**Audio Assets:**
| Asset Category | Count | Phase Needed |
|----------------|-------|--------------|
| [Category] | [X] | Phase [N] |

---

## Risk Register

| Risk | Impact | Mitigation | Phase Affected |
|------|--------|------------|----------------|
| [Risk] | High/Med/Low | [Mitigation strategy] | [Phase] |

---

## Dependencies Graph

```
Phase 1
├── [Feature A] ─────────────────────────┐
├── [Feature B] ──────────┐              │
└── [Feature C]           │              │
                          ▼              ▼
Phase 2                   │              │
├── [Feature D] ◄─────────┘              │
├── [Feature E] ◄────────────────────────┘
└── [Feature F]
```

---

**END OF ROADMAP**

**Next Steps:**
1. Review roadmap and adjust phase assignments if needed
2. Set up project structure and version control
3. Begin Phase 1 implementation
4. Track progress with changelog-updater
```

---

## Workflow

### Step 1: Read Production GDD

1. **Find the production GDD:**
   - Look for `docs/*production-gdd*.md` or ask user for path
   - Read the entire GDD

2. **Extract key information:**
   - Game title and overview
   - Timeline (from Production Plan section)
   - All game systems (from Game Systems section)
   - Content scope (missions, enemies, abilities, etc.)
   - Progression systems
   - UI screens needed
   - Art and audio requirements
   - Technical requirements

---

### Step 2: Create Feature Inventory

**Extract ALL features from GDD into a flat list:**

From **Core Gameplay** section:
- Primary mechanics
- Secondary mechanics
- Core loop components

From **Game Systems** section:
- Each documented system becomes a feature
- Sub-systems may become separate features

From **Progression & Economy** section:
- Progression system
- Economy/currency system
- Unlock systems

From **Content Scope** section:
- Content production (levels, enemies, items)
- Writing content
- Asset production

From **Player Experience** section:
- Tutorial/onboarding
- Difficulty system
- Save/load system

From **UI screens** (inferred from GDD):
- Main menu
- Game HUD
- Pause menu
- All other UI screens

From **Technical Design** section:
- Core architecture
- Performance requirements
- Platform-specific features

From **Art & Audio** sections:
- Art integration
- Audio integration
- VFX systems

---

### Step 3: Categorize and Prioritize Features

**Assign each feature:**

1. **Type:**
   - Core System (gameplay mechanics)
   - Content (levels, enemies, items)
   - UI (menus, HUD, screens)
   - Polish (VFX, audio, juice)
   - Integration (connecting systems)
   - Technical (architecture, performance)

2. **Priority:**
   - Critical: Game cannot function without this
   - High: Core experience requires this
   - Medium: Important but not blocking
   - Low: Nice to have, can cut if needed

3. **Effort Estimate:**
   - S: 1-2 days
   - M: 3-5 days
   - L: 1-2 weeks
   - XL: 2+ weeks

4. **Dependencies:**
   - What other features must exist first?

---

### Step 4: Assign Features to Phases

**Phase Assignment Algorithm:**

```
FOR each feature:
  IF feature has no dependencies AND is Critical/High priority:
    Assign to Phase 1 (Foundation)
  ELSE IF feature depends only on Phase 1 features:
    Assign to Phase 2 (Systems)
  ELSE IF feature is Content type:
    Assign to Phase 3 (Content)
  ELSE IF feature is Progression/Balance type:
    Assign to Phase 4 (Balance)
  ELSE IF feature is Polish type:
    Assign to Phase 5 (Polish)
  ELSE:
    Assign to Phase 6 (Ship)
```

**Phase Guidelines:**

| Phase | Focus | Feature Types |
|-------|-------|---------------|
| 1 | Foundation | Core systems, basic UI, placeholder content |
| 2 | Systems | All gameplay systems complete |
| 3 | Content | All levels, enemies, abilities, narrative |
| 4 | Balance | Progression, difficulty, economy tuning |
| 5 | Polish | VFX, audio, animations, UI polish |
| 6 | Ship | Bug fixes, optimization, release prep |

---

### Step 5: Write Feature Specs

**For each feature, write the mid-detail spec:**

1. Fill in template fields from GDD information
2. Add implementation notes based on GDD technical details
3. Define acceptance criteria (testable, specific)
4. Suggest file/scene structure based on project conventions

**Detail Level:**
- Enough to start implementing without questions
- Not so detailed it constrains implementation choices
- Include the "what" and "why", hint at "how"

---

### Step 6: Build Dependencies Graph

**Map feature dependencies:**

1. Draw dependency arrows between features
2. Ensure no circular dependencies
3. Verify phase assignments respect dependencies
4. Identify critical path (longest dependency chain)

---

### Step 7: Extract Asset Schedule

**From GDD's content scope and art/audio sections:**

1. List all art assets needed
2. List all audio assets needed
3. Map assets to phases (when they're needed)
4. Note external vs internal asset production

---

### Step 8: Identify Risks

**From GDD's risk section and inferred risks:**

1. Technical risks (uncertain implementations)
2. Scope risks (features that might grow)
3. External risks (assets, tools, dependencies)
4. Timeline risks (underestimated effort)

---

### Step 9: Save Roadmap

**Save to:** `docs/[game-name]-production-roadmap.md`

**Output to user:**
```
Created production roadmap with:
- [X] phases
- [Y] total features
- [Z] critical path features

Phase breakdown:
- Phase 1: [N] features (Foundation)
- Phase 2: [N] features (Systems)
- Phase 3: [N] features (Content)
- Phase 4: [N] features (Balance)
- Phase 5: [N] features (Polish)
- Phase 6: [N] features (Ship)

Roadmap saved to: docs/[game]-production-roadmap.md

Next steps:
1. Review and adjust phase assignments
2. Begin Phase 1 implementation
3. Track progress in changelog
```

---

## Example Interaction

**User:** "Create production roadmap"

**Skill:**
```
Reading production GDD...

Found: docs/shadow-mage-production-gdd.md
- 5 week timeline
- Stealth tactical puzzle with turn-based combat
- 40 missions across 4 acts
- 14 spells, 30 passives, 12 equipment pieces
- 7 enemy types

Extracting features...
- 8 core system features
- 6 content features
- 5 UI features
- 4 polish features
- 3 technical features

Total: 26 features

Assigning to phases...

Phase 1: Core Foundation (8 features)
- Grid movement system
- Vision cone system
- Guard patrol system
- Detection state machine
- Basic combat grid
- Turn order system
- Player health/damage
- Mission structure

Phase 2: Full Systems (6 features)
- All stealth abilities (6)
- All combat spells (8)
- Equipment system
- Passive ability trees
- Mission rating system
- Save/load system

Phase 3: Content Production (5 features)
- Act 1 missions (10)
- Act 2 missions (10)
- Act 3 missions (10)
- Act 4 missions (10)
- All narrative content

Phase 4: Progression & Balance (3 features)
- Progression point economy
- Unlock sequence
- Difficulty curve tuning

Phase 5: Polish (3 features)
- Combat spell VFX
- Audio integration
- UI polish pass

Phase 6: Ship (1 feature)
- Testing and bug fixes

Writing feature specs...
Building dependency graph...
Extracting asset schedule...

Roadmap saved to: docs/shadow-mage-production-roadmap.md

26 features across 6 phases
Critical path: Grid → Guards → Detection → Combat → Content
```

---

## Integration with Other Skills

### Reads From:
- `production-gdd-generator` - Input GDD defining the full game

### Feeds Into:
- `feature-spec-generator` - For features needing even more detail
- `feature-implementer` - Implement features from roadmap
- `changelog-updater` - Track progress as features complete

### Works With:
- `systems-bible-updater` - Document systems as they're built
- `version-control-helper` - Commits per feature
- `gdscript-quality-checker` - Review code after each phase

---

## Quality Checklist

Before finalizing roadmap:

**Coverage:**
- ✅ All systems from GDD "Game Systems" section included
- ✅ All content from GDD "Content Scope" section included
- ✅ All UI screens accounted for
- ✅ Art and audio integration features included
- ✅ Technical requirements addressed

**Organization:**
- ✅ Features assigned to appropriate phases
- ✅ Dependencies respected (no feature before its dependency)
- ✅ Each phase has clear purpose and deliverable
- ✅ Phases build on each other logically

**Feature Specs:**
- ✅ Each feature has complete spec (all template fields)
- ✅ Requirements are specific and testable
- ✅ Acceptance criteria are checkboxes
- ✅ Implementation notes provide guidance
- ✅ File/scene structure suggested

**Practicality:**
- ✅ Effort estimates are realistic
- ✅ Critical path identified
- ✅ Risks documented with mitigations
- ✅ Asset schedule included

---

## Effort Estimation Guidelines

### Size Definitions

| Size | Days | Characteristics |
|------|------|-----------------|
| **S** | 1-2 | Single script, simple UI, data entry |
| **M** | 3-5 | One system, multiple scripts, moderate complexity |
| **L** | 1-2 weeks | Multiple systems, significant content, integration work |
| **XL** | 2+ weeks | Major system, large content batch, cross-cutting changes |

### Examples by Type

**Core Systems:**
- Simple (S): Input handling, basic state machine
- Medium (M): Patrol system, vision cones, turn order
- Large (L): Full combat system, progression system
- XL: Complete stealth system with all abilities

**Content:**
- Simple (S): 1-2 missions with simple layouts
- Medium (M): 5 missions or 3-4 enemy types
- Large (L): Full act (10 missions) or all enemy types
- XL: Multiple acts or complete content pass

**UI:**
- Simple (S): Single screen, basic layout
- Medium (M): Complex screen with interactions
- Large (L): Multiple connected screens
- XL: Complete UI overhaul

**Polish:**
- Simple (S): Single effect or sound integration
- Medium (M): VFX for one system
- Large (L): All VFX or all audio
- XL: Complete polish pass

---

## Key Principles

**DO:**
- ✅ Extract features directly from production GDD
- ✅ Write specs detailed enough to implement from
- ✅ Respect dependencies in phase assignments
- ✅ Include acceptance criteria for every feature
- ✅ Provide implementation guidance (not just what, but hints at how)
- ✅ Create playable milestones at each phase end
- ✅ Front-load risky/uncertain features

**DON'T:**
- ❌ Invent features not in the GDD
- ❌ Write full code implementations in specs
- ❌ Assign features to phases ignoring dependencies
- ❌ Use vague acceptance criteria ("works well")
- ❌ Estimate everything as Medium
- ❌ Ignore technical requirements
- ❌ Leave polish for "if there's time"

---

## Phase Deliverable Examples

**Phase 1 Deliverable:**
"Can move player on grid, guards patrol with visible vision cones, getting detected triggers combat, can win/lose combat. Ugly but functional."

**Phase 2 Deliverable:**
"All 14 spells work, all 30 passives apply effects, equipment can be equipped and affects gameplay, missions save/load progress."

**Phase 3 Deliverable:**
"All 40 missions playable, all narrative content viewable, complete game start-to-finish with placeholder polish."

**Phase 4 Deliverable:**
"Progression feels meaningful, difficulty curve is smooth, all three build archetypes viable."

**Phase 5 Deliverable:**
"Game looks and sounds polished, effects are satisfying, UI is clear and responsive."

**Phase 6 Deliverable:**
"Game is stable, performs well, ready to upload to Itch.io."

---

This skill creates an **actionable implementation roadmap** that bridges the production GDD and actual development. Each feature spec provides enough detail to start coding immediately while leaving room for implementation decisions.
