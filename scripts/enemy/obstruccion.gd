extends EnemyBase

@export var wall_scene: PackedScene = preload("res://scenes/attacks/rastro_obstruccion.tscn")
@export var escudo_distancia: float = 65.0 
@export var distancia_frontal: float = 60.0 
@export var distancia_seguridad: float = 200.0
@export_range(0.0, 1.0) var probabilidad_giro: float = 0.6
@export var radio_de_dano: float = 85.0 
var cooldown_dano: float = 0.0

var last_wall_position: Vector2 = Vector2.ZERO
var wall_spacing: float = 43.0 
var tiempo_atascado: float = 0.0 # Sirve como sensor para saber si se atoró

func _ready():
	speed = 100
	health = 8
	points = 15
	collision_damage = 2
	damage_color = Color.SADDLE_BROWN
	
	super._ready() 
	add_to_group("obstruccion")
	
	leave_wall()
	last_wall_position = global_position
	
	# --- RELOJ DE TÁCTICA ---
	# Obliga al enemigo a recalcular su ruta constantemente para hacer zig-zag
	var turn_timer = Timer.new()
	turn_timer.wait_time = 1.5
	turn_timer.autostart = true
	turn_timer.timeout.connect(choose_random_direction)
	add_child(turn_timer)

func choose_random_direction():
	var direccion_anterior = movement_direction 
	
	if not is_instance_valid(player):
		var direcciones_rectas = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
		movement_direction = direcciones_rectas.pick_random()
		_sellar_esquina(direccion_anterior)
		return
		
	var to_player = player.global_position - global_position
	var distancia_al_jugador = global_position.distance_to(player.global_position)
	
	# --- INSTINTO DE SUPERVIVENCIA ---
	if distancia_al_jugador < distancia_seguridad:
		# Si estás muy cerca, prioriza alejarse de ti
		if abs(to_player.x) > abs(to_player.y):
			# Huye horizontalmente en dirección contraria a ti
			movement_direction = Vector2(-sign(to_player.x), 0)
		else:
			# Huye verticalmente en dirección contraria a ti
			movement_direction = Vector2(0, -sign(to_player.y))
			
	# --- TÁCTICA DE LA TRINCHERA ---
	else:
		if abs(to_player.x) > abs(to_player.y):
			var dir_y = sign(to_player.y)
			if dir_y == 0: dir_y = 1
			movement_direction = Vector2(0, dir_y)
		else:
			var dir_x = sign(to_player.x)
			if dir_x == 0: dir_x = 1
			movement_direction = Vector2(dir_x, 0)
			
		# Solo intenta hacer giros trampa de 90 grados si NO está huyendo
		if randf() < probabilidad_giro: 
			var giros = [PI/2, -PI/2] 
			movement_direction = movement_direction.rotated(giros.pick_random()).round()
		
	_sellar_esquina(direccion_anterior)


# Obliga a poner un bloque instantáneo al doblar una esquina para no dejar grietas
func _sellar_esquina(direccion_anterior: Vector2):
	if direccion_anterior != Vector2.ZERO and direccion_anterior != movement_direction:
		leave_wall()
		last_wall_position = global_position
		
	
func _physics_process(delta):
	super._physics_process(delta) 
	
	# --- 1. DAÑO POR PROXIMIDAD ---
	# Medimos la distancia matemática
	if cooldown_dano > 0:
		cooldown_dano -= delta
	elif is_instance_valid(player):
		if global_position.distance_to(player.global_position) <= radio_de_dano:
			if player.has_method("take_damage"):
				player.take_damage(collision_damage, damage_color)
				cooldown_dano = 1.0 # Te golpea una vez y espera 1 segundo
				
	# --- 2. SENSOR ANTI-ATASCOS DE EMERGENCIA ---
	if movement_direction != Vector2.ZERO and get_real_velocity().length() < (speed * 0.1):
		tiempo_atascado += delta
		if tiempo_atascado > 0.2:
			# Si se quedó atascado en una esquina, elige una nueva ruta
			# No llamamos a _sellar_esquina() para que no se encierre con sus propios muros
			var direcciones = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
			movement_direction = direcciones.pick_random()
			tiempo_atascado = 0.0
	else:
		tiempo_atascado = 0.0 
	
	# --- 3. CONSTRUCCIÓN DE LA TRINCHERA ---
	if global_position.distance_to(last_wall_position) >= wall_spacing:
		leave_wall()
		last_wall_position = global_position

func leave_wall() -> void:
	var wall_pos = global_position
	var is_horizontal = true
	
	if abs(movement_direction.x) > 0:
		is_horizontal = true
		wall_pos.x += sign(movement_direction.x) * distancia_frontal
		
		if is_instance_valid(player):
			if player.global_position.y < global_position.y:
				wall_pos.y -= escudo_distancia 
			else:
				wall_pos.y += escudo_distancia 
	else:
		is_horizontal = false
		wall_pos.y += sign(movement_direction.y) * distancia_frontal
		
		if is_instance_valid(player):
			if player.global_position.x < global_position.x:
				wall_pos.x -= escudo_distancia
			else:
				wall_pos.x += escudo_distancia 

	# --- EL RADAR---
	var space_state = get_world_2d().direct_space_state
	if space_state:
		var query = PhysicsPointQueryParameters2D.new()
		query.position = wall_pos 
		
		# 32 (Tus muros) + 1 (Los muros del nivel) = 33
		query.collision_mask = 33 
		query.exclude = [self.get_rid()] 
		
		var overlaps = space_state.intersect_point(query)
		if not overlaps.is_empty():
			return 
	
	# --- CONSTRUCCIÓN ---
	if wall_scene:
		var new_wall = wall_scene.instantiate()
		new_wall.global_position = wall_pos 
		new_wall.is_horizontal = is_horizontal
		
		get_parent().call_deferred("add_child", new_wall)
		
		
func decide_direction():
	pass
