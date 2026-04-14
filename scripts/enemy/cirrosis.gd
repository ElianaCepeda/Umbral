extends EnemyBase

@export var puddle_scene: PackedScene 

func _ready():
	super._ready()
	effect_name = "reduce_max_health"
	speed = 60 
	
	var puddle_timer = Timer.new()
	# Le asignamos un tiempo aleatorio a cada enemigo (ej: entre 1 y 3 segundos)
	puddle_timer.wait_time = randf_range(1.0, 3.0) 
	puddle_timer.timeout.connect(leave_puddle)
	add_child(puddle_timer)
	
	# Crucial: No iniciamos el timer inmediatamente. 
	# Esperamos un tiempo aleatorio corto para que no todos empiecen al mismo segundo.
	var initial_delay = randf_range(0.0, 2.0)
	get_tree().create_timer(initial_delay).timeout.connect(puddle_timer.start)

func leave_puddle():
	if puddle_scene and is_instance_valid(self):
		var puddle = puddle_scene.instantiate()
		puddle.global_position = global_position
		
		# Buscamos el contenedor específico en el nivel
		var contenedor = get_parent().get_node_or_null("ContenedorManchas")
		
		# Si el contenedor existe, metemos el charco ahí. Si no, lo ponemos normal.
		if contenedor:
			contenedor.add_child(puddle)
		else:
			get_parent().add_child(puddle)
