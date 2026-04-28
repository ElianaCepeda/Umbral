# scripts/patterns/GameManager.gd 
extends Node

var current_level: LevelState = null
var preguntas_completadas = false

func _ready() -> void:
	# Nos suscribimos al evento de carga asíncrona exitosa
	TransitionManager.load_completed.connect(_on_level_loaded)

func change_level(new_level: LevelState):
	# Le decimos a Godot que ejecute el cambio de nivel de forma diferida (segura)
	# y le pasamos 'new_level' como argumento para que la siguiente función lo reciba.
	TransitionManager.load_level_async(new_level)
	
func _on_level_loaded(packed_scene: PackedScene, new_level: LevelState) -> void:
	# Cuando la escena está lista en la memoria RAM, inyectamos y cambiamos
	new_level.preloaded_scene = packed_scene
	call_deferred("_perform_change_level", new_level)

func _perform_change_level(new_level: LevelState) -> void:
	if current_level:
		current_level.exit()
		remove_child(current_level)
		current_level.queue_free()
	
	current_level = new_level
	add_child(current_level)
	current_level.level_manager = self
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
