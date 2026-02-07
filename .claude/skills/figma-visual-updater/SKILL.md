---
name: figma-visual-updater
description: Update game UI visuals based on Figma prototype links. Takes a Figma URL, extracts design specifications using the Figma MCP tools, and updates Godot scenes/scripts to match the prototype.
domain: project
type: integration
version: 1.0.0
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
  - Edit
  - mcp__figma__get_design_context
  - mcp__figma__get_screenshot
  - mcp__figma__get_metadata
  - mcp__figma__get_variable_defs
---

# Figma Visual Updater Skill

This skill takes a Figma prototype URL and updates your Godot game's UI to match the design. It extracts colors, layouts, typography, and component structures from Figma and applies them to your existing UI scenes and scripts.

---

## When to Use This Skill

Invoke this skill when the user:
- Provides a Figma URL and says "update the UI to match this"
- Says "apply this Figma design to [screen/component]"
- Says "sync visuals from Figma"
- Wants to implement a Figma prototype in Godot
- Says "update [component] based on this Figma link"
- Has a finalized design and wants code to match

---

## Core Principle

**Design-to-code synchronization:**
- ✅ Extracts exact colors, sizes, and spacing from Figma
- ✅ Maps Figma components to Godot Control nodes
- ✅ Updates existing code rather than rewriting
- ✅ Preserves functionality while updating visuals
- ✅ Documents all changes made
- ✅ Provides before/after comparison

---

## Workflow

### Step 1: Parse the Figma URL

**Extract from the URL:**
- `fileKey`: The file identifier (e.g., `abc123` from `figma.com/design/abc123/...`)
- `nodeId`: The specific node/frame (e.g., `1-2` from `?node-id=1-2`)

**URL Patterns:**
```
https://figma.com/design/:fileKey/:fileName?node-id=:nodeId
https://www.figma.com/file/:fileKey/:fileName?node-id=:nodeId
https://figma.com/design/:fileKey/branch/:branchKey/:fileName (use branchKey as fileKey)
```

---

### Step 2: Fetch Figma Design Data

**Use MCP tools to extract design information:**

1. **Get Design Context** (primary data source):
```
mcp__figma__get_design_context(fileKey, nodeId)
```
Returns: Component structure, styles, layout code

2. **Get Screenshot** (visual reference):
```
mcp__figma__get_screenshot(fileKey, nodeId)
```
Returns: Visual image of the design

3. **Get Variable Definitions** (design tokens):
```
mcp__figma__get_variable_defs(fileKey, nodeId)
```
Returns: Color variables, spacing tokens, etc.

4. **Get Metadata** (structure overview):
```
mcp__figma__get_metadata(fileKey, nodeId)
```
Returns: Node hierarchy, names, positions

---

### Step 3: Extract Design Specifications

**From the Figma data, extract:**

```markdown
## Extracted Design Specs

### Colors
- Background: #[hex] (rgba: r, g, b, a)
- Primary Text: #[hex]
- Secondary Text: #[hex]
- Accent: #[hex]
- Button Normal: #[hex]
- Button Hover: #[hex]
- Panel: #[hex] @ [opacity]%

### Typography
- Title: [Font], [Size]px, [Weight]
- Body: [Font], [Size]px, [Weight]
- Button: [Font], [Size]px, [Weight]

### Spacing
- Padding: [top] [right] [bottom] [left]
- Gap between elements: [value]px
- Margins: [values]

### Dimensions
- Width: [value]px (or percentage)
- Height: [value]px (or auto)
- Corner radius: [value]px

### Layout
- Direction: [horizontal/vertical]
- Alignment: [start/center/end]
- Distribution: [packed/space-between/etc]

### Components
- [Component 1]: [properties]
- [Component 2]: [properties]
```

---

### Step 4: Identify Target Files

**Ask the user or search for matching files:**

```
Which Godot files should I update to match this design?

Based on the Figma design "[Design Name]", I found these potential matches:
1. scenes/ui/[similar_name].tscn
2. scripts/ui/[similar_name].gd
3. [other matches]

Which should I update? Or specify a different target.
```

**If user specifies target, read those files:**
- Read the .tscn scene file
- Read the associated .gd script
- Read any theme files (.tres)

---

### Step 5: Map Figma to Godot

**Create a mapping between Figma components and Godot nodes:**

```markdown
## Component Mapping

| Figma Component | Godot Node | Property Updates |
|-----------------|------------|------------------|
| Frame "Header" | PanelContainer "Header" | bg_color, size |
| Text "Title" | Label "TitleLabel" | font_size, color |
| Button "Start" | Button "StartButton" | colors, size |
| Image "Icon" | TextureRect "Icon" | position, size |
```

**Godot Control equivalents:**
- Figma Frame → Panel, PanelContainer, Control
- Figma Text → Label, RichTextLabel
- Figma Rectangle → ColorRect, Panel
- Figma Button → Button, TextureButton
- Figma Image → TextureRect, Sprite2D
- Figma Auto Layout → VBoxContainer, HBoxContainer, GridContainer

---

