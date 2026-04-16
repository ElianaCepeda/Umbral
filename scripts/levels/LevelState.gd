extends Node
class_name LevelState

var level_manager: Node 
var scene_instance: Node2D
var fondo_custom: Node

# --- VARIABLES DE CONFIGURACIÓN (Los hijos deben llenarlas) ---
var scene_path: String = ""
var timeline_name: String = ""
var enemy_type: String = ""
var level_name: String = "Base" # Útil para los prints de depuración

func enter():
	print("Entrando al nivel de " + level_name + "...")
	
	# 1. Cargar e instanciar la escena visual
	if scene_path != "":
		# Usamos load() en vez de preload() porque la ruta ahora es una variable
		scene_instance = load(scene_path).instantiate()
		add_child(scene_instance)
	else:
		push_error("CRÍTICO: No se definió 'scene_path' en el nivel " + level_name)
		return

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

func exit():
	print("Saliendo del nivel " + level_name + "...")
	
	# RESTAURAMOS LA VIDA MÁXIMA DEL JUGADOR AQUÍ
	if is_instance_valid(scene_instance):
		var player = scene_instance.get_node_or_null("Player")
		if player and player.has_method("restore_max_health"):
			player.restore_max_health()
			
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
	
	var player = scene_instance.get_node_or_null("Player")
	if player and player.has_method("show_ui"): 
		player.show_ui()
		
	var spawner = scene_instance.get_node_or_null("Spawner")
	if spawner:
		print("¡" + level_name + " listo! Generando enemigos...")
		spawner.generar_oleada()
