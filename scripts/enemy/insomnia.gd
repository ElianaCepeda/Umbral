extends CharacterBody2D

@export var speed = 150
@export var bullet_scene = preload("res://scenes/bulletenemy.tscn") 
@export var salud = 3
@export var puntos = 10

var direccion_movimiento = Vector2.ZERO
var player = null
func _ready():
	# 1. Buscamos al jugador
	buscar_jugador()
	
	# 2. Iniciamos el movimiento aleatorio
	elegir_direccion_aleatoria()
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING 
	
	# 3. SEGURIDAD: Forzamos la conexión del Timer por código
	# Asegúrate de que el nodo se llame "TimerDisparo" exactamente
	if has_node("TimerDisparo"):
		$TimerDisparo.timeout.connect(shoot)
		$TimerDisparo.start(randf_range(1.5, 2))
	if has_node("TimerMovimiento"):
		$TimerMovimiento.timeout.connect(elegir_direccion_aleatoria)

func buscar_jugador():
	var nodos = get_tree().get_nodes_in_group("jugador")
	for n in nodos:
		if n is Node2D:
			player = n
			break

func _physics_process(delta):
	$AnimatedSprite2D.play()
	
	# MOVIMIENTO: Ahora es siempre aleatorio
	velocity = direccion_movimiento * speed
	move_and_slide()
	
	# Si choca con pared, cambia de rumbo
	if is_on_wall():
		elegir_direccion_aleatoria()

func elegir_direccion_aleatoria():
	# Elige un ángulo al azar entre 0 y 360 grados
	var angulo = randf_range(0, TAU)
	direccion_movimiento = Vector2.RIGHT.rotated(angulo)

func shoot():
	if is_instance_valid(player):
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_position = global_position
		var dir = (player.global_position - global_position).normalized()
		var dispersion = randf_range(0.13, 0.3)
		var dir_desviada = dir.rotated(dispersion)
		new_bullet.direction = dir_desviada
		new_bullet.rotation = dir_desviada.angle()
		get_tree().root.add_child(new_bullet)

func recibir_danio(cantidad):
	salud -= cantidad
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if salud <= 0:
		if is_instance_valid(player):
			player.increase_consciousness(puntos)
		morir()

func morir():
	queue_free()
