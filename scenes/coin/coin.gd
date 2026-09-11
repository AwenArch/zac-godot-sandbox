extends Area2D
## A coin pickup that emits a 'collected' signal when the player overlaps
## it, increments the player's score directly, and frees itself.

signal collected

@export var sprite_texture: Texture2D
@export var collision_radius: float = 16.0


func _ready() -> void:
	collision_layer = 1
	collision_mask = 1
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = collision_radius
	shape.shape = circle
	add_child(shape)

	if sprite_texture:
		var sprite := Sprite2D.new()
		sprite.texture = sprite_texture
		add_child(sprite)

	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body.name == "Player" and body.has_method("increment_score"):
		body.increment_score(1)
		collect()


func collect() -> void:
	emit_signal("collected")
	queue_free()
