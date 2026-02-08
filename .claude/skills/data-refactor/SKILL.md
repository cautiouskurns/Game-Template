---
name: data-refactor
description: Analyze code for hardcoded values and extract them into data files (.tres resources, JSON configs). Combines analysis and extraction in one skill.
domain: code-quality
type: refactorer
version: 1.0.0
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Data Refactor Skill

This skill analyzes GDScript code to identify hardcoded configuration data and extracts it into external data files. It operates in two modes: **Analyze mode** (scan and report) and **Extract mode** (create data files and refactor code).

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | qa-docs |
| **Sprint Phase** | Phase C (QA) after 3+ features |
| **Directory Scope** | `docs/data-analysis/` |
| **Output Directory** | `docs/data-analysis/` (analysis), `docs/refactoring/` (extraction) |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

## When to Use This Skill

Invoke this skill when the user:
- Asks to "make it more data-driven" or "extract data from code"
- Says "move numbers to JSON/config files" or "externalize settings"
- Wants to improve balancing workflow or separate data from logic
- Asks "how can I tune this without changing code?"
- Says "create config files", "extract hardcoded values", or "apply the data analysis"
- Requests "create the data files from the analysis report"

## Modes of Operation

### Analyze Mode (Default)

Scan code for hardcoded values and produce a report. Triggered by:
- "analyze data in scripts", "find hardcoded values", "make it data-driven"

### Extract Mode

Create data files and refactor scripts. Triggered by:
- "extract the data", "create the config files", "apply the data analysis"

### Default Flow

When neither mode is specified explicitly:
1. Run **Analyze mode** first -- scan and generate report
2. Present findings to the user
3. Offer to switch to **Extract mode** to create data files and refactor

---

## Analyze Mode

### Core Principle

**Data-driven design** separates "what" (data) from "how" (code):
- Designers can tweak values without touching code
- Balance changes do not require code review
- Easy to compare configurations via git diff
- Multiple variants and presets are easy to maintain

### What to Look For

#### 1. Game Balance Numbers

Hardcoded values that designers might want to tune:

```gdscript
# Bad -- hardcoded in script
const MAX_SPEED = 200.0
const BULLET_DAMAGE = 15
const FIRE_RATE = 0.2
var health = 100
```

Common balance data:
- Weapon stats (damage, cooldown, range, projectile speed)
- Enemy stats (health, speed, attack damage, score value)
- Player stats (health, movement speed, starting weapons)
- Wave progression (spawn rates, enemy counts, difficulty scaling)
- Upgrade values (damage multipliers, cooldown reduction)
- Economy (XP values, costs, rewards)

#### 2. Configuration Settings

System-level settings:
- Screen shake intensity/duration
- Particle effect counts
- Audio volume levels
- UI animation speeds
- Debug flags and test mode settings

#### 3. Content Definitions

Structured game content:
- Enemy type definitions (name, stats, behavior type, sprite)
- Weapon loadouts (available weapons, unlock requirements)
- Passive ability definitions
- Wave definitions (timing, enemy composition)
- Upgrade tree options

#### 4. Tuning Constants

Magic numbers scattered in code:
```gdscript
# Bad -- magic numbers
velocity = velocity.move_toward(Vector2.ZERO, 500 * delta)
if distance < 150:
    attack()

# Good -- named constants in a data file
# friction_deceleration: 500
# attack_range: 150
```

### Red Flags for Extraction

Definitely extract when you see:
- Same constant names across multiple scripts
- Numbers in comments like "TODO: tune this"
- Repeated if/else chains checking hardcoded values
- Balance changes requiring code edits
- Difficulty creating variants (Elite vs Normal enemy)

### Analysis Process

1. **Scan for hardcoded values**: Look for `const` declarations with numeric values, direct numeric assignments in `_ready()`, exported variables with defaults, magic numbers in calculations
2. **Categorize data**: Group by weapon data, enemy data, player data, wave data, system settings, UI constants
3. **Identify duplication**: Multiple scripts with the same variable names or identical stat structures
4. **Recommend format**: Choose the right data storage for each category (see Data Storage Options)
5. **Generate report**: Create markdown analysis with migration plan
6. **Display and save**: Show in chat and save to `docs/data-analysis/`

### Data Storage Options (Godot-Specific)

#### Option 1: Godot Resources (.tres files)

**When to use:** Type-safe data with Godot editor integration, inheritance/composition, per-instance configuration.

```gdscript
# Resource script: weapon_data.gd
class_name WeaponData
extends Resource

@export var weapon_name: String
@export var damage: int
@export var cooldown: float
@export var range: float
@export var projectile_scene: PackedScene
```

