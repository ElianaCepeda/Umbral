extends LevelState
class_name FatigaLevel

func _init():
	level_name = "Fatiga"
	scene_path = "res://scenes/levels/fatiga.tscn"
	timeline_name = "res://dialogues/illDescription/fatigaDescription.dtl"
	enemy_type = "fatiga"
