extends Node2D
## Main scene script that instantiates the player, coin, and HUD.

@onready var player: CharacterBody2D = $Player
@onready var hud: CanvasLayer = null


func _ready() -> void:
	# Instantiate the coin
	var coin_scene: PackedScene = load("res://scenes/coin/coin.tscn")
	var coin: Area2D = coin_scene.instantiate()
	add_child(coin)
	coin.name = "Coin"
	# Positioned to the right of the player's start (575, 552), high enough
	# above the floor (top surface ~y=580) that a single jump (~82px peak)
	# can't reach it, but a double-jump comfortably can.
	coin.position = Vector2(700, 440)

	# Instantiate the HUD
	var hud_scene: PackedScene = load("res://scenes/hud/hud.tscn")
	hud = hud_scene.instantiate()
	hud.name = "HUD"
	add_child(hud)

	# Set the player's hud reference
	player.hud = hud
