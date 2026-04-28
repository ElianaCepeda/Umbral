extends LevelState
class_name ConjuntivitisLevel

func _init():
	level_name = "Conjuntivitis"
	scene_path = "res://scenes/levels/conjuntivitis.tscn"
	timeline_name = "res://dialogues/illDescription/conjuntivitisDescription.dtl"
	enemy_type = "conjuntivitis"
	macro_level = "marihuana"
