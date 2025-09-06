extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var health: int = 100
var gold: int = 0

@onready var anim: AnimatedSprite2D = $Anim
@onready var anim_2: AnimationPlayer = $Anim2
@onready var camera_2d: Camera2D = $Camera2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("attack") and is_on_floor():
		anim_2.play("Jump")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:	
		if velocity.y == 0:	
			anim_2.play("Run")
		velocity.x = direction * SPEED
	else:
		if velocity.y == 0:
			anim_2.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction > 0:
		#camera_2d.offset.x = move_toward(camera_2d.offset.x, -100, 10)
		anim.flip_h = false
	elif direction < 0:
		#camera_2d.offset.x = move_toward(camera_2d.offset.x, -350, 10)
		anim.flip_h = true
		
	if velocity.y > 0:
		anim_2.play("Fall")
		
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://Scenes/menu/menu.tscn")

	move_and_slide()
