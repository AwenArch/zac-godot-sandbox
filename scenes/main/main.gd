extends Node2D
## Main scene script that instantiates the player, coins, and HUD.

@onready var player: CharacterBody2D = $Player
@onready var hud: CanvasLayer = null


func _ready() -> void:
	# Instantiate the coins
	var coin_scene: PackedScene = load("res://scenes/coin/coin.tscn")

	# Coin1 - positioned to require a single jump
	var coin1: Area2D = coin_scene.instantiate()
	add_child(coin1)
	coin1.name = "Coin1"
	coin1.position = Vector2(700, 440)

	# Coin2 - double-jump reachable. Single jump peaks ~82px above
	# standing (v=400, g=980); a well-timed double jump can reach ~160px,
	# but real timing isn't perfect - 430 keeps this ~125px above
	# standing, safely within reach without needing frame-perfect input.
	var coin2: Area2D = coin_scene.instantiate()
	add_child(coin2)
	coin2.name = "Coin2"
	coin2.position = Vector2(850, 430)

	# Coin3 - double-jump reachable, same safe height band as Coin2,
	# spread further right for visual variety across the level.
	var coin3: Area2D = coin_scene.instantiate()
	add_child(coin3)
	coin3.name = "Coin3"
	coin3.position = Vector2(1000, 425)

	# Instantiate the HUD
	var hud_scene: PackedScene = load("res://scenes/hud/hud.tscn")
	hud = hud_scene.instantiate()
	hud.name = "HUD"
	add_child(hud)

	# Set the player's hud reference
	player.hud = hud
