# Art Reference Collector

Collate reference images for a target game's art style, analyze its visual characteristics, and produce a style guide that drives consistent asset generation via Ludo's `generateWithStyle`.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | asset-artist (or orchestrator during Phase 0) |
| **Sprint Phase** | Phase 0 (after design bible) or Phase A (before asset generation) |
| **Directory Scope** | `assets/references/`, `docs/art-direction.md` |
| **Downstream** | asset-artist uses style anchors with `mcp__ludo__generateWithStyle` |

## How to Invoke This Skill

Users can trigger this skill by saying:
- `/art-reference-collector`
- "Collect reference images for [game name]"
- "Set up the art direction"
- "I want to replicate [game name]'s art style"

---

## Procedure

### Step 1: Identify the Target Game

Ask the user (or read from context) which game's art style to replicate. Gather:

1. **Game name** — the primary reference game
2. **Secondary references** (optional) — other games with similar style elements
3. **What to prioritize** — e.g., "the character sprites more than backgrounds" or "the color palette"

If the user provides screenshots directly (file paths or pasted images), skip to Step 3.

### Step 2: Gather Reference Images

Use **multiple sources** to build a comprehensive reference set:

#### 2a: Web Search for Screenshots

Search for high-quality screenshots and art:

```
WebSearch: "[game name] screenshot gameplay"
WebSearch: "[game name] sprite sheet pixel art"
WebSearch: "[game name] environment art background"
WebSearch: "[game name] UI interface HUD design"
WebSearch: "[game name] character design concept art"
WebSearch: "[game name] visual effects VFX"
```

From the results, identify URLs of useful reference images. Prefer:
- Official press kits and media pages (highest quality)
- Wiki pages with clean screenshots
- Fan sites with sprite rips (for pixel art games)
- Artstation/DeviantArt for concept art

#### 2b: Download References

For each useful image URL, download to the references directory:

```bash
curl -L -o "assets/references/[category]/[descriptive_name].png" "[url]"
```

Organize into category subdirectories:
- `assets/references/characters/` — player, NPCs, enemies, bosses
- `assets/references/environments/` — backgrounds, rooms, landscapes
- `assets/references/tilesets/` — terrain, platforms, walls
- `assets/references/ui/` — HUD, menus, dialog boxes, icons
- `assets/references/effects/` — particles, spells, hit effects, lighting
- `assets/references/palette/` — color palette extractions or swatches

Create the directories first:
```bash
mkdir -p assets/references/{characters,environments,tilesets,ui,effects,palette}
```

#### 2c: User-Provided References

If the user provides their own screenshots (often the best references):
1. Copy them to the appropriate category subdirectory
2. Rename to follow the convention: `[game]_[category]_[description].png`

**Aim for 3-5 images per category minimum, 10+ total across all categories.**

### Step 3: Analyze the Art Style

Read each reference image (Claude can view images via the Read tool) and analyze the visual characteristics. Document the following:

#### Color Analysis
- **Dominant palette** — the 5-8 most prominent colors (list as hex codes)
- **Palette mood** — warm/cool/neutral, saturated/muted, high/low contrast
- **Background treatment** — dark/light, atmospheric, layered parallax
- **Accent colors** — what draws the eye (UI highlights, damage numbers, collectibles)

#### Line & Shape Analysis
- **Line style** — pixel art (what resolution?), hand-drawn, vector, painterly, 3D-rendered
- **Line weight** — thin/thick outlines, no outlines, variable weight
- **Shape language** — rounded/angular/organic, silhouette readability
- **Detail density** — sparse/medium/detailed, where detail concentrates

#### Animation & Motion Style
- **Frame count** — how many frames per animation (2-frame bobble vs 12-frame smooth)
- **Animation style** — snappy/floaty, anticipation frames, squash-and-stretch
- **Particle effects** — minimal/heavy, style of VFX

#### Scale & Proportion
- **Character size** — pixel height of characters relative to screen
- **Head-to-body ratio** — chibi/realistic/exaggerated
- **Environment scale** — how much of the screen one room fills
- **UI scale** — how much screen space UI occupies

#### Mood & Atmosphere
- **Lighting** — flat/directional, ambient occlusion, glow effects
- **Atmosphere** — fog, depth layers, environmental storytelling
- **Tone** — dark/whimsical/gritty/clean/nostalgic

### Step 4: Select Style Anchors

From the collected references, designate **one primary style anchor per category**. These are the specific images that will be passed to Ludo's `generateWithStyle` as the `style_image` parameter.

Selection criteria for a good style anchor:
- **Representative** — captures the core look of that category
- **Clean** — no UI overlays, watermarks, or compression artifacts
- **Complete** — shows a full character/scene, not a cropped fragment
- **Medium complexity** — not the simplest or most complex example

Designate anchors:
- `assets/references/style_anchor_character.png` — primary character style reference
- `assets/references/style_anchor_environment.png` — primary environment style reference
- `assets/references/style_anchor_tileset.png` — primary tileset style reference
- `assets/references/style_anchor_ui.png` — primary UI style reference
- `assets/references/style_anchor_effects.png` — primary effects style reference (if applicable)

