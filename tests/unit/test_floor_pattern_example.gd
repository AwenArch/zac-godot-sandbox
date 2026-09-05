extends GdUnitTestSuite
## Reference pattern for any test needing a real floor / grounded state.
## Copy this pattern exactly - do not fake grounding with set_position()
## or collision-mask assignment alone.

func test_player_is_grounded_with_real_floor() -> void:
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

	# One physics frame is required for the collision to register.
	await get_tree().physics_frame
	await get_tree().physics_frame

	assert_bool(player.is_on_floor()).is_true()

	player.free()
	floor.free()
