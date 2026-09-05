extends GdUnitTestSuite


func test_player_can_double_jump() -> void:
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

	# Grounded jump
	Input.action_press("ui_accept")
	await get_tree().physics_frame
	Input.action_release("ui_accept")
	await get_tree().physics_frame
	assert_that(player.velocity.y).is_equal(-400.0)

	# Airborne second jump
	Input.action_press("ui_accept")
	await get_tree().physics_frame
	Input.action_release("ui_accept")
	await get_tree().physics_frame
	assert_that(player.velocity.y).is_equal(-400.0)

	# Third jump should not work - velocity should just be decaying
	# under gravity, not another full jump impulse
	Input.action_press("ui_accept")
	await get_tree().physics_frame
	Input.action_release("ui_accept")
	await get_tree().physics_frame
	assert_that(player.velocity.y).is_greater(-400.0)

	player.free()
	floor.free()


func test_player_resets_jump_count_on_landing() -> void:
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

	# Grounded jump
	Input.action_press("ui_accept")
	await get_tree().physics_frame

	# Airborne second jump
	Input.action_press("ui_accept")
	await get_tree().physics_frame
	Input.action_release("ui_accept")
	await get_tree().physics_frame

	# Simulate landing
	player.global_position = Vector2(0, 130)
	await get_tree().physics_frame

	# Should be able to jump again after landing
	Input.action_press("ui_accept")
	await get_tree().physics_frame
	Input.action_release("ui_accept")
	await get_tree().physics_frame
	assert_that(player.velocity.y).is_equal(-400.0)

	player.free()
	floor.free()
