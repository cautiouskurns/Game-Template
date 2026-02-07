---
name: figma-prompt-generator
description: Generate detailed prompts for Figma Make to create game UI visuals. Analyzes project context (GDD, existing UI, color schemes, design pillars) and produces comprehensive Figma Make prompts for UI screens, HUD elements, menus, and visual components.
domain: project
type: generator
version: 1.0.0
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
---

# Figma Prompt Generator Skill

This skill analyzes your game project context and generates **detailed, production-ready prompts** for Figma Make to create UI visuals that match your game's aesthetic and design vision.

---

## When to Use This Skill

Invoke this skill when the user:
- Says "create a Figma prompt for [UI element]"
- Says "generate visuals for [screen/HUD/menu]"
- Wants to design UI in Figma that matches their game style
- Says "I need a Figma Make prompt for..."
- Wants consistent UI design across multiple screens
- Needs to communicate design intent to Figma AI
- Says "design prompt for [component]"

---

## Core Principle

**Context-aware prompts produce better results:**
- ✅ Analyzes existing game design documents
- ✅ Extracts color schemes from existing code/assets
- ✅ Understands the game's visual style and mood
- ✅ References design pillars for consistency
- ✅ Generates detailed, specific prompts
- ✅ Includes technical specifications for game integration

---

## Workflow

### Step 1: Gather Project Context

**Search for and read:**

1. **Design Documents:**
   - `docs/*gdd*.md` - Game design document
   - `docs/*design-bible*.md` - Visual/design guidelines
   - `docs/features/*` - UI-related feature specs

2. **Existing UI Code:**
   - `scripts/ui/*.gd` - UI scripts for color constants
   - `scenes/ui/*.tscn` - Scene structure
   - `theme/*.tres` - Godot theme resources

3. **Color Schemes:**
   - Look for `Color(...)` definitions in code
   - Check for named color constants
   - Find theme color references

4. **Art Direction:**
   - `docs/*art*.md` - Art direction docs
   - Check for pixel art specifications
   - Note any style references (dark fantasy, cyberpunk, etc.)

---

### Step 2: Ask Clarifying Questions

**After gathering context, ask the user:**

```
I've analyzed your project context. Let me confirm a few things:

**1. What UI Element?**
What do you want to create?
- [ ] Full screen (menu, inventory, dialogue)
- [ ] HUD element (health bar, ability cooldowns)
- [ ] Popup/modal (confirmation, tooltip)
- [ ] Component (button, panel, card)

**2. Specific Screen/Element:**
Which exact element? (e.g., "main menu", "health bar", "inventory grid")

**3. Game State:**
When is this shown?
- [ ] Main menu (before gameplay)
- [ ] In-game HUD (during gameplay)
- [ ] Pause/overlay (over gameplay)
- [ ] Transition (between states)

**4. Key Information to Display:**
What data/content appears? (e.g., health numbers, item icons, player stats)

**5. Reference Style (if any):**
Any specific games or styles to reference?
```

**Wait for user response before generating prompt.**

---

### Step 3: Generate Figma Make Prompt

**Create a comprehensive prompt with these sections:**

