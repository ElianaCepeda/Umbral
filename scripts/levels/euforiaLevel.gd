extends LevelState
class_name EuforiaLevel

var scene_instance: Node2D
# var fondo_custom: Node # Descomenta si usas diálogos aquí
# var timeline_name: String = "res://dialogues/tu_dialogo.dtl" # Descomenta si usas diálogos

func enter():
	print("Entrando al nivel de Euforia...")
	
	# 1. Cargar la escena visual (Asegúrate de crear esta escena y ponerle la ruta correcta)
	# Esta escena debe tener tu TileMap, tu Player, tu Camera2D y tu Spawner
	scene_instance = preload("res://scenes/levels/euforia.tscn").instantiate()
	add_child(scene_instance)
	
	# --- LÓGICA SI NO TIENES DIÁLOGO INICIAL ---
	# Si vas a poner un diálogo inicial usando Dialogic, básate en el código de taquicardiaLevel.gd
	# Si este nivel arranca directo a la acción, usamos lo siguiente:
	
	var player = scene_instance.get_node("Player")
	if player and player.has_method("show_ui"): 
		player.show_ui()
		
	var spawner = scene_instance.get_node("Spawner")
	if spawner:
		print("¡Spawner encontrado! Configurando a euforia...")
		spawner.tipo_enemigo_actual = "euforia"
		spawner.generar_oleada()
	else:
		push_error("No se encontró el Spawner en la escena de Euforia")

func exit():
	print("Saliendo del nivel Euforia...")
	if scene_instance:
		scene_instance.queue_free()
		scene_instance = null
