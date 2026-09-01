extends GdUnitTestSuite

const PlayerScene := preload("res://scenes/player/player.tscn")


func test_double_jump_allows_second_jump() -> void:
	var player: CharacterBody2D = PlayerScene.instantiate()
	auto_free(player)

	player.jump()
	assert_that(player.jump_count).is_equal(1)

	player.jump()
	assert_that(player.jump_count).is_equal(2)


func test_double_jump_ignores_third_jump() -> void:
	var player: CharacterBody2D = PlayerScene.instantiate()
	auto_free(player)

	player.jump()
	player.jump()
	player.jump()
	assert_that(player.jump_count).is_equal(2)


func test_grounded_jump_behavior_unchanged() -> void:
	var player: CharacterBody2D = PlayerScene.instantiate()
	auto_free(player)

	player.jump()
	assert_that(player.jump_count).is_equal(1)
	assert_that(player.velocity.y).is_less(0.0)
