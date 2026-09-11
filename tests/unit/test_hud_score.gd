extends GdUnitTestSuite
## Test that the HUD correctly displays and updates the player's score.


func test_hud_updates_score() -> void:
	# Load the HUD scene
	var hud_scene: PackedScene = load("res://scenes/hud/hud.tscn")
	var hud: CanvasLayer = hud_scene.instantiate()
	add_child(hud)

	# Create a mock player to test with
	var player_scene: PackedScene = load("res://scenes/player/player.tscn")
	var player: CharacterBody2D = player_scene.instantiate()
	add_child(player)

	# Connect the player's score to the HUD
	player.hud = hud

	# Verify initial score is 0
	assert_that(hud.get_node("ScoreLabel").text).is_equal("Score: 0")

	# Increment player's score
	player.increment_score(10)

	# Wait for one physics frame to let the HUD update
	await get_tree().physics_frame

	# Verify the HUD text updated correctly
	assert_that(hud.get_node("ScoreLabel").text).is_equal("Score: 10")

	# Increment score again
	player.increment_score(5)

	# Wait for one physics frame to let the HUD update
	await get_tree().physics_frame

	# Verify the HUD text updated correctly again
	assert_that(hud.get_node("ScoreLabel").text).is_equal("Score: 15")

	hud.free()
	player.free()
