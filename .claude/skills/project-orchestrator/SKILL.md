---
name: project-orchestrator
description: Orchestrate the full game development workflow — Phase 0 design pipeline, sprint cycles, lifecycle gates. Reads workflow state to ensure correct sequencing across sessions. Run this before starting any game development work.
domain: orchestration
type: controller
version: 1.0.0
trigger: user
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
---

# Project Orchestrator

This skill is the **workflow enforcement layer** for the agent team. It reads a state file to determine the current position in the workflow, then executes the correct next step — invoking the right skills, spawning teams at the right phase, and enforcing user approval at every gate.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | Orchestrator (main Claude instance) |
| **Sprint Phase** | All phases — this skill manages the entire workflow |
| **Directory Scope** | `docs/.workflow-state.json` (state file only) |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

## How to Invoke This Skill

Users can trigger this skill by saying:
- `/project-orchestrator`
- "What's my project status?"
- "Where am I in the workflow?"
- "Continue the workflow"
- "Start the design pipeline"

---

## CRITICAL: First Action — Read State

**Every time this skill is invoked, immediately do the following:**

### 1. Check for State File

```
Look for: docs/.workflow-state.json
```

### 2. If State File Exists → Resume Flow

1. Read `docs/.workflow-state.json`
2. Parse `workflow_position` to determine current step
3. Display the status dashboard (see Status Display Format below)
4. Branch to the appropriate section based on `workflow_position.phase`:
   - `pre_phase_0` → Begin Phase 0 (step 0.1)
   - `phase_0` → Resume Phase 0 at the current step
   - `sprint` → Resume Sprint orchestration at the current sprint phase

5. **If status is `awaiting_user_approval`:** The previous session was interrupted before the user approved. Re-present the artifact and use AskUserQuestion to ask for approval.

6. **If status is `in_progress`:** The previous session was interrupted mid-step. Check if the artifact file exists:
   - If artifact exists → present it for approval (set status to `awaiting_user_approval`)
   - If no artifact → re-run the step from scratch

### 3. If No State File → Check Bootstrap

1. Check if the project directory structure exists (look for `scripts/autoloads/`, `scenes/gameplay/`, etc.)
2. **If bootstrapped but no state file:** Initialize the state file (see State Initialization below) and begin Phase 0
3. **If NOT bootstrapped:** Tell the user: "This project hasn't been bootstrapped yet. Run `/project-bootstrap` first to set up the directory structure."

### State Initialization

Create `docs/.workflow-state.json` with:

```json
{
  "version": "1.0.0",
  "project_name": "[read from project.godot or CLAUDE.md]",
  "created_at": "[current ISO timestamp]",
  "updated_at": "[current ISO timestamp]",
  "lifecycle_phase": "not_started",
  "workflow_position": {
    "phase": "pre_phase_0",
    "step": null,
    "status": "pending",
    "substep": null
  },
  "phase_0_progress": {
    "game_ideator": { "status": "pending", "artifact": null, "approved_at": null },
    "concept_validator": { "status": "pending", "artifact": null, "approved_at": null },
    "design_bible_updater": { "status": "pending", "artifact": null, "approved_at": null },
    "gdd_generator": { "status": "pending", "artifact": null, "approved_at": null },
    "roadmap_planner": { "status": "pending", "artifact": null, "approved_at": null },
    "feature_pipeline": { "sprint_1_features": [] }
  },
  "sprints": [],
  "lifecycle_gates": {
    "prototype_gate": { "status": "pending", "decision": null, "decided_at": null },
    "vertical_slice_gate": { "status": "pending", "decision": null, "decided_at": null }
  }
}
```

---

## Status Display Format

Always display this dashboard when the orchestrator is invoked or when transitioning between steps:

```
╔══════════════════════════════════════════════════╗
║  Project: [project_name]
║  Lifecycle: [lifecycle_phase]
║  Phase: [workflow_position.phase]
║  Step: [workflow_position.step]
║  Status: [workflow_position.status]
╠══════════════════════════════════════════════════╣
║  Next action: [description of what happens next]
╚══════════════════════════════════════════════════╝
```

---

## Phase 0: Design Pipeline

**Mode:** No team. You (the orchestrator) act as the design-lead agent directly, working interactively with the user. Do NOT create a team for Phase 0.

