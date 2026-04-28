extends LevelState
class_name ObstruccionLevel

func _init():
	level_name = "Obstrucción"
	scene_path = "res://scenes/levels/obstruccion.tscn"
	timeline_name = "res://dialogues/illDescription/obstruccionDescription.dtl"
	enemy_type = "obstruccion"
	macro_level = "tabaco"
