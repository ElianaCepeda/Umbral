extends CharacterBody2D

var is_dead: bool = false
var is_paralyzed: bool = false
var controls_inverted: bool = false
var has_input_delay: bool = false
var input_buffer: Array[Vector2] = []
var delay_frames: int = 25 
var base_vision_scale: float = 3
var base_max_consciousness: int = 100 # El límite máximo original
var max_consciousness: int = 100      # El límite actual, que Cirrosis va a encoger
var is_invulnerable: bool = false
var damage_multiplier: int = 1 # Multiplicador de daño (1 = normal)

# Variables de Ansiedad / Abstinencia
var normal_acceleration: float = 1500.0
var normal_friction: float = 1500.0
var anxiety_acceleration: float = 80.0 # Cuesta arrancar
var anxiety_friction: float = 20.0     # Cuesta MUCHÍSIMO frenar
var is_anxious: bool = false

var can_shoot: bool = true
var fatigue_time_left: float = 0.0

@onready var vision_light = $PointLight2D
@export var speed: int = 100
@export var consciousness: int = base_max_consciousness

@onready var shoot_timer = $ShootTimer
@onready var shoot_position = $bullet_pos
@onready var consciousness_bar = $HUD/PanelContainer/ConsciousnessBar
@onready var back_consciousness_bar = $HUD/PanelContainer/ColorRect
@onready var animated_sprite = $AnimatedSprite2D
@onready var dash_timer = $DashTimer
@onready var blur_rect = $HUD/EfectoBorroso
@onready var original_bar_width: float = consciousness_bar.size.x

var is_dashing: bool = false
@export var dash_speed: int = 400
@export var dash_duration: float = 0.0001

var bullet_scene = preload("res://scenes/attacks/bullet.tscn")

func _ready():
	consciousness_bar.value = consciousness
	consciousness_bar.hide()
	back_consciousness_bar.hide()
	base_vision_scale = vision_light.texture_scale

func show_ui():
	consciousness_bar.show()
	back_consciousness_bar.show()
	
func get_target_color() -> Color:
	if is_paralyzed:
		return Color.YELLOW # La parálisis parpadea, pero esto sirve de base
	if controls_inverted:
		return Color(0.6, 0.4, 1.0) # Morado
	if vision_light.texture_scale < base_vision_scale:
		return Color.DARK_GRAY # Visión reducida
	if not can_shoot:     # Si no puede disparar, está fatigado
		return Color.DIM_GRAY 
	if is_anxious:        # El color de la ansiedad que pusimos antes
		return Color.PALE_TURQUOISE
	if vision_light.texture_scale < base_vision_scale:
		return Color.DARK_GRAY 
		
	return Color.WHITE # Normal

func take_damage(amount: int, damage_color: Color = Color.RED):
	if is_dead or is_invulnerable or not is_inside_tree():
		return
	is_invulnerable = true 
	var final_damage = amount * damage_multiplier
	consciousness -= final_damage
	update_bar()

	var damage_tween = create_tween()
	# ¡Usamos el color que nos pasaron en lugar de Color.RED fijo!
	modulate = damage_color 
	damage_tween.tween_property(self, "modulate", get_target_color(), 0.3)
	get_tree().create_timer(0.5).timeout.connect(func():
		if is_instance_valid(self):
			is_invulnerable = false
	)
	if consciousness <= 0:
		die()

func increase_consciousness(amount: int):
	consciousness += amount
	# Ya no lo limitamos a 100, sino al maximo actual(max_consciousness)
	if consciousness > max_consciousness:
		consciousness = max_consciousness
	update_bar()

func update_bar():
	# 1. Calculamos el nuevo ancho físico de la barra roja/verde
	# Si max_consciousness es 100, usa el 100%. Si es 60, usa el 60% del ancho.
	var new_width = (float(max_consciousness) / base_max_consciousness) * original_bar_width
	
	# Aplicamos el ancho para que se vea el FondoGris que está detrás.
	consciousness_bar.custom_minimum_size.x = new_width
	consciousness_bar.size.x = new_width
	
	# Ahora el 100% de esta barra más corta es el nuevo máximo
	consciousness_bar.max_value = max_consciousness
	
	# 3. Ponemos el valor actual
	consciousness_bar.value = consciousness
	
func die():
	if is_dead:
		return
	is_dead = true
	Engine.time_scale = 1.0 
	GameManager.game_over()

