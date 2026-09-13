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

	# Coin2 - positioned to require a double jump
	var coin2: Area2D = coin_scene.instantiate()
	add_child(coin2)
	coin2.name = "Coin2"
	coin2.position = Vector2(850, 300)

	# Coin3 - positioned to require a double jump
	var coin3: Area2D = coin_scene.instantiate()
	add_child(coin3)
	coin3.name = "Coin3"
	coin3.position = Vector2(1000, 200)

	# Instantiate the HUD
	var hud_scene: PackedScene = load("res://scenes/hud/hud.tscn")
	hud = hud_scene.instantiate()
	hud.name = "HUD"
	add_child(hud)

	# Set the player's hud reference
	player.hud = hud
