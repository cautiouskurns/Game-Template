# Known Patterns & Recurring Bugs

A living reference of Godot gotchas and integration patterns discovered during development. All agents should read this file before implementing to avoid repeating known issues.

---

## Godot Engine Gotchas

### 1. Autoload class_name conflicts
**Problem:** If an autoload singleton is named `Foo` in Project Settings and the script also declares `class_name Foo`, Godot emits a parser error: "class_name hides autoload singleton."
**Fix:** Never give autoload scripts a `class_name` that matches the autoload name. Access them by the autoload name registered in Project Settings.

### 2. Preloaded scenes cause circular parse dependencies
**Problem:** If script A preloads scene B, and scene B has script C with a `class_name`, then A cannot use C's class_name as a type hint — Godot sees a circular dependency during parsing.
**Fix:** Use `Node` (or the appropriate base type) instead of the specific class_name in type hints when the reference crosses a preload boundary.

### 3. add_child() in _ready() on parent
**Problem:** Calling `get_parent().add_child(node)` inside `_ready()` fails because the parent is still setting up its own children.
**Fix:** Use `call_deferred("add_child", node)` or `get_parent().call_deferred("add_child", node)`.

### 4. Scene nesting changes tree paths
**Problem:** When wrapping a scene (e.g., `combat.tscn`) inside another scene (e.g., `run.tscn`), `get_tree().current_scene` changes. Code that finds nodes via `current_scene` breaks.
**Fix:** Use `%UniqueNodeName` (unique names) or relative paths. Avoid relying on absolute tree paths that assume a specific scene root.

### 5. @onready fails for headless/simulation nodes
**Problem:** `@onready` references require the node to be in the scene tree. Nodes created via `Node.new()` in simulation or testing contexts won't have `@onready` vars initialized.
**Fix:** Use `get_node_or_null()` with null checks instead of `@onready` for nodes that may be instantiated outside the scene tree.

---

## Integration Patterns

### 6. Node reparenting causes recursive lookups
**Problem:** If code searches for a container via `node.get_parent()` and reparents the node into the container, subsequent calls find the container as the parent and search inside it — creating nested containers infinitely.
**Fix:** Cache the container reference as a member variable on first creation. Never re-search from the reparented node.

### 7. Duplicate VFX from multiple systems
**Problem:** Both an entity script (e.g., `enemy._flash_damage()`) and a centralized animator (e.g., `CombatAnimator.play_enemy_hit()`) run visual effects for the same event, resulting in doubled animations.
**Fix:** Choose one authority for each VFX category. If CombatAnimator handles hit effects, remove the equivalent method from the entity script.

### 8. Tween alpha restore to wrong value
**Problem:** A tween that temporarily changes `modulate` to a flash color tweens back to `Color.WHITE` (alpha 1.0), but the node may be at a different base alpha (e.g., dimmed at 0.4). The node briefly appears at full opacity.
**Fix:** Tween back to the node's expected resting state, not always `Color.WHITE`. Store or compute the correct resting modulate value.

### 9. Signal-driven UI shows false state on reset
**Problem:** When a value (like block or HP) is reset at turn start, the signal handler sees the change and displays floating text ("Blocked!", damage numbers) even though no gameplay event occurred.
**Fix:** Reset tracking variables (`_prev_hp`, `_prev_block`) in the turn-start handler so the delta is zero when the signal fires.

---

## Asset & Resource Patterns

### 10. VFX sprite scale mismatch
**Problem:** AI-generated sprites (e.g., 768px) displayed at `scale = 1.0` are far too large for typical game viewports.
**Fix:** Use a default VFX scale of 0.3 or smaller. Always test generated assets at their intended display size before committing.

### 11. Files from previous context can be lost
**Problem:** When agents work across phases or sessions, files created in Phase A may not be visible or may have been overwritten by Phase B agents who weren't aware of them.
**Fix:** Always verify that expected files exist before referencing them. Use `ResourceLoader.exists()` or file checks before `preload()`/`load()`.

### 12. Orphaned scenes never instantiated
**Problem:** An agent creates a `.tscn` file (e.g., `boss_health_bar.tscn`) but never adds it as a child of any other scene or loads it from any script. The scene exists on disk but is never visible in-game.
**Fix:** Every new `.tscn` must be referenced by at least one other `.tscn` (via `instance=ExtResource()`) or loaded by a script (via `load()`/`preload()`). Feature specs must include a Scene Instantiation Map. Phase B.5 verifies no orphaned scenes.

