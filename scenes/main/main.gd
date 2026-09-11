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

	# Instantiate the HUD
	var hud_scene: PackedScene = load("res://scenes/hud/hud.tscn")
	hud = hud_scene.instantiate()
	hud.name = "HUD"
	add_child(hud)

	# Set the player's hud reference
	player.hud = hud
