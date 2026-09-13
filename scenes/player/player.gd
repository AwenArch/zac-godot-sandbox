extends CharacterBody2D
## Player movement: run left/right, jump on ui_accept.
## This file is the reference implementation for agents. It demonstrates
## every rule in CONVENTIONS.md — imitate its style exactly.

@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var land_sound: AudioStream = null

## Pulled from Project Settings so all bodies share one gravity value.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

## Player's score
var score: int = 0

## Number of jumps performed (0 = grounded, 1 = first jump, 2 = second jump)
var jump_count: int = 0

## Spawn position for respawning
var spawn_position: Vector2 = Vector2.ZERO

@onready var hud: CanvasLayer = null
@onready var audio_player: AudioStreamPlayer2D = null

## Flag to track if sound has been played for current landing
var _landed: bool = false


func _physics_process(delta: float) -> void:
	# NOTE: `velocity` is CharacterBody2D's built-in property. Never redeclare it.
	var was_on_floor := is_on_floor()
	if not is_on_floor():
		velocity.y += gravity * delta
		_landed = false
	else:
		jump_count = 0

	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = jump_velocity
			jump_count = 1
		elif jump_count == 1:
			velocity.y = jump_velocity
			jump_count = 2

	# Axis is -1.0 (left) to 1.0 (right); 0.0 when no input.
	var axis: float = Input.get_axis("ui_left", "ui_right")
	if axis != 0.0:
		velocity.x = axis * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)

	# Godot 4: move_and_slide() takes NO arguments; it uses `velocity`.
	move_and_slide()

	# Check if player has fallen below respawn threshold. 900 is well
	# below the floor's top surface (~580) and normal standing height
	# (~552-556) - a threshold of 500 would fire every frame just from
	# standing on the ground, since standing height already exceeds it.
	if global_position.y > 900:
		global_position = spawn_position
		velocity = Vector2.ZERO

	# Play land sound if player just landed
	if not was_on_floor and is_on_floor() and land_sound != null and not _landed:
		audio_player.stream = land_sound
		audio_player.play()
		_landed = true

	# Update HUD if available
	if hud != null:
		hud.update_score(score)


func increment_score(amount: int) -> void:
	score += amount
	# Update HUD if available
	if hud != null:
		hud.update_score(score)


func _ready() -> void:
	audio_player = AudioStreamPlayer2D.new()
	audio_player.autoplay = false
	add_child(audio_player)

	# Store initial spawn position
	spawn_position = global_position
