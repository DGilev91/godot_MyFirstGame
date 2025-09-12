extends CharacterBody2D

var alive: bool = true
var chase: bool = false
var speed: int = 100
@onready var anim: AnimatedSprite2D = $Anim



func  _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var player = $"../../Player"
	var direction = (player.position - self.position).normalized()
	
	if not alive:
		return
		
	if chase:
		velocity.x = direction.x * speed
		anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		anim.play("Idle")
		
	if direction.x < 0:
		anim.flip_h = true
	elif direction.x > 0:
		anim.flip_h = false
			
	move_and_slide()                                          

func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true


func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false


func _on_death_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		death()
		
		
func death():
	alive = false
	anim.play("Death")
	await anim.animation_finished
	queue_free()


func _on_death_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if alive:
			body.health -= 40
			death()
