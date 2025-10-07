extends Node2D

@onready var label: Label = get_tree().current_scene.get_node("Killzone/UI/Label")
@onready var timer: Timer = get_tree().current_scene.get_node("Killzone/Timer")
@onready var win_screen = $player1/Camera2D/CanvasLayer/WinScreen
@onready var timer1: Timer = $Timer
var won = false


func _ready():
	Score.reset()
	TimerMgr.start(120)
	TimerMgr.time_out.connect(die)
	Score.goal_reached.connect(win)
	timer1.one_shot = true
	timer1.wait_time = 1.2
	timer1.autostart = false



		
func die():
	var player = get_node("player1")
	if player and player.has_node("CollisionShape2D"):
		player.get_node("CollisionShape2D").queue_free()
		Engine.time_scale = 0.5
	if label:
		label.text = "TIME'S UP!"
		label.visible = true
	if timer:
		timer.start()
		
func win() -> void:
	if won:
		return
	win_screen.visible = true
	Engine.time_scale = 0.1
	timer1.start()
	won = true

func _on_timer_timeout() -> void:
	print("Hello")
	Engine.time_scale = 1
	get_tree().reload_current_scene()