**Before starting:** Read `.claude/agents/design-lead.md` for role context.

### Step 0.1: Game Ideator

**Precondition:** State is at `pre_phase_0` or `phase_0` with step `game_ideator`

**Action:**
1. Update state: `workflow_position` → `{ phase: "phase_0", step: "game_ideator", status: "in_progress" }`
2. Write state file
3. Read `.claude/skills/game-ideator/SKILL.md`
4. Follow that skill's instructions: run the interactive questioning process with the user
5. When the skill produces its output, save to `docs/ideas/game-concepts.md`
6. Update state: `phase_0_progress.game_ideator.artifact` → `"docs/ideas/game-concepts.md"`
7. Update state: `status` → `"awaiting_user_approval"`
8. Write state file

**User Gate:**
STOP. Present a summary of the generated concepts and reference file `docs/ideas/game-concepts.md`, then use AskUserQuestion with these options:

Question: "How do you want to proceed with Game Concept Generation?"
Options:
- APPROVE — Select a concept and proceed to Concept Validation
- MODIFY — Adjust constraints and regenerate concepts
- REJECT — Discard and start over from scratch

If the user selects APPROVE, use a follow-up AskUserQuestion to ask which concept to select (list concepts as options).

**On APPROVE:** Update status → `"completed"`, record `approved_at`, proceed to Step 0.2
**On MODIFY:** Update status → `"user_requested_changes"`, gather feedback, re-run skill
**On REJECT:** Update status → `"pending"`, re-run from scratch

---

### Step 0.2: Concept Validator

**Precondition:** `game_ideator` status is `completed` or `skipped`

**Action:**
1. Update state: step → `"concept_validator"`, status → `"in_progress"`
2. Write state file
3. Read `.claude/skills/concept-validator/SKILL.md`
4. Follow that skill's instructions: validate the selected concept for feasibility
5. Save output to `docs/ideas/concept-validation.md`
6. Update artifact and status → `"awaiting_user_approval"`
7. Write state file

**User Gate:**
STOP. Present a summary of the feasibility assessment, risks identified, and recommended mitigations. Reference file `docs/ideas/concept-validation.md`, then use AskUserQuestion with these options:

Question: "How do you want to proceed with Concept Validation?"
Options:
- APPROVE — Risks are acceptable, proceed to Design Bible
- MODIFY — Adjust scope to reduce risk and re-validate
- REJECT — Return to Concept Generation (resets Step 0.1 and 0.2)

**On APPROVE:** Mark completed, proceed to Step 0.3
**On MODIFY:** Gather feedback, re-validate with adjusted scope
**On REJECT:** Reset this step AND Step 0.1 to `pending`, return to Step 0.1

---

### Step 0.3: Design Bible

**Precondition:** `concept_validator` status is `completed` or `skipped`

**Action:**
1. Update state: step → `"design_bible_updater"`, status → `"in_progress"`
2. Write state file
3. Read `.claude/skills/design-bible-updater/SKILL.md`
4. Follow that skill's instructions: establish design pillars, creative vision, tone
5. Save output to `docs/design-bible.md`
6. Update artifact and status → `"awaiting_user_approval"`
7. Write state file

**User Gate:**
STOP. Present a summary of the design pillars, vision statement, and creative direction. Reference file `docs/design-bible.md`. Emphasize that the design bible guides ALL future decisions — this is the most important approval. Then use AskUserQuestion with these options:

Question: "How do you want to proceed with the Design Bible?"
Options:
- APPROVE — Accept the design pillars and creative direction, proceed to Prototype GDD
- MODIFY — Provide feedback on pillars/tone for revision
- REJECT — Discard and start the Design Bible fresh

**On APPROVE:** Mark completed, proceed to Step 0.4
**On MODIFY:** Gather specific feedback on pillars/tone, revise
**On REJECT:** Reset to pending, start fresh

---

### Step 0.4: Prototype GDD

**Precondition:** `design_bible_updater` status is `completed` or `skipped`

**Action:**
1. Update state: step → `"gdd_generator"`, status → `"in_progress"`
2. Write state file
3. Read `.claude/skills/gdd-generator/SKILL.md`
4. Follow that skill's instructions: create the Game Design Document through interactive Q&A
5. Save output to `docs/prototype-gdd.md`
6. Update artifact and status → `"awaiting_user_approval"`
7. Write state file

