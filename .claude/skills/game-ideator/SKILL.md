---
name: game-ideator
description: Generate creative, emotionally grounded game concepts through interactive constraint gathering. Uses uniqueness tests and personal resonance to avoid derivative ideas.
domain: design
type: generator
version: 1.0.0
trigger: user
allowed-tools:
  - Write
---

# Game Ideator Skill

This skill generates game concepts through an **interactive questioning process** to understand user constraints, then produces 3-5 viable, non-derivative game ideas with emotionally grounded descriptions and detailed core loops.

The goal is not competent ideas. The goal is ideas that make the user **stop scrolling and start prototyping**. Every concept must pass the test: "Would I be excited to tell a friend about this?"

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

## Core Principles

**Interactive constraint gathering** ensures generated concepts are:
- Realistic for the user's constraints
- Aligned with their interests, personality, and emotional goals
- Technically feasible with their tools
- Scoped appropriately for their timeline
- **Genuinely original** -- not genre mashups or reskins of popular games
- **Emotionally resonant** -- connected to feelings the player should experience
- **Personally meaningful** -- tied to the developer's unique perspective

### The Originality Mandate

Generic concepts kill motivation. Every concept this skill produces must have a **core idea that cannot be reduced to "[Existing Game] but [minor twist]."** If you can describe a concept as just "Slay the Spire but with potions" or "Vampire Survivors meets tower defense," the concept is not ready. Dig deeper. Find the mechanical novelty, the emotional core, the personal angle that makes the idea irreplaceable.

---

## Interactive Questioning Workflow

### Phase 1: Practical Constraints (Required)

**Always start by asking these core questions. Use AskUserQuestion with selectable options wherever indicated.**

Present the following questions to the user:

```
I'll help you generate game concepts! Let me understand your constraints first.

**1. Development Timeline**
How much time do you have?
- [ ] Weekend (2-3 days)
- [ ] Week (5-7 days)
- [ ] Month (4 weeks)
- [ ] Longer-term project
- [ ] Flexible / exploring ideas

**2. Target Platform**
Where will this game run?
- [ ] PC (Windows/Mac/Linux)
- [ ] Web (HTML5/WebGL)
- [ ] Mobile (iOS/Android)
- [ ] Console
- [ ] Multiple platforms

**3. Team Size**
Who's working on this?
- [ ] Solo developer
- [ ] 2-3 people
- [ ] Small team (4-6)
- [ ] Larger team

**4. Engine/Tools**
What are you building with?
- [ ] Godot
- [ ] Unity
- [ ] Unreal
- [ ] Custom engine
- [ ] Other: _______
```

**Wait for user response before proceeding.**

---

### Phase 2: Genre, Mechanics & Art (Clarification)

**After receiving Phase 1 answers, ask the following. Use selectable options for genre, mechanics, and art style:**

```
Great! Now let's narrow down the type of game:

**5. Genre Preference**
Any genres you're excited about? (Select all that apply)
- [ ] Action (combat, reflexes, timing)
- [ ] Puzzle (logic, problem-solving)
- [ ] Strategy (planning, resource management)
- [ ] RPG (progression, stats, narrative)
- [ ] Roguelike (permadeath, procedural, runs)
- [ ] Platformer (jumping, movement)
- [ ] Simulation (systems, sandbox)
- [ ] Rhythm (music, timing)
- [ ] Tower Defense
- [ ] Auto-battler
- [ ] Narrative/Story
- [ ] Horror / Tension
- [ ] Cozy / Relaxing
- [ ] Competitive / PvP
- [ ] Hybrid (mix of above)
- [ ] Open to anything

**6. Core Mechanic Interest**
What sounds fun to implement?
- [ ] Combat system
- [ ] Movement mechanics (physics, parkour, momentum)
- [ ] Puzzle mechanics
- [ ] Procedural generation
- [ ] AI/pathfinding
- [ ] Building/crafting
- [ ] Economy/trading
- [ ] Dialogue/narrative branching
- [ ] Physics-based interactions
- [ ] Time manipulation (rewind, slow-mo, loops)
- [ ] Spatial reasoning (tetris-like, packing, arrangement)
- [ ] Pattern recognition / memory
- [ ] No preference - surprise me!

**7. Visual Complexity**
What art style are you comfortable with?
- [ ] Minimal (shapes, colors, no art needed)
- [ ] Pixel art (sprites, tiles)
- [ ] 3D simple (basic models)
- [ ] Hand-drawn 2D
- [ ] Vector graphics
- [ ] Text-based
- [ ] Collage / mixed media
- [ ] Stylized / abstract
```

