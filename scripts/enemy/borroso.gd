extends EnemyBase

@export var projectile_scene: PackedScene # Arrastra tu borroso_bullet.tscn aquí en el Inspector
@export var shoot_interval: float = 3.5

var shoot_timer: Timer

func _ready():
	super._ready()
	
	shoot_timer = Timer.new()
	
	var intervalo_unico = shoot_interval + randf_range(-0.5, 0.5)
	shoot_timer.wait_time = intervalo_unico
	shoot_timer.timeout.connect(shoot_fog_wave)
	add_child(shoot_timer)
	
	var desfase_inicial = randf_range(0.5, 2.0)
	get_tree().create_timer(desfase_inicial).timeout.connect(func():
		if is_instance_valid(self) and is_instance_valid(shoot_timer):
			shoot_fog_wave()
			shoot_timer.start()
	)

func shoot_fog_wave():
	if not projectile_scene or not is_instance_valid(player):
		return
		
	var projectile = projectile_scene.instantiate()
	
	projectile.global_position = global_position
	# Calculamos la dirección exacta hacia el jugador
	projectile.direction = (player.global_position - global_position).normalized()
	projectile.rotation = projectile.direction.angle()
	
	get_parent().add_child(projectile)
