extends EnemyBase

@export var projectile_scene: PackedScene # Aquí arrastrarás tu euforia_bullet.tscn en el inspector
@export var shoot_interval: float = 2.5 # Tiempo entre cada ráfaga
@export var projectiles_per_circle: int = 8 # Cantidad de proyectiles por ráfaga circular

var shoot_timer: Timer

func _ready():
	super._ready()
	
	shoot_timer = Timer.new()
	
	# 1. Le damos a cada enemigo un ritmo ligeramente único
	# Si shoot_interval es 2.5, esto lo hará variar entre 2.0 y 3.0 segundos
	var intervalo_unico = shoot_interval + randf_range(-0.5, 0.5)
	shoot_timer.wait_time = intervalo_unico
	shoot_timer.timeout.connect(shoot_circular_projectiles)
	add_child(shoot_timer)
	
	# 2. Calculamos un desfase inicial aleatorio para que no disparen a la vez
	var desfase_inicial = randf_range(0.2, intervalo_unico)
	
	# 3. Usamos un temporizador de un solo uso para esperar ese desfase
	get_tree().create_timer(desfase_inicial).timeout.connect(func():
		# Validamos que el enemigo no haya sido eliminado por el jugador mientras esperaba
		if is_instance_valid(self) and is_instance_valid(shoot_timer):
			shoot_circular_projectiles() # Hacemos el primer disparo
			shoot_timer.start() # Arrancamos el ciclo infinito con su intervalo único
	)

func shoot_circular_projectiles():
	if not projectile_scene:
		push_error("No se ha asignado la escena del proyectil en Euforia.")
		return
		
	# TAU es equivalente a 2 * PI (360 grados en radianes)
	var angle_step = TAU / projectiles_per_circle
	
	for i in range(projectiles_per_circle):
		var angle = i * angle_step
		var projectile = projectile_scene.instantiate()
		
		# Configuramos la posición y la dirección de cada bala
		projectile.global_position = global_position
		projectile.direction = Vector2.RIGHT.rotated(angle)
		projectile.rotation = projectile.direction.angle()
		
		# Agregamos la bala a la escena raíz (para que no se mueva junto con el enemigo)		
		get_parent().add_child(projectile)
