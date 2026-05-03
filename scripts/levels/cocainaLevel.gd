extends LevelState
class_name CocainaLevel

func _init():
	level_name = "Jefe Cocaina"
	scene_path = "res://scenes/levels/cocaina.tscn"
	timeline_name = ""
	enemy_type = "cocaina" 
	macro_level = "cocaina"

func _start_gameplay():
	super._start_gameplay()
	
	# Buscamos el componente desacoplado en la escena instanciada
	var boss_controller = scene_instance.get_node_or_null("BossFightController")
	if boss_controller:
		# Apagamos el chequeo normal del LevelState para que no interfiera
		is_gameplay_active = false 
		
		# Conectamos la señal del controlador a la función de victoria del LevelState
		boss_controller.boss_defeated.connect(_on_level_won)
