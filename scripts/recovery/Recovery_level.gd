extends LevelState
class_name RecoveryState
	
	
func _init() -> void:
	level_name = "Recovery"
	scene_path = "res://scenes/recovery/BaseLevelRecovery.tscn"

func enter():
	print("Entrando al Nivel de Recuperación (Base)...")
	
	if not GameManager.preguntas_completadas:
		SaveManager.reset_phase_state()
	
	# 1. Usamos la escena que se cargó de forma asincrona
	if preloaded_scene:
		scene_instance = preloaded_scene.instantiate()
		add_child(scene_instance)
	else:
		push_error("CRÍTICO: No hay escena precargada en RecoveryState")
		return
	
	# 2. Buscamos la fuente DENTRO de la escena que acabamos de crear
	var fountain = scene_instance.get_node_or_null("Fountain")
	
	if fountain:
		if GameManager.preguntas_completadas:
			# Si ya jugamos las preguntas, destruimos la fuente
			fountain.queue_free()
		else:
			# Si NO las hemos jugado, conectamos la señal de colisión por código
			fountain.body_entered.connect(_on_fountain_body_entered)
	
	# 3. (Opcional) Si necesitas activar la UI del jugador en este nivel, lo haces aquí
	var player = scene_instance.get_node_or_null("Player")
	

func _on_fountain_body_entered(body: Node2D) -> void:
	# Verificamos que el objeto que entró al área sea el jugador
	if body.name == "Player":
		GameManager.change_level(RecoveryQuestions.new())
