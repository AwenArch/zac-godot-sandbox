extends CharacterBody2D
## Player movement: run left/right, jump on ui_accept.
## This file is the reference implementation for agents. It demonstrates
## every rule in CONVENTIONS.md — imitate its style exactly.

@export var speed: float = 200.0
@export var jump_velocity: float = -400.0

## Pulled from Project Settings so all bodies share one gravity value.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	# NOTE: `velocity` is CharacterBody2D's built-in property. Never redeclare it.
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Axis is -1.0 (left) to 1.0 (right); 0.0 when no input.
	var direction: float = Input.get_axis("ui_left", "ui_right")
	if direction != 0.0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)

	# Godot 4: move_and_slide() takes NO arguments; it uses `velocity`.
	move_and_slide()