```markdown
# Figma Make Prompt: [Element Name]

## Project Context
- **Game:** [Game name from GDD]
- **Genre:** [Genre]
- **Visual Style:** [Style extracted from docs]
- **Target Platform:** [PC/Mobile/Console]

---

## Design Request

### Element Type
[Full screen / HUD / Popup / Component]

### Element Name
[Specific name, e.g., "Mission Briefing Screen"]

### Purpose
[What this UI element does, from user input and GDD context]

---

## Visual Specifications

### Color Palette
**Primary Colors:**
- Background: [Hex code] - [Description]
- Text Primary: [Hex code] - [Description]
- Accent/Highlight: [Hex code] - [Description]

**Semantic Colors:**
- Success/Positive: [Hex code]
- Warning/Caution: [Hex code]
- Error/Danger: [Hex code]
- Disabled/Inactive: [Hex code]

**UI-Specific:**
- Panel Background: [Hex code with alpha]
- Border/Outline: [Hex code]
- Button Normal: [Hex code]
- Button Hover: [Hex code]

### Typography
- **Title Font Style:** [Bold, pixelated, clean, etc.]
- **Title Size:** [Large/Medium based on hierarchy]
- **Body Font Style:** [Description]
- **Body Size:** [Medium/Small]
- **Accent/Label Style:** [UPPERCASE, small caps, etc.]

### Visual Style
- **Overall Mood:** [Dark, light, vibrant, muted]
- **Corners:** [Sharp/Rounded/Pixel-rounded]
- **Borders:** [Thin lines / Thick frames / None / Glow]
- **Shadows:** [Hard pixel shadows / Soft shadows / None]
- **Texture:** [Clean / Subtle noise / Grunge / Pixel dithering]

---

## Layout Specifications

### Screen Dimensions
- **Target Resolution:** [1920x1080 / 1280x720 / etc.]
- **Safe Area:** [Margins for different screen sizes]

### Structure
```
[ASCII diagram of layout]
+---------------------------+
|         HEADER            |
|---------------------------|
|  SIDEBAR  |    MAIN       |
|           |    CONTENT    |
|           |               |
|---------------------------|
|         FOOTER            |
+---------------------------+
```

### Key Components
1. **[Component 1]:** [Size, position, purpose]
2. **[Component 2]:** [Size, position, purpose]
3. **[Component 3]:** [Size, position, purpose]

---

## Content Requirements

### Text Content
- **Title:** "[Placeholder title]"
- **Subtitle:** "[Placeholder subtitle]"
- **Body Text:** "[Sample content that represents typical length]"
- **Buttons:** "[Button labels]"

### Visual Content
- **Icons Needed:** [List of icon types]
- **Images/Portraits:** [Placeholder areas]
- **Decorative Elements:** [Borders, dividers, etc.]

---

## Interactive States

### Buttons
- **Normal:** [Description]
- **Hover:** [Description - color shift, glow, scale]
- **Pressed:** [Description]
- **Disabled:** [Description]

### Panels/Cards
- **Default:** [Description]
- **Selected:** [Description]
- **Highlighted:** [Description]

---

## Animation Hints
- **Entrance:** [Fade in / Slide / Scale]
- **Transitions:** [How elements change state]
- **Feedback:** [Micro-animations for interactions]

---

## Game Integration Notes

### Godot Implementation
- **Scene Type:** [Control / CanvasLayer / etc.]
- **Anchor Points:** [Full rect / Center / etc.]
- **Scaling Mode:** [How it handles different resolutions]

### Asset Export
- **Format:** PNG with transparency
- **Resolution:** [1x, 2x for retina]
- **Naming:** [Naming convention for assets]

---

## Reference Images
[If user provided references, list them here]

---

## Prompt for Figma Make

**Copy this prompt directly into Figma Make:**

---

Create a [element type] for a [genre] game called "[game name]".

**Style:** [Visual style description - 2-3 sentences capturing the mood, era, and aesthetic]

**Color Scheme:**
- Dark background ([hex])
- Primary text ([hex])
- Accent highlights ([hex])
- Panel backgrounds with transparency

**Layout:**
[Describe the layout in natural language, mentioning all key components and their approximate positions]

**Components to include:**
- [Component 1 with description]
- [Component 2 with description]
- [Component 3 with description]

**Visual Details:**
- [Corner style]
- [Border treatment]
- [Shadow style]
- [Any decorative elements]

**States to show:**
- Default state
- [Any hover/active states if relevant]

**Important notes:**
- [Any critical design requirements]
- [Things to avoid]
- [Technical constraints]

---

## Checklist Before Using Prompt

- [ ] Colors match game's existing palette
- [ ] Style matches game's visual direction
- [ ] All required content/data is specified
- [ ] Layout works for target resolution
- [ ] Interactive states are defined
- [ ] Export requirements are clear
```

---

### Step 4: Save and Present

**Save the prompt to:** `docs/figma-prompts/[element-name]-prompt.md`

**Present to user with:**
```
I've generated a Figma Make prompt for your [element].

**Saved to:** docs/figma-prompts/[name]-prompt.md

**Quick copy prompt at the bottom** - paste directly into Figma Make.

The full document includes:
- Color specifications extracted from your codebase
- Layout structure based on your game's UI patterns
- Interactive states for consistency
- Godot integration notes

Would you like me to:
1. Adjust any colors or styles?
2. Generate prompts for related UI elements?
3. Create a style guide for all UI elements?
```

---

## Context Extraction Patterns

### Finding Colors in GDScript

Look for patterns like:
```gdscript
const COLOR_PRIMARY := Color(0.1, 0.1, 0.15)
Color(0.9, 0.8, 0.4, 1)  # Gold
Color.from_hsv(...)
"#FF5500"
```

### Finding Colors in TSCN

Look for:
```
theme_override_colors/font_color = Color(0.9, 0.9, 0.9, 1)
bg_color = Color(0.08, 0.08, 0.12, 0.95)
```

### Style Inference

From GDD keywords:
- "Dark fantasy" → Dark backgrounds, muted colors, ornate borders
- "Pixel art" → Crisp edges, limited palette, pixel-perfect scaling
- "Minimalist" → Clean lines, lots of whitespace, simple shapes
- "Stealth" → Dark UI, subtle highlights, cyan/green accents

---

## Example Invocations

User: "Create a Figma prompt for the main menu"
User: "Generate visuals for my health bar HUD"
User: "I need a Figma Make prompt for the inventory screen"
User: "Design prompt for mission briefing screen"
User: "Figma prompt for ability cooldown indicators"

---

## Quality Checklist

Before presenting the prompt:

- ✅ Colors extracted from actual codebase
- ✅ Style matches GDD/design bible
- ✅ All user requirements addressed
- ✅ Layout is clearly described
- ✅ Interactive states defined
- ✅ Export format specified
- ✅ Godot integration notes included
- ✅ Quick-copy prompt is clear and complete

---

## Integration with Other Skills

**Inputs from:**
- GDD (design pillars, visual style)
- Existing UI code (color constants, patterns)
- User requirements (what to design)

**Outputs to:**
- **figma-visual-updater** - Can update these prompts based on Figma prototypes
- **feature-implementer** - Provides visual specs for implementation

**Workflow chain:**
```
[UI Need] → Figma Prompt Generator → [Figma Make Prompt]
                                            ↓
[Figma Make Prompt] → Figma → [Visual Prototype]
                                      ↓
[Visual Prototype] → figma-visual-updater → [Updated Game Code]
```
