extends GdUnitTestSuite


func test_player_plays_sound_on_landing() -> void:
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
	await get_tree().physics_frame

	# Verify player is on floor initially
	assert_bool(player.is_on_floor()).is_true()

	# A sound-playing node must exist on the player.
	assert_that(player.audio_player).is_not_null()

	# Assign a real (if silent) AudioStream so play() actually has
	# something to trigger - land_sound defaults to null, and the game
	# logic correctly skips playing when it's null, so the test needs a
	# real stream assigned to genuinely exercise the triggering logic.
	player.land_sound = AudioStreamWAV.new()

	# Make player jump
	player.velocity.y = -400.0
	player.jump_count = 1
	player.move_and_slide()

	# Wait for physics frame to process the jump
	await get_tree().physics_frame

	# Verify player is now airborne
	assert_bool(player.is_on_floor()).is_false()

	# Simulate landing by moving the player back down near the floor -
	# zeroing velocity alone doesn't relocate the player, it just stops
	# it wherever the jump left it, so is_on_floor() would never become
	# true again without actually repositioning.
	player.global_position = Vector2(0, 100)
	player.velocity.y = 0.0

	# Wait for physics frames to process the landing collision.
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame

	# Verify player is on floor again
	assert_bool(player.is_on_floor()).is_true()

	# Verify the sound actually played on landing.
	assert_bool(player.audio_player.playing).is_true()

	player.free()
	floor.free()
