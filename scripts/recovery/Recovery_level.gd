extends LevelState
class_name RecoveryState
	
func enter():
	print("Entrando al Nivel de Recuperación (Base)...")
	
	# 1. Definimos las variables y creamos la escena visual
	level_name = "Recovery"
	scene_path = "res://scenes/recovery/BaseLevelRecovery.tscn"
	scene_instance = load(scene_path).instantiate()
	add_child(scene_instance)
	
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
