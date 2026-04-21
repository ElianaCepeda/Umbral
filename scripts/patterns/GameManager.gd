# scripts/GameManager.gd 
extends Node

var current_level: LevelState = null
var attackpoints: int = 0
var defense1points : int = 0
var defense2points : int = 0
var count : int = 1


func set_attackpoints(value: int) -> void:
	attackpoints = value
	print("Attack actualizado a:", value)

func get_attackpoints() -> int:
	return attackpoints


func set_defense1points(value: int) -> void:
	defense1points = value
	print("Defense1 actualizado a:", value)

func get_defense1points() -> int:
	return defense1points

func set_defense2points(value: int) -> void:
	defense2points = value
	print("Defense2 actualizado a:", value)

func get_defense2points() -> int:
	return defense2points

func set_count(value: int) -> void:
	count = value

func get_count()-> int:
	return count

func reset_points():
	attackpoints = 0
	defense1points  = 0
	defense2points  = 0

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