**User Gate:**
STOP. Present a summary of the GDD including core loop, mechanics, systems needed, and scope. Reference file `docs/prototype-gdd.md`, then use AskUserQuestion with these options:

Question: "How do you want to proceed with the Prototype GDD?"
Options:
- APPROVE — Accept the GDD and proceed to Roadmap Planning
- MODIFY — Provide feedback to revise specific sections
- REJECT — Discard and restart the GDD

**On APPROVE:** Mark completed, proceed to Step 0.5
**On MODIFY:** Gather feedback, revise specific sections
**On REJECT:** Reset to pending

---

### Step 0.5: Prototype Roadmap

**Precondition:** `gdd_generator` status is `completed` or `skipped`

**Action:**
1. Update state: step → `"roadmap_planner"`, status → `"in_progress"`
2. Write state file
3. Read `.claude/skills/roadmap-planner/SKILL.md`
4. Follow that skill's instructions: break the GDD into sprint-sized deliverable slices
5. Save output to `docs/prototype-roadmap.md`
6. Update artifact and status → `"awaiting_user_approval"`
7. Write state file

**User Gate:**
STOP. Present a summary of the sprint breakdown including how many sprints, what each delivers, and dependencies. Reference file `docs/prototype-roadmap.md`, then use AskUserQuestion with these options:

Question: "How do you want to proceed with the Prototype Roadmap?"
Options:
- APPROVE — Accept the roadmap and proceed to Feature Pipeline
- MODIFY — Adjust sprint scope, reorder, or add/remove sprints
- REJECT — Discard and restart the roadmap

**On APPROVE:** Mark completed, proceed to Step 0.6 (Feature Pipeline)
**On MODIFY:** Gather feedback on sprint scope/ordering, revise
**On REJECT:** Reset to pending

---

### Step 0.6: Feature Pipeline (Sprint 1 Features)

**Precondition:** `roadmap_planner` status is `completed` or `skipped`

This step is iterative — it runs once per feature in Sprint 1.

**Action:**
1. Read the roadmap (`docs/prototype-roadmap.md`) to identify Sprint 1 features
2. Update state: step → `"feature_pipeline"`, status → `"in_progress"`
3. For each Sprint 1 feature that hasn't been processed:

   **a) Idea Brief (feature-spec-generator):**
   1. Read `.claude/skills/feature-spec-generator/SKILL.md`
   2. Follow that skill's instructions for this specific feature (idea brief mode)
   3. Save to `docs/ideas/[feature-name]-idea.md`
   4. Present to user for approval

   **b) Feature Spec (feature-spec-generator):**
   1. Read `.claude/skills/feature-spec-generator/SKILL.md`
   2. Follow that skill's instructions using the approved idea brief (full spec mode)
   3. Save to `docs/features/[feature-name].md`
   4. Present to user for approval

4. Track each feature's progress in `phase_0_progress.feature_pipeline.sprint_1_features`
5. When ALL Sprint 1 features have approved specs → Phase 0 is complete

**User Gate (per feature):**
STOP after each idea brief and each spec. Present a summary of the document produced, then use AskUserQuestion with these options:

For idea briefs:
Question: "How do you want to proceed with the [feature-name] Idea Brief?"
Options:
- APPROVE — Accept the idea brief and proceed to Feature Spec
- MODIFY — Provide feedback to revise the idea brief
- REJECT — Discard and restart this idea brief

For feature specs:
Question: "How do you want to proceed with the [feature-name] Feature Spec?"
Options:
- APPROVE — Accept the spec and move to next feature (or complete Phase 0)
- MODIFY — Provide feedback to revise the spec
- REJECT — Discard and restart this spec

---

### Phase 0 Completion → Transition to Sprint 1

When all Phase 0 steps are `completed` (or `skipped`):

1. Update state:
   - `lifecycle_phase` → `"prototype"`
   - `workflow_position` → `{ phase: "sprint", step: "A", status: "pending" }`
2. Initialize the first sprint entry in `sprints` array
3. Write state file
4. Display: "Phase 0 complete! All design documents approved. Ready to begin Sprint 1."
5. Proceed to Sprint Orchestration

---

## Sprint Orchestration

**Mode:** Multi-agent team. Use TeamCreate, Task, TaskCreate, SendMessage tools.

