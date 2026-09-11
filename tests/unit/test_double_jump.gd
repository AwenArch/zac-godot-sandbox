extends GdUnitTestSuite


func test_player_can_double_jump() -> void:
	var scene: PackedScene = load("res://scenes/player/player.tscn")
	var player: CharacterBody2D = scene.instantiate()
	add_child(player)

	# Create a floor for the player to stand on
	var floor := StaticBody2D.new()
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(1000, 40)
	shape.shape = rect
	floor.add_child(shape)
	add_child(floor)

	# Position player above the floor
	player.global_position = Vector2(0, 100)
	floor.global_position = Vector2(0, 132)

	# One physics frame is required for the collision to register.
	await get_tree().physics_frame

	# Test initial jump (grounded)
	Input.action_press("ui_accept")
	await get_tree().physics_frame
	Input.action_release("ui_accept")
	await get_tree().physics_frame

	# Player should be airborne now
	assert_bool(player.is_on_floor()).is_false()

	# Test second jump (airborne)
	Input.action_press("ui_accept")
	await get_tree().physics_frame
	Input.action_release("ui_accept")
	await get_tree().physics_frame

	# Player should still be airborne, but with new velocity
	assert_bool(player.is_on_floor()).is_false()
	assert_that(player.velocity.y).is_less(0.0)

	player.free()
	floor.free()


func test_player_cannot_double_jump_twice() -> void:
	var scene: PackedScene = load("res://scenes/player/player.tscn")
	var player: CharacterBody2D = scene.instantiate()
	add_child(player)

	# Create a floor for the player to stand on
	var floor := StaticBody2D.new()
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(1000, 40)
	shape.shape = rect
	floor.add_child(shape)
	add_child(floor)

	# Position player above the floor
	player.global_position = Vector2(0, 100)
	floor.global_position = Vector2(0, 132)

	# One physics frame is required for the collision to register.
	await get_tree().physics_frame

	# Test initial jump (grounded)
	Input.action_press("ui_accept")
	await get_tree().physics_frame
	Input.action_release("ui_accept")
	await get_tree().physics_frame

	# Player should be airborne now
	assert_bool(player.is_on_floor()).is_false()

	# Test second jump (airborne)
	Input.action_press("ui_accept")
	await get_tree().physics_frame
	Input.action_release("ui_accept")
	await get_tree().physics_frame

	# Test third jump (should not work)
	Input.action_press("ui_accept")
	await get_tree().physics_frame
	Input.action_release("ui_accept")
	await get_tree().physics_frame

	# Player should still be airborne, but velocity should not have changed
	assert_bool(player.is_on_floor()).is_false()
	assert_that(player.velocity.y).is_less(0.0)

	player.free()
	floor.free()


func test_player_jumps_from_ground() -> void:
	var scene: PackedScene = load("res://scenes/player/player.tscn")
	var player: CharacterBody2D = scene.instantiate()
	add_child(player)

	# Create a floor for the player to stand on
	var floor := StaticBody2D.new()
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(1000, 40)
	shape.shape = rect
	floor.add_child(shape)
	add_child(floor)

	# Position player above the floor
	player.global_position = Vector2(0, 100)
	floor.global_position = Vector2(0, 132)

	# One physics frame is required for the collision to register.
	await get_tree().physics_frame

	# Test jump from ground
	Input.action_press("ui_accept")
	await get_tree().physics_frame
	Input.action_release("ui_accept")
	await get_tree().physics_frame

	# Player should be airborne now
	assert_bool(player.is_on_floor()).is_false()
	assert_that(player.velocity.y).is_less(0.0)

	player.free()
	floor.free()
