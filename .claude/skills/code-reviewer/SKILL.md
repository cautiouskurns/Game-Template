---
name: code-reviewer
description: Analyze GDScript code for quality, anti-patterns, and refactoring opportunities, then execute fixes. Combines review and refactoring in one skill.
domain: code-quality
type: reviewer
version: 1.0.0
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Code Reviewer Skill

This skill analyzes GDScript files for code quality issues and executes refactorings. It operates in two modes: **Review mode** (analyze and report) and **Fix mode** (apply recommended changes).

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | qa-docs |
| **Sprint Phase** | Phase C (QA) |
| **Directory Scope** | Reviews all `scripts/` directories |
| **Output Directory** | `docs/code-reviews/` |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

## When to Use This Skill

Invoke this skill when the user:
- Asks to "check code quality", "review my code", or "code review"
- Says "refactor [script_name].gd" or "analyze [script_name]"
- Wants to find code duplication or anti-patterns
- Asks "is this good GDScript?" or "how can I improve this code?"
- Requests performance analysis or says "find performance issues"
- Says "fix the issues from the code review" or "apply the review fixes"

## Modes of Operation

### Review Mode (Default)

Analyze code and produce a report. Triggered by:
- "review this code", "check quality", "analyze scripts"

### Fix Mode

Execute refactorings from a review report. Triggered by:
- "fix these issues", "apply the review fixes", "execute the refactor"

### Default Flow

When neither mode is specified explicitly:
1. Run **Review mode** first -- analyze and generate report
2. Present findings to the user
3. Offer to switch to **Fix mode** to apply recommendations

---

## Review Mode

### Analysis Categories

#### 1. Godot-Specific Best Practices

**Node References:**
- Bad: Using `get_node("NodeName")` or `$NodeName` in `_ready()` or repeatedly
- Good: Use `@onready var node_ref = $NodeName`

**Signals vs. Polling:**
- Bad: Checking conditions in `_process()` every frame (e.g., `if health <= 0:`)
- Good: Emit signals when state changes (e.g., `health_depleted.emit()`)

**Process Functions:**
- Bad: Physics operations in `_process(delta)`
- Good: Use `_physics_process(delta)` for physics
- Bad: Empty `_process()` or `_physics_process()` functions (remove them)

**Resource Loading:**
- Bad: Loading resources at runtime with `load("res://...")`
- Good: Preload with `const RESOURCE = preload("res://...")`

**Node Access:**
- Bad: Deep node paths like `get_node("../../UI/HUD/Label")`
- Good: Use signals or dependency injection

**Type Safety:**
- Bad: Untyped variables (`var speed = 100`) and returns (`func get_damage():`)
- Good: Typed variables (`var speed: float = 100.0`) and returns (`func get_damage() -> int:`)

#### 2. Performance Anti-Patterns

**Expensive Operations in Loops:**
```gdscript
# Bad -- query inside loop
for enemy in enemies:
    var player = get_tree().get_first_node_in_group("player")

# Good -- query once outside loop
var player = get_tree().get_first_node_in_group("player")
for enemy in enemies:
```

**String Operations:**
- Bad: String concatenation in loops (`str += "text"`)
- Good: String formatting (`"%s: %d" % [name, value]`)

**Unnecessary Repeated Calls:**
- Bad: Repeated `get_tree()` calls
- Good: Cache in `@onready var tree = get_tree()`

**Array/Dictionary Operations:**
- Bad: Using `append()` in hot paths without pre-sizing
- Good: Pre-allocate with `array.resize(expected_size)`

**Node Creation:**
- Bad: Instantiating nodes every frame
- Good: Use object pooling for frequently created/destroyed nodes

#### 3. Code Organization Issues

**Magic Numbers:**
```gdscript
# Bad
velocity.x = 200
health -= 15

# Good
const MAX_SPEED: float = 200.0
const BULLET_DAMAGE: int = 15
```

**Long Functions:** Functions over 30-40 lines should be broken up.

**Duplicate Code:** Similar code blocks across files should be extracted to shared functions or base classes.

**Poor Naming:** Single-letter variables (except loops), unclear function names (`do_thing()`), generic names (`temp`, `data`).

**Missing Documentation:** No docstrings for public functions, no comments explaining complex logic, no `@export` hints for designer-facing variables.

#### 4. Memory Management

**Signal Leaks:**
- Bad: Connecting signals without disconnecting
- Good: Disconnect in `_exit_tree()` or use `CONNECT_ONE_SHOT`

**Queue Free:**
- Bad: Calling `free()` directly (can cause crashes)
- Good: Use `queue_free()` for safe deferred deletion

**Circular References:** Nodes holding references to each other without cleanup.

**Resource Cleanup:** Not freeing manually allocated resources or holding references to destroyed nodes.

#### 5. Error Handling

