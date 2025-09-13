extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $Anim
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $AttackDirection/AttackRange/CollisionShape2D

enum State {
	IDLE,
	ATTACK,
	CHASE
}

var state: State = State.IDLE:
	set(value):
		state = value
		match state:
			State.IDLE:
				idle_state()
			State.ATTACK:
				attack_state()
			State.CHASE:
				pass
			
	get:
		return state

func  _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	#var player = $"../../Player"
	#var direction = (player.position - self.position).normalized()
	
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