**Wait for user response before proceeding.**

---

### Phase 3: Emotional Core & Personal Connection (The Depth Phase)

**This phase is critical. It separates generic concepts from inspired ones. After receiving Phase 2 answers, ask:**

```
Now for the questions that will make your concepts actually great:

**8. Target Feelings**
What emotions do you want players to experience? (Pick your top 2-3)
- [ ] Tension / dread (something bad could happen any second)
- [ ] Satisfaction / crunch (the click of things fitting perfectly)
- [ ] Discovery / wonder (what's around the next corner?)
- [ ] Mastery / flow (getting better feels incredible)
- [ ] Power fantasy (becoming unstoppable)
- [ ] Cozy comfort (a warm blanket of gameplay)
- [ ] Dark humor / absurdity (laughing at the chaos)
- [ ] Creeping unease (something is wrong but you can't stop)
- [ ] Frantic panic (too many things happening, barely surviving)
- [ ] Quiet contemplation (thinking deeply about a choice)
- [ ] Competitive fire (I NEED to beat this)
- [ ] Surprise / delight (that unexpected thing that makes you grin)

**9. Experience Level**
How comfortable are you with game dev?
- [ ] Beginner (first few games)
- [ ] Intermediate (made 2-5 games)
- [ ] Advanced (experienced developer)
- [ ] Expert (shipped multiple games)

**10. Scope Preference**
What kind of scope appeals to you?
- [ ] Tiny (one core mechanic, super focused)
- [ ] Small (2-3 mechanics, clear goal)
- [ ] Medium (multiple systems, 30-60 min gameplay)
- [ ] Ambitious (full game, hours of content)

**11. The Dream Game Question**
What game do you WISH existed but doesn't? Describe the experience, not the genre.
(e.g., "A game where I feel like an actual detective piecing together clues, not just following quest markers" or "Something that captures the feeling of finding a secret passage in an old building")

**12. Personal Obsessions**
What are you personally fascinated by outside of games? These are goldmines for original concepts.
Examples: mycology, urban exploration, bookbinding, competitive cooking, bird migration patterns, analog synthesizers, lockpicking, tide pools, cartography, vintage radio...

Share anything -- hobbies, subjects you read about, YouTube rabbit holes, things you bore your friends about.

**13. Interesting Systems**
Are there any real-world systems, jobs, or processes you find fascinating?
Examples: air traffic control, ant colonies, how libraries organize books, emergency room triage, how sourdough starter works, supply chain logistics, how languages evolve...

(These often translate into incredible game mechanics.)

**14. Inspiration & Anti-Inspiration**
- Favorite games to reference? (But we'll find what makes YOUR idea different)
- Games you're TIRED of seeing clones of?
- Specific theme, setting, or aesthetic?
- Game jam theme (if applicable)?
- Technical limitations to respect?
- Must-have features?

(Share whatever feels relevant)
```

**Wait for user response before proceeding.**

---

### Phase 4: Generate Concepts

**After gathering all constraints, generate 3-5 game concepts.**

#### Pre-Generation Mental Checklist (Internal -- Do Not Show to User)

Before writing any concept, run through this checklist internally:

1. **Derivative Check:** Am I just describing an existing game with a new skin? If yes, start over.
2. **Reference Trap Check:** Am I leaning too hard on the user's reference games? If every concept is "[Reference Game] but [twist]," I've failed. Reference games inform FEEL and SCOPE, not the concept itself.
3. **Variety Check:** Do my concepts actually feel different from each other, or are they all variations on the same theme? At least 3 of my concepts should use fundamentally different core mechanics.
4. **Personal Connection Check:** Did I actually USE the user's personal interests (Q12, Q13) or did I ignore them? At least 1-2 concepts must be directly inspired by their unique answers.
5. **Feeling Check:** Does each concept deliver on the target emotions (Q8), or did I forget the emotional goals?

#### Concept Requirements

Each concept MUST include:

1. **Concept Name** (catchy, memorable -- not generic fantasy words)
2. **One-Line Pitch** (elevator pitch -- must be compelling on its own, not require explanation)
3. **Emotional Hook** -- What specific feeling makes this worth building? What is the moment that will make a player say "whoa" or lean forward or hold their breath? Be specific. Not "it's fun" but "the moment you realize the pattern you've been building for 3 minutes is about to cascade and you don't know if it'll save you or destroy you."
4. **The First 60 Seconds** -- Describe exactly what the player sees, does, and feels in their first minute of gameplay. Be visceral and concrete. This is not a feature list; it is a micro-narrative of the experience.
5. **Core Loop** (what the player does minute-to-minute -- must be **specific and visceral**, not abstract. Bad: "Player makes decisions." Good: "You slam a tile down, the infection spreads two squares, your quarantine wall holds -- barely -- and now you have to decide: reinforce the wall or push into the contaminated zone for the antigen.")
6. **Key Mechanics** (2-4 primary mechanics with enough detail to understand how they FEEL, not just what they DO)
7. **Unique Hook** -- What makes this concept genuinely novel? This must pass the **Uniqueness Test**: "Has this exact combination been done before? If yes, what is the twist that makes it fresh?" The answer cannot be "genre X meets genre Y." It must identify a mechanical or experiential novelty.
8. **What Makes This Concept YOURS** -- How does this connect to the user's personal interests, obsessions, or dream game? Why is this person the right person to build this specific game?
9. **The 30-Second Test** -- Can you describe the core fun to a non-gamer friend in 30 seconds? Write that description. If it doesn't sound fun out loud, the concept needs work.
10. **Scope Assessment** (realistic timeline estimate with MVP features and stretch goals)
11. **Technical Complexity** (Low/Medium/High with brief justification)
12. **Why You'll Finish This** -- Motivation sustainability analysis. What about this concept will keep the developer excited at day 3, day 5, day 14? What's the "I can't wait to see if this works" factor? Be honest about motivation risks too.
13. **Similar Games for Reference** (for scope/feel reference, NOT because the concept is a clone of these)

#### Concept Diversity Requirements

- **At least 1 "Wildcard" concept** that combines unexpected genres, themes, or mechanics that the user might not have considered. This should be the concept that makes them go "wait, that's weird... but actually that could be amazing."
- **At least 1 concept directly inspired by the user's personal interests** (Q12/Q13). Take their real-world fascination and find the game hiding inside it.
- **No two concepts should share the same primary mechanic.** If concept 1 uses drafting, concept 2 cannot also use drafting as its core.
- **Maximum 1 concept** may closely reference the user's stated favorite game. The rest must chart new territory.

---

## The Anti-Derivative Framework

Before finalizing any concept, apply these tests:

**1. The Name-Drop Test**
Remove all references to existing games from your concept description. Does it still make sense? Does it still sound compelling? If a concept only works when you say "it's like [Game X]," the concept doesn't stand on its own yet.