Copy (don't move) the selected images to these anchor paths. The originals stay in their category folders.

### Step 5: Generate Art Direction Document

Create `docs/art-direction.md` using this template:

```markdown
# Art Direction

## Reference Game
- **Primary:** [game name]
- **Secondary:** [other references, if any]
- **Target fidelity:** [exact replica / inspired by / loose interpretation]

## Visual Style Summary
[2-3 sentence description of the overall art style, readable by any agent]

## Color Palette

| Role | Hex | Usage |
|------|-----|-------|
| Primary BG | #XXXXXX | Main background color |
| Secondary BG | #XXXXXX | Foreground/platform color |
| Player highlight | #XXXXXX | Player character accent |
| Enemy highlight | #XXXXXX | Enemy accent/warning color |
| UI text | #XXXXXX | HUD and menu text |
| UI accent | #XXXXXX | Health bars, selection |
| Collectible | #XXXXXX | Geo, pickups, rewards |
| Danger | #XXXXXX | Damage, hazards, lava |

## Line & Shape Style
- **Rendering:** [pixel art NxN / hand-drawn / vector / painterly]
- **Outlines:** [none / 1px black / variable weight / colored]
- **Shape language:** [description]
- **Detail level:** [sparse / medium / detailed]

## Character Proportions
- **Sprite size:** [WxH pixels]
- **Head-to-body:** [ratio, e.g., 1:2 chibi]
- **Silhouette priority:** [what makes characters readable at a glance]

## Environment Style
- **Room composition:** [layered parallax / flat / 2.5D]
- **Platform style:** [description]
- **Background treatment:** [description]
- **Atmosphere:** [fog, lighting, depth]

## UI Style
- **HUD placement:** [top-left / bottom / minimal overlay]
- **Font style:** [pixel / clean sans / ornate]
- **Panel style:** [bordered / borderless / ornamental]
- **Health/resource display:** [hearts / bar / masks / orbs]

## Animation Guidelines
- **Idle:** [frame count, description]
- **Run/Walk:** [frame count, description]
- **Attack:** [frame count, description]
- **Frame timing:** [fps or ms per frame]

## Style Anchors (for Ludo generateWithStyle)

| Category | Path | Description |
|----------|------|-------------|
| Characters | `assets/references/style_anchor_character.png` | [what the image shows] |
| Environments | `assets/references/style_anchor_environment.png` | [what the image shows] |
| Tilesets | `assets/references/style_anchor_tileset.png` | [what the image shows] |
| UI | `assets/references/style_anchor_ui.png` | [what the image shows] |
| Effects | `assets/references/style_anchor_effects.png` | [what the image shows] |

## Ludo Prompt Guidelines

When generating assets with `generateWithStyle`, follow these prompt patterns:

### Characters
```
style_image: [base64 of style_anchor_character.png]
prompt: "[character description], [pose], [color palette notes], matching reference art style"
image_type: "sprite"
```

### Environments
```
style_image: [base64 of style_anchor_environment.png]
prompt: "[scene description], [mood], [lighting], matching reference art style"
image_type: "fixed_background"
```

### Tilesets
```
style_image: [base64 of style_anchor_tileset.png]
prompt: "[terrain type] tileset, seamless, [material], matching reference art style"
image_type: "asset"
```

### UI
```
style_image: [base64 of style_anchor_ui.png]
prompt: "[UI element], [style notes], matching reference art style"
image_type: "ui_asset"
```

## Notes
[Any additional observations about the art style, gotchas, or things to watch for]
```

### Step 6: Present to User for Approval

Display a summary of:
1. How many reference images collected per category
2. The style analysis highlights (palette, line style, scale)
3. Which images were selected as style anchors
4. The art direction document path

Use AskUserQuestion:
- **APPROVE** — Accept the art direction, proceed
- **MODIFY** — Change style anchors, adjust analysis, add more references
- **ADD MORE** — User wants to provide additional screenshots before approving

---

## Integration with Asset-Artist Agent

Once approved, the art direction feeds into asset generation:

1. **asset-artist reads `docs/art-direction.md`** at the start of every sprint
2. **Every `generateWithStyle` call** uses the appropriate style anchor:
   - Character sprites → `style_anchor_character.png`
   - Backgrounds → `style_anchor_environment.png`
   - Tilesets → `style_anchor_tileset.png`
   - UI elements → `style_anchor_ui.png`
3. **The `style_image` parameter** accepts base64 — encode the anchor file:
   ```bash
   base64 -i assets/references/style_anchor_character.png
   ```
   Then pass as `"data:image/png;base64,[encoded_data]"`
4. **Prompt augmentation** — include palette hex codes and style keywords from the art direction doc in every prompt for best results

## Integration with Feature Specs

Feature specs should reference the art direction when describing visual requirements:
- "Character sprites following `docs/art-direction.md` Character Proportions"
- "Environment using palette from art direction (Primary BG: #XXXXXX)"
- "UI panel matching style_anchor_ui.png"

## Updating the Art Direction

If the art style evolves during development:
1. Add new reference images to `assets/references/[category]/`
2. Update style anchors if a better reference is found
3. Update `docs/art-direction.md` with the changes
4. Note the change in `CHANGELOG.md`

---

## Quick Reference

```
# Collect references for a game:
/art-reference-collector

# Output:
assets/references/           — organized reference images
assets/references/style_anchor_*.png  — primary style anchors for Ludo
docs/art-direction.md        — full style guide with palette, proportions, prompts
```