```gdscript
# Usage in weapon script
@export var weapon_data: WeaponData

func fire():
    var damage = weapon_data.damage
```

Benefits: Type safety, editor property panel, drag-and-drop in editor, can reference other resources/scenes.

#### Option 2: JSON Files

**When to use:** Simple key-value data, human-readable format, easy version control diffing, external tools.

```json
{
  "machine_gun": {
    "damage": 5,
    "fire_rate": 5.0,
    "range": 300,
    "projectile_speed": 500
  }
}
```

```gdscript
# Loading in script
func _ready():
    var file = FileAccess.open("res://data/weapons.json", FileAccess.READ)
    var json = JSON.new()
    json.parse(file.get_as_text())
    weapons_data = json.data
    file.close()
```

Benefits: Simple to edit, good for large datasets, easy to compare versions.

#### Option 3: GDScript Data Files

**When to use:** Complex data structures, code completion, shared constants/enums.

```gdscript
# data/weapon_stats.gd
class_name WeaponStats
extends Node

const WEAPONS = {
    "machine_gun": {"damage": 5, "fire_rate": 5.0, "range": 300},
    "railgun": {"damage": 100, "fire_rate": 0.5, "range": 600}
}
```

Benefits: No runtime parsing, type checking, enums and complex types, fast access.

#### Option 4: ConfigFile (.cfg)

**When to use:** INI-style settings, user preferences, simple key-value per section.

```ini
[player]
max_health = 100
movement_speed = 200

[weapons.machine_gun]
damage = 5
fire_rate = 5.0
```

Benefits: Built-in Godot support, good for settings, human-readable.

#### Format Decision Tree

- **Structured game entities** (weapons, enemies) -- use .tres Resources
- **Large lists / progression data** (waves, upgrades) -- use JSON
- **System settings** (debug, VFX intensity) -- use ConfigFile
- **Shared constants** (layers, groups) -- use GDScript data file

### Analyze Output Format

```markdown
# Data-Driven Refactor Analysis

## Summary
- Scripts analyzed: X
- Hardcoded values found: X
- Recommended extractions: X

---

## Priority 1: Game Balance Data (High Value)

### Weapon Statistics
**Current state:** Hardcoded in N weapon scripts
**Problem:** Each weapon redefines damage/cooldown/range constants
**Duplication:** Same variable names across all weapons

**Current code example:**
[code snippet]

**Recommended approach:** Godot Resources (.tres)
**Effort:** Medium (2-3 hours)

---

## Priority 2: [Next Category]
[Same format]

---

## Quick Wins (Low Effort, High Value)
1. Player Stats -> ConfigFile (15 minutes)
2. VFX Settings -> GDScript Constants (10 minutes)

---

## Migration Priority Order
1. Weapon data -> Resources
2. Enemy data -> Resources
3. Wave progression -> JSON
4. System settings -> ConfigFile
5. UI constants -> Keep in code

## Overall Recommendation
[1-2 paragraph summary with concrete next steps]
```

### Report File Output

Every analysis must be saved to a file in addition to being shown in chat.

**File Location:** `docs/data-analysis/[scope]_data-analysis_[YYYY-MM-DD].md`

**Examples:**
- `docs/data-analysis/weapon-system_data-analysis_2025-12-20.md`
- `docs/data-analysis/full-project_data-analysis_2025-12-20.md`

**File Naming Convention:**
- Use descriptive scope name (what was analyzed), in kebab-case
- Append `_data-analysis_[date]` where date is YYYY-MM-DD

**Report Header (file only, not in chat):**
```markdown
---
analysis_date: YYYY-MM-DD
analyzed_files:
  - path/to/script1.gd
  - path/to/script2.gd
analyzer: Claude Code (data-refactor skill)
analysis_type: Data-Driven Design Opportunities
---
```

---

## Extract Mode

### Extract Workflow

#### Step 1: Read the Report

List available reports from `docs/data-analysis/` and ask user to confirm which to execute. If invoked immediately after an analysis, use those findings directly.

#### Step 2: Parse Recommendations

Extract data extraction opportunities grouped by priority:
- Priority 1: High-value extractions (weapon stats, enemy data)
- Priority 2: Medium-value extractions (wave progression, upgrades)
- Priority 3: Nice-to-have extractions (UI constants, settings)

For each, identify: data to extract, recommended format, source files, target files, refactoring steps.

#### Step 3: Confirm Execution Plan

