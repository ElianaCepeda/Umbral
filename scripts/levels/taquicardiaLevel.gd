extends LevelState
class_name TaquicardiaLevel2

func _init():
	level_name = "Taquicardia"
	scene_path = "res://scenes/levels/taquicardia2.tscn" 
	timeline_name = "res://dialogues/illDescription/taquicardiaDescription.dtl"
	enemy_type = "taquicardia"
	macro_level = "cocaina"
