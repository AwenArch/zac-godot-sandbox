extends GdUnitTestSuite
 
func test_player_scene_loads() -> void:
	var scene: PackedScene = load("res://scenes/player/player.tscn")
	assert_that(scene).is_not_null()
	var player := scene.instantiate()
	assert_that(player.speed).is_greater(0.0)
	player.free()
