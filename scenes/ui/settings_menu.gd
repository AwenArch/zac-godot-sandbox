extends Control

## Settings menu with a volume slider.

@onready var volume_slider: HSlider = $VBoxContainer/VolumeSlider


func get_volume() -> int:
	return volume_slider.value
