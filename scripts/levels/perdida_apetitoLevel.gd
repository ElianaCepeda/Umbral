extends LevelState
class_name PerdidaApetitoLevel

func _init():
	level_name = "PerdidaApetito"
	scene_path = "res://scenes/levels/perdida_apetito.tscn"
	timeline_name = "res://dialogues/illDescription/perdidaApetitoDescription.dtl"
	enemy_type = "perdidaApetito"
	macro_level = "cocaina"
