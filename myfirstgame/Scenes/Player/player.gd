extends CharacterBody2D

enum State {
	IDLE,
	MOVE,
	ATTACK,
	ATTACK_2,
	ATTACK_3,
	BLOCK,
	SLIDE
}

const SPEED = 300.0
var RUN_SPEED = 1.0
const JUMP_VELOCITY = -400.0
var health: int = 100
var gold: int = 0
var state: State = State.IDLE

@onready var anim: AnimatedSprite2D = $Anim
@onready var anim_2: AnimationPlayer = $Anim2
@onready var camera_2d: Camera2D = $Camera2D


func _physics_process(delta: float) -> void:
	
	state = State.MOVE
	match state:
		State.IDLE:
			pass
		State.MOVE:
			move_state()
		State.ATTACK:
			pass
		State.ATTACK_2:
			pass
		State.ATTACK_3:
			pass
		State.BLOCK:
			pass
		State.SLIDE:
			pass
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

			
	if velocity.y > 0:
		anim_2.play("Fall")
		
	if health <= 0:
		health = 0
		anim_2.play("Death")
		await anim_2.animation_finished
		queue_free()
		get_tree().change_scene_to_file("res://Scenes/menu/menu.tscn")

	move_and_slide()

func move_state():
	var direction := Input.get_axis("left", "right")
	if direction:	
		if velocity.y == 0:	
			if RUN_SPEED == 1:
				anim_2.play("Walk")
			else:
				anim_2.play("Run")
		velocity.x = direction * SPEED * RUN_SPEED
	else:
		if velocity.y == 0:
			anim_2.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction > 0:
		anim.flip_h = false
	elif direction < 0:
		anim.flip_h = true
		
	if Input.is_action_pressed("run"):
		RUN_SPEED = 2
	else:
		RUN_SPEED = 1
