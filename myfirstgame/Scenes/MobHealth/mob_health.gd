extends Node2D

signal no_health()
signal damage_received()

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var damage_text: Label = $DamageText

var health: float = 100:
	set(value):
		if value < 0:
			value = 0
		health = value
		health_bar.value = health
		damage_text.text = str(health)
	get:
		return health
		
func _ready() -> void:
	health = 100
	Signals.connect("player_attack", on_player_attack)

func on_player_attack(damage: float):
	health -= damage
	if health == 0:
		emit_signal("no_health")
	else:			
		emit_signal("damage_received")