**Reference:** See `docs/agent-team-workflow.md` for full sprint details and `phase-transitions.md` for valid transitions.

### Sprint Setup

When beginning a new sprint:

1. Read the roadmap to identify this sprint's deliverable and features
2. Create git branch: `git checkout -b sprint/[N]-[short-description]`
3. Create team: `TeamCreate: team_name="sprint-[N]", description="Sprint [N]: [deliverable]"`
4. Add sprint entry to state:
   ```json
   {
     "sprint_number": N,
     "name": "[deliverable slice name]",
     "branch": "sprint/N-description",
     "lifecycle_phase": "[current lifecycle phase]",
     "current_phase": "A",
     "team_name": "sprint-N",
     "phases": {
       "A": { "status": "pending", "agents": [] },
       "B": { "status": "pending", "agents": [] },
       "B5": { "status": "pending", "checklist": {} },
       "C": { "status": "pending", "agents": [] },
       "D": { "status": "pending" }
     },
     "features": []
   }
   ```
5. Populate features from the roadmap/feature specs
6. Write state file
7. Transition to Phase A

---

### Phase A: Spec & Foundation

1. Update sprint `current_phase` → `"A"`, Phase A status → `"in_progress"`
2. Write state file
3. Spawn agents:

   **design-lead** (if specs need refinement):
   ```
   Task: name="design-lead", subagent_type="general-purpose", team_name="sprint-N"
   Prompt: "You are the design-lead agent. Read .claude/agents/design-lead.md for your role.
   Read CLAUDE.md and docs/agent-team-workflow.md for context.
   Your task: refine and finalize feature specs for Sprint N: [list features]"
   ```

   **systems-dev:**
   ```
   Task: name="systems-dev", subagent_type="general-purpose", team_name="sprint-N"
   Prompt: "You are the systems-dev agent. Read .claude/agents/systems-dev.md for your role.
   Read CLAUDE.md and docs/agent-team-workflow.md for context.
   Your task: implement system-level features for Sprint N. Read these specs: [list].
   Use the feature-implementer skill. Signal when foundation APIs are ready."
   ```

   **asset-artist:**
   ```
   Task: name="asset-artist", subagent_type="general-purpose", team_name="sprint-N"
   Prompt: "You are the asset-artist agent. Read .claude/agents/asset-artist.md for your role.
   Read CLAUDE.md and docs/agent-team-workflow.md for context.
   Your task: begin generating visual and audio assets for Sprint N features: [list]"
   ```

4. Create tasks via TaskCreate for each agent's work, with dependencies
5. Record spawned agents in Phase A state

**Transition to Phase B when:**
- All feature specs are approved by user
- systems-dev signals "foundation APIs ready"

---

### Phase B: Implementation

1. Update sprint `current_phase` → `"B"`, Phase B status → `"in_progress"`
2. Write state file
3. Spawn additional agents:

   **gameplay-dev:**
   ```
   Task: name="gameplay-dev", subagent_type="general-purpose", team_name="sprint-N"
   Prompt: "You are the gameplay-dev agent. Read .claude/agents/gameplay-dev.md for your role.
   Read CLAUDE.md, docs/agent-team-workflow.md, and docs/systems-bible.md for context.
   Your task: implement gameplay features for Sprint N. Read these specs: [list].
   Use the feature-implementer skill."
   ```

   **ui-dev:**
   ```
   Task: name="ui-dev", subagent_type="general-purpose", team_name="sprint-N"
   Prompt: "You are the ui-dev agent. Read .claude/agents/ui-dev.md for your role.
   Read CLAUDE.md, docs/agent-team-workflow.md, and docs/systems-bible.md for context.
   Your task: implement UI features for Sprint N. Read these specs: [list].
   Use the feature-implementer skill."
   ```

   **content-architect:**
   ```
   Task: name="content-architect", subagent_type="general-purpose", team_name="sprint-N"
   Prompt: "You are the content-architect agent. Read .claude/agents/content-architect.md for your role.
   Read CLAUDE.md and docs/agent-team-workflow.md for context.
   Your task: create data files for Sprint N features: [list]"
   ```

4. Keep asset-artist running from Phase A
5. Create tasks via TaskCreate for each feature, with `addBlockedBy` for dependencies

**Transition to Phase B.5 when:**
- All Phase B tasks are marked complete in TaskList

---

