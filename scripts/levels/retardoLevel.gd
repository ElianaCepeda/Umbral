extends LevelState
class_name RetardoLevel

func _init():
	level_name = "Retardo"
	scene_path = "res://scenes/levels/retardo.tscn"
	timeline_name = "res://dialogues/illDescription/retardoDescription.dtl"
	enemy_type = "retardo"
	macro_level = "alcohol"
