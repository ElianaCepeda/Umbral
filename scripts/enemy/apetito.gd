extends EnemyBase
@export var bullet_scene: PackedScene
@onready var shoot_position = $ShootPosition

func _ready():
	super._ready()
	speed = 80 
	add_to_group("anxiety")
	
	# Conectamos el temporizador de disparo
	$ShootTimer.timeout.connect(_shoot)

func _shoot():
	if not is_instance_valid(player): return
	
	var new_bullet = bullet_scene.instantiate()
	new_bullet.global_position = shoot_position.global_position
	
	# APUNTADO: Calculamos la dirección exacta al jugador en el momento del disparo
	var dir_to_player = (player.global_position - global_position).normalized()
	new_bullet.direction = dir_to_player
	
	# Orientamos la bala visualmente hacia el jugador
	new_bullet.rotation = dir_to_player.angle()
	
	get_parent().add_child(new_bullet)
