# scripts/GameManager.gd 
extends Node

var current_level: LevelState = null
var points: int = 0

func get_points() -> int:
	return points

func add_points(cantidad: int):
	points += cantidad

func reset_points():
	points = 0

func change_level(new_level: LevelState):
	# Si ya hay un nivel activo, ejecutamos su lógica de salida y lo borramos
	if current_level:
		current_level.exit()
		remove_child(current_level)
		current_level.queue_free()
	
	# Asignamos el nuevo nivel
	current_level = new_level
	add_child(current_level)
	current_level.level_manager = self
	
	# Iniciamos el nuevo nivel
	current_level.enter()

func game_over():
	# 1. Apagamos el nivel inmediatamente para que nada más se mueva o haga daño
	if current_level:
		current_level.process_mode = Node.PROCESS_MODE_DISABLED
	
	# 2. Le pedimos a Godot que ejecute el cambio de escena de forma SEGURA al final del frame
	call_deferred("_realizar_game_over")


func _realizar_game_over():
	print("Iniciando secuencia de Game Over de forma segura...")
	
	# 3. Nos aseguramos de quitar cualquier pausa
	get_tree().paused = false
	
	# LIMPIAR EFECTOS GENÉRICOS
	var efectos = get_tree().get_nodes_in_group("efectos_enemigos")
	for efecto in efectos:
		efecto.queue_free()
	
	# 4. Destruimos el nivel viejo
	if current_level:
		current_level.exit()
		remove_child(current_level)
		current_level.queue_free()
		current_level = null
		
	await get_tree().process_frame
	
	# 4. Cargamos el menú principal
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
