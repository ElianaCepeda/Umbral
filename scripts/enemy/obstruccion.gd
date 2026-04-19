extends EnemyBase

@export var wall_scene: PackedScene = preload("res://scenes/attacks/rastro_obstruccion.tscn")
@export var escudo_distancia: float = 65.0 
@export var distancia_frontal: float = 60.0 

# ¡NUEVO! Controla la tendencia a hacer curvas (0.0 es nunca, 1.0 es siempre)
@export_range(0.0, 1.0) var probabilidad_giro: float = 0.6 

var last_wall_position: Vector2 = Vector2.ZERO
var wall_spacing: float = 43.0 

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
	
	# --- NUEVO: RELOJ DE TÁCTICA ---
	# Obliga al enemigo a recalcular su ruta constantemente para hacer zig-zag
	var turn_timer = Timer.new()
	turn_timer.wait_time = 1.5 # Cada medio segundo piensa si debe girar
	turn_timer.autostart = true
	turn_timer.timeout.connect(choose_random_direction)
	add_child(turn_timer)

func choose_random_direction():
	if not is_instance_valid(player):
		var direcciones_rectas = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
		movement_direction = direcciones_rectas.pick_random()
		return
		
	var to_player = player.global_position - global_position
	
	# Busca acercarse a ti
	if abs(to_player.x) > abs(to_player.y):
		movement_direction = Vector2(sign(to_player.x), 0) 
	else:
		movement_direction = Vector2(0, sign(to_player.y)) 
		
	# ¡NUEVO! Usa la variable del Inspector para decidir si hace un quiebre de 90 grados
	if randf() < probabilidad_giro: 
		var giros = [PI/2, -PI/2] 
		# Rotamos y usamos round() para mantener ángulos perfectos de 90°
		movement_direction = movement_direction.rotated(giros.pick_random()).round()

func _physics_process(delta):
	super._physics_process(delta) 
	
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

	# --- EL RADAR MEJORADO ---
	var space_state = get_world_2d().direct_space_state
	if space_state:
		var query = PhysicsPointQueryParameters2D.new()
		query.position = wall_pos 
		
		# ¡LA CLAVE! 32 (Tus muros) + 1 (Los muros del nivel) = 33
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