func get_input() -> Vector2:
	if is_paralyzed:
		return Vector2.ZERO

	var raw_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if controls_inverted:
		raw_input = -raw_input
		
	var final_input = raw_input
	
	if has_input_delay:
		input_buffer.push_back(raw_input)
		if input_buffer.size() > delay_frames:
			final_input = input_buffer.pop_front()
		else:
			final_input = Vector2.ZERO
	else:
		input_buffer.clear()
		
	# Manejo de animaciones y giro de la pistola
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x < global_position.x:
		animated_sprite.flip_h = true
		shoot_position.position.x = -abs(shoot_position.position.x)
	else:
		animated_sprite.flip_h = false
		shoot_position.position.x = abs(shoot_position.position.x)

	if final_input.length() > 0:
		animated_sprite.play()
	else:
		animated_sprite.stop()
		
	# Devolvemos la dirección final calculada
	return final_input

func dash():
	if Input.is_action_just_pressed("dash") and not is_dashing and velocity.length() > 0:
		is_dashing = true
		velocity = velocity.normalized() * dash_speed
		
		dash_timer.start()
		await dash_timer.timeout
		
		is_dashing = false

func shoot():
	if not can_shoot: return
	
	if Input.is_action_just_pressed("click_disparo") and shoot_timer.is_stopped():
		var target_pos = get_global_mouse_position()
		var direction = (target_pos - global_position).normalized()
		
		var new_bullet = bullet_scene.instantiate()
		
		# AJUSTE PARA PAREDES: 
		var spawn_offset = direction * 20 # Ajusta este número (distancia desde tu centro)
		new_bullet.global_position = global_position + spawn_offset
		
		new_bullet.direction = direction
		new_bullet.rotation = direction.angle()
		
		get_parent().add_child(new_bullet)
		shoot_timer.start()
		
func _physics_process(delta):
	if fatigue_time_left > 0:
		fatigue_time_left -= delta
		if fatigue_time_left <= 0:
			can_shoot = true
			speed = 100
			modulate = get_target_color()
	
	shoot()
	dash()
	
	if is_dashing:
		move_and_slide()
		return
		
	var target_dir = get_input()
	
	var current_accel = normal_acceleration
	var current_friction = normal_friction
	
	if is_anxious:
		current_accel = anxiety_acceleration
		current_friction = anxiety_friction
		
		# --- EFECTO DE ESCALOFRÍOS/NERVIOSISMO ---
		# Sacudimos ligeramente el dibujo usando su offset
		var shake = 3.0
		animated_sprite.offset = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
	else:
		# Cuando se pasa la ansiedad, el dibujo vuelve a su centro normal
		animated_sprite.offset = Vector2.ZERO
	
	if target_dir != Vector2.ZERO:
		var target_velocity = target_dir * speed
		velocity = velocity.move_toward(target_velocity, current_accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, current_friction * delta)
	
	move_and_slide()
	
	
func restore_max_health():
	max_consciousness = base_max_consciousness
	update_bar()

