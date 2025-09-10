extends Node2D

enum  State {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

var state: State = State.MORNING
@onready var directional_light_2d: DirectionalLight2D = $DirectionalLight2D


func  _ready() -> void:
	directional_light_2d.enabled = true

func  _process(_delta: float) -> void:
	match state:
		State.MORNING:
			morning_state()
		State.DAY:
			day_state()
		State.EVENING:
			evening_state()
		State.NIGHT:
			night_state()
			
func morning_state():
	var tween = get_tree().create_tween()
	tween.tween_property(directional_light_2d, "energy", 0.5, 3)
	
func day_state():
	var tween = get_tree().create_tween()
	tween.tween_property(directional_light_2d, "energy", 0.2, 3)
	
func evening_state():
	var tween = get_tree().create_tween()
	tween.tween_property(directional_light_2d, "energy", 0.5, 3)
	
func night_state():
	var tween = get_tree().create_tween()
	tween.tween_property(directional_light_2d, "energy", 0.97, 3)

func _on_day_night_timeout() -> void:
	match state:
		State.MORNING:
			state = State.DAY
		State.DAY:
			state = State.EVENING
		State.EVENING:
			state = State.NIGHT
		State.NIGHT:
			state = State.MORNING
