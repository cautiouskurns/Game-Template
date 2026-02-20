# Standardized Report Formats

Reference document for all structured output the orchestrator and agents produce during the workflow. Every checkpoint, delivery, and transition uses one of these formats to keep the chat scannable.

---

## Visual Hierarchy

| Level | When | Style |
|-------|------|-------|
| **Banner** | Lifecycle gates, epic completions, phase transitions | `══════` double-line box |
| **Card** | Sprint start/end, feature deliveries, phase completions | `──────` single-line box |
| **Log** | Document updates, file changes, minor status updates | Compact bullet list with header |

---

## 1. Status Dashboard (on every orchestrator invocation)

Used every time the orchestrator is invoked or resumes from a session restart.

```
╔══════════════════════════════════════════════════╗
║  Project: {project_name}
║  Lifecycle: {lifecycle_phase}
║  Epic: {epic_name} (Epic {N})
║  Sprint: {sprint_number} — "{sprint_name}"
║  Phase: {current_phase} | Status: {status}
╠══════════════════════════════════════════════════╣
║  Next: {what happens next}
╚══════════════════════════════════════════════════╝
```

---

## 2. Phase Transition Card

Used when moving between sprint phases (A→B, B→B.5, B.5→C, C→D) or Phase 0 steps.

```
┌─ PHASE {X} COMPLETE ─────────────────────────────┐
│                                                    │
│  Sprint {N}: "{sprint_name}"                       │
│                                                    │
│  Delivered:                                        │
│    • {what was built/done, 1 line per item}        │
│    • {next item}                                   │
│                                                    │
│  Files changed:                                    │
│    + {new_file.gd}                                 │
│    ~ {modified_file.gd}                            │
│                                                    │
│  ▸ Moving to: Phase {Y}                            │
└────────────────────────────────────────────────────┘
```

**Symbols:** `+` = created, `~` = modified, `-` = deleted

---

## 3. Feature Delivery Card

Used when a feature implementation is complete (during Phase B), or when a Phase 0 artifact is produced.

```
┌─ FEATURE DELIVERED ──────────────────────────────┐
│                                                   │
│  {Feature Name}                                   │
│  Spec: {path/to/spec.md}                          │
│  Agent: {agent_name}                              │
│                                                   │
│  What was built:                                  │
│    • {concrete deliverable 1}                     │
│    • {concrete deliverable 2}                     │
│                                                   │
│  New files:                                       │
│    + {scenes/gameplay/orb.tscn}                   │
│    + {scripts/entities/orb.gd}                    │
│                                                   │
│  Modified files:                                  │
│    ~ {scripts/autoloads/event_bus.gd}             │
│    ~ {scenes/gameplay/game_arena.tscn}            │
│                                                   │
│  How to test:                                     │
│    1. {step to verify it works}                   │
│    2. Success = {what confirms it works}          │
│                                                   │
│  Status: COMPLETE                                 │
└───────────────────────────────────────────────────┘
```

For Phase 0 artifacts, use a simpler variant:

```
┌─ ARTIFACT PRODUCED ──────────────────────────────┐
│                                                   │
│  {Step Name} (Step {0.N})                         │
│  File: {docs/design-bible.md}                     │
│                                                   │
│  Summary:                                         │
│    {2-3 sentence summary of what was produced}    │
│                                                   │
│  Key decisions:                                   │
│    • {decision 1}                                 │
│    • {decision 2}                                 │
│                                                   │
│  ▸ Awaiting your approval                         │
└───────────────────────────────────────────────────┘
```

---

## 4. Sprint Summary Card

Used at the start and end of every sprint.

### Sprint Start

```
╔══ SPRINT {N} ════════════════════════════════════╗
║                                                   ║
║  "{sprint_name}"                                  ║
║  Epic: {epic_name} (Epic {E})                     ║
║  Branch: {branch_name}                            ║
║                                                   ║
║  Features:                                        ║
║    {N}. {feature_name} → {agent}                  ║
║    {N}. {feature_name} → {agent}                  ║
║                                                   ║
║  Agents: {list}                                   ║
║                                                   ║
╚═══════════════════════════════════════════════════╝
```

### Sprint End (Review)

```
╔══ SPRINT {N} REVIEW ═════════════════════════════╗
║                                                   ║
║  "{sprint_name}"                                  ║
║  Epic: {epic_name} (Epic {E})                     ║
║                                                   ║
╠── Features ───────────────────────────────────────╣
║                                                   ║
║  {feature_name}                        COMPLETE   ║
║    • {what it does}                               ║
║    • Files: {count} new, {count} modified         ║
║                                                   ║
║  {feature_name}                        COMPLETE   ║
║    • {what it does}                               ║
║    • Files: {count} new, {count} modified         ║
║                                                   ║
╠── QA ─────────────────────────────────────────────╣
║                                                   ║
║  Code review: {PASS / PASS WITH WARNINGS}         ║
║  Critical issues: {count} (all resolved: YES/NO)  ║
║  Smoke test: PASSED ({N} attempts)                ║
║                                                   ║
╠── Docs Updated ───────────────────────────────────╣
║                                                   ║
║  ~ docs/systems-bible.md                          ║
║  ~ docs/architecture.md                           ║
║  ~ CHANGELOG.md                                   ║
║  + docs/code-reviews/sprint-{N}-review.md         ║
║                                                   ║
╠── Next Sprint Preview ────────────────────────────╣
║                                                   ║
║  Sprint {N+1}: "{next_sprint_name}"               ║
║  Features: {list}                                 ║
║                                                   ║
╚═══════════════════════════════════════════════════╝
```

