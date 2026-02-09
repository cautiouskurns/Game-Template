---
name: game-ideator
description: Generate creative, emotionally grounded game concepts through interactive constraint gathering. Uses uniqueness tests and personal resonance to avoid derivative ideas.
domain: design
type: generator
version: 2.2.0
trigger: user
allowed-tools:
  - Write
  - AskUserQuestion
---

# Game Ideator Skill v2.2

Generate game concepts through a **fast, conversational discovery process** that respects the user's time. Get to ideas quickly, generate many, let the user steer, and iterate until something clicks.

The goal: ideas that make the user **stop scrolling and start prototyping**.

## Tool Constraints

AskUserQuestion supports **max 4 questions per call, max 4 options per question**. All selectable questioning in this skill is designed around these limits. Use tree-structured questions (broad categories first, then drill-down) to capture rich preferences within these constraints.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | design-lead |
| **Sprint Phase** | Pre-sprint ideation |
| **Directory Scope** | `docs/ideas/` |
| **Workflow Reference** | See `docs/agent-team-workflow.md` |

---

## When to Use This Skill

Invoke this skill when the user:
- Asks for "game ideas" or "game concepts"
- Says "I want to make a game but don't know what"
- Requests inspiration for a game jam or prototype
- Wants to explore what's possible within constraints
- Says "generate a [genre] game concept"
- Asks "what game should I build?"
- Says "help me brainstorm game ideas"

---

## Core Philosophy

1. **Speed to inspiration** — Get to ideas fast. Don't interrogate, converse.
2. **Wide funnel, then narrow** — Generate many rough ideas, then expand favorites.
3. **The user steers** — They can skip questions, redirect, or say "more like X, less like Y" at any point.
4. **Revision is not failure** — The loop back to "try again" should feel natural, not like starting over.
5. **Personal connection > genre labels** — "A game about the anxiety of checking your phone" is better input than "puzzle roguelike."
6. **Show, don't categorize** — Describe experiences, not feature lists.

---

## Phase 1: Quick Context (1 AskUserQuestion call)

**Get practical constraints in a single pass.**

Ask these 4 questions simultaneously:

**Q1 — Timeline:**
- "Weekend jam (2-3 days)"
- "One week"
- "One month"
- "Long-term project"

**Q2 — Engine:**
- "Godot"
- "Unity"
- "Unreal"
- "Web/HTML5"

**Q3 — Experience level:**
- "First few games"
- "Made a handful"
- "Experienced dev"
- "Shipped titles"

**Q4 — Scope feel:**
- "Tiny and laser-focused"
- "Small but complete"
- "Medium (30-60 min)"
- "Ambitious"

Acknowledge briefly and move to Phase 2. Do NOT ask follow-up clarifications on practical constraints.

---

## Phase 2: Genre & Direction (Tree Structure)

This phase uses a **3-level funnel**: Genre → Sub-genre → Tone/Feel. Each step narrows from the previous, with example games at every level to anchor choices in concrete references.

### Level 1: Genre & Basics (1 AskUserQuestion call, 4 questions)

Genre is the primary organizer. Example games in descriptions make each option concrete.

**Q5 — What genre family? (single-select)**
- "Strategy & Systems" — Factorio, Into the Breach, Slay the Spire, Mini Motorways
- "Action & Survival" — Hades, Vampire Survivors, Celeste, Dead Cells
- "Puzzle & Discovery" — Baba Is You, Obra Dinn, The Witness, Dorfromantik
- "Narrative & Exploration" — Outer Wilds, Disco Elysium, A Short Hike, Stardew Valley

**Q6 — What visual/audio world? (single-select)**
- "Dark and moody" — Atmospheric, shadows, noir, industrial (Limbo, Inside, Darkest Dungeon)
- "Bright and alive" — Colorful, nature, vibrant, energetic (Stardew Valley, Ori, Celeste)
- "Retro and crunchy" — Pixels, minimal, lo-fi, terminal (Downwell, Papers Please, Pico-8)
- "Strange and beautiful" — Surreal, hand-drawn, dreamlike (Gris, Hollow Knight, Cocoon)

**Q7 — How should failure work? (single-select)**
- "Fail fast, restart fast" — Quick loops, instant retry, learn by dying (Super Meat Boy, Hotline Miami)
- "Failure should sting" — Meaningful stakes, real loss, tension (XCOM, Darkest Dungeon, FTL)
- "No real failure" — Sandbox, always progressing, expression (Stardew Valley, Townscaper)
- "Failure is a puzzle" — Adapt and overcome, figure out what went wrong (Obra Dinn, Baba Is You)

