extends Node
class_name LevelState

var level_manager: Node 
var scene_instance: Node2D
var fondo_custom: Node
var preloaded_scene: PackedScene = null

var is_gameplay_active: bool = false
var _win_check_timer: float = 0.0
var is_door_open: bool = false

# --- VARIABLES DE CONFIGURACIÓN (Los hijos deben llenarlas) ---
var scene_path: String = ""
var timeline_name: String = ""
var enemy_type: String = ""
var level_name: String = "Base"
var macro_level: String = ""
var skill1: String
var skill2: String
var skill3: String

func enter():
	print("Entrando al nivel de " + level_name + "...")
	
	# 1. Cargar e instanciar la escena visual
	if preloaded_scene:
		scene_instance = preloaded_scene.instantiate()
		add_child(scene_instance)
	else:
		push_error("CRÍTICO: No hay escena precargada asíncronamente en " + level_name)
		return
		
	_setup_skills_by_macro_level()
	
	var player = scene_instance.find_child("Player", true, false)
	if player and player.has_method("apply_level_skills"):
		player.apply_level_skills(self)
		print("Habilidades inyectadas al NUEVO jugador: ", skill1, " y ", skill2)
	else:
		print("ADVERTENCIA: No se encontró al nodo 'Player' en la escena nueva.")

	# 2. Configurar el Spawner de antemano
	var spawner = scene_instance.get_node_or_null("Spawner")
	if spawner and enemy_type != "":
		spawner.tipo_enemigo_actual = enemy_type

	# 3. Lógica del Diálogo Dialogic
	fondo_custom = scene_instance.get_node_or_null("FondoDialogo")
	
	# Si el nivel tiene un diálogo configurado, lo lanzamos
	if timeline_name != "":
		if fondo_custom:
			fondo_custom.show()
			
		var layout = Dialogic.start(timeline_name)
		if layout:
			layout.process_mode = Node.PROCESS_MODE_ALWAYS
			
		Dialogic.Inputs.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		Dialogic.timeline_ended.connect(_on_timeline_ended)
	else:
		# Si un nivel no tiene diálogo, arrancamos el gameplay directamente
		_start_gameplay()

func _setup_skills_by_macro_level() -> void:
	match macro_level:
		"alcohol":
			skill1 = "food_alcohol"
			skill2 = "medicine_alcohol"
			skill3 = "water_attack"
		"tabaco":
			skill1 = "exercise_tabaco"
			skill2 = "patch_tabaco"
			skill3 = "gum_attack"
		"marihuana":
			skill1 = "dosis_measure_marihuana"
			skill2 = "nodrink_marihuana"
			skill3 = "sleep_attack" 
		"cocaina":
			skill1 = "nasalcare_cocaina"
			skill2 = "noexcercise_cocaina"
			skill3 = "temperature_attack" 
		_:
			# Si un nivel no tiene macro_level (ej. Sala de Recuperación), 
			# se ignoran o se dejan vacíos.
			pass

func exit():
	print("Saliendo de la sub-fase (síntoma): " + level_name + "...")
	
	if scene_instance:
		scene_instance.queue_free()
		scene_instance = null
		
		
func update(_delta: float):
	pass

# Función interna que responde a Dialogic
func _on_timeline_ended():
	print("--- DIÁLOGO TERMINADO en " + level_name + " ---")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	get_tree().paused = false
	
	if fondo_custom:
		fondo_custom.hide()
		
	_start_gameplay()