### Phase B.5: Integration Wiring (Team Lead)

**This phase is MANDATORY.** The team lead (you) personally verifies that all pieces built by independent agents actually connect. Skipping this phase was the #1 source of bugs in early sprints.

1. Update sprint `current_phase` → `"B5"`, Phase B5 status → `"in_progress"`
2. Write state file
3. Shut down all Phase B agents (they're done implementing)
4. Run the integration checklist below **in order**:

#### Integration Checklist

**Scene Instantiation Verification:**
- [ ] Every new `.tscn` created this sprint is instantiated or loaded by at least one other scene or script
- [ ] No orphaned scenes (search for `ExtResource` or `load()`/`preload()` references to each new scene)
- [ ] New UI scenes are added to the correct parent (e.g., HUD children go in `hud.tscn`)

**project.godot Verification:**
- [ ] `run/main_scene` points to the correct scene
- [ ] All new autoloads are registered in `[autoload]` section
- [ ] Input map includes any new actions added this sprint

**Signal Wiring Verification:**
- [ ] Every signal emitted by new code has at least one listener connected
- [ ] Every signal listener references a signal that actually exists in EventBus or the emitting node
- [ ] No duplicate signal connections (idempotency check)

**Collision Layer Verification:**
- [ ] New physics bodies use the correct collision layers per `docs/known-patterns.md` registry
- [ ] `collision_layer` (what I am) and `collision_mask` (what I detect) are not confused
- [ ] Area2D triggers have `collision_layer = 0` and `collision_mask` set to the target layer

**Group Membership Verification:**
- [ ] Nodes expected to be in groups (e.g., `"player"`, `"enemies"`) are added via `.add_to_group()` or scene property
- [ ] Code that calls `get_nodes_in_group()` or `is_in_group()` references groups that actually exist

**Naming Convention Verification:**
- [ ] Autoload scripts do NOT use `class_name` that matches the autoload name (use `FooClass` pattern)
- [ ] No `class_name` conflicts between scripts

**Spatial/Dimension Verification:**
- [ ] New rooms/levels use dimensions consistent with `docs/known-patterns.md` Reference Dimensions
- [ ] Spawned entities are positioned within room bounds
- [ ] Camera limits match room dimensions

**Cross-Feature Integration:**
- [ ] Features that share state (e.g., health system + HUD, boss + health bar) are actually wired together
- [ ] Room transitions preserve persistent entities (player, HUD)
- [ ] Save/load (if applicable) covers new state introduced this sprint

#### After Checklist

5. Run class cache rebuild: `godot --headless --editor --quit`
6. Run smoke test: `godot --headless --quit 2>&1`
7. If issues found → fix them directly, re-run smoke test
8. Record results in state:
   ```json
   "B5": {
     "status": "completed",
     "checklist": {
       "orphaned_scenes": "passed",
       "project_godot": "passed",
       "signals": "passed",
       "collision_layers": "passed",
       "groups": "passed",
       "naming": "passed",
       "dimensions": "passed",
       "cross_feature": "passed"
     },
     "issues_found": 0,
     "issues_fixed": 0,
     "smoke_test": "passed"
   }
   ```
9. GIT COMMIT (if fixes were needed): ask user to approve

**Transition to Phase C when:**
- All checklist items pass
- Smoke test passes

---

### Phase C: QA & Documentation

1. Update sprint `current_phase` → `"C"`, Phase C status → `"in_progress"`
2. Write state file
3. Spawn qa-docs:

   **qa-docs:**
   ```
   Task: name="qa-docs", subagent_type="general-purpose", team_name="sprint-N"
   Prompt: "You are the qa-docs agent. Read .claude/agents/qa-docs.md for your role.
   Read CLAUDE.md and docs/agent-team-workflow.md for context.
   Your tasks:
   1. Run code-reviewer on all new/modified scripts
   2. Update docs/systems-bible.md
   3. Update docs/architecture.md
   4. Update CHANGELOG.md
   Save reviews to docs/code-reviews/"
   ```

4. Keep developer agents running for critical issue fixes
5. Optionally spawn design-lead to pipeline next sprint's specs (parallel)

**Transition to Phase D when:**
- qa-docs completes all reviews
- Developers fix all critical issues
- **Headless smoke test passes** (see below)

### Phase C Exit: Headless Smoke Test

**Before transitioning to Phase D**, run the Godot headless smoke test.

**IMPORTANT — Godot Path:** The Godot binary may not be in PATH. Check the sprint state for `godot_path`. If not set, try these locations in order:
1. `godot` (if in PATH)
2. `/Users/*/Downloads/Godot.app/Contents/MacOS/Godot` (macOS download)
3. Ask the user for the path

Once found, record it in the sprint state as `"godot_path"` so future sprints don't need to search again.

**Procedure:**
1. After all QA fixes are applied, **rebuild the class cache first**:
   ```bash
   [godot_path] --headless --editor --quit 2>&1
   ```
   This is required whenever new `class_name` declarations were added this sprint. Skipping it causes stale cache errors that look like missing classes.

2. Run the headless smoke test:
   ```bash
   [godot_path] --headless --quit 2>&1
   ```

3. This catches compile/parse errors that would waste user time:
   - Script syntax errors
   - `class_name` conflicts with autoload singletons
   - Missing dependencies or broken resource references

4. **If errors are found:**
   - Read the error output and diagnose
   - Fix the issues directly (you are the team lead)
   - Rebuild class cache again if you changed any `class_name` declarations
   - Re-run the headless test
   - Repeat until it passes cleanly
5. **If clean:** Update state and transition to Phase D
6. Record the smoke test result in the sprint state:
   ```json
   "smoke_test": { "status": "passed", "attempts": 2, "errors_fixed": ["class_name conflict", "missing resource"] }
   ```

**CRITICAL:** Never present Phase D sprint review to the user until the headless smoke test passes. The user should never encounter compile errors.

---

### Phase D: Sprint Review (ITERATIVE USER GATE)

Phase D is **iterative** — it includes a fix loop where the user can report issues via screenshots or descriptions, the team lead fixes them, and the user re-tests. Bug reports during review are first-class workflow events, not interruptions.

#### Phase D Sub-States

Track the current sub-state in `workflow_position.substep`:

| Sub-State | Description |
|-----------|-------------|
| `smoke_test` | Running initial headless smoke test |
| `presenting_review` | Compiling and presenting the sprint review |
| `user_testing` | User is playtesting, may report issues |
| `fix_loop` | User reported issues, team lead is fixing |
| `final_approval` | Fix loop complete, presenting formal approval gate |

#### Step 1: Smoke Test

1. Update sprint `current_phase` → `"D"`, Phase D status → `"in_progress"`, substep → `"smoke_test"`
2. Write state file
3. Shut down all agents: `SendMessage: type="shutdown_request"` to each
4. `TeamDelete`
5. Clear `team_name` in sprint state
6. Run: `godot --headless --quit 2>&1`
7. If errors → fix them, re-run until clean
8. Update substep → `"presenting_review"`

#### Step 2: Present Sprint Review

**Compile Sprint Review** using this format (from workflow doc):

```markdown
# Sprint [N] Review: "[Deliverable Slice Name]"

## Completed Features
For each feature:
- **Feature name** — status: COMPLETE | PARTIAL | BLOCKED
- What was built (1-2 sentences)
- Files created/modified
- Deviations from spec (if any)

## QA Summary
- Critical issues found: [count]
- Performance warnings: [count]
- Code quality suggestions: [count]
- All critical issues resolved: YES/NO

## Smoke Test
- Status: PASSED (N attempts, errors fixed: [list or "none"])

## Assets Produced
- [list with paths]

## Content Produced
- [list with paths]

## Documentation Updated
- Systems bible: YES/NO
- Architecture doc: YES/NO
- Changelog: YES/NO

## Metrics
- Features planned: [N] | Completed: [N] | Carried over: [N]

## Next Sprint Preview
- Proposed deliverable: "[what player can do next]"
- Feature specs ready: [list]

## Questions for User
- [decisions needed]
```

Present the review and tell the user: "Please playtest the build in Godot. Report any bugs or issues (screenshots welcome), or proceed to the formal approval when ready."

Update substep → `"user_testing"`

#### Step 3: Fix Loop

When the user reports issues (screenshots, text descriptions, bug reports):

1. Update substep → `"fix_loop"`, increment `fix_loop_iteration` in state
2. **Diagnose** the reported issue
3. **Fix** the issue in code
4. **Re-run headless smoke test** (`godot --headless --quit 2>&1`) to verify the fix doesn't introduce new errors
5. **Report back** to the user: describe what was fixed, ask them to test again
6. Update substep → `"user_testing"`
7. **Repeat** as many times as needed — this loop has no iteration limit

Track fix loop history in the sprint state:
```json
"fix_loop": {
  "iterations": [
    { "reported_by": "user", "issue": "Parser error: class_name hides autoload", "fix": "Removed class_name from autoload scripts", "smoke_test": "passed" },
    { "reported_by": "user", "issue": "UI text too small at 1080p", "fix": "Increased theme font size and panel dimensions", "smoke_test": "passed" }
  ]
}
```

#### Step 4: Final Approval

When the user indicates they're satisfied (says "looks good", "ready to approve", or asks to proceed):

Update substep → `"final_approval"`

**Present formal approval gate** using AskUserQuestion for each decision point:

**Per-feature decisions** — For each feature, use AskUserQuestion:
Question: "What is your decision for [feature-name]?"
Options:
- ACCEPT — Feature is complete and acceptable
- REQUEST CHANGES — Send back for fixes (returns to Phase C)
- REJECT — Discard this feature's implementation

**Next sprint scope** — Use AskUserQuestion:
Question: "How do you want to proceed with the next sprint?"
Options:
- APPROVE — Accept the proposed next sprint scope
- MODIFY SCOPE — Adjust the next sprint's scope or reorder features
- REORDER — Change the sprint ordering

**Overall sprint decision** — Use AskUserQuestion:
Question: "What is your overall decision for Sprint [N]?"
Options:
- CONTINUE — Accept sprint results and move forward
- PAUSE — Pause development (can resume later)
- PIVOT — Significant direction change needed

**On Continue (all features accepted):**
1. Update Phase D status → `"completed"`, sprint `current_phase` → `"completed"`
2. Merge sprint branch: `git checkout main && git merge sprint/N-description`
3. Check if this is the last sprint in the current lifecycle phase:
   - If YES → proceed to Lifecycle Gate
   - If NO → proceed to next Sprint Setup
4. Write state file

**On Request Changes (any feature):**
1. Return to Phase C, re-spawn relevant agents
2. Update state accordingly

---

## Lifecycle Gates

### Prototype Gate (after all prototype sprints)

Present a summary to the user including sprints completed, core loop assessment, and known issues. Then use AskUserQuestion:

Question: "PROTOTYPE GO/NO-GO — Is this fun? How do you want to proceed?"
Options:
- GO — Proceed to Vertical Slice phase
- PIVOT — Revise GDD and re-prototype
- KILL — Stop development, return to concepts

**On GO:**
1. Update `lifecycle_phase` → `"vertical_slice"`
2. Update `lifecycle_gates.prototype_gate` → `{ status: "completed", decision: "GO" }`
3. Set `workflow_position` → `{ phase: "phase_0", step: "vertical_slice_gdd" }`
4. Run `gdd-generator` (vertical slice mode) → then `roadmap-planner` (vertical slice mode) → then feature pipeline
5. Then begin Vertical Slice sprints

**On PIVOT:**
1. Stay in `prototype`, record pivot reason
2. Reset to `gdd_generator` step, revise GDD
3. Plan new prototype sprints

**On KILL:**
1. Set `lifecycle_phase` → `"killed"`
2. Optionally restart from `game_ideator`

---

### Vertical Slice Gate (after all VS sprints)

Present a summary to the user including quality bar assessment and polish level. Then use AskUserQuestion:

Question: "VERTICAL SLICE GO/NO-GO — Can this be a good game? How do you want to proceed?"
Options:
- GO — Proceed to Production
- ITERATE — More polish sprints before moving on
- RESCOPE — Reduce production scope
- KILL — Stop development

Handle each decision similarly to the Prototype Gate, adjusting lifecycle phase and workflow position accordingly.

---

## State File Management

### Writing State

After EVERY state change:
1. Update `updated_at` to current timestamp
2. Write the complete state object to `docs/.workflow-state.json`
3. Use the Write tool (overwrite entire file — do not try to patch)

### Validation on Resume

When reading state on session start, validate:
1. For each step with status `completed`: check that the artifact file exists
2. If artifact is missing for a `completed` step: warn the user and use AskUserQuestion to ask whether to re-run or mark as skipped
3. For sprint state: verify the team exists (it won't survive session restarts — recreate if needed)

---

## Edge Cases

### User Requests to Skip a Step

If the user says "skip this" or "I don't need concept validation":

1. **WARN:** Present the consequences of skipping, then use AskUserQuestion:

   Question: "Skipping [step] means [specific consequence]. The workflow recommends this step because [reason]. Are you sure?"
   Options:
   - CONFIRM SKIP — Skip this step and proceed (accepts the risks)
   - CANCEL — Do not skip, continue with this step

   Consequence reference:
   - Skipping concept validation → feasibility risks unassessed
   - Skipping design bible → no pillars to guide design decisions
   - Skipping GDD → no shared design document for agents
   - Skipping roadmap → no sprint structure

2. If user selects CONFIRM SKIP: set step status to `"skipped"`, proceed to next step
3. **Never skip silently.** Always warn and require explicit confirmation via AskUserQuestion.

### User Requests to Backtrack

If the user says "go back to the GDD" or "redo the design bible":

1. Identify the target step
2. Present the consequences, then use AskUserQuestion:

   Question: "Going back to [step] will reset the following steps to pending: [list dependent steps]. Do you want to proceed?"
   Options:
   - CONFIRM BACKTRACK — Reset dependent steps and go back to [step]
   - CANCEL — Stay at the current step

3. If user selects CONFIRM BACKTRACK:
   - Set target step and all dependent steps to `"pending"` (cascade reset)
   - Clear their artifacts from state (files remain on disk)
   - Resume from target step
4. See `phase-transitions.md` for the full cascade reset table.

### User Requests to Jump Forward

If the user says "start Sprint 2" or "jump to vertical slice":

1. Check preconditions for the target position
2. List any incomplete prerequisites, then use AskUserQuestion:

   Question: "The following steps haven't been completed: [list]. Do you want to skip them all and jump to [target]?"
   Options:
   - CONFIRM JUMP — Mark all prerequisites as skipped and jump forward
   - CANCEL — Stay at the current step and complete prerequisites first

3. If user selects CONFIRM JUMP, skip all prerequisites and jump to target

### Session Restart Recovery

On every invocation, this skill reads the state file. Recovery logic:

| State Found | Action |
|-------------|--------|
| `in_progress` + artifact exists | Present artifact for approval |
| `in_progress` + no artifact | Re-run the step |
| `awaiting_user_approval` | Re-present artifact and ask for approval |
| `user_requested_changes` | Ask user for their feedback again |
| `completed` | Proceed to next step |
| Sprint with `team_name` set | Check if team exists; recreate if needed |
| Phase D substep `smoke_test` | Re-run the headless smoke test |
| Phase D substep `presenting_review` | Re-compile and present the sprint review |
| Phase D substep `user_testing` | Remind user they were playtesting, ask for status |
| Phase D substep `fix_loop` | Show the last reported issue and ask if the fix is still needed |
| Phase D substep `final_approval` | Re-present the formal approval gate |

---

## User Approval Protocol

Every user gate follows this consistent pattern using the **AskUserQuestion** tool:

1. **Present context** — Display a brief summary (1-3 sentences) of what was produced, the artifact file path, and any key decisions or tradeoffs.

2. **Use AskUserQuestion** — Instead of asking the user to type a response, always use the AskUserQuestion tool to present selectable options. This ensures a clean, clickable UX.

   Standard approval gate format:
   ```
   AskUserQuestion:
     Question: "How do you want to proceed with [Step Name]?"
     Options:
       - APPROVE — Accept and proceed to [next step]
       - MODIFY — Provide feedback for revision
       - REJECT — Discard and restart this step
   ```

3. **Follow-up questions** — If additional input is needed after a selection (e.g., which concept to pick, what feedback to give), use additional AskUserQuestion calls or ask the user for free-text input as appropriate.

4. **Lifecycle gates** use GO/PIVOT/KILL (or GO/ITERATE/RESCOPE/KILL) options instead of APPROVE/MODIFY/REJECT.

5. **Confirmation gates** (skip, backtrack, jump forward) use CONFIRM/CANCEL options.

**CRITICAL:** Do NOT proceed past any approval gate without an explicit user selection via AskUserQuestion. If the user changes the subject or asks an unrelated question, the gate remains active. When they return to the workflow, re-present the gate using AskUserQuestion.
