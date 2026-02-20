---
name: figma-ui-pipeline
description: End-to-end UI generation pipeline — generate art with Ludo MCP, build HTML mockup, push to Figma, pull interactive Make prototype back, and implement in Godot.
domain: implementation
type: executor
version: 1.0.0
trigger: user
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - WebFetch
  - ToolSearch
  - ReadMcpResourceTool
  - AskUserQuestion
---

# Figma UI Pipeline

Generate game UI through a Figma Make round-trip: create art assets, compose an HTML mockup, push to Figma, let the user add interactivity in Make, pull the interactive prototype back, and implement it in Godot.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | Any (typically ui-dev or orchestrator) |
| **Sprint Phase** | Phase A or B (UI implementation) |
| **Directory Scope** | `assets/ui/`, `scenes/ui/`, `scripts/ui/` |
| **Required MCP Servers** | Figma (`plugin:figma:figma`), Ludo (`ludo`) |

## How to Invoke This Skill

Users can trigger this skill by saying:
- `/figma-ui-pipeline`
- "Create a UI element using the Figma pipeline"
- "Generate UI with Ludo and Figma"
- "Build a HUD element through Figma Make"
- "Design a [menu/HUD/inventory] using the Figma workflow"

## Arguments

The skill accepts an optional argument describing the UI element to create:
- `/figma-ui-pipeline action bar for an RPG`
- `/figma-ui-pipeline main menu with animated title`
- `/figma-ui-pipeline inventory grid with item tooltips`

If no argument is provided, ask the user what UI element they want to create.

---

## Pipeline Overview

```
Phase 1: Asset Generation (Ludo MCP)
    ↓
Phase 2: HTML Mockup (local)
    ↓
Phase 3: Push to Figma (generate_figma_design)
    ↓
Phase 4: User edits in Figma Make (manual)
    ↓
Phase 5: Pull from Make (MCP resources)
    ↓
Phase 6: Implement in Godot (.tscn + .gd)
    ↓
Phase 7: Smoke Test
```

---

## Phase 1: Asset Generation

Generate visual assets for the UI element using Ludo MCP.

### 1.1 Plan the Assets

Before generating, determine what images are needed:
- **Icons** (ability icons, item icons, status icons)
- **Portraits** (character portraits, NPC faces)
- **Frames** (panel borders, slot frames, bar decorations)
- **Backgrounds** (panel backgrounds, decorative elements)

### 1.2 Generate with Ludo MCP

Load the Ludo tools:
```
ToolSearch: query="+ludo create"
```

For each asset, use `mcp__ludo__createImage`:
```
mcp__ludo__createImage:
  prompt: "[descriptive prompt for the asset]"
  style: "[match project art direction if docs/art-direction.md exists]"
  imageType: "game_asset"
  genre: "[game genre]"
  aspectRatio: "1:1"  (for icons/portraits) or "16:9" (for backgrounds)
```

**Style consistency:** If `docs/art-direction.md` exists, read it and use the established style keywords in every prompt. If style anchors exist in `assets/references/`, use `mcp__ludo__generateWithStyle` instead.

### 1.3 Download Assets Locally

**CRITICAL:** Remote URLs will NOT load reliably in the Figma capture. Always download locally.

```bash
cd assets/ui/[element-name]/
curl -sL "[ludo-url]" -o [name].webp
```

Save all generated images to `assets/ui/[element-name]/`.

### 1.4 Record Asset Manifest

Create a brief manifest file for reference:

```
assets/ui/[element-name]/assets.md
```

Contents:
```markdown
# [Element Name] Assets
Generated via Ludo MCP on [date]

| File | Description | Ludo URL |
|------|-------------|----------|
| sword.webp | Sword slash ability icon | https://storage... |
```

---

## Phase 2: HTML Mockup

Build a static HTML page at 1920x1080 that composites the generated images into the UI layout.

### 2.1 Create the HTML File

Save to: `assets/ui/[element-name]/mockup.html`

**Required elements in the HTML:**

1. **Figma capture script** (in `<head>`):
```html
<script src="https://mcp.figma.com/mcp/html-to-design/capture.js" async></script>
```

2. **Fixed viewport** (1920x1080 for game resolution):
```css
body {
  width: 1920px;
  height: 1080px;
  overflow: hidden;
  position: relative;
}
```

3. **Local image paths** (relative, not remote URLs):
```html
<img src="sword.webp" alt="Sword Slash">
```

