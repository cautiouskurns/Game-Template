# Valid Phase Transitions

Reference document for the project-orchestrator skill. Defines all valid state transitions in the workflow.

---

## Phase 0 Sequence (strictly linear)

Each step requires the previous step to have status `completed` (or `skipped` with user confirmation).

```
pre_phase_0
    ↓
game_ideator → concept_validator → design_bible_updater →
gdd_generator → roadmap_planner → feature_pipeline
    ↓
sprint (transition to Sprint 1)
```

### Phase 0 Step Details

| Step | Produces | Approval Required |
|------|----------|-------------------|
| `game_ideator` | `docs/ideas/game-concepts.md` | User selects concept direction |
| `concept_validator` | `docs/ideas/concept-validation.md` | User reviews risks, decides to proceed |
| `design_bible_updater` | `docs/design-bible.md` | User approves pillars and tone |
| `gdd_generator` | `docs/prototype-gdd.md` | User approves GDD |
| `roadmap_planner` | `docs/prototype-roadmap.md` | User approves sprint breakdown |
| `feature_pipeline` | `docs/ideas/*.md` + `docs/features/*.md` | User approves each idea brief and spec |

---

## Sprint Phase Sequence (per sprint, strictly linear)

```
Phase A (Spec & Foundation)
    ↓  [when: specs approved + systems-dev signals APIs ready]
Phase B (Implementation)
    ↓  [when: all Phase B tasks complete]
Phase C (QA & Documentation)
    ↓  [when: QA passes + critical issues fixed + headless smoke test passes]
Phase D (Sprint Review — ITERATIVE USER GATE)
    ├── smoke_test → presenting_review → user_testing
    ├── ↔ fix_loop (user reports issues → team lead fixes → user re-tests)
    └── final_approval → [when: user approves sprint]
Next Sprint Phase A  OR  Lifecycle Gate
```

### Sprint Phase Agent Mapping

| Phase | Agents to Spawn | Agents to Keep | Agents to Shut Down |
|-------|-----------------|----------------|---------------------|
| A | design-lead, systems-dev, asset-artist | — | — |
| B | gameplay-dev, ui-dev, content-architect | asset-artist | design-lead (optional) |
| C | qa-docs | developers (for fixes), design-lead (pipelines next sprint) | Phase B agents not needed |
| D | — (team lead only) | — | All agents shut down, team deleted |

### Phase Transition Conditions

| Transition | Condition |
|------------|-----------|
| A → B | All feature specs approved by user AND systems-dev reports foundation APIs ready |
| B → C | All Phase B tasks marked complete in TaskList |
| C → D | qa-docs completes review AND developers fix all critical issues AND `godot --headless --quit` passes cleanly |
| D → next A | User approves sprint review (after fix loop completes) AND approves next sprint scope |

### Phase D Sub-State Sequence

```
smoke_test → presenting_review → user_testing ↔ fix_loop → final_approval
```

| Sub-State | Description | Transitions To |
|-----------|-------------|---------------|
| `smoke_test` | Run `godot --headless --quit`, fix any errors | `presenting_review` (when clean) |
| `presenting_review` | Compile and present sprint review to user | `user_testing` |
| `user_testing` | User is playtesting the build | `fix_loop` (if issues reported) OR `final_approval` (if satisfied) |
| `fix_loop` | Team lead fixes reported issues, re-runs smoke test | `user_testing` (after fix applied) |
| `final_approval` | Present formal ACCEPT/REJECT/CHANGES gate | `completed` OR Phase C (if changes requested) |

**Fix loop has no iteration limit.** It repeats until the user is satisfied. Each iteration is tracked in the state file for audit trail.

---

## Lifecycle Transitions

```
not_started → prototype     [when: Phase 0 completes, first sprint begins]
prototype → vertical_slice  [when: Gate 1 decision = GO]
prototype → prototype       [when: Gate 1 decision = PIVOT — revise GDD, re-prototype]
prototype → killed          [when: Gate 1 decision = KILL]
vertical_slice → production [when: Gate 2 decision = GO]
vertical_slice → vertical_slice [when: Gate 2 decision = ITERATE or RESCOPE]
vertical_slice → killed     [when: Gate 2 decision = KILL]
```

### Lifecycle Gate Triggers

| Gate | Triggers When | Skill to Run After |
|------|--------------|-------------------|
| Prototype Gate | All prototype sprints completed + approved | `gdd-generator` (vertical slice mode, on GO) |
| Vertical Slice Gate | All vertical slice sprints completed + approved | `gdd-generator` (production mode, on GO) |

### Gate Decision Effects

**Prototype Gate (Gate 1):**

| Decision | Effect |
|----------|--------|
| GO | Set `lifecycle_phase` to `vertical_slice`, run `gdd-generator` (vertical slice mode) + `roadmap-planner` (vertical slice mode) |
| PIVOT | Stay in `prototype`, reset GDD step, re-run design pipeline from `gdd_generator` |
| KILL | Set `lifecycle_phase` to `killed`, optionally restart from `game_ideator` |

**Vertical Slice Gate (Gate 2):**

| Decision | Effect |
|----------|--------|
| GO | Set `lifecycle_phase` to `production`, run `gdd-generator` (production mode) + `roadmap-planner` (production mode) |
| ITERATE | Stay in `vertical_slice`, plan additional polish sprints |
| RESCOPE | Stay in `vertical_slice`, reduce production scope, update GDD |
| KILL | Set `lifecycle_phase` to `killed` |

---

## Backtrack Rules

When the user requests to backtrack to an earlier step:

1. **Within Phase 0:** Set target step and all subsequent steps to `pending`. Feature pipeline entries are cleared if backtracking before `roadmap_planner`.

2. **Within a Sprint:** Reset target phase and all later phases to `pending`. Cannot backtrack across sprints (start a new sprint instead).

3. **Across Lifecycle Phases:** Not supported directly. User must explicitly decide at lifecycle gates. If they want to return to prototyping from vertical slice, that's a gate decision (PIVOT-equivalent).

### Cascade Reset Table

| Backtrack To | Steps Reset to Pending |
|-------------|----------------------|
| `game_ideator` | All Phase 0 steps + feature pipeline |
| `concept_validator` | concept_validator through feature pipeline |
| `design_bible_updater` | design_bible through feature pipeline |
| `gdd_generator` | GDD through feature pipeline |
| `roadmap_planner` | roadmap + feature pipeline |
| `feature_pipeline` | feature pipeline only |
| Sprint Phase A | Phases A, B, C, D of current sprint |
| Sprint Phase B | Phases B, C, D of current sprint |
| Sprint Phase C | Phases C, D of current sprint |

---

## Skip Rules

Any Phase 0 step can be skipped with explicit user confirmation. The orchestrator must:

1. Warn: "Skipping [step] means [consequence]"
2. Require explicit user confirmation
3. Set step status to `skipped` (not `completed`)
4. Record the skip in state

Sprint phases cannot be skipped — they represent necessary workflow stages.
