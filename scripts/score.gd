extends Node
signal score_changed(value)
signal goal_reached
var score := 0
var goal = 7



func reset():
	score = 6
	score_changed.emit(score)

func add(points:int):
	score += points
	score_changed.emit(score)

func _process(delta: float) -> void:
	if score == goal:
		emit_signal("goal_reached")
	

	

	