### 2.2 Embed Images as Base64 (Recommended)

For maximum reliability with Figma capture, embed images as base64 data URIs. This eliminates any image loading timing issues.

Generate the embedded version using Python:
```python
python3 -c "
import base64
with open('mockup.html', 'r') as f:
    html = f.read()
for name in ['image1', 'image2', ...]:
    with open(f'{name}.webp', 'rb') as f:
        b64 = base64.b64encode(f.read()).decode('ascii')
    html = html.replace(f'{name}.webp', f'data:image/webp;base64,{b64}')
with open('mockup-embedded.html', 'w') as f:
    f.write(html)
"
```

Save as: `assets/ui/[element-name]/mockup-embedded.html`

### 2.3 Design Guidelines

When building the mockup, follow the project's visual style:
- Read `docs/design-bible.md` for color palette and tone (if it exists)
- Use the game's background color as the page background
- Include hover states via CSS `:hover` as visual reference (won't transfer to Figma)
- Add CSS transitions for interactive elements (serves as animation spec)
- Use proper semantic structure (each UI element in its own container)

---

## Phase 3: Push to Figma

### 3.1 Start Local Server

```bash
# Check if port is free
lsof -i :8080

# Start server from the asset directory
cd assets/ui/[element-name]/
npx http-server . -p 8080 --cors
```

### 3.2 Verify Server

```bash
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/mockup-embedded.html
# Should return 200
```

### 3.3 Generate Figma File

Load the Figma tool:
```
ToolSearch: query="select:mcp__plugin_figma_figma__generate_figma_design"
```

Create a new Figma file:
```
mcp__plugin_figma_figma__generate_figma_design:
  outputMode: "newFile"
  fileName: "[Element Name] - Game UI"
```

This returns a capture ID and instructions.

### 3.4 Open with Capture

**CRITICAL:** Use `figmadelay=5000` or higher to ensure images load before capture.

```bash
open "http://localhost:8080/mockup-embedded.html#figmacapture=[CAPTURE_ID]&figmaendpoint=[ENDPOINT]&figmadelay=5000"
```

### 3.5 Poll for Completion

Wait 15 seconds, then poll:
```
mcp__plugin_figma_figma__generate_figma_design:
  captureId: "[CAPTURE_ID]"
```

### 3.6 Open the Figma File

```bash
open "[FIGMA_CLAIM_URL]"
```

### 3.7 Present to User

Tell the user:
```
The UI mockup has been pushed to Figma: [URL]

Next steps:
1. Open the Figma file and verify the layout looks correct
2. Pass it to Figma Make to add interactivity
3. In Make, add animations (hover effects, transitions, state changes)
4. When done, share the Make URL with me and I'll implement it in Godot
```

### 3.8 Troubleshooting

**Images missing in Figma:**
- Ensure you used the base64-embedded HTML version
- Increase `figmadelay` to 7000-10000ms
- Verify the local server is running and serving images (curl test)
- Try a fresh capture ID (each is single-use)

**Capture fails/errors:**
- Check the browser actually opened the page (look for the capture toolbar)
- Wait longer before polling (20-30 seconds for large pages)
- Generate a completely new capture ID if the old one expired

**Layout wrong:**
- The capture converts HTML to Figma vectors — some CSS properties don't translate perfectly
- Complex gradients, box-shadows, and filters may simplify
- This is expected — the user will refine in Figma/Make

---

## Phase 4: User Edits in Figma Make (Manual)

This phase is done by the user. They will:
1. Import the Figma Design file into Figma Make
2. Add interactivity using React + Framer Motion
3. Test the interactive prototype in the Make preview
4. Share the Make URL when done

**While waiting**, you can:
- Prepare the Godot scene structure
- Set up placeholder scripts
- Continue other sprint work

**When the user shares the Make URL**, proceed to Phase 5.

---

## Phase 5: Pull from Figma Make

### 5.1 Extract the File Key

From a Make URL like:
```
https://www.figma.com/make/[FILE_KEY]/[NAME]?...
```
Extract `[FILE_KEY]`.

### 5.2 Get Resource Links

Load the Figma tool:
```
ToolSearch: query="select:mcp__plugin_figma_figma__get_design_context"
```

```
mcp__plugin_figma_figma__get_design_context:
  fileKey: "[FILE_KEY]"
  nodeId: ""
  clientLanguages: "gdscript"
  clientFrameworks: "godot"
```

This returns a list of resource links. The key files are:
- `src/app/App.tsx` — **Primary file.** Contains all interactive behavior.
- `src/imports/[ComponentName].tsx` — Auto-generated static layout from Figma Design.

### 5.3 Fetch the Source Files

**IMPORTANT:** The MCP server name is `plugin:figma:figma` (with colons, not underscores).

```
ReadMcpResourceTool:
  server: "plugin:figma:figma"
  uri: "file://figma/make/source/[FILE_KEY]/src/app/App.tsx"
```

Also fetch any custom components imported by App.tsx. Skip the generic `components/ui/` files (those are shadcn defaults).

### 5.4 Analyze the Interactive Behaviors

Read the App.tsx and extract a behavior map. Look for:

| React/Framer Motion Pattern | What It Means |
|---|---|
| `whileHover={{ scale: 1.05 }}` | Hover: scale to 1.05 |
| `whileTap={{ scale: 0.95 }}` | Press: scale to 0.95 |
| `animate={{ opacity: [0.3, 0.7, 0.3] }}` | Looping opacity pulse |
| `transition={{ duration: 2, repeat: Infinity }}` | 2-second infinite loop |
| `initial={{ opacity: 0, y: -50 }}` | Entrance animation (fade + slide) |
| `useState` / `useEffect` | State management / side effects |
| `onClick` handler | Click behavior |
| `onMouseEnter` / `onMouseLeave` | Hover enter/exit |
| CSS `transition: all 0.2s ease` | Smooth property transitions |
| CSS `box-shadow: 0 0 Npx color` | Glow effect (use shader or modulate in Godot) |
| CSS `filter: grayscale(1)` | Desaturated icon (use modulate in Godot) |

Document the behavior map before implementing.

---

## Phase 6: Implement in Godot

### 6.1 Create the Scene

Create a minimal `.tscn` file with just the root Control node and script reference:

```
Scene: scenes/ui/[element_name].tscn
Script: scripts/ui/[element_name].gd
```

### 6.2 Translation Reference

Use this mapping to convert Make behaviors to Godot:

| Make (React/Framer Motion) | Godot Equivalent |
|---|---|
| `<div>` container | `Control` / `Panel` / `ColorRect` |
| `<img src="...">` | `TextureRect` with loaded texture |
| `<p>` / `<span>` text | `Label` / `RichTextLabel` |
| `<button>` | `Button` / `Panel` with `gui_input` signal |
| `whileHover` scale | `mouse_entered`/`mouse_exited` signals → Tween scale |
| `whileTap` scale | `gui_input` (button_pressed) → Tween scale |
| `animate` looping | `create_tween().set_loops()` |
| `transition.duration` | Tween duration parameter |
| `transition.ease: "easeOut"` | `Tween.EASE_OUT` |
| `transition.delay` | `tween.tween_interval(delay)` before animation |
| `initial` → `animate` | Entrance tween in `_ready()` |
| `useState` | GDScript `var` member variables |
| `useEffect` with interval | `_process(delta)` or Timer node |
| `onClick` | `gui_input` signal or `pressed` signal |
| CSS `background: linear-gradient(...)` | `StyleBoxFlat` with `bg_color` or gradient shader |
| CSS `border: 2px solid color` | `StyleBoxFlat` with `border_color` and `border_width` |
| CSS `border-radius: Npx` | `StyleBoxFlat` with `corner_radius` |
| CSS `box-shadow: 0 0 Npx color` | Glow shader (`radial_glow.gdshader`) or `CanvasItemMaterial(BLEND_MODE_ADD)` |
| CSS `opacity: N` | `modulate.a = N` or `self_modulate.a = N` |
| CSS `transform: translateY(-4px)` | Tween `position.y` |
| CSS `filter: grayscale(1)` | `modulate = Color(0.5, 0.5, 0.5, 0.4)` |
| `toLocaleString()` (number formatting) | Custom `_format_number()` function |

### 6.3 Glow Effects

For CSS `box-shadow` glow effects on dark backgrounds, use the project's radial glow shader:

```gdscript
var glow_shader: Shader = load("res://resources/shaders/radial_glow.gdshader")
```

If the shader doesn't exist, create it:
```glsl
shader_type canvas_item;
uniform vec4 glow_color : source_color = vec4(0.0, 1.0, 0.533, 0.4);
uniform float softness : hint_range(0.01, 1.0) = 0.5;
void fragment() {
    float dist = distance(UV, vec2(0.5));
    float alpha = smoothstep(0.5, 0.5 - softness * 0.5, dist);
    COLOR = vec4(glow_color.rgb, glow_color.a * alpha);
}
```

For sweep/flash effects (button press flash), use:
```glsl
shader_type canvas_item;
uniform float sweep_position : hint_range(-0.5, 1.5) = -0.5;
uniform float sweep_width : hint_range(0.05, 0.5) = 0.15;
uniform float max_opacity : hint_range(0.0, 1.0) = 0.3;
void fragment() {
    float dist = abs(UV.x - sweep_position);
    float alpha = smoothstep(sweep_width, 0.0, dist) * max_opacity;
    COLOR = vec4(1.0, 1.0, 1.0, alpha);
}
```

### 6.4 Build the Script

Structure the GDScript to match the Make file's component architecture:

```gdscript
extends Control

# --- Constants (from Make file's data model) ---
const ITEM_DATA: Array[Dictionary] = [...]

# --- State (from Make file's useState) ---
var _selected_item: int = 0
var _hovered_item: int = -1

# --- UI References (built in _ready or from scene tree) ---
var _slots: Dictionary = {}

func _ready() -> void:
    _load_textures()
    _build_ui()

func _process(delta: float) -> void:
    # Tick any timers (cooldowns, animations)
    pass

func _input(event: InputEvent) -> void:
    # Keyboard shortcuts (from Make file's useEffect keydown handler)
    pass
```

### 6.5 Implementation Checklist

- [ ] All static layout elements from the Make file are present
- [ ] All textures load from `assets/ui/[element-name]/`
- [ ] Hover effects match Make file (`mouse_entered`/`mouse_exited`)
- [ ] Click/press effects match Make file (`gui_input` / `pressed`)
- [ ] Looping animations match Make file (tweens with `set_loops()`)
- [ ] State changes work (HP/mana bars, counters, selections)
- [ ] Keyboard shortcuts work (if applicable)
- [ ] Tooltips show/hide correctly (if applicable)
- [ ] Entrance animations play on `_ready()` (if applicable)
- [ ] Colors match Make file hex values
- [ ] Sizes and positions match Make file pixel values
- [ ] All `mouse_filter` settings are correct (IGNORE on decorative elements)

---

## Phase 7: Smoke Test

### 7.1 Rebuild Class Cache

```bash
[godot_path] --headless --editor --quit --path "[project_path]" 2>&1
```

### 7.2 Headless Run

```bash
[godot_path] --headless --quit --path "[project_path]" 2>&1
```

### 7.3 Report to User

If clean:
```
Smoke test passed. The [element name] scene is ready at:
- Scene: scenes/ui/[element_name].tscn
- Script: scripts/ui/[element_name].gd

To test: open the scene in Godot and run it (F6).
```

If errors: diagnose, fix, and re-run until clean.

---

## Quick Reference: MCP Server Names

| Server | Name (for ReadMcpResourceTool) |
|--------|------|
| Figma | `plugin:figma:figma` |
| Figma Desktop | `plugin:figma:figma-desktop` |
| Ludo | `ludo` |
| Epidemic Sound | `epidemic-sound` |

## Quick Reference: Make File Resource URIs

```
Source files:  file://figma/make/source/[FILE_KEY]/[path]
Image assets:  file://figma/make/image/[FILE_KEY]/[hash].png
```

## Quick Reference: Figma Capture Gotchas

1. **Never use `file://` URLs** — always serve via http-server
2. **Remote images won't load** in time — download locally or embed as base64
3. **Each capture ID is single-use** — generate a new one for each attempt
4. **Use `figmadelay=5000`** minimum for image-heavy pages
5. **Poll after 15+ seconds** — the capture + upload takes time
6. **If capture fails**, generate a completely new capture ID and retry

---

## Example Invocation

**User:** `/figma-ui-pipeline RPG inventory grid with item tooltips`

**Expected flow:**
1. Ask user about grid size, item types, visual style preferences
2. Generate icons via Ludo (weapons, armor, potions, etc.)
3. Build 1920x1080 HTML with inventory grid layout
4. Push to Figma, share link
5. User adds hover/drag/tooltip animations in Make
6. User shares Make URL
7. Pull Make source, analyze behaviors
8. Implement in Godot with matching animations
9. Smoke test, deliver scene + script
