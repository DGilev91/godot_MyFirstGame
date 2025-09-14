extends CharacterBody2D

signal health_changed(health: int)


enum State {
	IDLE,
	MOVE,
	ATTACK,
	ATTACK_2,
	ATTACK_3,
	BLOCK,
	SLIDE,
	DAMAGE,
	DEATH
}

const SPEED = 300.0
var RUN_SPEED = 1.0
const JUMP_VELOCITY = -400.0
var max_health: int = 100
var health: int = max_health:
	set(value):
		if value <= 0:
			value = 0
		health = value
		emit_signal("health_changed", health)
	get:
		return health
		
		
var gold: int = 0
var state: State = State.MOVE
var is_combo: bool = false

var damage_basic: float = 10
var damage_multiplier: float = 1
var damage_current: float = 0

@onready var anim: AnimatedSprite2D = $Anim
@onready var anim_2: AnimationPlayer = $Anim2
@onready var camera_2d: Camera2D = $Camera2D
@onready var damage_box: Node2D = $AttackDirection/DamageBox

func _ready() -> void:
	Signals.connect("enemy_attack", on_enemy_attack)
	#health = max_health

func _physics_process(delta: float) -> void:


	match state:
		State.IDLE:
			pass
		State.MOVE:
			move_state()
		State.ATTACK:
			attack_state()
		State.ATTACK_2:
			attack2_state()
		State.ATTACK_3:
			attack3_state()
		State.BLOCK:
			block_state()
		State.SLIDE:
			slide_state()
		State.DAMAGE:
			damage_state()
		State.DEATH:
			death_state()
	
	damage_current = damage_basic * damage_multiplier
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

			
	if velocity.y > 0:
		anim_2.play("Fall")
		
	move_and_slide()
	
	Signals.emit_signal("player_position_update", position)

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
		damage_box.rotation_degrees = 0
	elif direction < 0:
		anim.flip_h = true
		damage_box.rotation_degrees = 180
		
	if Input.is_action_pressed("run"):
		RUN_SPEED = 2
	else:
		RUN_SPEED = 1
		
	if Input.is_action_pressed("block"):
		if velocity.x == 0:
			state = State.BLOCK
		else: 
			state = State.SLIDE
	elif Input.is_action_just_pressed("attack"):
		state = State.ATTACK
		
func block_state():
	velocity.x = 0
	anim_2.play("Block")
	if Input.is_action_just_released("block"):
		state = State.MOVE

func slide_state():
	anim_2.play("Slide")
	await anim_2.animation_finished
	state = State.MOVE
	
func attack_state():
	damage_multiplier = 1
	if Input.is_action_just_pressed("attack") and is_combo:
		state = State.ATTACK_2
		return
	
	velocity.x = 0
	anim_2.play("Attack")
	await anim_2.animation_finished
	state = State.MOVE	
	
func attack2_state():
	damage_multiplier = 1.2
	if Input.is_action_just_pressed("attack") and is_combo:
		state = State.ATTACK_3
		return
		
	velocity.x = 0
	anim_2.play("Attack2")
	await anim_2.animation_finished
	state = State.MOVE	

func attack3_state():
	damage_multiplier = 2
	velocity.x = 0
	anim_2.play("Attack3")
	await anim_2.animation_finished
	state = State.MOVE	


func combo1():
	is_combo = true
	await anim_2.animation_finished
	is_combo = false
	
	
func damage_state():
	velocity.x = 0
	anim_2.play("Damage")
	await anim_2.animation_finished
	state = State.MOVE	
	
func death_state():	
	state = State.IDLE	
	anim_2.play("Death")
	await anim_2.animation_finished
	get_tree().change_scene_to_file("res://Scenes/menu/menu.tscn")	
	
func on_enemy_attack(damange: int):
	if state == State.BLOCK:
		damange /= 2
	elif state == State.SLIDE:
		damange = 0
	
	if state == State.DEATH:
		return
	state = State.DAMAGE
	health -= damange
	if health == 0:
		state = State.DEATH


func _on_hit_box_area_entered(area: Area2D) -> void:
	Signals.emit_signal("player_attack", damage_current)
