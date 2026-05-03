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
	
	var exit_door = scene_instance.get_node_or_null("ExitDoor")
	if exit_door:
		exit_door.body_entered.connect(_on_exit_door_body_entered)
		
		var puerta_cerrada = exit_door.get_node_or_null("PuertaCerrada")
		var puerta_abierta = exit_door.get_node_or_null("PuertaAbierta")
		
		# 1. Puerta Cerrada
		if puerta_cerrada: puerta_cerrada.show()
		if puerta_abierta: puerta_abierta.hide()
		
		# 2. SI YA RESPONDIÓ, ABRIMOS LA PUERTA Y DESTRUIMOS EL MURO
		if GameManager.preguntas_completadas:
			if puerta_cerrada: puerta_cerrada.hide()
			if puerta_abierta: puerta_abierta.show()
	
	var player = scene_instance.get_node_or_null("Player")
	if GameManager.preguntas_completadas and GameManager.player_position_before_questions != Vector2.ZERO:
		if player:
			player.global_position = GameManager.player_position_before_questions
	
func exit():
	super.exit()
	

func _on_exit_door_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Solo permitimos salir si ya completó el cuestionario
		if GameManager.preguntas_completadas:
			print("Cruzando la puerta de la zona de recuperación. Avanzando...")
			GameManager.advance_campaign_flow()

func _on_fountain_body_entered(body: Node2D) -> void:
	GameManager.player_position_before_questions = body.global_position
	# Verificamos que el objeto que entró al área sea el jugador
	if body.name == "Player":
		var rango_preguntas = GameManager.get_current_question_range()
		var min_q = rango_preguntas[0]
		var max_q = rango_preguntas[1]
		GameManager.change_level(RecoveryQuestions.new(min_q, max_q))