### Step 6: Generate Update Plan

**Present the update plan before making changes:**

```markdown
## Update Plan for [Target File]

### Color Updates

**In [script].gd:**
```gdscript
# Before:
const COLOR_BACKGROUND := Color(0.1, 0.1, 0.15)
# After:
const COLOR_BACKGROUND := Color(0.08, 0.08, 0.12)  # From Figma: #14141F
```

### Layout Updates

**In [scene].tscn:**
- Node "Panel" → custom_minimum_size: (400, 300)
- Node "VBox" → separation: 16
- Node "Title" → position: (20, 20)

### Typography Updates

**In [script].gd or theme:**
```gdscript
# Before:
label.add_theme_font_size_override("font_size", 24)
# After:
label.add_theme_font_size_override("font_size", 32)  # From Figma
```

### New Properties

**Adding:**
- Corner radius: 8px (via StyleBoxFlat)
- Shadow: offset (2, 2), color #00000040

Proceed with these updates?
```

**Wait for user confirmation.**

---

### Step 7: Apply Updates

**Make the changes:**

1. **Update Color Constants in Scripts:**
```gdscript
# Convert Figma hex to Godot Color
# #1A1A24 → Color(0.102, 0.102, 0.141)
const COLOR_BACKGROUND := Color(0.102, 0.102, 0.141)
```

2. **Update Theme Overrides:**
```gdscript
func _setup_styles() -> void:
    var panel_style := StyleBoxFlat.new()
    panel_style.bg_color = Color(0.08, 0.08, 0.12, 0.95)  # From Figma
    panel_style.corner_radius_top_left = 8  # From Figma
    panel_style.corner_radius_top_right = 8
    panel_style.corner_radius_bottom_left = 8
    panel_style.corner_radius_bottom_right = 8
    panel.add_theme_stylebox_override("panel", panel_style)
```

3. **Update Layout Properties in Scene:**
- Edit .tscn file for position/size changes
- Or document manual changes needed in editor

4. **Update Typography:**
```gdscript
label.add_theme_font_size_override("font_size", 32)
label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
```

---

### Step 8: Generate Update Report

```markdown
# Figma Visual Update Report

**Source:** [Figma URL]
**Target:** [File(s) updated]
**Updated:** [Date]

---

## Summary

- ✅ Colors updated: X
- ✅ Typography updated: X
- ✅ Layout changes: X
- ⚠️ Manual steps required: X

---

## Changes Made

### [filename].gd

**Color Constants:**
| Constant | Before | After | Source |
|----------|--------|-------|--------|
| COLOR_BG | #1A1A24 | #14141F | Figma "Background" |
| COLOR_TEXT | #E0E0E0 | #F5F5F5 | Figma "Primary Text" |

**Typography:**
| Element | Before | After |
|---------|--------|-------|
| Title size | 24px | 32px |
| Body size | 14px | 16px |

### [filename].tscn

**Layout Changes:**
| Node | Property | Before | After |
|------|----------|--------|-------|
| Panel | size | 300x200 | 400x280 |
| VBox | separation | 8 | 16 |

---

## Manual Steps Required

⚠️ **The following changes require manual action in Godot Editor:**

1. **Import font file:**
   - Download font from [source]
   - Place in `assets/fonts/`
   - Update theme reference

2. **Asset replacement:**
   - Replace `icon.png` with exported asset from Figma
   - Export at 2x resolution for crisp display

---

## Visual Comparison

**Figma Design:**
[Screenshot from get_screenshot]

**Expected Godot Result:**
The updated UI should now match the Figma design with:
- [Key visual element 1]
- [Key visual element 2]
- [Key visual element 3]

---

## Rollback

If changes cause issues:

```bash
git diff scripts/ui/[file].gd
git checkout -- scripts/ui/[file].gd
```

---

## Next Steps

1. [ ] Run the game and verify visual match
2. [ ] Test all interactive states (hover, pressed, disabled)
3. [ ] Verify on different resolutions
4. [ ] Export and replace any image assets from Figma
```

---

## Color Conversion Utilities

### Hex to Godot Color

```
#RRGGBB → Color(R/255, G/255, B/255)
#RRGGBBAA → Color(R/255, G/255, B/255, A/255)

Examples:
#FFFFFF → Color(1.0, 1.0, 1.0)
#000000 → Color(0.0, 0.0, 0.0)
#1A1A24 → Color(0.102, 0.102, 0.141)
#FF5500 → Color(1.0, 0.333, 0.0)
#00000080 → Color(0.0, 0.0, 0.0, 0.502)
```

### Figma RGBA to Godot

```
Figma: rgba(26, 26, 36, 0.95)
Godot: Color(0.102, 0.102, 0.141, 0.95)
```

---

## Figma to Godot Node Mapping

### Container Types

| Figma | Godot | Notes |
|-------|-------|-------|
| Frame (no auto-layout) | Control or Panel | Manual positioning |
| Frame (horizontal auto-layout) | HBoxContainer | separation = gap |
| Frame (vertical auto-layout) | VBoxContainer | separation = gap |
| Frame (wrap auto-layout) | GridContainer | columns = items per row |
| Component | PackedScene | Reusable prefab |

