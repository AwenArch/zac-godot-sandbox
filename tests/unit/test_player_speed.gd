extends GdUnitTestSuite


func test_player_horizontal_speed() -> void:
	var scene: PackedScene = load("res://scenes/player/player.tscn")
	assert_that(scene).is_not_null()
	var player := scene.instantiate()
	add_child(player)
	await get_tree().physics_frame
	Input.action_press("ui_right")
	await get_tree().physics_frame
	assert_that(player.velocity.x).is_greater(0.0)
	player.free()
