# Audio Reference Collector

Collate audio references from a target game's soundtrack and sound design, analyze its audio identity, and produce an audio direction document that drives consistent music and SFX sourcing via Epidemic Sound and Ludo voice generation.

## Workflow Context

| Field | Value |
|-------|-------|
| **Assigned Agent** | asset-artist (or orchestrator during Phase 0) |
| **Sprint Phase** | Phase 0 (after design bible) or Phase A (before audio sourcing) |
| **Directory Scope** | `assets/references/audio/`, `docs/audio-direction.md` |
| **Downstream** | asset-artist uses search terms and mood tags for Epidemic Sound queries |

## How to Invoke This Skill

Users can trigger this skill by saying:
- `/audio-reference-collector`
- "Collect audio references for [game name]"
- "Set up the audio direction"
- "I want to replicate [game name]'s soundtrack / sound design"

---

## Procedure

### Step 1: Identify the Target Game

Ask the user (or read from context) which game's audio to reference. Gather:

1. **Game name** — the primary audio reference
2. **Secondary references** (optional) — other games with similar audio
3. **What to prioritize** — e.g., "the ambient music more than SFX" or "the combat sounds"
4. **Specific tracks** (optional) — if the user knows particular tracks they love (e.g., "City of Tears theme from Hollow Knight")

### Step 2: Research the Audio Identity

#### 2a: Web Search for Soundtrack Information

Search for the game's audio design:

```
WebSearch: "[game name] soundtrack composer"
WebSearch: "[game name] OST tracklist"
WebSearch: "[game name] sound design analysis"
WebSearch: "[game name] music style genre"
WebSearch: "[game name] ambient sound design"
```

Gather:
- **Composer name(s)** and their other work
- **Genre classification** — orchestral, chiptune, ambient, electronic, folk, etc.
- **Tracklist** — identify key tracks per game context (title, exploration, combat, boss, ambient, menu)
- **Sound design philosophy** — any interviews or GDC talks about the audio approach
- **Instrumentation** — what instruments dominate (piano, strings, synths, etc.)

#### 2b: Find Reference Tracks on Spotify (via Epidemic Sound)

Use Epidemic Sound's external reference search to find Spotify track IDs for the game's key tracks:

```
mcp__epidemic-sound__SearchExternalReferences:
  term: "[game name] soundtrack [track name]"
```

Then use those IDs to find similar tracks in Epidemic Sound's catalog:

```
mcp__epidemic-sound__SearchRecordings:
  query: { externalID: { type: "SPOTIFY_TRACK", id: "[spotify_id]" } }
  first: 5
```

This gives you Epidemic Sound tracks that sound similar to the reference game's music — the core of the audio pipeline.

#### 2c: Search by Mood/Genre/Instrument

For each game context, search Epidemic Sound directly using mood and genre tags:

```
mcp__epidemic-sound__SearchRecordings:
  query: { term: "[descriptive term]" }
  filter: {
    moodSlugs: { matchType: "ALL", values: ["dark", "atmospheric"] },
    featuredInstrumentSlugs: { matchType: "ANY", values: ["piano", "strings"] },
    bpm: { min: 60, max: 90 },
    vocals: false
  }
  first: 5
  sort: { by: "RELEVANCE", order: "DESCENDING" }
```

#### 2d: Search for Sound Effects

For each SFX category the game uses:

```
mcp__epidemic-sound__SearchSoundEffects:
  term: "[description, e.g., sword slash impact]"
  first: 5
```

### Step 3: Analyze the Audio Style

Analyze the collected information and document:

#### Music Analysis

**Overall Tone:**
- Genre(s) and sub-genres
- Emotional range — does it go from serene to intense? Always melancholic?
- Instrumentation palette — what instruments appear most
- Production style — lo-fi, orchestral, synthetic, acoustic, hybrid

**Per-Context Breakdown:**

| Context | Mood | Tempo (BPM) | Key Instruments | Energy Level | Example Track |
|---------|------|-------------|-----------------|-------------|---------------|
| Title/Menu | | | | | |
| Exploration (safe) | | | | | |
| Exploration (danger) | | | | | |
| Combat (normal) | | | | | |
| Combat (boss) | | | | | |
| Ambient/Environmental | | | | | |
| Emotional/Story | | | | | |
| Victory/Reward | | | | | |
| Death/Failure | | | | | |

