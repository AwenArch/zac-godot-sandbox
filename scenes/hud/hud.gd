extends CanvasLayer
## HUD that displays the player's score.

@onready var score_label: Label = $ScoreLabel


func _ready() -> void:
	# Initialize score label text
	score_label.text = "Score: 0"


func update_score(new_score: int) -> void:
	# Update the score label text
	score_label.text = "Score: " + str(new_score)
