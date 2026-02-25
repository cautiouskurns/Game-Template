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
    "art_reference_collector": { "status": "pending", "artifact": null, "approved_at": null },
    "audio_reference_collector": { "status": "pending", "artifact": null, "approved_at": null },
    "narrative_reference_collector": { "status": "pending", "artifact": null, "approved_at": null },
    "game_vision_generator": { "status": "pending", "artifact": null, "approved_at": null },
    "gdd_generator": { "status": "pending", "artifact": null, "approved_at": null },
    "roadmap_planner": { "status": "pending", "artifact": null, "approved_at": null },
    "feature_pipeline": {
      "sprint_1_features": [],
      "sprint_2_features": [],
      "sprint_3_features": [],
      "sprint_4_features": []
    }
  },
  "epics": [],
  "sprints": [],
  "lifecycle_gates": {
    "prototype_gate": { "status": "pending", "decision": null, "decided_at": null },
    "vertical_slice_gate": { "status": "pending", "decision": null, "decided_at": null }
  }
}
```

---

## CRITICAL: Skill Invocation Protocol

Every Phase 0 step and every sprint agent task requires reading a specific skill file.
The mapping is defined in `skill-registry.json` (in this skill's directory).

Before executing ANY step:
1. Look up the current step in `skill-registry.json` to find the required `skill` path
2. Read that skill file using the Read tool
3. Then proceed with the skill's instructions

A PreToolUse hook (`enforce-skill-read.sh`) enforces this — artifact writes are blocked unless the required skill was read first. A PostToolUse hook (`track-skill-read.sh`) automatically records skill reads in the state file's `skill_reads` field.

This is **NON-NEGOTIABLE** even if you "know" what the skill does. The hooks track reads mechanically and will block writes if the read didn't happen in the current step.

---

## CRITICAL: Structured Output Formats

All status updates, deliveries, and transitions MUST use the standardized report formats defined in:

```
.claude/skills/project-orchestrator/report-formats.md
```

**Read this file at the start of every session.** It defines templates for:
- Status dashboard (on every invocation)
- Phase transition cards (A→B, B→B.5, etc.)
- Feature delivery cards (when a feature is implemented)
- Sprint summary cards (sprint start and sprint review)
- Epic review banners
- Lifecycle gate banners
- Integration check reports
- Document update logs
- Fix loop reports
- Playtest guides (Phase D, per sprint)

**Rules:**
- Never freeform a status update — always use the matching template
- Banners (`══`) for milestones only (sprint start/end, epic reviews, gates)
- Cards (`──`) for deliverables (features, phase completions, artifacts)
- Logs for supporting details (doc updates, file lists)

---

## CRITICAL: Report Delivery Protocol (Hook-Enforced)

A PreToolUse hook (`enforce-report-delivery.sh`) blocks ALL artifact writes when `pending_reports` in the state file is non-empty. This ensures reports are always delivered at transition points.

### How It Works

1. When you reach a transition point, **set `pending_reports`** in the state file with the required report type(s)
2. **Present the report** using the correct format from `report-formats.md`
3. **Clear `pending_reports`** (set to `[]`) in the state file
4. Now artifact writes are unblocked and you can continue

### Transition → Required Report Mapping

| Transition | Set `pending_reports` to | Report Format |
|------------|--------------------------|---------------|
| Sprint Phase D approved (CONTINUE) | `["sprint_end_review"]` | Sprint End Review (#4) |
| Starting a new sprint (before Phase A) | `["sprint_start"]` | Sprint Start Card (#4) |
| All sprints in epic completed | `["epic_review"]` | Epic Review Banner (#5) |
| Lifecycle gate reached | `["lifecycle_gate"]` | Lifecycle Gate Banner (#6) |
| Phase B.5 completed | `["integration_check"]` | Integration Check Report (#8) |
| Phase A→B, B→B.5, C→D | `["phase_transition"]` | Phase Transition Card (#2) |

### Multiple Reports

When multiple reports are required at the same transition (e.g., sprint completes AND epic completes), set all of them:
```json
"pending_reports": ["sprint_end_review", "epic_review"]
```

Present each report in order, then clear `pending_reports` to `[]`.

### Example Flow: Sprint Completion → Next Sprint

```
1. User approves Sprint N Phase D → CONTINUE
2. Write state: sprint.current_phase = "completed", pending_reports = ["sprint_end_review"]
3. Present Sprint End Review card (format #4)
4. Check: is this the last sprint in the epic?
   - If YES: write state: pending_reports = ["epic_review", "sprint_start"]
   - If NO: write state: pending_reports = ["sprint_start"]
5. Present Epic Review banner if required (format #5)
6. Present Sprint Start card (format #4)
7. Write state: pending_reports = []
8. NOW you can write feature specs and other artifacts
```

This is **NON-NEGOTIABLE**. The hook will block writes to `docs/features/`, `scripts/`, `scenes/`, and all other artifact paths until `pending_reports` is empty.

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
- APPROVE — Accept the design pillars and creative direction, proceed to Full Game Vision
- MODIFY — Provide feedback on pillars/tone for revision
- REJECT — Discard and start the Design Bible fresh

**On APPROVE:** Mark completed, proceed to Steps 0.3a/0.3b/0.3c (Reference Collection) or skip to Step 0.4 if user declines
**On MODIFY:** Gather specific feedback on pillars/tone, revise
**On REJECT:** Reset to pending, start fresh

---

### Step 0.3a: Art Reference Collection (Optional)

**Precondition:** `design_bible_updater` status is `completed` or `skipped`

**Action:**
1. Update state: step → `"art_reference_collector"`, status → `"in_progress"`
2. Write state file
3. Read `.claude/skills/art-reference-collector/SKILL.md`
4. Follow that skill's instructions: identify reference game, gather images, analyze style, select style anchors
5. Save output to `docs/art-direction.md` and style anchors to `assets/references/`
6. Update artifact and status → `"awaiting_user_approval"`
7. Write state file

**User Gate:**
STOP. Present a summary of: reference images collected per category, style analysis highlights (palette, line style, scale), which images were selected as style anchors. Reference file `docs/art-direction.md`, then use AskUserQuestion:

Question: "How do you want to proceed with Art Direction?"
Options:
- APPROVE — Accept the art direction, proceed
- MODIFY — Change style anchors, adjust analysis, add more references
- SKIP — Skip art direction (asset-artist will use default prompts without style anchors)

---

### Step 0.3b: Audio Reference Collection (Optional)

**Precondition:** `design_bible_updater` status is `completed` or `skipped`

**Action:**
1. Update state: step → `"audio_reference_collector"`, status → `"in_progress"`
2. Write state file
3. Read `.claude/skills/audio-reference-collector/SKILL.md`
4. Follow that skill's instructions: research audio identity, find Epidemic Sound matches, build search anchor tables
5. Save output to `docs/audio-direction.md`
6. Update artifact and status → `"awaiting_user_approval"`
7. Write state file

**User Gate:**
STOP. Present a summary of: audio identity analysis (genre, mood, instrumentation), Epidemic Sound matches found per context, search anchor table. Reference file `docs/audio-direction.md`, then use AskUserQuestion:

Question: "How do you want to proceed with Audio Direction?"
Options:
- APPROVE — Accept the audio direction, proceed
- MODIFY — Adjust mood targets, add references, change priorities
- SKIP — Skip audio direction (asset-artist will search Epidemic Sound ad-hoc)

---

### Step 0.3c: Narrative Reference Collection (Optional)

**Precondition:** `design_bible_updater` status is `completed` or `skipped`

**Action:**
1. Update state: step → `"narrative_reference_collector"`, status → `"in_progress"`
2. Write state file
3. Read `.claude/skills/narrative-reference-collector/SKILL.md`
4. Follow that skill's instructions: analyze story structure, dialogue voice, lore delivery, worldbuilding patterns
5. Save output to `docs/narrative-direction.md`
6. Update artifact and status → `"awaiting_user_approval"`
7. Write state file

**User Gate:**
STOP. Present a summary of: narrative structure (model, lore hierarchy, dialogue voice), emotional design targets, key templates created. Reference file `docs/narrative-direction.md`, then use AskUserQuestion:

Question: "How do you want to proceed with Narrative Direction?"
Options:
- APPROVE — Accept the narrative direction, proceed
- MODIFY — Adjust tone, change lore delivery priorities, add references
- SKIP — Skip narrative direction (downstream skills use their own defaults)

---

### Step 0.4: Full Game Vision

**Precondition:** `design_bible_updater` status is `completed` or `skipped`. Reference collectors (0.3a-c) are `completed`, `skipped`, or `pending` (they don't block the vision).

**Action:**
1. Update state: step → `"game_vision_generator"`, status → `"in_progress"`
2. Write state file
3. Read `.claude/skills/game-vision-generator/SKILL.md`
4. Follow that skill's instructions: work through the interactive visioning process with the user to capture the complete game
5. Save output to `docs/game-vision.md`
6. Update state: `phase_0_progress.game_vision_generator.artifact` → `"docs/game-vision.md"`
7. Update state: `status` → `"awaiting_user_approval"`
8. Write state file

**User Gate:**
STOP. Present a summary of the vision including: game identity, total mechanics cataloged, scope map breakdown (how many features per lifecycle phase), and key design decisions. Reference file `docs/game-vision.md`. Emphasize that this vision is the master plan — GDDs will scope down from it. Then use AskUserQuestion with these options:

Question: "How do you want to proceed with the Full Game Vision?"
Options:
- APPROVE — Accept the vision and proceed to Prototype GDD
- MODIFY — Provide feedback to adjust mechanics, scope, or priorities
- REJECT — Discard and restart the vision

**On APPROVE:** Mark completed, proceed to Step 0.5
**On MODIFY:** Gather specific feedback, revise relevant sections
**On REJECT:** Reset to pending, start fresh

---

### Step 0.5: Prototype GDD

**Precondition:** `game_vision_generator` status is `completed` or `skipped`. The GDD should reference `docs/game-vision.md` to scope down to prototype-appropriate features.

**Action:**
1. Update state: step → `"gdd_generator"`, status → `"in_progress"`
2. Write state file
3. Read `.claude/skills/gdd-generator/SKILL.md`
4. Follow that skill's instructions: create the Game Design Document through interactive Q&A, scoping from the approved Game Vision
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

**On APPROVE:** Mark completed, proceed to Step 0.6
**On MODIFY:** Gather feedback, revise specific sections
**On REJECT:** Reset to pending

---

### Step 0.6: Prototype Roadmap

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

**On APPROVE:** Mark completed, proceed to Step 0.7 (Feature Pipeline)
**On MODIFY:** Gather feedback on sprint scope/ordering, revise
**On REJECT:** Reset to pending

---

### Step 0.7: Feature Pipeline (Sprint 1 Features)

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

4. Track each feature's progress in `phase_0_progress.feature_pipeline.sprint_N_features` using this per-feature structure:
   ```json
   {
     "name": "feature-name",
     "idea_brief": { "status": "pending|skipped|completed", "artifact": null },
     "feature_spec": { "status": "pending|completed", "artifact": "docs/features/feature-name.md", "approved_at": null }
   }
   ```
   Populate entries for ALL sprints defined in the roadmap (not just Sprint 1). Future sprint features start with `"status": "pending"`.
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

1. Read the roadmap to identify this sprint's deliverable, features, and **parent epic**
1a. **Validate sprint scope** — check feature count against limits:
    - Prototype: max 2 features
    - Vertical Slice: max 3 features
    - Production: max 4 features
    If the roadmap assigns more features than the limit, split into multiple sprints and inform the user.
1b. **Ensure epic exists in state** — if this is the first sprint of an epic, add the epic:
    ```json
    {
      "epic_number": E,
      "name": "[Player-facing goal from roadmap]",
      "lifecycle_phase": "[current lifecycle phase]",
      "status": "in_progress",
      "sprint_numbers": [N],
      "review": null
    }
    ```
    If the epic already exists, append this sprint number to `sprint_numbers`.
2. Create git branch: `git checkout -b sprint/[N]-[short-description]`
3. Create team: `TeamCreate: team_name="sprint-[N]", description="Sprint [N]: [deliverable]"`
4. Add sprint entry to state with **full detail** — including all tasks from the roadmap pre-populated:
   ```json
   {
     "sprint_number": N,
     "name": "[deliverable slice name]",
     "epic_number": E,
     "branch": "sprint/N-description",
     "lifecycle_phase": "[current lifecycle phase]",
     "current_phase": "A",
     "team_name": "sprint-N",
     "godot_path": null,
     "phases": {
       "A": { "status": "pending", "agents": [], "completed_at": null, "notes": null },
       "B": { "status": "pending", "agents": [], "completed_at": null, "notes": null },
       "B5": { "status": "pending", "checklist": {}, "issues_found": 0, "issues_fixed": 0, "smoke_test": null, "notes": null },
       "C": { "status": "pending", "agents": [], "completed_at": null, "notes": null },
       "D": { "status": "pending", "substep": null, "fix_loop": { "iterations": [] }, "approval": {} }
     },
     "features": ["feature-name-1", "feature-name-2"],
     "tasks": []
   }
   ```
5. **Populate tasks from the roadmap** — read `docs/prototype-roadmap.md` (or equivalent) and create a task entry for EVERY task listed in this sprint, using this schema:
   ```json
   {
     "id": "SYS-N.M",
     "agent": "systems-dev|gameplay-dev|ui-dev|content-architect|asset-artist|team-lead",
     "phase": "A|B|B5|C|D",
     "feature": "feature-name or null for integration/bug tasks",
     "description": "What this task does — one line",
     "status": "pending|completed",
     "files_created": [],
     "files_modified": [],
     "completed_at": null,
     "notes": null
   }
   ```
   Task ID prefixes: `SYS-` (systems-dev), `GP-` (gameplay-dev), `UI-` (ui-dev), `CON-` (content-architect), `ART-` (asset-artist), `TL-` (team-lead).
   Include tasks for ALL phases (A, B, B5, C, D) that are defined in the roadmap.
6. Populate features list from the roadmap/feature specs
7. Write state file
8. Transition to Phase A

**IMPORTANT — Task Tracking During Sprint:**
- When a task is completed: update its `status` to `"completed"`, fill in `files_created`, `files_modified`, `completed_at`, and `notes`
- When Phase D fix loop iterations occur: add `TL-` tasks for each fix
- When phases complete: update `completed_at` and `notes` on the phase entry
- When B.5 integration runs: fill in `checklist`, `issues_found`, `issues_fixed`, `smoke_test`
- When Phase D approval occurs: fill in the `approval` object with per-feature decisions

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
   Check for docs/art-direction.md — if it exists, read it for style anchors and palette.
   Check for docs/audio-direction.md — if it exists, read it for music/SFX search anchors.
   Your task: generate visual and audio assets for Sprint N features: [list]"
   ```

4. Create tasks via TaskCreate for each agent's work, with dependencies
5. Record spawned agents in Phase A state: `phases.A.agents = ["systems-dev", "asset-artist"]`

**As tasks complete:** Update the corresponding task entry in `sprints[N].tasks` with `status: "completed"`, `files_created`, `files_modified`, `completed_at`, and `notes`.

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

**As tasks complete:** Update the corresponding task entry in `sprints[N].tasks` with `status: "completed"`, `files_created`, `files_modified`, `completed_at`, and `notes`. When the phase finishes, update `phases.B.completed_at` and `phases.B.notes`.

**Per-Feature Progress Reports:**

As each feature is completed by an implementing agent, **present a Feature Completion Report to the user**. This is a non-blocking progress update — the sprint continues. Use this format:

```
## Feature Complete: [Feature Name]

### What Was Built
[2-3 sentences: what this feature does and why]

### What's Different Now
- [Visible change 1]
- [Visible change 2]

### How to Playtest
1. [Steps to test]
2. Success: [what confirms it works]

### Known Limitations
- [Anything not yet wired up or placeholder]
```

The user does not need to respond. If they raise concerns, address them before continuing. Otherwise proceed to the next feature.

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
7. **Review captured output:** The `capture-smoke-test.sh` hook automatically logs all smoke test output to:
   - `docs/sprint-logs/sprint-{N}-smoke-test.log` — Human-readable log with categorized errors/warnings
   - `docs/sprint-logs/sprint-{N}-smoke-test-latest.json` — Machine-readable summary with error counts

   Read the latest JSON summary to confirm the captured result matches your assessment before proceeding.

**CRITICAL:** Never present Phase D sprint review to the user until the headless smoke test passes. The user should never encounter compile errors.

---

### Phase D: Sprint Review (ITERATIVE USER GATE)

Phase D is **iterative** — it includes a fix loop where the user can report issues via screenshots or descriptions, the team lead fixes them, and the user re-tests. Bug reports during review are first-class workflow events, not interruptions.

#### Phase D Sub-States

Track the current sub-state in `workflow_position.substep`:

| Sub-State | Description |
|-----------|-------------|
| `smoke_test` | Running initial headless smoke test |
| `generating_playtest_guide` | Generating playtest guide from feature specs + sprint tasks |
| `presenting_review` | Compiling and presenting the sprint review + playtest guide |
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
8. Update substep → `"generating_playtest_guide"`

#### Step 2: Generate Playtest Guide

1. Update substep → `"generating_playtest_guide"` (if not already set)
2. Gather context from these sources:
   - **Feature specs** (`docs/features/{name}.md`) — what each feature does, acceptance criteria
   - **Sprint tasks** (workflow state `sprints[N].tasks`) — what was actually built, files created/modified
   - **`project.godot`** — `run/main_scene` for the entry point scene
   - **Systems bible** (`docs/systems-bible.md`) — navigation flow between scenes (how to reach each feature)
   - **Previous playtest guide** (`docs/sprint-logs/sprint-{N-1}-playtest-guide.md`, if exists) — for the "Cumulative Game State" section baseline
3. Generate `docs/sprint-logs/sprint-{N}-playtest-guide.md` using the Playtest Guide template from `report-formats.md` (format #10)
4. Update substep → `"presenting_review"`
5. Present the playtest guide path alongside the sprint review in the next step

#### Step 3: Present Sprint Review

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
- Full log: `docs/sprint-logs/sprint-{N}-smoke-test.log`

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

Present the review and reference the playtest guide: "The playtest guide is at `docs/sprint-logs/sprint-{N}-playtest-guide.md` — it has step-by-step test instructions for each feature. Report any bugs or issues (screenshots welcome), or proceed to the formal approval when ready."

Update substep → `"user_testing"`

#### Step 4: Fix Loop

When the user reports issues (screenshots, text descriptions, bug reports):

1. Update substep → `"fix_loop"`, increment `fix_loop_iteration` in state
2. **Diagnose** the reported issue
3. **Fix** the issue in code
4. **Re-run headless smoke test** (`godot --headless --quit 2>&1`) to verify the fix doesn't introduce new errors
5. **Report back** to the user: describe what was fixed, ask them to test again
6. Update substep → `"user_testing"`
7. **Repeat** as many times as needed — this loop has no iteration limit

Track fix loop history in the sprint state, and add a corresponding `TL-` task for each fix:
```json
"fix_loop": {
  "iterations": [
    { "reported_by": "user", "issue": "Parser error: class_name hides autoload", "fix": "Removed class_name from autoload scripts", "smoke_test": "passed", "task_id": "TL-N.1" },
    { "reported_by": "user", "issue": "UI text too small at 1080p", "fix": "Increased theme font size and panel dimensions", "smoke_test": "passed", "task_id": "TL-N.2" }
  ]
}
```
Each fix loop iteration must also create a task entry in `sprints[N].tasks`:
```json
{ "id": "TL-N.M", "agent": "team-lead", "phase": "D", "feature": null, "description": "Fix: [issue summary]", "status": "completed", "files_created": [], "files_modified": ["affected files"], "completed_at": "[timestamp]", "notes": "[details]" }
```

#### Step 5: Final Approval

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

**Record approval decisions** in the sprint state:
```json
"approval": {
  "feature-name-1": "accepted|request_changes|rejected",
  "feature-name-2": "accepted|request_changes|rejected",
  "next_sprint": "approved|modified|reordered",
  "overall": "continue|pause|pivot"
}
```

**On Continue (all features accepted):**
1. Update Phase D status → `"completed"`, sprint `current_phase` → `"completed"`
2. Merge sprint branch: `git checkout main && git merge sprint/N-description`
3. **Check epic completion** — read the current epic from state. If this was the last sprint in the epic's `sprint_numbers`:
   - Present the **Epic Review** (see below)
   - Wait for user decision before proceeding
4. Check if this is the last sprint in the current lifecycle phase:
   - If YES → proceed to Lifecycle Gate
   - If NO → proceed to next Sprint Setup (which begins the next epic if applicable)
5. Write state file

**On Request Changes (any feature):**
1. Return to Phase C, re-spawn relevant agents
2. Update state accordingly

---

## Epic Review

When the final sprint in an epic is completed (all sprint numbers in `epic.sprint_numbers` have `current_phase: "completed"`), present an Epic Review before starting the next epic.

### Presenting the Epic Review

Compile and present this format:

```markdown
## Epic Review: "[Epic Goal]"

### Goal Assessment
- Epic goal: [What we set out to achieve]
- Achieved: [YES / PARTIAL / NO]
- Evidence: [What the user can now do in-game that proves it]

### Sprints Completed
- Sprint N: "[deliverable]" — [accepted / partially accepted]
- Sprint N+1: "[deliverable]" — [accepted / partially accepted]

### Lessons Learned
- [What worked well]
- [What to improve for next epic]

### Next Epic Preview
- Epic: "[Next goal]"
- Sprints planned: [count]
- First sprint: "[deliverable]"
```

Then use AskUserQuestion:

Question: "How do you want to proceed after Epic [N]: '[Goal]'?"
Options:
- PROCEED — Move to the next epic
- ITERATE — Add a fix sprint to address gaps in this epic's goal
- PAUSE — Pause to reassess direction before continuing

**On PROCEED:**
1. Update epic status → `"completed"`, set `review.goal_achieved` and `review.user_decision` → `"proceed"`, `review.reviewed_at`
2. Write state file
3. Proceed to next Sprint Setup (first sprint of next epic)

**On ITERATE:**
1. Update epic status → `"iterated"`, set `review.goal_achieved` → `"partial"`, `review.user_decision` → `"iterate"`
2. Create a new iteration sprint at the end of the epic's `sprint_numbers`
3. Discuss scope with user, then proceed to Sprint Setup for the iteration sprint

**On PAUSE:**
1. Update `review.user_decision` → `"pause"`, `review.reviewed_at`
2. Write state file
3. Wait for user to resume — on next `/project-orchestrator` invocation, re-present the pause state

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
3. **Update the Game Vision** — Read `.claude/skills/game-vision-generator/SKILL.md` and update `docs/game-vision.md` based on prototype learnings (what worked, what didn't, scope adjustments). Present changes for user approval.
4. Set `workflow_position` → `{ phase: "phase_0", step: "vertical_slice_gdd" }`
5. Run `gdd-generator` (vertical slice mode, scoping from updated vision) → then `roadmap-planner` (vertical slice mode) → then feature pipeline
6. Then begin Vertical Slice sprints

**On PIVOT:**
1. Stay in `prototype`, record pivot reason
2. **Update the Game Vision** if the pivot changes the overall game direction
3. Reset to `gdd_generator` step, revise GDD
4. Plan new prototype sprints

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
| Phase D substep `generating_playtest_guide` | Check if playtest guide file exists; if yes, advance to `presenting_review`; if no, regenerate it |
| Phase D substep `presenting_review` | Re-compile and present the sprint review + reference playtest guide |
| Phase D substep `user_testing` | Remind user they were playtesting, reference playtest guide, ask for status |
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