**Q8 — What should the player NEVER feel? (single-select)**
- "Bored or waiting" — Always something happening, constant engagement
- "Punished unfairly" — Clear rules, skill rewarded, no cheap deaths
- "Overwhelmed by complexity" — Elegant simplicity, easy to grasp
- "Like they've seen this before" — Freshness, surprise, unpredictability

### Level 2: Sub-Genre Deep-Dive (1 AskUserQuestion call, 3 questions)

The first question adapts based on the genre family from Q5. The other two are universal.

#### If Q5 = "Strategy & Systems":
**Q9 — What kind of strategy? (single-select)**
- "Optimization / Factory" — Build efficient machines, perfect the pipeline (Factorio, Shapez, Opus Magnum)
- "Tactical Combat" — Positional battles, ability combos, outsmart enemies (Into the Breach, Slay the Spire, XCOM)
- "Management / Tycoon" — Run something, balance competing needs, grow (Game Dev Tycoon, RimWorld, Two Point Hospital)
- "Tower Defense / Waves" — Place defenses, survive escalating waves (Bloons TD, Kingdom Rush, Orcs Must Die)

#### If Q5 = "Action & Survival":
**Q9 — What kind of action? (single-select)**
- "Roguelite / Permadeath" — Random runs, build power, die and try again (Hades, Dead Cells, Spelunky, Risk of Rain)
- "Precision Platformer" — Tight controls, hard jumps, master the movement (Celeste, Super Meat Boy, Hollow Knight)
- "Swarm / Bullet Heaven" — Mow down hordes, auto-attack, build upgrades (Vampire Survivors, Brotato, 20 Minutes Till Dawn)
- "Survival Craft" — Gather, build, survive, explore a dangerous world (Don't Starve, Terraria, Core Keeper)

#### If Q5 = "Puzzle & Discovery":
**Q9 — What kind of puzzles? (single-select)**
- "Rule Discovery" — Learn the rules through play, rewrite the logic (Baba Is You, The Witness, Stephen's Sausage Roll)
- "Deduction / Mystery" — Evidence, logic, connect the dots (Obra Dinn, The Case of the Golden Idol, Her Story)
- "Spatial / Pattern" — Arrange, fit, tile, satisfy (Tetris, Dorfromantik, Cosmic Express, Townscaper)
- "Automation / Programming" — Write rules, build machines, watch them run (Zachtronics, Human Resource Machine, Opus Magnum)

#### If Q5 = "Narrative & Exploration":
**Q9 — What kind of narrative? (single-select)**
- "Exploration Adventure" — Discover a world, uncover its secrets (Outer Wilds, Tunic, A Short Hike)
- "Story Choice / RPG" — Dialogue, decisions, branching consequences (Disco Elysium, Citizen Sleeper, Slay the Princess)
- "Cozy / Life Sim" — Tend, nurture, build relationships, relax (Stardew Valley, Spiritfarer, Unpacking)
- "Atmospheric / Walking Sim" — Absorb a place, experience a story (Firewatch, Edith Finch, Journey)

#### Always ask (regardless of Q5):

**Q10 — What pacing feels right? (single-select)**
- "Twitchy and intense" — Fast reactions, split-second timing, physical skill
- "Thoughtful and deliberate" — Plan ahead, weigh options, no time pressure
- "Rhythmic and flowing" — Patterns, momentum, getting into a groove
- "Chill with bursts" — Mostly relaxed, occasional spikes of intensity

**Q11 — What's the MOST important thing? (single-select)**
- "One brilliant mechanic" — The core interaction must be perfect and deep
- "Satisfying progression" — The feeling of getting stronger / smarter / further
- "A world I want to be in" — Atmosphere, setting, and immersion above all
- "Replayability" — Every run different, high variety, reasons to come back

### Level 3: Personal Fuel (Open-Ended Text)

After receiving Level 2 answers, present these open-ended questions as text. Tell the user to answer whichever ones spark something — they can skip any or all.

```
Last batch — these are the questions that turn good ideas into YOUR ideas. Answer whichever ones spark something, skip the rest:

**12. The moment:** Think of one specific moment in a game that stuck with you — not a whole game, just one moment. What was it and why did it hit?

**13. The obsession:** What are you fascinated by outside of games? Hobbies, rabbit holes, things you bore your friends about. (Examples: fermentation, urban decay, how ant colonies decide things, vintage radio, competitive cooking, tide pools, how rumors spread...)

**14. The system:** Is there a real-world process or job you find weirdly compelling? (Examples: air traffic control, ER triage, library cataloging, sourdough ecology, supply chain logistics, how languages evolve...)

**15. The dream:** Describe a game experience you WISH existed — not a genre, but how it would FEEL to play.

**16. The anti-inspiration:** What are you tired of seeing in games?

**17. Seeds:** Any half-formed ideas, themes, settings, words, images, or vibes already in your head? Even fragments help.
```

**IMPORTANT:** If the user gives short answers or skips the open-ended questions, that's fine. Work with what you have. The genre and sub-genre answers from Levels 1-2 give you a strong foundation. The open-ended answers make ideas personal.

---

## Phase 3: Rapid-Fire Concepts

**Generate 8-10 concepts in a compact format.** The goal is breadth — give the user a wide menu to react to. Details come later.

### Pre-Generation Checklist (Internal — Do Not Show)

Before writing concepts:
1. **Am I staying in genre?** Every concept must fit the genre (Q5) and sub-genre (Q9) the user chose. Don't drift into other genres unless it's the 1 wildcard.
2. **Did I use their personal interests (Q13, Q14)?** At least 2 concepts must be directly inspired by these if they answered.
3. **Am I just reskinning the example games?** If any concept is basically "[Referenced Game] but [twist]", rework it. The examples are reference points, not templates.
4. **Do I have mechanical variety?** No two concepts should share the same primary mechanic.
5. **Did I include at least 1 wildcard** the user didn't ask for but might love? This is the ONE concept that can bend the genre constraint.
6. **Is scope realistic?** Match every concept to their timeline (Q1) and scope (Q4).
7. **Did I respect Q8 (what they never want to feel)?** No concept should violate this.
8. **Does failure work how they want (Q7)?** Match the failure model to their preference.
9. **Does pacing match (Q10)?** Don't pitch twitchy games to someone who said "thoughtful and deliberate."
10. **Does it deliver on Q11 (most important thing)?** If they said "one brilliant mechanic," every concept should have a clear, specific core mechanic.

### Rapid-Fire Format

For each concept, write ONLY:

```markdown
### [Number]. [Concept Name]
**Pitch:** [2-3 sentences max. What is this game? What does the player DO? What makes it exciting?]
**The hook:** [1 sentence. The specific moment/feeling/mechanic that makes this worth building.]
**Vibe:** [3-5 words capturing the aesthetic/emotional tone]
**Scope:** [Tiny / Small / Medium] — [one line on feasibility]
```

That's it. No more. Keep each concept to 4-6 lines. The user needs to be able to scan all 8-10 concepts in under 2 minutes.

### Concept Diversity Requirements

Out of 8-10 concepts:
- **At least 2** inspired by their personal interests / obsessions (Q13, Q14, Q15) if they answered those
- **At least 2** that are wildcards — genres, themes, or mechanics they didn't mention
- **At least 1** that is tiny in scope (could prototype in a day)
- **At least 1** that is more ambitious (uses their full timeline)
- **No two concepts** share the same primary mechanic
- **Maximum 1** can closely reference their stated favorite games
- **At least 1** that feels weird or risky — the "wait, that's actually kind of brilliant" idea

### After Presenting Concepts

Present the **steering menu** using AskUserQuestion:

**What next?**
- "Expand 2-3 favorites" — Detailed writeup of my top picks
- "More like these" — I like the direction, generate more in this space
- "None of these click" — Let me tell you what's missing
- "Combine/remix" — Blend elements from different concepts

This is the **revision loop entry point**. See Phase 5.

---

## Phase 4: Detailed Expansion

**When the user picks 2-3 favorites**, expand each into a full concept brief.

### Expanded Concept Format

For each selected concept:

```markdown
## [Concept Name]

### The Pitch
[3-4 sentence compelling description. Must stand on its own without referencing other games.]

### The First 60 Seconds
[Present-tense micro-narrative of the player's first minute. What do they see, touch, hear, feel? Be specific and immersive. This is not a feature list — it's a moment.]

### Core Loop
[Describe the minute-to-minute gameplay with energy and specificity. Use a concrete example scenario that shows a decision, its consequence, and why it's interesting. Make the reader FEEL the loop.]

### Key Mechanics (2-4)
For each:
- **What it is:** [One sentence]
- **How it feels:** [The sensory/emotional experience of using this mechanic]
- **Why it's interesting:** [What makes decisions around this mechanic non-obvious?]

### What Makes This Original
[The specific mechanical or experiential novelty. Must not reduce to "X meets Y." What has genuinely not been done this way before?]

### Emotional Arc
[How does the player's experience evolve over a session? Map the journey in 3-4 beats.]

### Scope & Feasibility
- **MVP (what you build first):** [3-4 features, buildable in ~30% of timeline]
- **Full version:** [What gets added after MVP proves fun]
- **Stretch goals:** [Nice-to-haves]
- **Hardest technical challenge:** [One sentence]
- **Will you finish this?** [Honest motivation assessment — what keeps you going at day 5?]

### Reference Points
[2-3 games for scope/feel reference. For each, specify WHICH ASPECT you're referencing and how your concept differs.]
```

### After Expansion

Present another steering menu using AskUserQuestion:

**Where to from here?**
- "Lock it in — let's build it" — Commit to a concept and start the pipeline
- "Refine / adjust this one" — Tweak before committing
- "Go back — more concepts" — Return to rapid-fire generation
- "Combine expanded concepts" — Blend elements from the detailed writeups

---

## Phase 5: Revision Loop

**The revision loop is the most important part of this skill. It should feel like a creative conversation, not a restart.**

### When user says "none of these click":

Ask ONE focused question using AskUserQuestion:

**What's the gap?**
- "Too safe / generic" — I want weirder, more surprising ideas
- "Wrong territory entirely" — Let me redirect the genre/theme/mechanic
- "Right feel, wrong execution" — The themes are close but mechanics are off
- "Let me explain" — I'll describe what's missing in my own words

If they pick "let me explain" or "wrong territory," let them type freely. Then generate 6-8 fresh concepts incorporating their feedback. No need to re-ask any previous questions.

### When user says "more like these":

Ask using AskUserQuestion:

**What drew you to those concepts?**
- "The mechanic" — I want more ideas with that kind of interaction
- "The theme/setting" — I want to explore that world from different angles
- "The emotional tone" — That's the feeling, find more ways to get there
- "The scope/simplicity" — That size of idea is right, give me more at that level

Generate 6-8 new concepts pulling on that specific thread. State explicitly what thread you're pulling: "You gravitated toward [X] — here are more ideas in that space."

### When user says "combine/remix":

Ask which concepts to blend (they can type numbers/names). Then:
1. Identify compatible elements from each
2. Generate 2-3 hybrid concepts
3. For each, explain what you kept, what you dropped, and why
4. Present in Rapid-Fire format

### Revision Loop Principles

- **Never re-ask discovery questions** — you have the context from Phase 2
- **Acknowledge what didn't work** — "Previous batch was too [X], pivoting toward [Y]"
- **Each new batch must feel fresh** — if batch 2 feels like batch 1 reshuffled, you've failed
- **Track cumulative preferences** — by batch 3, you should have a clear picture
- **No limit on iterations** — keep going until something clicks

---

## Phase 6: Lock-In & Handoff

**When the user commits to a concept:**

1. Save the final concept to `docs/ideas/game-concepts.md` with:
   - The expanded concept brief
   - A "Constraints Summary" section with their Phase 1 answers
   - A "Creative DNA" section noting which personal interests/feelings drove the concept
   - An "Ideas Explored" section briefly listing all concepts generated (for future reference)

2. Present next steps:

```
Concept locked: [Name]

Next steps in the workflow:
1. /concept-validator — Stress-test feasibility, scope, and similar games
2. /design-bible-updater — Establish design pillars and creative vision
3. /gdd-generator — Create the Game Design Document
4. /roadmap-planner — Plan sprint-by-sprint implementation

Or if you want to keep exploring:
- "Actually, go back — I want to reconsider"
- "Generate variations on this concept before I commit"
```

---

## The Anti-Derivative Framework

Apply these tests internally before presenting any concept:

**1. The Reduction Test:** Can this concept be fully described as "[Game] but [twist]"? If yes, it's not ready.

**2. The Moment Test:** Can you name the *exact moment* the player feels the target emotion? Not "it's tense" but "it's tense when you hear the third crack and realize the ice under your left foot is thinner than you thought."

**3. The Explanation Test:** Can you describe the core fun to a non-gamer in 20 seconds?

**4. The Personal Test:** Is this concept connected to something specific about this user?

---

## Constraint Matching

### Timeline Scoping

| Timeline | Max Mechanics | Art Ceiling | Session Length | Concept Style |
|----------|--------------|-------------|----------------|---------------|
| Weekend | 1 core | Shapes/colors | 3-5 min | The mechanic IS the game |
| Week | 2-3 | Simple pixel/3D | 10-15 min | One "aha" mechanic + structure |
| Month | 4-6 | Multi-system | 30-60 min | Complete experience with depth |
| Long-term | 6+ | Full art pipeline | Hours | Systems interacting |

### Red Flags

- Feature creep disguised as "depth"
- Vague loops ("explore and discover things")
- Technical overreach for timeline
- All concepts feel like the same idea with different skins
- Zero connection to user's personal interests
- "Fun" used as a descriptor instead of showing what the fun IS
- Every concept references the same existing game

---

## Workflow Summary

```
Phase 1: Quick Context (timeline, engine, experience, scope)
  [1 AskUserQuestion call: 4 questions, 4 options each]
    ↓
Phase 2 Level 1: Genre & Basics (genre family, visual world, failure, anti-feel)
  [1 AskUserQuestion call: 4 questions, 4 options each — with example games]
    ↓
Phase 2 Level 2: Sub-Genre Deep-Dive (sub-genre + pacing + priority)
  [1 AskUserQuestion call: 3 questions, 4 options each — adapts to genre]
    ↓
Phase 2 Level 3: Personal Fuel
  [Open-ended text questions, all optional]
    ↓
Phase 3: Rapid-Fire Concepts (8-10 compact pitches, all within genre)
    ↓
    ├── "Expand favorites" → Phase 4 (detailed writeup)
    │       ↓
    │       ├── "Lock in" → Phase 6 (save & handoff)
    │       ├── "Refine" → adjust and re-expand
    │       └── "Go back" → Phase 3 or 5
    │
    ├── "More like these" → Phase 5 (what drew you? → new batch)
    │       ↓
    │       └── [loops back to Phase 3 steering menu]
    │
    ├── "None click" → Phase 5 (what's the gap? → new batch)
    │       ↓
    │       └── [loops back to Phase 3 steering menu]
    │
    └── "Combine/remix" → Phase 5 (hybrid generation)
            ↓
            └── [loops back to Phase 3 steering menu]
```

**Total AskUserQuestion calls before first ideas: 3** (Phase 1 + Genre & Basics + Sub-Genre Deep-Dive) + open-ended text. Each call uses max 4 questions with max 4 options. Example games anchor every choice.

**The funnel:** Practical constraints → Genre family → Sub-genre → Tone/feel → Personal fuel → Ideas. Each step narrows from the previous. By the time we generate, we know exactly what space we're in.

**Key principle:** The user can loop through Phase 3 → Phase 5 → Phase 3 as many times as they want. Each loop uses 1 AskUserQuestion call to understand the gap, then generates fresh concepts.

---

## Important Notes

- **Genre first, always.** Genre is the most natural starting point. It immediately tells the user "we're in the same space" and makes all subsequent questions feel structured.
- **Example games at every level.** Every genre and sub-genre option includes 3-4 reference games. This makes abstract choices concrete and ensures you and the user mean the same thing.
- **3 calls to ideas.** Phase 1 (practical) + Level 1 (genre/basics) + Level 2 (sub-genre/pacing/priority) + open text → generate. Don't add extra rounds.
- **Never present more than 4 options per question.** This is a hard constraint of AskUserQuestion.
- **Open-ended questions are optional.** If the user skips them, generate from genre + sub-genre + tone answers alone. Don't nag.
- **8-10 concepts, all within the chosen genre.** Only 1 wildcard is allowed to bend the genre. The rest must respect the user's genre and sub-genre choice.
- **The rapid-fire format is sacred.** Do NOT expand concepts until asked.
- **The revision loop is the feature.** Most users won't love the first batch. That's fine.
- **Don't just reskin the example games.** The reference games anchor the genre choice, but concepts must be original. "Factorio but with plants" is lazy.
- **Save output** to `docs/ideas/game-concepts.md` when a concept is locked in.
- **Acknowledge context.** If the user has an existing project, GDD, or design bible, read those files and incorporate that context into ideation.
