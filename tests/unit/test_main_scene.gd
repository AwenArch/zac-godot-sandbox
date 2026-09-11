extends GdUnitTestSuite


func test_main_scene_instantiates_coin_and_hud() -> void:
	var main_scene: PackedScene = load("res://scenes/main/main.tscn")
	var main: Node2D = main_scene.instantiate()
	add_child(main)

	# Verify coin is instantiated and added as child
	var coin: Area2D = main.get_node("Coin")
	assert_that(coin).is_not_null()
	assert_bool(main.has_node("Coin")).is_true()

	# Verify HUD is instantiated and added as child
	var hud: CanvasLayer = main.get_node("HUD")
	assert_that(hud).is_not_null()
	assert_bool(main.has_node("HUD")).is_true()

	# Verify player's hud reference is set correctly
	var player: CharacterBody2D = main.get_node("Player")
	assert_that(player.hud).is_equal(hud)

	main.free()