### 13. Persistent entities destroyed during room transitions
**Problem:** If the Player or HUD is instanced as a child of a room scene, it gets `queue_free()`'d when the room transitions. The player disappears.
**Fix:** Persistent entities (Player, HUD) must live outside the room tree — as siblings of the RoomContainer, not children of any room. Use a Game wrapper scene pattern: `Game > RoomContainer + Player + HUD`.

### 14. Stale class cache after adding class_name
**Problem:** After adding new `class_name` declarations, `godot --headless --quit` may fail with "unknown class" errors because the class cache file is stale.
**Fix:** Always run `godot --headless --editor --quit` to rebuild the class cache before running the smoke test. This is mandatory in Phase B.5 and Phase C.

### 15. Death tween races with respawn reset
**Problem:** A death animation tween (e.g., fading to transparent) is still running when the respawn logic resets `modulate` to opaque. The tween overwrites the reset on its next frame, leaving the player invisible.
**Fix:** Store tween references (`_death_tween: Tween`). At the start of any reset/respawn function, call `_death_tween.kill()` if the tween exists and is valid before resetting visual state.

---

## Project Conventions

### Autoload Naming Convention
Autoload scripts that need a `class_name` for type hints must use the `FooClass` pattern:
- Autoload registered as `EventBus` → script declares `class_name EventBusClass`
- Autoload registered as `RoomManager` → script declares `class_name RoomManagerClass`
- Access via the autoload name (`EventBus.signal_name`), not the class_name

### Collision Layer Registry

All agents MUST reference this table when setting `collision_layer` and `collision_mask` on physics bodies and areas.

| Bit | Layer Name | Used By | Notes |
|-----|-----------|---------|-------|
| 1 | Environment / Player Body | Player CharacterBody2D, StaticBody2D walls/floors | Player's physical body + all terrain |
| 2 | Nail Hitbox | Player's attack Area2D | What the player's nail can hit |
| 4 | Enemy Hurtbox | Enemy damage-receiving Area2D | Where enemies can be hit |
| 8 | Enemy Hitbox | Enemy attack Area2D, contact damage Area2D | What hurts the player |
| 16 | Player Hurtbox | Player's damage-receiving Area2D | Where the player can be hit |

**Rules:**
- `collision_layer` = "what I am" (which layer this body exists on)
- `collision_mask` = "what I detect" (which layers this body scans for)
- Area2D triggers (e.g., transition triggers, pickup areas) should use `collision_layer = 0` (they are not a physical thing) and `collision_mask` set to the layer they want to detect
- Never use raw bit numbers in code comments — always reference the layer name from this table

### Reference Dimensions

All agents MUST reference these values when creating rooms, levels, UI, or any spatial content. Designing content without checking these dimensions causes scale mismatches that require full rework.

| Property | Value | Notes |
|----------|-------|-------|
| **Viewport** | 1920 x 1080 | Project window size |
| **Player sprite** | 256 x 256 | Native sprite sheet frame size |
| **Player collision capsule** | ~40px radius, ~80px height | Physical body for movement |
| **Minimum room width** | 2560 (10x player width) | Smallest room should be at least 10 player-widths wide |
| **Minimum room height** | 960 (3.75x player height) | Smallest room gives ~4 player-heights of vertical space |
| **Standard tile size** | 64 x 64 | For future tilemap alignment |
| **Transition trigger collision** | 64 x 256 | Side triggers (vertical); 256 x 64 for top/bottom triggers (horizontal) |
| **Wall/floor thickness** | 128 | Standard StaticBody2D boundary thickness |

**Room sizing guidance:**
- Small room: 2560 x 960 (compact corridor or reward room)
- Medium room: 3840 x 960 (standard exploration/combat room)
- Large room: 5120 x 1280 (boss arena or multi-platform challenge)
- Always verify: camera limits match room dimensions, spawn points are within room bounds, entities fit within playable area

---

## Adding New Patterns

When you encounter a bug that took significant effort to diagnose and could recur:

1. Add it to the appropriate section above
2. Include: **Problem** (what goes wrong), **Fix** (how to avoid it)
3. Keep entries concise — one paragraph each for Problem and Fix
4. Number entries sequentially
