extends LevelState
class_name TaquicardiaLevel

func _init():
	level_name = "Taquicardia"
	scene_path = "res://scenes/levels/taquicardia.tscn" 
	timeline_name = "res://dialogues/illDescription/taquicardiaDescription.dtl"
	enemy_type = "taquicardia"
