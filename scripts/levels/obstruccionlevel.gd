extends LevelState
class_name ObstruccionLevel

func _init():
	level_name = "Obstrucción"
	scene_path = "res://scenes/levels/obstruccion.tscn"
	timeline_name = "res://dialogues/illDescription/obstruccionDescription.dtl"
	enemy_type = "obstruccion"
	skill1 = "food_alcohol"
	skill2 = ""
	skill3 = "gum_attack"