func apply_effect(effect_name: String, _value: float, duration: float = 0.0):
	match effect_name:
		"invert_controls":
			controls_inverted = true
			# Cambiamos el color a un morado claro/medio
			# Puedes usar Color.MEDIUM_PURPLE o un código Hex como Color("9c59ff")
			modulate = Color(0.6, 0.4, 1.0) 
			
			var timer = get_tree().create_timer(duration)
			timer.timeout.connect(func():
				# Al terminar el tiempo, volvemos al color normal (blanco)
				controls_inverted = false
				modulate = Color.WHITE
			)
		"reduce_vision":
			# 1. No guardamos nada localmente, usamos la variable global del script
			vision_light.texture_scale = 0.2
			modulate = Color.DARK_GRAY 
			
			# 2. Creamos el timer para restaurar
			get_tree().create_timer(duration).timeout.connect(func():
				if is_instance_valid(self):
					# 3. Volvemos SIEMPRE al valor original real
					vision_light.texture_scale = base_vision_scale
					modulate = Color.WHITE
			)
		
		"random_speed_boost":
			var random_increase = randi_range(80, 200)
			var max_speed = 350 
			
			var speed_before = speed
			speed += random_increase
			
			if speed > max_speed:
				speed = max_speed
				
			var actual_increase = speed - speed_before
			
			if actual_increase > 0:
				modulate = Color.YELLOW 
				
				var timer = get_tree().create_timer(duration)
				timer.timeout.connect(func():
					if is_instance_valid(self):
						# Subtract exactly what we added
						speed -= actual_increase 
						
						# Only return to the default color if we are back to base speed (100)
						if speed <= 100:
							modulate = Color.WHITE
				)
			
		"paralyze":
				if is_paralyzed: return
				
				is_paralyzed = true
				
				# Creamos un efecto de parpadeo amarillo
				var blink_tween = create_tween().set_loops()
				blink_tween.tween_property(self, "modulate", Color.YELLOW, 0.1)
				blink_tween.tween_property(self, "modulate", Color.WHITE, 0.1)
				
				# Timer para la duración de la parálisis
				get_tree().create_timer(duration).timeout.connect(func():
					if is_instance_valid(self):
						is_paralyzed = false
						blink_tween.kill() # Detenemos el parpadeo
						modulate = Color.WHITE # Restauramos el color original
				)
				
		"input_delay":
			if has_input_delay: 
				return
			
			has_input_delay = true
			input_buffer.clear()
			
			modulate = Color.SLATE_GRAY # Color gris para indicar pesadez
			
			# Reducimos tu velocidad a la mitad para que no te salgas de control
			var speed_before_delay = speed
			speed = int(speed / 2) 
			
			var timer = get_tree().create_timer(duration)
			timer.timeout.connect(func():
				if is_instance_valid(self):
					has_input_delay = false
					input_buffer.clear()
					speed = speed_before_delay # Restauramos tu velocidad normal
					modulate = Color.WHITE
			)
			
		"blur_vision":
			if blur_rect == null: return
			
			blur_rect.visible = true
			
			# Usamos un Tween para que la vista se nuble suavemente, no de golpe
			var tween_in = create_tween()
			tween_in.tween_property(blur_rect.material, "shader_parameter/blur_amount", 1.0, 0.5)
			
			var timer = get_tree().create_timer(duration)
			timer.timeout.connect(func():
				if is_instance_valid(self):
					# Cuando acaba el efecto, aclaramos la vista suavemente
					var tween_out = create_tween()
					tween_out.tween_property(blur_rect.material, "shader_parameter/blur_amount", 0.0, 1.0)
					
					# Ocultamos el cuadro cuando termine de aclararse por completo
					tween_out.finished.connect(func(): blur_rect.visible = false)
			)
			
		"reduce_max_health":
			var reduction_amount = 5 
			
			# Reducimos el límite máximo, pero evitamos que baje de 20
			max_consciousness = max(30, max_consciousness - reduction_amount)
			
			# Si tu vida actual quedó por encima del nuevo límite, te la cortamos
			if consciousness > max_consciousness:
				consciousness = max_consciousness
				
			# Parpadeo verde para indicar daño por podredumbre
			var blink_tween = create_tween()
			blink_tween.tween_property(self, "modulate", Color.DARK_GREEN, 0.2)
			blink_tween.tween_property(self, "modulate", Color.WHITE, 0.2)
			
			update_bar()
			take_damage(reduction_amount)
			
		"hipertension":
			if damage_multiplier > 1: return 
			
			damage_multiplier = 2
			modulate = Color.ORANGE_RED
			
			# Acelera todo el motor del juego
			Engine.time_scale = 1.5 
			
			# Como el tiempo del juego va más rápido, un timer normal de 4s duraría menos.
			# Le agregamos ", false, false, true" para que ignore el time_scale y cuente 4 segundos reales.
			var timer = get_tree().create_timer(duration, false, false, true)
			timer.timeout.connect(func():
				if is_instance_valid(self):
					damage_multiplier = 1
					modulate = Color.WHITE
					Engine.time_scale = 1.0 # Devolvemos el juego a la normalidad
			)
			
		"anxiety":
			if is_anxious: return # Si ya está ansioso, no reiniciamos el timer de golpe
			
			is_anxious = true
			
			# Opcional: Un tono pálido o azulado para representar sudor frío / tensión
			modulate = Color.PALE_TURQUOISE 
			
			var timer = get_tree().create_timer(duration)
			timer.timeout.connect(func():
				if is_instance_valid(self):
					is_anxious = false
					modulate = Color.WHITE
			)
			
		"fatigue":
			# Siempre recargamos el cronómetro al máximo (1 segundo extra)
			fatigue_time_left = duration
			
			# Solo aplicamos los cambios si el jugador estaba sano
			if can_shoot: 
				can_shoot = false
				speed = 50
				modulate = get_target_color()
