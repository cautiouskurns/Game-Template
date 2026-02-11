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

---

## Adding New Patterns

When you encounter a bug that took significant effort to diagnose and could recur:

1. Add it to the appropriate section above
2. Include: **Problem** (what goes wrong), **Fix** (how to avoid it)
3. Keep entries concise — one paragraph each for Problem and Fix
4. Number entries sequentially
