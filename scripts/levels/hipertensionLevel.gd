extends LevelState
class_name HipertensionLevel

func _init():
	level_name = "Hipertensión"
	scene_path = "res://scenes/levels/hipertension.tscn"
	timeline_name = "res://dialogues/illDescription/hipertensionDescription.dtl"
	enemy_type = "hipertension"
