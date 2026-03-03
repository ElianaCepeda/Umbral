extends CharacterBody2D

@export var speed = 120
@export var salud = 5
@export var puntos = 15
@export var danio_colision = 10 # --- NUEVO: Daño por choque físico ---

# --- NUEVO: Escena del rastro de veneno ---
@export var veneno_scene = preload("res://scenes/attacks/veneno.tscn")
@onready var veneno_timer = $TimerVeneno
# ------------------------------------------
@export var tiempo_botando: float = 3.0
@export var tiempo_espera: float = 2.0

var direccion_movimiento = Vector2.ZERO
var player = null

func _ready():
	buscar_jugador()
	elegir_direccion_aleatoria()
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING 
	
	if has_node("TimerVeneno"):
		veneno_timer.timeout.connect(dejar_rastro)
		iniciar_ciclo_veneno()

func iniciar_ciclo_veneno():
	veneno_timer.start(0.005) 
	
	await get_tree().create_timer(tiempo_botando).timeout
	veneno_timer.stop()
	
	await get_tree().create_timer(tiempo_espera).timeout
	iniciar_ciclo_veneno()

func buscar_jugador():
	var nodos = get_tree().get_nodes_in_group("jugador")
	for n in nodos:
		if n is Node2D:
			player = n
			break

func _physics_process(delta):
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play()
	
	velocity = direccion_movimiento * speed
	
	# move_and_slide() devuelve true si hubo una colisión
	move_and_slide()
	
	# --- NUEVO: Detectar colisión con el jugador ---
	# Revisamos todos los choques ocurridos en este frame
	for i in get_slide_collision_count():
		var colision = get_slide_collision(i)
		var objeto_chocado = colision.get_collider()
		
		# Si el objeto está en el grupo jugador y tiene el método para recibir daño
		if objeto_chocado.is_in_group("jugador"):
			if objeto_chocado.has_method("recibir_danio"):
				objeto_chocado.recibir_danio(danio_colision)
				# Opcional: Rebotar al chocar para que no le quite toda la vida en un segundo
				elegir_direccion_aleatoria() 
	
	if is_on_wall():
		elegir_direccion_aleatoria()

func elegir_direccion_aleatoria():
	var angulo = randf_range(0, TAU)
	direccion_movimiento = Vector2.RIGHT.rotated(angulo)

func dejar_rastro():
	if veneno_scene:
		var nuevo_veneno = veneno_scene.instantiate()
		nuevo_veneno.global_position = global_position
		get_tree().root.add_child(nuevo_veneno)

func recibir_danio(cantidad):
	salud -= cantidad
	modulate = Color.GREEN 
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if salud <= 0:
		if is_instance_valid(player):
			player.increase_consciousness(puntos)
		morir()

func morir():
	queue_free()