**Null Checks:**
```gdscript
# Bad -- crashes if null
var target = get_target()
target.take_damage(10)

# Good
var target = get_target()
if target:
    target.take_damage(10)
```

**Array Access:**
- Bad: Direct index access (`array[5]`) without bounds check
- Good: Check bounds first (`if array.size() > 5:`)

**Type Assumptions:** Always verify with `is_instance_valid()` before accessing destroyed nodes.

#### 6. Code Duplication Patterns

Look for repeated logic in:
- Enemy scripts (movement, health, death)
- Weapon scripts (targeting, firing, cooldown)
- UI scripts (showing/hiding, updating)

Suggest: Base classes, composition (health_component.gd, movement_component.gd), utility functions.

#### 7. Godot 4.x Specific Issues

**Deprecated Syntax:**
- `onready var` should be `@onready var`
- `export var` should be `@export var`
- `yield()` should be `await`
- Old signal syntax should use `.emit()`

**New Features Not Used:**
- Typed Arrays: `var items: Array[Item]`
- Export hints: `@export_range`, `@export_enum`
- Warning suppression: `@warning_ignore`

#### 8. Project-Specific Patterns

**Delta Scaling:** Using `delta` when should use `DeltaScale.get_scaled_delta(delta)`.

**Manager Access:** Direct scene tree queries instead of using managers (PassiveManager, VFXManager, etc.).

**Weapon Pattern:** Weapons not following established pattern (target selection, cooldown, firing). Missing required methods: `fire()`, `select_target()`, `reset()`.

**Enemy Pattern:** Enemies not inheriting from `enemy_base.gd`. Not using shared health/damage/death systems.

### Review Process

1. **Identify scope**: Ask which files to analyze, or find all .gd files
2. **Read code**: Load script contents
3. **Run checks**: Go through all 8 analysis categories
4. **Cross-reference**: Look for duplication across multiple files
5. **Prioritize findings**: Critical bugs > Performance > Style
6. **Provide examples**: Show problematic code and suggested fix
7. **Generate report**: Create the markdown report
8. **Display in chat**: Show the complete report to the user
9. **Save to file**: Write the report to `docs/code-reviews/`

### Review Output Format

```markdown
# GDScript Refactor Report: [script_name].gd

## Summary
- Lines of code: X
- Issues found: X
- Severity breakdown: Critical / Warning / Suggestion

---

## Critical Issues (Fix Immediately)
### 1. [Issue Name] - Line X
**Problem:**
[code snippet]

**Impact:** [Why this is critical]

**Fix:**
[improved code snippet]

## Performance Warnings (Should Fix)
[Same format]

## Code Quality Suggestions (Nice to Have)
[Same format]

## Code Duplication Analysis
[If multiple files checked, show similar code blocks]

---

## Refactoring Recommendations

1. **[Suggestion]**
   - Extract [X] to [Y]
   - Benefits: [description]
   - Effort: Low/Medium/High

## Overall Assessment
[1-2 paragraph summary with priority recommendations]
```

### Report File Output

Every review must be saved to a file in addition to being shown in chat.

**File Location:** `docs/code-reviews/[script-name]_review_[YYYY-MM-DD].md`

**Examples:**
- Single file: `docs/code-reviews/player_review_2025-01-15.md`
- Multiple files: `docs/code-reviews/weapon-scripts_review_2025-01-15.md`
- Specific component: `docs/code-reviews/enemy-ai_review_2025-01-15.md`

**File Naming Convention:**
- Use the script name (without `.gd` extension), converted to kebab-case
- Append `_review_[date]` where date is YYYY-MM-DD format
- For multiple related scripts, use a descriptive group name

**Report Header (file only, not in chat):**
```markdown
---
review_date: YYYY-MM-DD
reviewed_files:
  - path/to/script1.gd
  - path/to/script2.gd
reviewer: Claude Code (code-reviewer skill)
---
```

---

## Fix Mode

### Fix Workflow

#### Step 1: Read the Report

List available reports from `docs/code-reviews/` and ask user to confirm which report to execute. If invoked immediately after a review, use that review's findings directly.

#### Step 2: Parse Recommendations

Extract actionable items grouped by priority:
- Critical Issues (Priority 1 -- must fix)
- Performance Warnings (Priority 2 -- should fix)
- Code Quality Suggestions (Priority 3 -- nice to have)

For each item, identify: target file, line numbers, issue type, and suggested fix.

#### Step 3: Confirm Execution Plan

Before making ANY changes, show the user a plan:

```markdown
## Execution Plan

### Priority 1: Critical Issues (N fixes)
1. player.gd:45 - Add type annotation to `speed` variable
2. player.gd:67 - Convert `get_node()` to `@onready`
3. player.gd:89 - Add null check before accessing `target`

### Priority 2: Performance Warnings (N fixes)
1. player.gd:102 - Cache `get_tree()` call outside loop
2. player.gd:134 - Use `@onready` for node reference

### Priority 3: Code Quality (N fixes)
[... etc ...]

**Total changes:** X edits across Y files

Proceed with execution?
```

