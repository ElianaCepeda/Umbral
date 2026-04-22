extends EnemyBase

@export var wave_scene: PackedScene 

func _ready():
	super._ready()
	speed = 80 # Velocidad normal
	z_index = 5
	
	var shoot_timer = Timer.new()
	shoot_timer.wait_time = randf_range(2.0, 4.0) # Lanza ondas cada 2-4 segundos
	shoot_timer.timeout.connect(shoot_wave)
	add_child(shoot_timer)
	
	# Desfase aleatorio para que no todos disparen al mismo tiempo
	get_tree().create_timer(randf_range(0.5, 1.5)).timeout.connect(shoot_timer.start)

func shoot_wave():
	if wave_scene and is_instance_valid(self):
		var wave = wave_scene.instantiate()
		wave.global_position = global_position
		
		# Apuntamos hacia el jugador
		player = get_tree().get_first_node_in_group("player")
		if player:
			wave.direction = (player.global_position - global_position).normalized()
		else:
			wave.direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			
		var contenedor = get_parent().get_node_or_null("ContenedorAtaques")
		if contenedor:
			contenedor.add_child(wave)
		else:
			get_parent().add_child(wave)