---

## 5. Epic Review Banner

Used when all sprints in an epic are complete.

```
╔══ EPIC {N} COMPLETE ═════════════════════════════╗
║                                                   ║
║  "{epic_name}"                                    ║
║  Lifecycle: {phase}                               ║
║                                                   ║
╠── Goal Assessment ────────────────────────────────╣
║                                                   ║
║  Goal: {what we set out to achieve}               ║
║  Achieved: {YES / PARTIAL / NO}                   ║
║  Evidence: {what the player can now do}           ║
║                                                   ║
╠── Sprints ────────────────────────────────────────╣
║                                                   ║
║  Sprint {N}: "{name}" .................. ACCEPTED  ║
║  Sprint {N}: "{name}" .................. ACCEPTED  ║
║                                                   ║
╠── Next Epic ──────────────────────────────────────╣
║                                                   ║
║  Epic {N+1}: "{next_epic_name}"                   ║
║  Sprints planned: {count}                         ║
║                                                   ║
╚═══════════════════════════════════════════════════╝
```

---

## 6. Lifecycle Gate Banner

Used at Prototype Gate and Vertical Slice Gate.

```
╔══════════════════════════════════════════════════╗
║          {PHASE} GATE — GO / NO-GO               ║
╠══════════════════════════════════════════════════╣
║                                                   ║
║  Epics completed: {N}                             ║
║  Sprints completed: {N}                           ║
║  Features delivered: {N}                          ║
║                                                   ║
╠── What Was Proved ────────────────────────────────╣
║                                                   ║
║  • {what the prototype/VS demonstrated}           ║
║  • {key learning}                                 ║
║                                                   ║
╠── Technical Health ───────────────────────────────╣
║                                                   ║
║  Smoke tests: {N}/{N} passed first attempt        ║
║  Code reviews: {N}/{N} passed                     ║
║  Known issues: {count or "none"}                  ║
║                                                   ║
╠── Critical Questions ─────────────────────────────╣
║                                                   ║
║  {question 1}: {assessment}                       ║
║  {question 2}: {assessment}                       ║
║                                                   ║
╚══════════════════════════════════════════════════╝
```

---

## 7. Document Update Log

Used when documents are updated (QA phase, sprint transitions, etc.). Compact format — doesn't need a full card.

```
── Docs Updated ──────────────────────────
  ~ docs/systems-bible.md       (+ Sprint {N} systems)
  ~ docs/architecture.md        (+ scene tree updates)
  ~ CHANGELOG.md                (+ Sprint {N} entries)
  + docs/code-reviews/sprint-{N}-review.md
──────────────────────────────────────────
```

---

## 8. Integration Check Report

Used after Phase B.5 integration wiring.

```
┌─ INTEGRATION CHECK ──────────────────────────────┐
│                                                   │
│  Sprint {N} — Phase B.5                           │
│                                                   │
│  Checklist:                                       │
│    [✓] Orphaned scenes         — passed           │
│    [✓] project.godot           — passed           │
│    [✓] Signal wiring           — passed           │
│    [✓] Collision layers        — passed           │
│    [✓] Groups                  — passed           │
│    [✓] Naming conventions      — passed           │
│    [✓] Dimensions              — passed           │
│    [✓] Cross-feature wiring    — passed           │
│                                                   │
│  Issues found: {N} | Fixed: {N}                   │
│  Smoke test: PASSED                               │
│                                                   │
│  ▸ Moving to: Phase C                             │
└───────────────────────────────────────────────────┘
```

---

## 9. Fix Loop Report

Used during Phase D when the user reports issues and they're fixed.

```
┌─ FIX APPLIED ────────────────────────────────────┐
│                                                   │
│  Issue: {what the user reported}                  │
│  Fix: {what was changed}                          │
│                                                   │
│  Files changed:                                   │
│    ~ {file}                                       │
│                                                   │
│  Smoke test: PASSED                               │
│  ▸ Ready for re-test                              │
└───────────────────────────────────────────────────┘
```

---

## Usage Rules

1. **Always use the appropriate format** — don't freeform status updates. Pick the matching template.
2. **Keep content concise** — each bullet should be one line. Details go in the referenced files, not the report.
3. **File paths are relative** to project root (e.g., `scripts/entities/player.gd`, not the full absolute path).
4. **Use symbols consistently:**
   - `+` = file created
   - `~` = file modified
   - `-` = file deleted
   - `[✓]` = check passed
   - `[✗]` = check failed
   - `▸` = next action
5. **Banners (══) are for milestones only** — sprint start/end, epic reviews, lifecycle gates. Don't use them for routine updates.
6. **Cards (──) are for deliverables** — features, phase completions, artifacts. These are the "receipt" for work done.
7. **Logs are for supporting details** — doc updates, file lists. Keep them compact.