# Función que arranca la acción real del nivel
func _start_gameplay():
	if not is_instance_valid(scene_instance): return
	
	var player = scene_instance.find_child("Player", true, false)
	if player and player.has_method("show_ui"):
		player.show_ui()
		
	var spawner = scene_instance.get_node_or_null("Spawner")
	if spawner:
		print("¡" + level_name + " listo! Generando enemigos...")
		spawner.generar_oleada()
		
	var exit_door = scene_instance.find_child("ExitDoor", true, false)
	if exit_door:
		exit_door.body_entered.connect(_on_exit_door_body_entered)
		
		# Forzamos visualmente que empiece cerrada
		var puerta_cerrada = exit_door.get_node_or_null("PuertaCerrada")
		var puerta_abierta = exit_door.get_node_or_null("PuertaAbierta")
		if puerta_cerrada: puerta_cerrada.show()
		if puerta_abierta: puerta_abierta.hide()
		
	await get_tree().create_timer(0.5).timeout
	is_gameplay_active = true


func _process(delta: float) -> void:
	if not is_gameplay_active:
		return
		
	_win_check_timer += delta
	# Verificamos cada 0.5 segundos para no saturar la CPU innecesariamente
	if _win_check_timer >= 0.5:
		_win_check_timer = 0.0
		_check_win_condition()

func _check_win_condition() -> void:
	# Buscamos cuántos enemigos quedan vivos en la escena
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	if enemies.size() == 0:
		# ¡Ya no quedan enemigos! Apagamos el monitoreo y ejecutamos la victoria
		is_gameplay_active = false
		print("¡Nivel completado! Todos los enemigos (" + level_name + ") fueron derrotados.")
		_on_level_won()

func _on_level_won() -> void:
	is_gameplay_active = false
	
	var player = scene_instance.find_child("Player", true, false)
	var exit_door = scene_instance.find_child("ExitDoor", true, false)
	
	# Guardamos el progreso SOLO porque el jugador acaba de ganar
	if player:
		SaveManager.sync_and_save_player_state(player.consciousness, player.max_consciousness)
	
	if player and exit_door:
		var camera = player.get_node_or_null("Camera2D")
		if camera:
			# Busca la posición real de la puerta desde sus hijos
			var door_target = Vector2.ZERO
			for child in exit_door.get_children():
				if child.global_position != Vector2.ZERO:
					door_target = child.global_position
					break
			
			# Fallback si ningún hijo tiene posición válida
			if door_target == Vector2.ZERO:
				push_warning("No se encontró posición válida para ExitDoor, usando PuertaCerrada.")
				var puerta_cerrada = exit_door.get_node_or_null("PuertaCerrada")
				if puerta_cerrada:
					door_target = puerta_cerrada.global_position

			get_tree().paused = true
			camera.top_level = true
			camera.global_position = player.global_position # Ancla explícita
			
			var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
			
			tween.tween_property(camera, "global_position", door_target, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			
			
			
			# 3. Cuando llega, abrimos la puerta
			tween.tween_callback(func():
				var puerta_cerrada = exit_door.get_node_or_null("PuertaCerrada")
				var puerta_abierta = exit_door.get_node_or_null("PuertaAbierta")
				var bloqueo = exit_door.get_node_or_null("BloqueoPuerta")
				
				if puerta_cerrada: puerta_cerrada.hide()
				if puerta_abierta: puerta_abierta.show()
				if bloqueo: bloqueo.queue_free() 
				
				is_door_open = true
				print("¡Puerta abierta visualmente!")
			)
			
			# 4. Esperamos 1 segundo mirando la puerta abierta
			tween.tween_interval(1.0)
			
			# 5. Paneo de regreso al jugador (1.5 segundos)
			tween.tween_property(camera, "global_position", player.global_position, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			
			# 6. Al volver, reconectamos la cámara y quitamos la pausa
			tween.tween_callback(func():
				camera.top_level = false
				camera.position = Vector2.ZERO # Reseteamos su posición local
				get_tree().paused = false
			)
			return

	# (Por si alguna vez haces un nivel sin cámara, forzamos la apertura directa)
	is_door_open = true


func _on_exit_door_body_entered(body: Node2D) -> void:
	# El jugador solo puede salir si la puerta ya está abierta
	if body.name == "Player" and is_door_open:
		print("El jugador escapó del nivel de combate. Avanzando...")
		GameManager.advance_campaign_flow()
