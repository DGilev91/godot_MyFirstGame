extends Node2D

enum  State {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

var state: State = State.NIGHT
var day_count: int = 1

@onready var directional_light_2d: DirectionalLight2D = $DirectionalLight2D
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var day_text: Label = $CanvasLayer/DayText
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer



func  _ready() -> void:
	directional_light_2d.enabled = true
	set_dat_text()		
		
func morning_state():
	var tween = get_tree().create_tween()
	tween.tween_property(directional_light_2d, "energy", 0.5, 3)
	
	var tween1 = get_tree().create_tween()
	tween1.tween_property(point_light_2d, "energy", 2, 3)
	
func day_state():
	var tween = get_tree().create_tween()
	tween.tween_property(directional_light_2d, "energy", 0.2, 3)
	
	var tween1 = get_tree().create_tween()
	tween1.tween_property(point_light_2d, "energy", 0, 3)
	
func evening_state():
	var tween = get_tree().create_tween()
	tween.tween_property(directional_light_2d, "energy", 0.5, 3)
	
	var tween1 = get_tree().create_tween()
	tween1.tween_property(point_light_2d, "energy", 2, 3)
	
func night_state():
	var tween = get_tree().create_tween()
	tween.tween_property(directional_light_2d, "energy", 0.97, 3)
	
	var tween1 = get_tree().create_tween()
	tween1.tween_property(point_light_2d, "energy", 3.5, 3)

func _on_day_night_timeout() -> void:	
	match state:
		State.MORNING:
			day_count += 1
			set_dat_text()		
			morning_state()
		State.DAY:
			day_state()
		State.EVENING:
			evening_state()
		State.NIGHT:
			night_state()
	
	match state:
		State.MORNING:
			state = State.DAY
		State.DAY:
			state = State.EVENING
		State.EVENING:
			state = State.NIGHT
		State.NIGHT:
			state = State.MORNING

func set_dat_text():
	day_text.text = "Day " + str(day_count)
	animation_player.play("day_text_fade_in")
	await get_tree().create_timer(3).timeout
	animation_player.play("day_text_fade_out")
	
