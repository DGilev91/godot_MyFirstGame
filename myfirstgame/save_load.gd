extends Node


const save_location = "user://SaveFile.save"

var player_pos: Vector2:
	set(value):
		player_pos = value
		save_game()
	get:
		load_game()
		return player_pos




func save_game():
	var file  = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(player_pos)
	
func load_game():
	var file  = FileAccess.open(save_location, FileAccess.READ)
	var data = file.get_var()
	if typeof(data) == TYPE_VECTOR2:
		player_pos = data
