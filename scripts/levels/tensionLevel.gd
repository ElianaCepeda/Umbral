extends LevelState
class_name TensionLevel

func _init():
	level_name = "Tensión"
	scene_path = "res://scenes/levels/tension.tscn"
	timeline_name = "res://dialogues/illDescription/tensionDescription.dtl"
	enemy_type = "tension"
