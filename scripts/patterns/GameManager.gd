# scripts/GameManager.gd 
extends Node

var current_level: LevelState = null
var points: int = 0

func get_points() -> int:
	return points

func add_points(amount: int):
	points += amount

func reset_points():
	points = 0

func change_level(new_level: LevelState):
	# If there is already an active level, execute its exit logic and delete it
	if current_level:
		current_level.exit()
		remove_child(current_level)
		current_level.queue_free()
	
	# Assign the new level
	current_level = new_level
	add_child(current_level)
	current_level.level_manager = self
	
	# Start the new level
	current_level.enter()

func game_over():
	# 1. Turn off the level immediately so nothing else moves or deals damage
	if current_level:
		current_level.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	
	# 2. Ask Godot to execute the scene change SAFELY at the end of the frame
	call_deferred("_perform_game_over")


func _perform_game_over():
	print("Starting Game Over sequence safely...")
	
	# 3. Make sure to remove any pause
	get_tree().paused = false
	
	if Dialogic.current_timeline != null:
		Dialogic.end_timeline()
	
	# CLEAN GENERIC EFFECTS
	var effects = get_tree().get_nodes_in_group("enemy_effects")
	for effect in effects:
		effect.queue_free()
	
	# 4. Destroy the old level
	if current_level:
		current_level.exit()
		remove_child(current_level)
		current_level.queue_free()
		current_level = null
		
	await get_tree().process_frame
	
	# 5. Load the main menu
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
