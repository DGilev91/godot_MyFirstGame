extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $Anim
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $AttackDirection/AttackRange/CollisionShape2D
@onready var attack_direction: Node2D = $AttackDirection

enum State {
	IDLE,
	ATTACK,
	CHASE
}


var player_pos: Vector2
var direction

var state: State = State.IDLE:
	set(value):
		state = value
		match state:
			State.IDLE:
				idle_state()
			State.ATTACK:
				attack_state()
			State.CHASE:
				chase_state()
			
	get:
		return state

func _ready() -> void:
	Signals.connect("player_position_update", player_pos_update)


func  _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	#var player = $"../../Player"


	
	
	move_and_slide()                                          



func _on_attack_range_body_entered(_body: Node2D) -> void:
	state = State.ATTACK
	
func idle_state():
	animation_player.play("Idle")
	await  get_tree().create_timer(1).timeout
	collision_shape_2d.disabled = false
	state = State.CHASE
	
func attack_state():
	animation_player.play("Attack")
	await animation_player.animation_finished
	collision_shape_2d.disabled = true
	state = State.IDLE

func chase_state():
	direction = (player_pos - self.position).normalized()
	if direction.x < 0:
		anim.flip_h = true
		attack_direction.rotation_degrees = 180
	elif direction.x > 0:
		anim.flip_h = false
		attack_direction.rotation_degrees = 0

func player_pos_update(player_pos: Vector2):
	self.player_pos = player_pos
