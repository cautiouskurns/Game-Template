---
name: gameplay-prototype
description: Generate and maintain a playable HTML/JS prototype from feature specs. Builds a persistent browser-based game sandbox that grows across sprints, letting you test mechanics and UI flows before committing to Godot implementation.
domain: project
type: generator
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

# Gameplay Prototype Skill

This skill generates a playable HTML/JS prototype from approved feature specs, creating a persistent browser-based sandbox that grows across sprints. It lets you test mechanics, UI flows, and system interactions before committing to Godot implementation.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | design-lead (or user directly) |
| **Sprint Phase** | Phase A (after specs approved, before Phase B) |
| **Directory Scope** | `docs/prototypes/` |
| **Downstream** | User play-tests in browser, feeds insights back into feature specs before implementation |

---

## When to Use This Skill

Invoke this skill when the user:
- Says `/gameplay-prototype`
- Says "Prototype [feature name]"
- Wants to "create a playable prototype of [feature]"
- Wants to "add [feature] to the prototype"
- Says "let me test [feature] in the browser"
- Wants to validate a feature spec before Godot implementation

---

## Key Design Principles

1. **Disposable, not precious.** The prototype validates ideas — it's not a deliverable. Don't polish.
2. **Spec-driven.** Every feature module traces back to a specific section of a feature spec.
3. **Cumulative.** The prototype grows across sprints. Sprint 4's combat prototype sits alongside Sprint 2's crafting prototype.
4. **Low-fidelity.** Colored rectangles, text labels, basic CSS. No art assets, no audio, no animation.
5. **Zero dependencies.** Vanilla HTML/CSS/JS. Opens with a double-click. No npm, no build tools, no CDN.
6. **Shared state.** Features that interact in the real game should interact in the prototype via a shared state object.
7. **Browser-only.** Never import prototype code into Godot. The two codebases are completely separate.

---

## Quick Reference

```
# Prototype a feature:
/gameplay-prototype

# Output:
docs/prototypes/index.html       — open in browser to test
docs/prototypes/styles.css        — project palette, shared styles
docs/prototypes/app.js            — router + shared state
docs/prototypes/features/*.js     — one module per prototyped feature
```

---

## How to Use This Skill

**IMPORTANT: Always announce at the start that you are using the Gameplay Prototype skill.**

Example: "I'm using the **Gameplay Prototype** skill to create a playable browser prototype for [feature-name]."

### Procedure (7 Steps)

---

### Step 1: Identify What to Prototype

Determine which feature(s) to prototype from user input or context.

**Ask the user:**
- Which feature spec(s) to prototype (can be multiple)
- What aspect to focus on (UI layout, mechanic feel, data flow, full loop)

Read the feature spec(s) from `docs/features/`.

**Wait for user response if the feature target is unclear.** If the user already specified a feature, proceed directly.

---

### Step 2: Gather Context

Read supporting docs for informed generation:

1. **The feature spec(s)** from `docs/features/` — primary input
2. **`docs/art-direction.md`** — extract the Global Palette hex codes for consistent colors (use the project's actual palette, not generic colors)
3. **GDD or systems bible** — for broader game context (`docs/*-gdd.md`, `docs/systems-bible.md`)
4. **Existing prototype code** — if `docs/prototypes/index.html` exists, read it to understand what's already built

---

### Step 3: Scaffold or Read Existing Prototype

Check if `docs/prototypes/index.html` exists using Glob.

#### If New (First Run)

Create the base scaffold:

```
docs/prototypes/
  index.html          — shell: nav sidebar + content area + shared styles
  styles.css          — project palette from art-direction, basic layout
  app.js              — simple hash router, shared state, nav rendering
  features/           — one JS file per prototyped feature
```

The scaffold MUST:
- Use the project's art direction palette for background, text, and accent colors (read from `docs/art-direction.md`)
- Include a sidebar nav that lists all prototyped features
- Use a simple hash-based router (`#combat`, `#crafting`, etc.)
- Include a shared state object that features can read/write (simulating game state)
- Be 100% vanilla HTML/CSS/JS — no build tools, no npm, no CDN dependencies
- Work by opening `index.html` directly in any browser (`file://` protocol)
- Use ES modules via `<script type="module">`

**index.html structure:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Project Name] — Prototype</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <nav id="sidebar">
    <h2>[Project Name]</h2>
    <p class="subtitle">Gameplay Prototype</p>
    <ul id="nav-list"></ul>
  </nav>
  <main id="content">
    <div id="welcome">
      <h1>Gameplay Prototype</h1>
      <p>Select a feature from the sidebar to begin testing.</p>
    </div>
  </main>
  <script type="module" src="app.js"></script>
