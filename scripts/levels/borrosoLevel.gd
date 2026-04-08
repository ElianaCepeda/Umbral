extends LevelState
class_name BorrosoLevel

var scene_instance: Node2D

func enter():
	print("Entrando al nivel de Borroso...")
	scene_instance = preload("res://scenes/levels/borroso.tscn").instantiate()
	add_child(scene_instance)
	
	var player = scene_instance.get_node("Player")
	if player and player.has_method("show_ui"): 
		player.show_ui()
		
	var spawner = scene_instance.get_node("Spawner")
	if spawner:
		spawner.tipo_enemigo_actual = "conjuntivitis"
		spawner.generar_oleada()
	else:
		push_error("No se encontró el Spawner en la escena de Borroso")

func exit():
	print("Saliendo del nivel Borroso...")
	if scene_instance:
		scene_instance.queue_free()
		scene_instance = null
