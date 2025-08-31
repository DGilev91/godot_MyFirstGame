extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim: AnimatedSprite2D = $Anim

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		anim.play("Jump")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:	
		if velocity.y == 0:	
			anim.play("Run")
		velocity.x = direction * SPEED
	else:
		if velocity.y == 0:
			anim.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction > 0:
		anim.flip_h = false
	elif direction < 0:
		anim.flip_h = true
		
	if velocity.y > 0:
		anim.play("Fall")

	move_and_slide()