</body>
</html>
```

**styles.css structure:**
- CSS custom properties from the project's art direction palette
- Sidebar layout (fixed left, scrollable)
- Content area (fills remaining space)
- Basic component styles (buttons, panels, grids, labels)
- Low-fidelity aesthetic: borders, background colors, monospace text

**app.js structure:**
```javascript
// Shared game state — features read/write this to simulate cross-system interaction
export const state = {
  // Populated by features as they're added
};

// Route table — maps hash routes to feature modules
const routes = {};

// Register a feature module
export function registerFeature(id, label, module) {
  routes[id] = module;
  // Add nav entry
}

// Router: listen for hashchange, call init/cleanup
// On hash change: cleanup current feature, init new feature

// Import and register feature modules below
```

#### If Existing

Read `index.html`, `styles.css`, `app.js`, and all files in `docs/prototypes/features/` to understand the current state.

List what features are already prototyped and tell the user.

---

### Step 4: Generate the Feature Module

Create `docs/prototypes/features/[feature-name].js` containing:

- An `init(container, state)` function that sets up the feature's DOM in the content area
- A `cleanup()` function that tears down when navigating away
- Event listeners for interaction
- Hardcoded test data (not real save/load — just enough to demonstrate the mechanic)
- Comments linking back to the feature spec section being prototyped

**The module MUST be deliberately low-fidelity:**
- Colored rectangles and text labels, not sprites
- CSS borders and backgrounds, not images
- `console.log` for events that would trigger audio/VFX
- Placeholder data that demonstrates the mechanic, not real game content

**ES module pattern:**
```javascript
// docs/prototypes/features/[feature-name].js
// Prototype for: [Feature Name]
// Spec: docs/features/[feature-name].md

let _container = null;

export function init(container, state) {
  _container = container;
  // Build DOM, attach listeners, render initial state
}

export function cleanup() {
  if (_container) _container.innerHTML = '';
  _container = null;
  // Remove any global listeners
}
```

**Guidelines for feature modules:**
- Keep each module self-contained — all DOM creation happens in `init()`
- Use `container.innerHTML` or `document.createElement` to build UI
- Read from and write to the shared `state` object for cross-feature interaction
- Include enough hardcoded data to make the feature testable (e.g., sample items, enemy stats, grid layouts)
- Add brief comments referencing which spec section each part implements

---

### Step 5: Wire Into the Prototype

Update `app.js` to:
- Import the new feature module
- Add it to the route table via `registerFeature()`
- The nav entry is automatically created by `registerFeature()`

If the feature interacts with existing prototyped features (e.g., crafting produces items used in combat), wire up the shared state connections:
- Add relevant keys to the `state` object
- Document which features read/write which state keys

---

### Step 6: Test in Browser

Instruct the user to open the prototype:

```
open docs/prototypes/index.html
```

Provide the full file path appropriate for their OS. Remind them that ES modules require either:
- A local server (e.g., `python3 -m http.server` from the `docs/prototypes/` directory), OR
- A browser that supports `file://` with module scripts (most modern browsers do with appropriate flags)

If modules cause issues with `file://`, offer to refactor into a single-file IIFE pattern as a fallback.

---

### Step 7: Present to User

Summarize what was prototyped:
- Which feature spec sections are covered
- What interactions are available
- What's hardcoded vs dynamic
- Known limitations (things the prototype doesn't test)

**Ask the user to choose:**

- **APPROVE** — Spec validated, proceed to Phase B implementation
- **REVISE** — Something feels wrong, revise the feature spec before implementing
- **EXTEND** — Add more to this prototype (another feature, deeper interaction, edge cases)

---

## Handling Existing Prototypes

When the prototype already exists and the user wants to add a feature:

1. Read all existing files to understand current state
2. Check if the new feature interacts with any existing prototyped features
3. Generate only the new feature module
4. Update `app.js` with the new import and registration
5. If shared state connections are needed, update both the new and existing modules
6. Do NOT regenerate the scaffold — only modify what's necessary

---

## Output

All prototype files live in:
```
docs/prototypes/
```

This directory is:
- **Separate from Godot** — never import prototype code into the game
- **Cumulative** — grows across sprints as features are prototyped
- **Disposable** — can be deleted entirely without affecting the game

---

## Quality Criteria

### Every Prototype Must:
1. **Open in a browser** with no build step or external dependencies
2. **Use the project's actual palette** from art direction, not generic colors
3. **Trace to a feature spec** — every interactive element maps to a spec section
4. **Be low-fidelity** — rectangles and labels, not polished UI
5. **Support shared state** — features that interact in the game interact in the prototype

### Red Flags to Avoid:
- **Over-polishing** — spending time on visual fidelity instead of mechanic feel
- **Real game data** — use hardcoded test data, not actual JSON content files
- **External dependencies** — no npm, no CDN, no build tools
- **Prototype-to-game copying** — the prototype is throwaway, never port its code to Godot
