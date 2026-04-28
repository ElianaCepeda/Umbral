extends Node
class_name LevelState

var level_manager: Node 
var scene_instance: Node2D
var fondo_custom: Node
var preloaded_scene: PackedScene = null

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
	
	if is_instance_valid(scene_instance):
		var player = scene_instance.get_node_or_null("Player")
		if player:
			
			SaveManager.sync_and_save_player_state(player.consciousness, player.max_consciousness)
			
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