Before making ANY changes, show the user a plan listing:
- Each priority group with the files to create (resource scripts, data files) and files to modify
- Total counts of new files and modified files
- A clear "Proceed with execution?" prompt

Wait for user confirmation before proceeding.

#### Step 4: Execute Data Extraction

Execute in phases, in order:

**Phase 1: Create Directory Structure**
Create `data/` subdirectories as needed (weapons/, enemies/, waves/, balance/).

**Phase 2: Create Resource Scripts (if using .tres)**
Write Resource class definitions with `@export` properties, `@export_group`, and `@export_range` hints.

Example:
```gdscript
class_name WeaponData
extends Resource

@export_group("Identity")
@export var weapon_name: String = ""

@export_group("Combat Stats")
@export var damage: int = 10
@export_range(0.1, 10.0) var fire_rate: float = 1.0
@export_range(0, 1000) var range: float = 300.0
```

**Phase 3: Create Data Files**
Generate .tres files, JSON files, or ConfigFile (.cfg) files with the extracted values.

Example .tres:
```
[gd_resource type="Resource" script_class="WeaponData" load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/resources/weapon_data.gd" id="1"]

[resource]
script = ExtResource("1")
weapon_name = "Machine Gun"
damage = 5
fire_rate = 5.0
range = 300.0
```

**Phase 4: Refactor Source Scripts**
- Read each script with hardcoded values
- Remove hardcoded constants
- Add `@export` or `load()` calls for data resources
- Replace references to constants with data file properties

**Phase 5: Validation**
- Check that all files were created
- Verify scripts reference correct data files
- Ensure no syntax errors

#### Step 5: Generate Execution Report

Save to `docs/refactoring/[report-name]_execution_[YYYY-MM-DD].md` with:
- Summary of directories created, resource scripts created, data files created, scripts refactored, and any failed operations
- Details for each phase (directory structure, resource scripts, data files, script modifications)
- Testing instructions: open Godot editor to verify files, assign .tres resources in Inspector, test in game, validate data-driven workflow by changing a value and confirming it takes effect
- Rollback instructions: use `git status`, `git checkout -- [file]`, or full revert as needed

---

## Safety Guidelines

### Before Any Changes
- Show complete execution plan with all files to create/modify
- Wait for user confirmation
- All changes are git-trackable files

### During Execution
- Create files in logical order (directories, then resource scripts, then data files, then refactor scripts)
- Validate each file creation before proceeding
- If error occurs, stop and report

### After Execution
- Generate execution report with testing instructions
- Recommend testing in Godot before committing

### What NOT to Do
- Do not proceed without user confirmation
- Do not delete original constants until data files are verified working
- Do not create files in wrong directories
- Do not modify scripts if data file creation failed

### Error Handling

**Values do not match:** Compare extracted values to original constants carefully before overwriting.

**Resource files not loading:** Check file paths, verify .tres format, ensure scripts can find resources.

**Complete rollback needed:** Use git to revert changes; original constants are preserved in git history.

## Important Guidelines

- **Do not over-extract**: Some constants are truly constant (TAU, MAX_INT)
- **Consider change frequency**: Extract data that changes often during balancing
- **Group related data**: Do not create many tiny files; organize logically
- **Type safety matters**: Prefer Resources over JSON when type safety is important
- **Prototype context**: Focus on weapon/enemy/wave data first
- **Editor integration**: Resources are faster to tweak than JSON during playtesting

## Example Invocations

**Analyze mode:**
- "Make weapon stats data-driven"
- "How can I make balancing easier?"
- "Find hardcoded values in my scripts"
- "Separate game data from scripts"

**Extract mode:**
- "Create the data files from the analysis"
- "Execute the data-driven refactor"
- "Extract enemy stats to resources"
- "Apply the data analysis report"

**Combined flow:**
- "Make my weapons data-driven" (analyzes first, then offers to extract)

## Workflow Summary

**Analyze mode:**
1. Scan specified GDScript file(s) for hardcoded configuration values
2. Categorize findings and recommend data storage formats
3. Generate comprehensive markdown analysis report
4. Display the report in chat
5. Save the report to `docs/data-analysis/[scope]_data-analysis_[date].md`
6. Confirm file location to the user
7. Offer to switch to Extract mode

**Extract mode:**
1. Read the analysis report (or use current analysis findings)
2. Parse recommendations and generate execution plan
3. Show plan and wait for user approval
4. Create directories, resource scripts, and data files
5. Refactor source scripts to load from data files
6. Generate execution report with testing instructions
7. Save execution report to `docs/refactoring/`
8. User assigns resources in Godot Editor (for .tres files) and tests
