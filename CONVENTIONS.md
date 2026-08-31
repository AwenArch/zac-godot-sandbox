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
