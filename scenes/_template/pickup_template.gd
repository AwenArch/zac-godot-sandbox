extends Area2D
## Template pattern for a simple interactive pickup object (coin, item,
## etc). The .tscn for this pattern is deliberately minimal - just the
## root node with this script attached. All child nodes (collision
## shape, sprite) are built here in code, not hand-authored in .tscn
## syntax - raw scene-resource syntax has proven unreliable for models to
## write from scratch, but building a node tree in GDScript is the same
## pattern already proven reliable in tests (see
## tests/unit/test_floor_pattern_example.gd).

@export var sprite_texture: Texture2D
@export var collision_radius: float = 16.0


func _ready() -> void:
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = collision_radius
	shape.shape = circle
	add_child(shape)

	if sprite_texture:
		var sprite := Sprite2D.new()
		sprite.texture = sprite_texture
		add_child(sprite)
