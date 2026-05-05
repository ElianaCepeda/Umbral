extends LevelState
class_name TestLevelState


func _init() -> void:
	level_name = "TestLevel"
	scene_path = "res://scenes/level_menu/TestLevel.tscn"
	target_group= "destructible_object"
	macro_level = "alcohol"

func enter() -> void:
	SaveManager.sync_and_save_player_state(
		100, 
		100,                             
		1,                
		1,
		1
	)
	super.enter()
	
func exit() -> void:
	SaveManager.reset_phase_state()
	super.exit()