Wait for user confirmation before proceeding.

#### Step 4: Execute Refactorings

For each fix, in priority order:
1. Read the target file to get current state
2. Verify the issue exists (line numbers may have shifted)
3. Apply the fix using the Edit tool
4. Mark as complete and move to next fix

Handle edge cases:
- If line number does not match, search for the pattern in the file
- If code is already fixed, skip and note
- If unsure, skip and note for manual review

#### Step 5: Generate Execution Report

Save to `docs/refactoring/[report-name]_execution_[YYYY-MM-DD].md`:

```markdown
# Refactoring Execution Report

**Executed:** [YYYY-MM-DD]
**Source Report:** docs/code-reviews/[report-name].md
**Executor:** Claude Code (code-reviewer skill)

---

## Summary
- Fixes applied: X
- Fixes skipped: Y
- Fixes failed: Z
- Files modified: N

## Applied Fixes
### 1. file.gd:line - Description
**Issue:** [description]
**Fix:** [what was changed]
**Status:** Applied successfully

## Skipped Fixes
### 1. file.gd:line - Description
**Reason:** [why it was skipped]

## Failed Fixes
### 1. file.gd:line - Description
**Reason:** [why it failed]

## Modified Files
1. scripts/systems/player.gd (N changes)

## Recommendations
1. Test the game to ensure functionality is preserved
2. Manual review needed for any failed fixes
3. Consider committing refactorings separately for easy rollback
```

### Refactoring Types Supported

**Type Annotations:**
`var speed = 200` becomes `var speed: float = 200.0`

**Deprecated Syntax:**
`onready var player = $Player` becomes `@onready var player = $Player`

**Node Reference Optimization:**
`get_node("Player")` in `_process()` becomes `@onready var player = $Player`

**Magic Numbers to Constants:**
Inline numbers become named `const` declarations at the top of the script.

**Null Safety Checks:**
Direct access becomes guarded with `if target:` checks.

**Performance Optimizations:**
Move expensive operations out of loops, cache repeated lookups.

**Signal Connection Cleanup:**
Add `_exit_tree()` disconnection for signals connected in `_ready()`.

**Process Function Corrections:**
Move physics operations from `_process()` to `_physics_process()`.

---

## Safety Guidelines

### Before Any Changes
- Always show execution plan and wait for confirmation
- Read the full target file before making changes
- Verify the issue still exists (code may have changed since report)

### During Execution
- Make one edit at a time (do not batch multiple complex refactorings)
- Use exact string matching when possible
- If ambiguous, skip and note for manual review
- Track which fixes succeeded, failed, or were skipped

### After Execution
- Generate execution report
- Recommend testing the game
- Note any manual follow-up needed

### What NOT to Do
- Do not make changes without user confirmation
- Do not guess at fixes if unclear
- Do not batch multiple complex refactorings in one edit
- Do not execute if report is too old (warn user if >7 days)
- Do not modify files not mentioned in the report

### Error Handling

**Line numbers do not match:** Search for surrounding code context. If found, apply fix. If not found, skip.

**File modified since report:** Check if issue still exists. If yes, apply. If no, skip as already resolved.

**Fix is ambiguous:** Skip, add to "Manual Review Needed" section.

**Syntax error after edit:** Attempt to revert the edit, mark as failed, continue with remaining fixes.

## Analysis Rules

- **Be specific**: Reference exact line numbers and code snippets
- **Show examples**: Always show before/after code
- **Context matters**: Consider prototype vs. production quality
- **Prioritize correctly**: Game-breaking bugs before style issues
- **Explain "why"**: Do not just say "bad" -- explain the consequences
- **Godot-first**: Focus on Godot-specific issues before generic coding practices
- **Prototype-aware**: Type safety is important but not critical for prototypes; prefer readability over micro-optimizations

## Example Invocations

**Review mode:**
- "Check my player.gd script"
- "Review all weapon scripts for issues"
- "Is my code following Godot best practices?"
- "Find performance issues in my scripts"

**Fix mode:**
- "Fix the issues from the code review"
- "Apply the refactoring recommendations"
- "Execute the critical issues from the latest code review"

**Combined flow:**
- "Review and fix my player.gd" (reviews first, then offers to fix)

## Workflow Summary

**Review mode:**
1. Analyze the specified GDScript file(s)
2. Generate comprehensive markdown report
3. Display the report in chat
4. Save the report to `docs/code-reviews/[name]_review_[date].md`
5. Confirm file location to the user
6. Offer to switch to Fix mode

**Fix mode:**
1. Read the review report (or use current review findings)
2. Parse recommendations and generate execution plan
3. Show plan and wait for user approval
4. Execute fixes systematically (one at a time)
5. Generate execution report and save to `docs/refactoring/`
6. Recommend testing the game to verify functionality
