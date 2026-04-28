extends LevelState
class_name GastritisLevel

func _init():
	level_name = "Gastritis"
	scene_path = "res://scenes/levels/gastritis.tscn"
	timeline_name = "res://dialogues/illDescription/gastritisDescription.dtl"
	enemy_type = "gastritis"
	macro_level = "alcohol"
	skill1 = "food_alcohol"
	skill2 = "medicine_alcohol"
	skill3 = "water_attack"
