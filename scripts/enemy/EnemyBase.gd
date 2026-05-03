extends CharacterBody2D
class_name EnemyBase

# --- SHARED ATTRIBUTES ---
@export var effect_name: String = ""
@export var effect_duration: float = 2.0
@export var speed: int = 120
@export var health: int = 5
@export var points: int = 10 # puntos que recibe el jugador cuando muere el enemigoo
@export var collision_damage: int = 1 # puntos que pierde el jugador cuando toca al enemigoo
@export var damage_color: Color = Color.RED 
@onready var death_sound = $DeathSound

var movement_direction: Vector2 = Vector2.ZERO
var player: Node2D = null
var is_recoiling: bool = false # Sensor para saber si está rebotando

# --- CONFIGURACIÓN DE IA ---
@export_enum("Constructor (Rastro Heurístico)", "Cazador (Embestida Errática)", "Expansivo (Lento y Directo)", "Random") var comportamiento: int = 1
@export_enum("4 Direcciones (Cruz)", "Libre (360 Grados)") var tipo_movimiento: int = 2
var prediction_time :float = 0.5

# --- PARÁMETROS DE HEURÍSTICA (deja rastro)---
var target_distance: float
var turn_penalty: float
var u_turn_penalty: float
var wall_penalty: float
var randomness_factor: float

# --- PARÁMETROS DE CAZADOR (Sin Rastro) ---
var is_charging: bool = false
var charge_probability: float # Probabilidad única para cada enemigo instanciado
var is_preparing_charge: bool = false 


func _ready():
	add_to_group("enemy")
	find_player()
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING 
	
	# Iniciamos de forma aleatoria para comportamientos similares pero no iguales
	# Heuristica
	target_distance = randf_range(80.0, 100.0)  
	turn_penalty = randf_range(20.0, 50.0)      
	u_turn_penalty = randf_range(300.0, 500.0)  
	wall_penalty = randf_range(200.0, 400.0)    
	randomness_factor = randf_range(10.0, 40.0) 
	# Embestida
	charge_probability = randf_range(0.30, 0.45)
	
	decide_direction()
	
	var ai_timer = Timer.new()
	ai_timer.wait_time = randf_range(0.8, 1.2) 
	ai_timer.autostart = true
	ai_timer.timeout.connect(decide_direction)
	add_child(ai_timer)

func _physics_process(_delta):
	
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play()
		
	var actual_speed = speed
	
	if comportamiento == 1 and is_charging:
		actual_speed = speed * 4
		
	velocity = movement_direction * actual_speed
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collided_object = collision.get_collider()
		
		if collided_object and collided_object.is_in_group("player"):
			if collided_object.has_method("take_damage"):
				collided_object.take_damage(collision_damage)
				if effect_name != "" and collided_object.has_method("apply_effect"):
					collided_object.apply_effect(effect_name, 0, effect_duration)
				
				trigger_recoil(collided_object.global_position)
				decide_direction() 
	
	if is_on_wall():
		decide_direction()
		
# ---  DECIDIR DIRECCION ---
func decide_direction():
	if is_recoiling or is_preparing_charge : return
	
	if comportamiento == 0:
		movement_direction = calculate_heuristic_direction()
	elif comportamiento == 1:
		hunt_player()
	elif comportamiento == 2:
		expand_towards_player()
	else:
		choose_random_direction()
		

# --- EL REBOTE (KNOCKBACK) ---
func trigger_recoil(target_pos: Vector2):
	if is_recoiling: return # Evita que se active mil veces por segundo
	
	is_recoiling = true
	is_charging = false # Apaga el turbo de embestida si lo tenía activo
	
	is_preparing_charge = false 
	modulate = Color.WHITE
	
	
	# Calcula la dirección para huir (Vector inverso desde donde golpeó)
	var repel_dir = (global_position - target_pos).normalized()
	
	# Lo forzamos a rebotar respetando tu cuadrícula (Cruz, Diagonales o Libre)
	movement_direction = snap_direction(repel_dir)
	
	# El enemigo queda aturdido y caminando hacia atrás por 2 segundos
	await get_tree().create_timer(2).timeout
	
	# Se le pasa el aturdimiento y vuelve a pensar qué hacer
	is_recoiling = false
	decide_direction()
	
# ENEMIGOS NORMALES: Movimiento aleatorio, pero respetando las restricciones de dirección
func choose_random_direction():
	if tipo_movimiento == 0: # 4 Direcciones
		var dirs = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
		movement_direction = dirs.pick_random()
	else: # Libre
		var angle = randf_range(0, TAU)
		movement_direction = Vector2.RIGHT.rotated(angle)


