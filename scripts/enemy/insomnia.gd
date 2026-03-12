extends EnemyBase

@export var bullet_scene: PackedScene = preload("res://scenes/attacks/bulletenemy.tscn") 

func _ready():
	# Definimos atributos específicos
	speed = 150
	health = 3
	points = 10
	collision_damage = 1
	damage_color = Color.RED
	
	super._ready() # Inicializa la lógica base
	
	if has_node("ShootTimer"):
		$ShootTimer.timeout.connect(shoot)
		$ShootTimer.start(randf_range(1.5, 2.0))
		
	if has_node("MovementTimer"):
		$MovementTimer.timeout.connect(choose_random_direction)

func shoot():
	if is_instance_valid(player):
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_position = global_position
		
		var dir = (player.global_position - global_position).normalized()
		var dispersion = randf_range(0.13, 0.3)
		var deviated_dir = dir.rotated(dispersion)
		
		new_bullet.direction = deviated_dir
		new_bullet.rotation = deviated_dir.angle()
		get_parent().add_child(new_bullet)
