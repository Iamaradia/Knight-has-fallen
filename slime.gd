extends AnimatedSprite2D

const SPEED = 55
var direction := 1
var dead := false
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var slime: AnimatedSprite2D = $"."
@onready var hurtbox: Area2D = $Hurtbox
@onready var killzone: Node = $Killzone
@onready var body_shape: CollisionShape2D = $CollisionShape2D
@onready var kill_shape: CollisionShape2D = $Killzone/CollisionShape2D

func _process(delta: float) -> void:
	if dead: return
	if ray_cast_right.is_colliding():
		var c = ray_cast_right.get_collider()
		if c and c.name != "player1":
			direction = -1
			slime.flip_h = true
	elif ray_cast_left.is_colliding():
		var c2 = ray_cast_left.get_collider()
		if c2 and c2.name != "player1":
			direction = 1
			slime.flip_h = false
	position.x += SPEED * delta * direction

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if dead: return
	if area.is_in_group("player_roll"):
		die()

func die() -> void:
	if dead: return
	dead = true
	set_process(false)
	hurtbox.set_deferred("monitoring", false)
	hurtbox.set_deferred("monitorable", false)
	if kill_shape: kill_shape.set_deferred("disabled", true)
	if killzone.has_method("disable"): killzone.call_deferred("disable")
	if body_shape: body_shape.set_deferred("disabled", true)
	Score.add(1)
	slime.play("death")
	await slime.animation_finished
	queue_free()
