extends GdUnitTestSuite


func test_player_respawns_at_spawn_position() -> void:
	var scene: PackedScene = load("res://scenes/player/player.tscn")
	var player: CharacterBody2D = scene.instantiate()
	add_child(player)

	var floor := StaticBody2D.new()
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(1000, 40)
	shape.shape = rect
	floor.add_child(shape)
	add_child(floor)

	player.global_position = Vector2(0, 100)
	floor.global_position = Vector2(0, 132)

	await get_tree().physics_frame
	await get_tree().physics_frame

	# Compare against player.spawn_position directly - the actual value
	# the real respawn logic uses - not a separately-tracked local
	# variable. spawn_position is captured in _ready(), which fires the
	# instant add_child(player) runs, BEFORE this test's manual
	# repositioning above - so a locally-stored "original_position"
	# captured after that repositioning would never actually match what
	# respawn moves the player back to.
	var expected_spawn: Vector2 = player.spawn_position

	# Godot's 2D Y-axis increases DOWNWARD - falling off the level means
	# Y growing larger (positive), not smaller.
	player.global_position = Vector2(0, 1000)

	# Exactly one frame - the respawn point (0,0) floats in empty space,
	# nowhere near the floor (at y=132), so any additional frame lets
	# gravity immediately pull the player away from the exact respawn
	# coordinate before this checks it.
	await get_tree().physics_frame

	assert_that(player.global_position).is_equal(expected_spawn)

	player.free()
	floor.free()


func test_player_velocity_zeroed_on_respawn() -> void:
	var scene: PackedScene = load("res://scenes/player/player.tscn")
	var player: CharacterBody2D = scene.instantiate()
	add_child(player)

	var floor := StaticBody2D.new()
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(1000, 40)
	shape.shape = rect
	floor.add_child(shape)
	add_child(floor)

	player.global_position = Vector2(0, 100)
	floor.global_position = Vector2(0, 132)

	await get_tree().physics_frame
	await get_tree().physics_frame

	player.velocity = Vector2(100, 200)
	player.global_position = Vector2(0, 1000)

	# Exactly one frame - same reason as the position test: any extra
	# frame lets gravity add back onto velocity.y before this checks it.
	await get_tree().physics_frame

	assert_that(player.velocity).is_equal(Vector2.ZERO)

	player.free()
	floor.free()


func test_player_respawn_only_activates_below_threshold() -> void:
	var scene: PackedScene = load("res://scenes/player/player.tscn")
	var player: CharacterBody2D = scene.instantiate()
	add_child(player)

	var floor := StaticBody2D.new()
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(1000, 40)
	shape.shape = rect
	floor.add_child(shape)
	add_child(floor)

	player.global_position = Vector2(0, 100)
	floor.global_position = Vector2(0, 132)

	await get_tree().physics_frame
	await get_tree().physics_frame

	var original_position := player.global_position

	# Just above the 900 threshold - should NOT trigger a respawn.
	player.global_position = Vector2(0, 800)

	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame

	assert_that(player.global_position).is_not_equal(original_position)

	player.free()
	floor.free()
