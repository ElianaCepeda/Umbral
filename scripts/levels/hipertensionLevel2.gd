extends LevelState
class_name HipertensionLevel2

func _init():
	level_name = "Hipertensión"
	scene_path = "res://scenes/levels/hipertension2.tscn"
	timeline_name = "res://dialogues/illDescription/hipertensionDescription.dtl"
	enemy_type = "hipertension"
	macro_level = "tabaco"