# ENEMIGOS DE RASTRO: IA Heurística Matemática
func calculate_heuristic_direction() -> Vector2:
	if not is_instance_valid(player):
		return Vector2.RIGHT.rotated(randf_range(0, TAU)) 
		
	var best_dir = Vector2.ZERO
	var lowest_cost = INF 
	var directions = []
	
	# Llenamos las opciones según el menú del Inspector
	if tipo_movimiento == 0:
		directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	else:
		# Si es libre, el cerebro evalúa 16 ángulos distintos para ser más preciso
		for i in range(16):
			directions.append(Vector2.RIGHT.rotated((TAU / 16.0) * i))
	
	var space_state = get_world_2d().direct_space_state
	
	for dir in directions:
		var cost = 0.0
		
		# 1. Distancia ideal
		var future_pos = global_position + (dir * speed * prediction_time ) 
		var dist_to_player = future_pos.distance_to(player.global_position)
		cost += abs(dist_to_player - target_distance)
		
		# 2. Inercia
		if movement_direction != Vector2.ZERO:
			# Si el ángulo entre donde iba y donde quiere ir es muy grande, lo castiga
			var angle_diff = abs(dir.angle_to(movement_direction))
			if angle_diff > PI * 0.8: # Es un giro de 180° (U-turn)
				cost += u_turn_penalty 
			elif angle_diff > 0.1: # Es un giro parcial
				cost += turn_penalty   
		
		# 3. Castigo por paredes
		if space_state:
			var query = PhysicsRayQueryParameters2D.create(global_position, global_position + dir * 60.0)
			query.collision_mask = 33 
			query.exclude = [self.get_rid()]
			
			if space_state.intersect_ray(query):
				cost += wall_penalty 
				
		# 4. Aleatoriedad
		cost += randf_range(0, randomness_factor)
		
		if cost < lowest_cost:
			lowest_cost = cost
			best_dir = dir
			
	return best_dir


# ENEMIGOS DE CAZA: Reglas para acercarse y embestir
func hunt_player():
	if not is_instance_valid(player):
		var angle = randf_range(0, TAU)
		movement_direction = snap_direction(Vector2.RIGHT.rotated(angle))
		return

	var to_player = (player.global_position - global_position).normalized()
	
	# Tiramos el dado virtual para ver si embiste
	if randf() < charge_probability:
		prepare_charge()
	else:
		is_charging = false
		modulate = Color.WHITE # Vuelve a su color normal
		# Acecho: Se acerca, pero con una desviación aleatoria (ruido de hasta 60 grados)
		var noise = randf_range(-PI / 3.0, PI / 3.0) 
		var erratic_direction = to_player.rotated(noise)
		movement_direction = snap_direction(erratic_direction)

func prepare_charge():
	is_preparing_charge = true
	movement_direction = Vector2.ZERO # Se detiene
	modulate = Color.PURPLE           # Brilla de color morado
	
	await get_tree().create_timer(0.2).timeout
	
	# REGLA DE SEGURIDAD: Si el enemigo murió mientras esperaba, abortamos
	if not is_inside_tree() or not is_instance_valid(player): return
	if not is_preparing_charge: return
	
	# Recalcula la posición exacta hacia ti en este momento, y ¡BAM!
	var new_to_player = (player.global_position - global_position).normalized()
	movement_direction = snap_direction(new_to_player)
	
	is_preparing_charge = false
	is_charging = true # ¡Se activa el turbo en _physics_process!



# ENEMIGOS EXPANSIVOS: Lentos, implacables, sin distracciones
func expand_towards_player():
	if not is_instance_valid(player):
		movement_direction = Vector2.ZERO # Se queda quieto si no estás
		return

	# Calcula el vector directo hacia ti
	var to_player = (player.global_position - global_position).normalized()
	
	# Pasa por el filtro de la cuadrícula para respetar si es Cruz o Libre
	movement_direction = snap_direction(to_player)
		
# --- PUNTAJES DAÑO Y MUERTE ---
func take_damage(amount: int):
	health -= amount
	
	modulate = damage_color
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if health <= 0:
		give_points_and_die()

func give_points_and_die():
	if is_instance_valid(player) and player.has_method("increase_consciousness"):
		player.increase_consciousness(points)
		
	die()

func die():
	if death_sound:
		death_sound.reparent(get_tree().root)
		death_sound.play()
	queue_free()
	
# --- AUXILIARES ---
	
func find_player():
	var nodes = get_tree().get_nodes_in_group("player")
	for n in nodes:
		if n is Node2D:
			player = n
			break	

func snap_direction(dir: Vector2) -> Vector2:
	if dir == Vector2.ZERO: 
		return Vector2.ZERO
		
	if tipo_movimiento == 0: # 4 Direcciones
		if abs(dir.x) > abs(dir.y):
			return Vector2(sign(dir.x), 0)
		else:
			return Vector2(0, sign(dir.y))
		
	else: # Libre
		return dir
