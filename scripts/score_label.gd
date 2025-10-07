extends Label

func _ready():
	text = "Score: 0"
	Score.score_changed.connect(_on_score_changed)

func _on_score_changed(value:int) -> void:
	text = "Score: %d" % value
