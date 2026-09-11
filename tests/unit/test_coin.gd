extends GdUnitTestSuite


func test_coin_emits_collected_signal() -> void:
	var coin_scene: PackedScene = load("res://scenes/coin/coin.tscn")
	var coin := coin_scene.instantiate()
	add_child(coin)

	# GDScript lambdas capture local variables BY VALUE, not by reference -
	# a plain bool set inside the lambda never affects the outer copy.
	# Use a single-element Array instead, which IS shared by reference.
	var collected_emitted := [false]
	coin.collected.connect(func(): collected_emitted[0] = true)

	var player_scene: PackedScene = load("res://scenes/player/player.tscn")
	var player := player_scene.instantiate()
	add_child(player)
	player.name = "Player"

	coin.global_position = Vector2(0, 0)
	player.global_position = Vector2(0, 0)

	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame

	assert_bool(collected_emitted[0]).is_true()
	player.free()


func test_coin_frees_itself_after_collection() -> void:
	var coin_scene: PackedScene = load("res://scenes/coin/coin.tscn")
	var coin := coin_scene.instantiate()
	add_child(coin)

	var player_scene: PackedScene = load("res://scenes/player/player.tscn")
	var player := player_scene.instantiate()
	add_child(player)
	player.name = "Player"

	coin.global_position = Vector2(0, 0)
	player.global_position = Vector2(0, 0)

	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame

	assert_bool(is_instance_valid(coin)).is_false()
	player.free()


func test_coin_collect_increments_player_score() -> void:
	var coin_scene: PackedScene = load("res://scenes/coin/coin.tscn")
	var coin := coin_scene.instantiate()
	add_child(coin)

	var player_scene: PackedScene = load("res://scenes/player/player.tscn")
	var player := player_scene.instantiate()
	add_child(player)
	player.name = "Player"

	coin.global_position = Vector2(0, 0)
	player.global_position = Vector2(0, 0)

	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame

	assert_that(player.score).is_equal(1)
	player.free()
