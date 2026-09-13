extends GdUnitTestSuite


func test_settings_menu_default_volume_is_100() -> void:
	var scene: PackedScene = load("res://scenes/ui/settings_menu.tscn")
	var settings_menu := scene.instantiate()
	add_child(settings_menu)

	assert_that(settings_menu.get_volume()).is_equal(100)

	settings_menu.free()


func test_settings_menu_volume_changes() -> void:
	var scene: PackedScene = load("res://scenes/ui/settings_menu.tscn")
	var settings_menu := scene.instantiate()
	add_child(settings_menu)

	settings_menu.get_node("VBoxContainer/VolumeSlider").value = 50
	assert_that(settings_menu.get_volume()).is_equal(50)

	settings_menu.free()
