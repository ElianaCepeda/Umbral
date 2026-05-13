extends LevelState
class_name AlcoholLevel

func _init():
	level_name = "Jefe Alcohol"
	scene_path = "res://scenes/levels/alcohol.tscn"
	timeline_name = "res://dialogues/illDescription/jefeAlcoholDescription.dtl"
	enemy_type = "alcohol" 
	macro_level = "alcohol"

func _start_gameplay():
	super._start_gameplay()
	
	# Buscamos el componente desacoplado en la escena instanciada
	var boss_controller = scene_instance.get_node_or_null("BossFightController")
	print("Boss controller encontrado: ", boss_controller)
	if boss_controller:
		# Apagamos el chequeo normal del LevelState para que no interfiera
		is_gameplay_active = false 
		
		# Conectamos la señal del controlador a la función de victoria del LevelState
		boss_controller.boss_defeated.connect(_on_level_won)
