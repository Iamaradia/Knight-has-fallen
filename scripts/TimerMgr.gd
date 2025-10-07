extends Node
signal time_changed(value)
signal time_out

var start_seconds := 150
var time_left := 0.0
var running := false

func start(seconds:int=start_seconds):
	time_left = float(seconds)
	running = true
	time_changed.emit(int(ceil(time_left)))

func reset_full():
	start(start_seconds)

func add_time(sec:int):
	if not running: return
	time_left = max(0.0, time_left + sec)
	time_changed.emit(int(ceil(time_left)))

func lose_time(sec:int):
	if not running: return
	time_left = max(0.0, time_left - sec)
	time_changed.emit(int(ceil(time_left)))
	if time_left <= 0.0:
		running = false
		time_out.emit()

func stop():
	running = false

func _process(delta):
	if not running: return
	time_left = max(0.0, time_left - delta)
	time_changed.emit(int(ceil(time_left)))
	if time_left <= 0.0:
		running = false
		time_out.emit()