**Musical Motifs:**
- Does the game use leitmotifs (recurring themes for characters/locations)?
- Are there musical transitions between areas (crossfades, key changes)?
- Does music react to gameplay (adaptive/dynamic scoring)?

#### Sound Effects Analysis

**SFX Style:**
- Realistic vs stylized vs retro/chiptune
- Reverb/space — dry and intimate vs cavernous and echoey
- Impact weight — punchy and snappy vs heavy and weighty
- UI sounds — clicks, confirms, navigation style

**Per-Category:**

| Category | Style Description | Reference Examples |
|----------|-------------------|-------------------|
| Player movement | (footsteps, jump, land, dash) | |
| Player combat | (attack, hit, parry, special) | |
| Enemy sounds | (idle, alert, attack, death) | |
| Environment | (ambient, doors, pickups, hazards) | |
| UI feedback | (menu, confirm, cancel, error) | |
| Boss-specific | (intro, phase change, special attacks) | |

#### Voice/Dialogue Style (if applicable)
- Fully voiced vs text-only vs partial (grunts/exclamations)
- Delivery style — serious, playful, stoic, emotive
- Language treatment — real language, gibberish, invented

### Step 4: Build the Search Reference Library

For each game context, compile the best Epidemic Sound search queries that produce results closest to the reference game's audio. These become the **audio anchors** — reusable search templates.

Document as a lookup table:

```markdown
### Music Search Anchors

| Context | Search Term | Mood Slugs | Genre/Taxonomy | BPM Range | Instruments | Vocals |
|---------|------------|------------|----------------|-----------|-------------|--------|
| Exploration | "dark ambient piano" | dark, atmospheric | ambient | 60-90 | piano, strings | false |
| Combat | "intense orchestral action" | aggressive, epic | orchestral | 120-160 | percussion, brass | false |
| Boss | "dramatic dark orchestra" | dark, epic, dramatic | orchestral | 100-140 | full-orchestra | false |
| Menu | "melancholic piano solo" | sad, calm | classical | 50-70 | piano | false |

### SFX Search Anchors

| Category | Search Terms |
|----------|-------------|
| Sword slash | "sword slash metal impact" |
| Footsteps | "footstep stone cave echo" |
| UI confirm | "soft click interface confirm" |
| Boss roar | "creature roar deep growl" |
```

If Spotify cross-references were found, also record the Epidemic Sound track IDs that matched:

```markdown
### Spotify Cross-Reference Results

| Reference Track | Spotify ID | Best ES Match | ES Track ID |
|----------------|------------|---------------|-------------|
| [game] - [track name] | [id] | [ES track title] | [ES id] |
```

### Step 5: Generate Audio Direction Document

Create `docs/audio-direction.md` using this template:

```markdown
# Audio Direction

## Reference Game
- **Primary:** [game name]
- **Composer:** [name]
- **Secondary:** [other references, if any]
- **Target fidelity:** [exact replica / inspired by / loose interpretation]

## Audio Style Summary
[2-3 sentence description of the overall audio identity]

## Music Direction

### Overall Characteristics
- **Genre:** [primary genre / sub-genre]
- **Instrumentation:** [dominant instruments]
- **Production:** [lo-fi / orchestral / synthetic / acoustic / hybrid]
- **Emotional range:** [description]
- **Dynamic scoring:** [yes/no — does music adapt to gameplay?]

### Per-Context Guide

| Context | Mood | Tempo (BPM) | Key Instruments | Energy | Notes |
|---------|------|-------------|-----------------|--------|-------|
| Title/Menu | | | | | |
| Exploration (safe) | | | | | |
| Exploration (danger) | | | | | |
| Combat (normal) | | | | | |
| Combat (boss) | | | | | |
| Ambient/Environmental | | | | | |
| Emotional/Story | | | | | |
| Victory/Reward | | | | | |

### Music Search Anchors (for Epidemic Sound)

| Context | Search Term | Mood Slugs | BPM Range | Instruments | Vocals |
|---------|------------|------------|-----------|-------------|--------|
| [context] | "[search term]" | [slugs] | [min-max] | [instruments] | [bool] |

### Spotify Cross-References (if found)

| Reference Track | Best ES Match | ES Track ID |
|----------------|---------------|-------------|
| [track] | [match] | [id] |

## Sound Effects Direction

### SFX Style
- **Overall feel:** [realistic / stylized / retro]
- **Reverb/space:** [dry / medium / cavernous]
- **Impact weight:** [light / medium / heavy]
- **UI audio:** [description of interface sound style]

### SFX Search Anchors (for Epidemic Sound)

| Category | Search Terms | Style Notes |
|----------|-------------|-------------|
| Player movement | "[terms]" | [notes] |
| Player combat | "[terms]" | [notes] |
| Enemy sounds | "[terms]" | [notes] |
| Environment | "[terms]" | [notes] |
| UI feedback | "[terms]" | [notes] |
| Boss-specific | "[terms]" | [notes] |

## Voice Direction (if applicable)
- **Style:** [fully voiced / partial / grunts only / text-only]
- **Delivery:** [serious / playful / stoic]
- **Ludo voice settings:** [voice type, tone, pace for `createSpeech`/`createVoice`]

## Audio Integration Notes
- **Format:** WAV preferred for Godot (fallback: OGG for music, WAV for SFX)
- **Looping:** Music tracks should loop seamlessly — use Epidemic Sound stems if needed
- **Crossfading:** [notes on transition style between tracks]
- **Volume balance:** [relative levels — music vs SFX vs voice]
```

