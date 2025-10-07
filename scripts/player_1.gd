extends CharacterBody2D

@onready var collision: CollisionShape2D = $CollisionShape2D
const SPEED = 143.0
const JUMP_VELOCITY = -270.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rolling := false 
const ROLL_SPEED := 210.0
var roll_dir := 1
const ROLL_DISTANCE := 85
var roll_time_left := 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		rolling = false
		$RollHitbox/CollisionShape2D.disabled = true
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	# Flips
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Roll animation
	if Input.is_action_just_pressed("Roll") and is_on_floor() and not rolling:
		rolling = true
		roll_dir = -1 if animated_sprite.flip_h else 1
		roll_time_left = ROLL_DISTANCE / ROLL_SPEED
		animated_sprite.play("roll")

		print("roll")
	
	if rolling:
		velocity.x = roll_dir * ROLL_SPEED
		roll_time_left -= delta
		if roll_time_left <= 0.0:
			rolling = false
		move_and_slide()
		$RollHitbox/CollisionShape2D.disabled = false
		return
	
	# Play animation
	if is_on_floor():
		if direction == 0 and rolling == false:
			animated_sprite.play("idle")
		elif direction != 0 and rolling == false:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	_apply_move()

	
	

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()	

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "roll":
		rolling = false 
		$RollHitbox/CollisionShape2D.disabled = true

func _apply_move() -> void:
	var direction := Input.get_axis("Left", "Right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
