# scripts/levels/gastritisLevel.gd
extends LevelState
class_name TaquicardiaLevel

var scene_instance: Node2D
var fondo_custom: Node
var timeline_name: String = "res://dialogues/illDescription/taquicardiaDescription.dtl"

func enter():
	scene_instance = preload("res://scenes/levels/gastritis.tscn").instantiate()
	add_child(scene_instance)
	
	fondo_custom = scene_instance.get_node("FondoDialogo")
	fondo_custom.show()
	
	var layout = Dialogic.start(timeline_name)
	if layout:
		layout.process_mode = Node.PROCESS_MODE_ALWAYS
		
	Dialogic.Inputs.process_mode = Node.PROCESS_MODE_ALWAYS
	
	get_tree().paused = true
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	
	var spawner = scene_instance.get_node("Spawner")
	if spawner:
		spawner.tipo_enemigo_actual = "taquicardia"

func exit():
	print("Saliendo del nivel Gastritis...")
	if scene_instance:
		scene_instance.queue_free()
		scene_instance = null
		
	if fondo_custom:
		fondo_custom.queue_free()
		fondo_custom = null

func _on_timeline_ended():
	print("--- DIÁLOGO TERMINADO ---")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	get_tree().paused = false
	fondo_custom.hide()
	
	var player = scene_instance.get_node("Player")
	if player and player.has_method("show_ui"): 
		player.show_ui()
		
	# ¡Ruta directa y exacta con mayúscula!
	var spawner = scene_instance.get_node("Spawner")
	
	if spawner:
		print("¡Spawner encontrado! Generando enemigos...")
		spawner.generar_oleada()