### Step 5.5: Generate Reference Manifest

Update the structured reference manifest for GameForge dashboard integration.

1. **Read or initialize** `docs/references/manifest.json`:
   - If it exists, read it and parse the JSON
   - If it doesn't exist, create it with: `{ "version": "1.0.0", "generated_at": "", "sources": [] }`

2. **Populate the `audio` section** with structured data extracted from `docs/audio-direction.md`:
   - `audio.style_summary` — the Audio Style Summary paragraph
   - `audio.tracks` — each Key Epidemic Sound Track with title, artist, epidemic_sound_id, context, bpm, and tags array
   - `audio.search_anchors.music` — each Music Search Anchor with context, search_term, mood_slugs, bpm_range, instruments, vocals, and best_match
   - `audio.search_anchors.sfx` — each SFX Search Anchor with category, search_terms, and style_notes
   - `audio.motifs` — each Musical Motif with name, usage, and description

3. **Preserve other sections untouched** — do NOT modify `art` or `narrative` if they exist.

4. **Update metadata**:
   - Set `generated_at` to today's date
   - Add `"docs/audio-direction.md"` to `sources` (if not already present)

5. **Write** the updated JSON back to `docs/references/manifest.json`.

Create the `docs/references/` directory if it doesn't exist (`mkdir -p docs/references`).

### Step 6: Present to User for Approval

Display a summary of:
1. The audio identity analysis (genre, mood, instrumentation)
2. How many Epidemic Sound matches were found per context
3. The search anchor table (what queries to use going forward)
4. Any Spotify cross-references found

Use AskUserQuestion:
- **APPROVE** — Accept the audio direction, proceed
- **MODIFY** — Adjust mood targets, add references, change priorities
- **PREVIEW** — Listen to some of the Epidemic Sound matches before deciding (provide lqmp3Url preview links)

---

## Integration with Asset-Artist Agent

Once approved:

1. **asset-artist reads `docs/audio-direction.md`** at the start of every sprint
2. **Music sourcing** uses the Music Search Anchors table — copy the search term, mood slugs, BPM range, and instrument filters directly into `SearchRecordings` calls
3. **SFX sourcing** uses the SFX Search Anchors table — copy search terms into `SearchSoundEffects` calls
4. **Spotify cross-references** provide the highest-fidelity matches — try these first via `SearchRecordings` with `externalID`
5. **Voice generation** uses the Voice Direction settings for Ludo's `createSpeech` and `createVoice`
6. **Similar track discovery** — after finding a good match, use `SearchSimilarToRecording` or `SearchSimilarToSoundEffect` to find more in the same style

## Integration with Feature Specs

Feature specs should reference the audio direction when describing audio requirements:
- "Combat music following `docs/audio-direction.md` Combat (normal) context"
- "Boss intro SFX matching 'creature roar deep growl' from audio anchors"
- "UI confirm sound per audio direction UI feedback style"

---

## Quick Reference

```
# Collect audio references for a game:
/audio-reference-collector

# Output:
docs/audio-direction.md    — full audio guide with search anchors and mood tables
docs/references/manifest.json — GameForge reference manifest (audio section)
```
