extends Label
func _ready():
	if not TimerMgr.time_changed.is_connected(_on_time_changed):
		TimerMgr.time_changed.connect(_on_time_changed)
	_on_time_changed(int(ceil(TimerMgr.time_left)) if TimerMgr.running else TimerMgr.start_seconds)

func _on_time_changed(v:int) -> void:
	text = "%02d:%02d" % [v/60, v%60]
