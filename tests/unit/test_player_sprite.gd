extends GdUnitTestSuite


func test_player_uses_sprite2d_instead_of_colorrect() -> void:
	var scene: PackedScene = load("res://scenes/player/player.tscn")
	var player: CharacterBody2D = scene.instantiate()
	add_child(player)

	# Check that the player has a Sprite2D node instead of ColorRect
	var sprite_node := player.get_node("Sprite2D")
	assert_that(sprite_node).is_not_null()
	assert_that(sprite_node is Sprite2D).is_true()

	# Verify the sprite texture is set correctly
	var expected_texture = preload("res://assets/sprites/player/player.png")
	assert_that(sprite_node.texture).is_equal(expected_texture)

	player.free()
