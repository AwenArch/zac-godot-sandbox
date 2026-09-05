# Conventions (agents: follow exactly)

## Godot version
- Godot 4.x ONLY. Never use Godot 3 API.
- CharacterBody2D/3D have a BUILT-IN `velocity` property. Never declare `var velocity`.
- `move_and_slide()` takes NO arguments. Set `velocity`, then call `move_and_slide()`.
- Signals: `signal_name.connect(callable)`. Exports: `@export`. Onready: `@onready`. `await`, never `yield`.

## Input
- Only use input actions that exist: ui_left, ui_right, ui_up, ui_down, ui_accept, ui_cancel.
- Never invent actions (no "ui_jump", no "shoot") unless the task explicitly says the action was added.

## Style
- Static typing everywhere: `var speed: float = 200.0`, `func jump() -> void:`, typed function args.
- One script per scene, same basename as the scene. Scripts `extends` the scene root's type.
- Tabs for indentation (Godot default).

## Structure
- Do not edit: project.godot, .import files, addons/, tests/smoke/, .github/.
- Use real file paths that exist in the project tree (e.g. res://scenes/player/player.gd).
- Every feature task must add or modify a test in tests/unit/ (gdUnit4), named test_<feature>.gd.

## Tests
- Test suites `extends GdUnitTestSuite` and use gdUnit4 asserts (assert_that, assert_bool, ...).
- Tests run headless. Never use SceneRunner input simulation (simulate_key_press etc.).
  Use Input.action_press()/action_release() or call methods directly, and await one
  physics frame when physics must process.
- Never call get_tree().quit() in a test. Never use raw assert().
- Nodes created in a test must be freed (auto_free() or queue_free()).

## Output format
- Return full file contents for every file you create or change. No diffs. No prose outside the JSON.

## Waiting in tests
- To let one physics frame process: `await get_tree().physics_frame`
- SceneTree has NO physics_frame_time or physics_process_time property. Never use timers to wait for frames.
- gdUnit4 number asserts: is_greater(x), is_less(x), is_equal(x). There is NO is_greater_than or is_less_than.
- Never reference a class by bare name (e.g. Foo.new()) unless that file declares
  `class_name Foo` or the class is preload()'d first (const Foo = preload("res://path/foo.gd")).
  An unresolved bare class name CRASHES the Godot test runner (engine bug) rather than
  failing cleanly - this is a hard rule, not a style preference.
- Connect signals with the signal-as-property syntax: `object.signal_name.connect(callable)`.
  Never `object.connect("signal_name", ...)` (Godot 3 syntax) and never wrap a lambda in
  Callable() when passing it directly — `func() -> void: ...` is already a Callable.
- Avoid `:=` type inference when the right side's type isn't statically obvious
  (e.g. `load(...).instantiate()`, `get_node(...)`). Use an explicit type instead:
  `var main: Node = load("res://scenes/main/main.tscn").instantiate()`. An
  unresolved `:=` inference is a parse error, and ANY parse error in a test file
  crashes the gdUnit4 runner rather than failing cleanly (confirmed: this happens
  for bare class references AND untyped := inference, likely any parse error).
- Never load() a .tscn file you did not also create in this same response.
  If a task doesn't explicitly ask you to create a scene file, build the
  node tree in code within the test instead (new NodeType(), set properties,
  add_child) rather than loading a scene that doesn't exist.
- Any script whose methods use get_tree() (directly or indirectly, e.g. via
  get_tree().paused) must be added to the scene tree with add_child() before
  those methods are called in a test - get_tree() returns null on a bare
  .new() instance that was never added anywhere.
- Before writing a `search` value, verify it appears character-for-character
  in the "Current contents" shown in THIS prompt - never search for text
  based on memory of what a file "usually" looks like, an earlier version,
  or an assumption that a prior attempt's edit already succeeded. If you
  are not certain a line exists in the content shown above, it probably
  does not.
- When making multiple edits in one response, check they don't collide -
  e.g. two edits that each declare the same variable. Each edit is applied
  independently; duplicate declarations across edits will fail to parse.

## Physics tests need a REAL floor
- `is_on_floor()` is computed by actual collision during `move_and_slide()` -
  it CANNOT be faked with `set_position()`, `set_collision_layer_value()`, or
  any property assignment. A test with no floor node means `is_on_floor()` is
  false forever, so any jump/ground logic gated on it will never trigger -
  the player will just fall under gravity with no jump ever registering.
- To test grounded behavior, instantiate a real floor in the test:
```gdscript
  var floor := StaticBody2D.new()
  var shape := CollisionShape2D.new()
  shape.shape = RectangleShape2D.new()
  shape.shape.size = Vector2(1000, 40)
  floor.add_child(shape)
  add_child(floor)
  floor.position = Vector2(0, 132)  # just below the player's feet
```
  Then position the player above it and `await get_tree().physics_frame`
  at least once before asserting `is_on_floor()` - one frame is needed for
  the collision to register.