**2. The Uniqueness Test**
For each concept ask: "Has this exact combination been done before?"
- If YES: What is the **specific twist** that makes it fresh? The twist must be mechanical or experiential, not just thematic (a new coat of paint doesn't count).
- If NO: Good, but verify it's not just obscure -- make sure the uniqueness is apparent and compelling, not accidental.

**3. The Emotional Specificity Test**
Can you name the **exact moment** the player will feel the target emotion? Not "the player will feel tense" but "the player will feel tense when they hear the third warning beep and realize they placed their last barrier one tile too far to the left."

**4. The Mechanical Novelty Test**
Is the core mechanic itself novel, or is it a reskin? Prioritize mechanical novelty over genre mashups. A new way to INTERACT is more valuable than a new combination of existing interactions.

**5. The Personal Resonance Test**
Is there something about this concept that connects to the specific user who asked for it? Would this concept be different if someone else had asked? If not, dig deeper into their Q11/Q12/Q13 answers.

---

## Output Format

```markdown
# Game Concepts for [User]

**Your Constraints:**
- Timeline: [X days/weeks]
- Platform: [Platform]
- Team: [Team size]
- Engine: [Engine]
- Genre interests: [Genres]
- Target feelings: [Emotions]
- Experience: [Level]
- Scope: [Preference]
- Dream game: [Brief summary of Q11 answer]
- Personal interests: [Brief summary of Q12 answer]

---

## Concept 1: [Concept Name]

**One-Line Pitch:**
[Compelling elevator pitch that stands on its own]

**Emotional Hook:**
[The specific feeling/moment that makes this worth building. Be vivid and precise.]

**The First 60 Seconds:**
[A concrete, immersive description of the player's first minute. What do they see? What do they touch? What happens? What do they feel? Write this as a present-tense micro-narrative, not a feature list.]

**Core Loop:**
[Describe the minute-to-minute gameplay with specificity and energy. Use concrete examples, not abstractions. Show the tension, the decisions, the consequences. Make the reader FEEL the loop, not just understand it.]

**Key Mechanics:**
- **[Mechanic 1]**: [How it works AND how it feels. What's the sensory experience?]
- **[Mechanic 2]**: [Same -- function AND feeling]
- **[Mechanic 3]**: [Same]

**Unique Hook:**
[What makes this genuinely novel? Must pass the Uniqueness Test. Cannot be reduced to "X meets Y." Identify the specific mechanical or experiential novelty.]

**What Makes This Concept Yours:**
[Direct connection to the user's personal interests, obsessions, or dream game.]

**The 30-Second Test:**
[Write the actual 30-second description you'd give a non-gamer friend.]

**Scope Assessment:**
- **Timeline:** [X days/weeks] - [Realistic/Ambitious/Tight]
- **MVP Features:** [3-4 must-have features for minimum viable version]
- **Stretch Goals:** [Optional features if time permits]

**Technical Complexity:** Low | Medium | High
[Brief justification -- what's the hardest technical challenge?]

**Why You'll Finish This:**
[What keeps the developer motivated? What's the "I can't wait to see if this works" factor?]

**Similar Games for Reference:**
- [Game 1] (for [specific aspect] reference, NOT because this is a clone)
- [Game 2] (for [specific aspect])

---

## Concept 2: [Concept Name]

[Same structure as above]

---

## Concept 3: [Concept Name]

[Same structure as above]

---

## Concept 4: [Concept Name] -- Wildcard

[Same structure -- this MUST be unexpected. Combine genres, themes, or mechanics the user didn't ask for but would love.]

---

## Concept 5: [Concept Name] -- Personal

[Same structure -- this MUST be directly inspired by the user's personal interests from Q12/Q13.]

---

## Recommendation

**Best fit for your constraints:**
[Concept #X] - [Name]

**Why:** [Consider feasibility, emotional resonance, motivation sustainability, and originality]

**Next Steps:**
1. Pick a concept (or hybrid ideas from multiple)
2. Create a prototype roadmap
3. Start with the core mechanic -- the thing that makes it feel unique
4. Iterate based on feel, not feature completion

**Questions to Pressure-Test Your Choice:**
- Does this concept excite you enough to push through the hard parts?
- Can you describe the core fun in one sentence without mentioning another game?
- What's the first thing you'd prototype? Can you feel whether it's fun within 2 hours?
- If you showed a 30-second clip to a friend, would they immediately understand the appeal?
- Is the scope honest, or are you already mentally adding features?

---

Would you like me to:
- [ ] **Deep Dive** on 1-2 favorites (detailed elaboration, expanded mechanics, development roadmap)
- [ ] Generate variations of a concept
- [ ] Create a prototype roadmap for a concept
- [ ] Combine ideas into a hybrid concept
```

---

## Deep Dive Phase (Optional -- Triggered by User Selection)

When the user picks 1-2 favorite concepts for a Deep Dive, produce a significantly expanded version:

### Deep Dive Output Structure

```markdown
# Deep Dive: [Concept Name]

## Expanded Core Loop
[Much more detailed loop description with 2-3 concrete example scenarios showing how the loop plays out differently each time. Show the RANGE of experiences, not just the template.]

## Detailed Mechanics Breakdown
For each mechanic:
- **How it works** (implementation-level detail)
- **How it feels** (the player experience, the sensory feedback)
- **How it scales** (how the mechanic evolves from minute 1 to minute 30)
- **Edge cases that create interesting moments** (what happens when the system is stressed?)

## Progression Arc
[How does the player's experience evolve over a full session? Map the emotional journey:
- Minutes 0-2: Learning/curiosity
- Minutes 2-5: First "aha" moment
- Minutes 5-15: Mastery building
- Minutes 15-30: Peak moments and resolution]

## Visual Identity
[Art direction suggestions. What should this game LOOK like? Not just "pixel art" but a specific visual personality. Color palettes, UI feel, animation priorities, reference images/games for aesthetic.]

## Audio Identity
[Sound design priorities. What are the 3-5 most important sounds? What music style? How does audio reinforce the target emotion?]

## Risk Assessment
- **Design risk:** What might not be fun? Where's the untested assumption?
- **Technical risk:** What's the hardest thing to implement?
- **Scope risk:** Where will feature creep try to sneak in?
- **Mitigation:** How to address each risk early

## Day-by-Day Development Sketch
[Rough plan for how to build this within the stated timeline. Focus on: when do you know if the core is fun?]
```

---

## Constraint Matching Guidelines

### Timeline-Based Scoping

| Timeline | Mechanics | Art | Gameplay | Focus |
|----------|-----------|-----|----------|-------|
| Weekend (2-3 days) | 1 core mechanic | Minimal (shapes) | Win/lose only | Mechanic IS the fun |
| Week (5-7 days) | 2-3 mechanics | Simple pixel/3D | 10-15 min | One "aha" mechanic + structure |
| Month (4 weeks) | 4-6 mechanics | Multiple systems | 30-60 min | Complete experience with depth |

### Platform Considerations

- **PC:** Complex controls OK, depth expected, long sessions
- **Web:** Load <5MB, simple controls, 5-10 min sessions, shareability matters
- **Mobile:** Touch only, 1-3 min sessions, minimize text

### Technical Complexity

- **Low:** Built-in nodes, basic movement/collision, simple state machines
- **Medium:** Custom physics/pathfinding, procedural generation, save/load
- **High:** Multiplayer, advanced AI, complex procgen, 3D with custom shaders

---

## Concept Quality Criteria

### Every Concept Must Be:

1. **Achievable** - Realistic within stated timeline
2. **Focused** - Clear core loop, not trying to do everything
3. **Original** - Cannot be fully described as "[Game] but [twist]"
4. **Emotionally Grounded** - Connected to specific target feelings
5. **Viscerally Described** - Core loop reads as an experience, not a feature list
6. **Personally Connected** - Tied to the user's unique interests where possible
7. **Testable** - Can prototype core loop in 20% of timeline
8. **Expandable** - Can add features incrementally

### Red Flags to Avoid

- **Feature creep:** Too many systems for the timeline
- **Vague loops:** "Explore and discover things" -- no sensory grounding
- **Technical overreach:** "MMO" for a weekend project
- **Derivative:** "It's like [popular game] but with [theme swap]" -- no genuine novelty
- **Scope mismatch:** Tiny concept for month timeline, or massive concept for weekend jam
- **Emotional emptiness:** "Fun" used as descriptor instead of showing what the fun IS
- **Reference dependency:** Concept only makes sense when compared to another game

---

## Follow-Up Actions

After generating concepts, offer:

### Deep Dive (Primary Follow-Up)
If user picks 1-2 favorites:
- Produce the full Deep Dive output (see Deep Dive Phase section above)
- Expand mechanics to implementation-level detail
- Map the emotional progression arc
- Sketch visual and audio identity
- Provide honest risk assessment
- Create day-by-day development sketch

### Elaboration
If user says "tell me more about Concept 2":
- Expand on implementation details
- Suggest art/audio references
- Break down development phases
- Estimate feature complexity

### Variation
If user says "I like Concept 1 but [change]":
- Generate 3 variations with their modification
- Explain trade-offs of each variation
- Suggest hybrid approaches

### Prototype Roadmap
If user says "I want to build Concept 3":
- Invoke `roadmap-planner` skill
- Create day-by-day implementation plan
- Identify critical path features
- Suggest testing milestones

### Hybrid Concepts
If user says "combine Concept 1 and 4":
- Analyze which mechanics blend well
- Create unified core loop
- Assess combined scope
- Suggest integration approach

---

## Important Notes

- **Interactive is key**: ALWAYS ask questions before generating -- especially the emotional/personal questions in Phase 3
- **Phase 3 is non-negotiable**: The emotional core and personal connection questions (Q8, Q11, Q12, Q13) are what separate generic output from inspired output. Do not skip them.
- **Constraints matter**: A weekend concept is not a month concept
- **Realistic scoping**: Better to under-promise and over-deliver
- **Originality over safety**: It is better to propose one risky, exciting concept than five safe, forgettable ones
- **Show, don't tell**: Core loops and First 60 Seconds should read like experiences, not feature lists
- **Respect the user's references without being enslaved by them**: If they mention Slay the Spire, understand WHY they love it (the drafting tension? the run variety? the escalation?) and deliver THAT feeling through a different lens -- do not just reskin Slay the Spire five times
- **Use their personal interests**: Q12 and Q13 answers are creative gold. A game inspired by someone's fascination with mycology or air traffic control will always be more interesting than another generic roguelike
- **Prototype-first**: Concepts should be testable quickly
- **Use selectable options**: Wherever possible in the questioning phases, present options the user can select from rather than open-ended questions (open-ended is fine for Q11, Q12, Q13, Q14)
- **Save output**: Create a markdown document capturing the game ideas to `docs/ideas/`

---

## Workflow Summary

1. **Ask Phase 1 questions** (timeline, platform, team, tools) -- use selectable options
2. **Wait for user response**
3. **Ask Phase 2 questions** (genre, mechanics, art) -- use selectable options
4. **Wait for user response**
5. **Ask Phase 3 questions** (feelings, dream game, personal interests, systems, inspiration) -- mix of selectable and open-ended
6. **Wait for user response**
7. **Run pre-generation checklist internally** (derivative check, variety check, personal connection check)
8. **Generate 3-5 concepts** matching all constraints, passing all quality tests
9. **Offer follow-up actions** including Deep Dive as primary option
10. **If user requests Deep Dive**, produce expanded analysis for 1-2 selected concepts
11. **Create a markdown document** capturing the game ideas to `docs/ideas/`

**This iterative approach ensures concepts are tailored to the user's actual situation, emotional goals, and personal identity -- not generic ideas anyone could have generated.**
