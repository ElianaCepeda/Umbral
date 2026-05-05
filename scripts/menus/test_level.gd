extends LevelState
class_name TestLevelState

func _init() -> void:
	level_name = "TestLevel"
	scene_path = "res://scenes/UI/TestLevel.tscn"

func enter():
	print("Entrando al Test Level...")
	
	if preloaded_scene:
		scene_instance = preloaded_scene.instantiate()
		add_child(scene_instance)
	else:
		push_error("CRÍTICO: No hay escena precargada en TestLevelState")
		return
	
	var exit_door = scene_instance.get_node_or_null("ExitDoor")
	if exit_door:
		exit_door.body_entered.connect(_on_exit_door_body_entered)

func exit():
	super.exit()

func _on_exit_door_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Saliendo del Test Level...")
		GameManager.advance_campaign_flow()
