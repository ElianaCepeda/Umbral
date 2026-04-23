extends EnemyBase

@export var wave_scene: PackedScene 

func _ready():
	super._ready()
	z_index = 5
	
	var shoot_timer = Timer.new()
	shoot_timer.wait_time = randf_range(2.0, 4.0) # Lanza ondas cada 2-4 segundos
	shoot_timer.timeout.connect(shoot_wave)
	add_child(shoot_timer)
	
	# Desfase aleatorio para que no todos disparen al mismo tiempo
	var initial_delay = randf_range(0.2, 0.6)
	get_tree().create_timer(initial_delay).timeout.connect(func():
		# Nos aseguramos de que el enemigo no haya muerto en esa fracción de segundo
		if is_instance_valid(self) and is_instance_valid(shoot_timer):
			shoot_wave() # ¡Dispara la primera onda rápido!
			shoot_timer.start() # Empieza el ciclo normal para los siguientes disparos
	)
	
	
func shoot_wave():
	if wave_scene and is_instance_valid(self):
		var wave = wave_scene.instantiate()
		wave.global_position = global_position
		
		wave.direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			
		var contenedor = get_parent().get_node_or_null("ContenedorAtaques")
		if contenedor:
			contenedor.add_child(wave)
		else:
			get_parent().add_child(wave)