### Interactive Elements

| Figma | Godot | Notes |
|-------|-------|-------|
| Interactive Frame | Button | With StyleBoxFlat |
| Text Input | LineEdit | Single line |
| Text Area | TextEdit | Multi-line |
| Dropdown | OptionButton | With items |
| Checkbox | CheckBox | Boolean toggle |
| Slider | HSlider/VSlider | Range input |

### Visual Elements

| Figma | Godot | Notes |
|-------|-------|-------|
| Text | Label | Static text |
| Rich Text | RichTextLabel | Formatted text |
| Rectangle | ColorRect | Solid color |
| Rectangle (styled) | Panel + StyleBoxFlat | With borders/corners |
| Image | TextureRect | Static image |
| Vector | Sprite2D | SVG → PNG |

---

## Style Property Mapping

### Fills

```
Figma Solid Fill → StyleBoxFlat.bg_color
Figma Gradient → StyleBoxFlat gradient (limited) or Shader
Figma Image Fill → TextureRect or StyleBoxTexture
```

### Strokes

```
Figma Stroke → StyleBoxFlat.border_width_*
Figma Stroke Color → StyleBoxFlat.border_color
```

### Effects

```
Figma Drop Shadow → StyleBoxFlat.shadow_* (limited)
Figma Inner Shadow → Requires custom shader
Figma Blur → Requires BackBufferCopy + Shader
```

### Corner Radius

```
Figma Corner Radius (uniform) → StyleBoxFlat.corner_radius_*
Figma Corner Radius (individual) → Set each corner separately
```

---

## Common Patterns

### Panel with Rounded Corners and Border

**Figma:**
- Fill: #1A1A24
- Stroke: #333340, 1px
- Corner Radius: 8px

**Godot:**
```gdscript
var style := StyleBoxFlat.new()
style.bg_color = Color(0.102, 0.102, 0.141)
style.border_color = Color(0.2, 0.2, 0.251)
style.border_width_top = 1
style.border_width_right = 1
style.border_width_bottom = 1
style.border_width_left = 1
style.corner_radius_top_left = 8
style.corner_radius_top_right = 8
style.corner_radius_bottom_left = 8
style.corner_radius_bottom_right = 8
panel.add_theme_stylebox_override("panel", style)
```

### Button with States

**Figma:** Button component with variants (Default, Hover, Pressed, Disabled)

**Godot:**
```gdscript
func _setup_button_styles(button: Button) -> void:
    # Normal
    var normal := StyleBoxFlat.new()
    normal.bg_color = Color(0.2, 0.2, 0.25)
    button.add_theme_stylebox_override("normal", normal)

    # Hover
    var hover := StyleBoxFlat.new()
    hover.bg_color = Color(0.25, 0.25, 0.3)
    button.add_theme_stylebox_override("hover", hover)

    # Pressed
    var pressed := StyleBoxFlat.new()
    pressed.bg_color = Color(0.15, 0.15, 0.2)
    button.add_theme_stylebox_override("pressed", pressed)

    # Disabled
    var disabled := StyleBoxFlat.new()
    disabled.bg_color = Color(0.1, 0.1, 0.12)
    button.add_theme_stylebox_override("disabled", disabled)
```

---

## Example Invocations

User: "Update the main menu to match this Figma: [URL]"
User: "Apply this design to my inventory screen: [URL]"
User: "Sync the HUD colors from Figma: [URL]"
User: "Update briefing screen based on this prototype: [URL]"
User: "[Figma URL] - apply to mission complete screen"

---

## Quality Checklist

Before completing the update:

- ✅ All colors converted accurately (hex → Color)
- ✅ Typography sizes match (accounting for DPI differences)
- ✅ Layout structure preserved
- ✅ Interactive states handled (hover, pressed, disabled)
- ✅ Existing functionality not broken
- ✅ Changes documented in report
- ✅ Manual steps clearly listed
- ✅ Rollback instructions provided

---

## Integration with Other Skills

**Inputs from:**
- `figma-prompt-generator` - Figma designs created from its prompts
- User-provided Figma URLs

**Outputs to:**
- Updated Godot scenes and scripts
- Visual update reports

**Workflow chain:**
```
[UI Need] → figma-prompt-generator → [Figma Make Prompt]
                                            ↓
[Figma Make Prompt] → Figma Make → [Visual Prototype]
                                            ↓
[Visual Prototype URL] → figma-visual-updater → [Updated Game Code]
```

---

## Limitations

**What this skill CANNOT do:**

1. **Create new scenes from scratch** - Updates existing files only
2. **Import image assets automatically** - Documents what to export
3. **Handle complex animations** - Basic states only
4. **Implement shaders** - Documents when needed
5. **Match pixel-perfect on all resolutions** - Godot's Control system differs from Figma

**What requires manual work:**

1. Font file imports
2. Image asset exports from Figma
3. Complex gradient effects
4. Advanced shadows/blur effects
5. Animation timing adjustments
