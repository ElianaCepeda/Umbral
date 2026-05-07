extends CharacterBody2D

var skill_icons = {
	"water_attack": preload("res://assets/characterAttacks/waterAttack_single.png"),
	"gum_attack": preload("res://assets/characterAttacks/gumAttack_single.png"),
	"sleep_attack": preload("res://assets/characterAttacks/Dormir.png"),
	"temperature_attack": preload("res://assets/characterAttacks/Temperatura.png"),
	"food_alcohol": preload("res://assets/defenses/Comida-Alcohol.png"),
	"medicine_alcohol": preload("res://assets/defenses/Medicina-Alcohol.png"), 
	"exercise_tabaco": preload("res://assets/defenses/Ejercicio-Tabaco.png"), 
	"patch_tabaco": preload("res://assets/defenses/Parche-Tabaco.png"), 
	"dosis_measure_marihuana": preload("res://assets/defenses/Dosis-Marihuana.png"),
	"nodrink_marihuana": preload("res://assets/defenses/SinAlcohol-Marihuana.png"), 
	"nasalcare_cocaina": preload("res://assets/defenses/Nasal-Cocaina.png"), 
	"noexcercise_cocaina": preload("res://assets/defenses/SinEjercicio-Cocaina.png"), 
}
var skill1_name: String = ""
var skill2_name: String = ""
var skill3_name: String = ""

var can_dash: bool = true
@export var dash_cooldown: float = 1.8

@onready var skill1_icon = $HUD/Container/TextureRect
@onready var skill2_icon = $HUD/Container/TextureRect2
@onready var skill3_icon = $HUD/Container/TextureRect3
@onready var hurt_sound = $HurtSound
@onready var death_sound = $DeathSound
@export var default_icon: Texture2D

var last_direction: Vector2 = Vector2.DOWN

var damage_reduction := 0.0      # 0.15 = 15% menos daño
var effect_resistance := 0.0     # 0.15 = 15% menos duración
var damage_boost := 1.0          # 1.2 = +20% daño

var is_dead: bool = false
var is_paralyzed: bool = false
var controls_inverted: bool = false
var has_input_delay: bool = false
var input_buffer: Array[Vector2] = []
var delay_frames: int = 40 
var base_vision_scale: float = 3
var base_max_consciousness: int = 100 # El límite máximo original
var max_consciousness: int = 100      # El límite actual, que Cirrosis va a encoger
var is_invulnerable: bool = false
var damage_multiplier: int = 1 # Multiplicador de daño (1 = normal)

# Variables de Ansiedad / Abstinencia
var normal_acceleration: float = 1500.0
var normal_friction: float = 1500.0
var anxiety_acceleration: float = 80.0 # Cuesta arrancar
var anxiety_friction: float = 20.0     # Cuesta frenar
var is_anxious: bool = false
var is_attacking: bool = false
var can_shoot: bool = true
var fatigue_time_left: float = 0.0

var skill1_used := false
var skill2_used := false

@onready var key1_sprite = $HUD/Container/key1
@onready var key2_sprite = $HUD/Container/key2
@onready var mouse_sprite = $HUD/Container/mouse
@onready var shield = $Shield

@onready var vision_light = $PointLight2D
@export var speed: int = 100
@export var consciousness: int = base_max_consciousness

@onready var shoot_timer = $ShootTimer
@onready var shoot_position = $bullet_pos
@onready var consciousness_bar = $HUD/Container/PanelContainer/ConsciousnessBar
@onready var back_consciousness_bar = $HUD/Container/PanelContainer/ColorRect
@onready var hud = $HUD
@onready var animated_sprite = $AnimatedSprite2D
@onready var dash_timer = $DashTimer
@onready var blur_rect = $HUD/EfectoBorroso
@onready var original_bar_width: float = consciousness_bar.size.x

var is_dashing: bool = false
var is_hurt: bool = false

@export var dash_speed: int = 400
@export var dash_duration: float = 0.0001

var bullet_scene = preload("res://scenes/attacks/bullet.tscn")

func apply_level_skills(level):
	skill1_name = level.skill1 if SaveManager.has_defense1() else ""
	skill2_name = level.skill2 if SaveManager.has_defense2() else ""
	skill3_name = level.skill3

	set_skill(1, skill1_name)
	set_skill(2, skill2_name)
	set_skill(3, skill3_name)
	update_skill_keys()
	

func set_skill(slot: int, skill_name: String):
	var target_icon = get("skill%d_icon" % slot)
	
	if target_icon == null:
		return
	
	if skill_icons.has(skill_name):
		target_icon.texture = skill_icons[skill_name]
	else:
		target_icon.texture = default_icon

		
func _ready():
	# --- INTEGRACIÓN CON SAVEMANAGER ---
	consciousness = SaveManager.get_consciousness()
	max_consciousness = SaveManager.get_max_consciousness()
	
	consciousness_bar.max_value = max_consciousness
	consciousness_bar.value = consciousness
	# -----------------------------------
	
	animated_sprite.animation_finished.connect(_on_animation_finished)
	hud.hide()
	base_vision_scale = vision_light.texture_scale
	shield.visible = false
	key1_sprite.play("not_pressed")
	key2_sprite.play("not_pressed")
	mouse_sprite.play()
	add_to_group("player")
	update_bar()

func show_ui():
	hud.show()
	

func update_skill_keys():
	if skill1_name == "" or skill1_name == null:
		key1_sprite.play("pressed")
	else:
		key1_sprite.play("not_pressed")

	if skill2_name == "" or skill2_name == null:
		key2_sprite.play("pressed")
	else:
		key2_sprite.play("not_pressed")


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

func activate_shield():
	shield.visible = true
	
	# opcional: duración
	await get_tree().create_timer(2.0).timeout
	
	if is_instance_valid(self):
		shield.visible = false

func handle_skills():
	# SKILL 1 → REDUCE DAÑO
	if Input.is_action_just_pressed("skill_1"):
		if skill1_name == "" or skill1_name == null:
			key1_sprite.play("pressed")
			return
	
		if not skill1_used:
			skill1_used = true
			damage_reduction = 0.15
			
			skill1_icon.modulate = Color(0, 0, 0, 0.6)
			key1_sprite.play("pressed")
			activate_shield()
			
			# ⏱ SOLO quitamos el efecto, NO reseteamos la skill
			get_tree().create_timer(5.0).timeout.connect(func():
				if is_instance_valid(self):
					damage_reduction = 0.0
			)

	# SKILL 2 → REDUCE EFECTOS
	if Input.is_action_just_pressed("skill_2"):
		if skill2_name == "" or skill2_name == null:
			key2_sprite.play("pressed")
			return
	
		if not skill2_used:
			skill2_used = true
			effect_resistance = 0.15
			
			skill2_icon.modulate = Color(0, 0, 0, 0.6)
			key2_sprite.play("pressed")
			activate_shield()
			
			# ⏱ SOLO quitamos el efecto
			get_tree().create_timer(5.0).timeout.connect(func():
				if is_instance_valid(self):
					effect_resistance = 0.0
			)


func take_damage(amount: int, damage_color: Color = Color.RED):
	if is_dead or is_invulnerable or not is_inside_tree():
		return
	if hurt_sound:
		hurt_sound.play()
	is_invulnerable = true 
	is_hurt = true
	is_attacking = false
	
	var reduced_amount = amount * (1.0 - damage_reduction)
	var final_damage = reduced_amount * damage_multiplier
	consciousness -= final_damage
	print("daniorecibido: ", final_damage)
	update_bar()

	var anim_dir = "down"
	if abs(last_direction.x) > abs(last_direction.y):
		anim_dir = "right" if last_direction.x > 0 else "left"
	else:
		anim_dir = "down" if last_direction.y > 0 else "up"

	animated_sprite.stop()
	animated_sprite.play("hurt_" + anim_dir)
	get_tree().create_timer(0.2).timeout.connect(func():
		if is_instance_valid(self):
			is_hurt = false
	)

	# Color de daño
	var damage_tween = create_tween()
	modulate = damage_color 
	damage_tween.tween_property(self, "modulate", get_target_color(), 0.3)

	# Invulnerabilidad temporal
	get_tree().create_timer(0.15).timeout.connect(func():
		if is_instance_valid(self):
			is_invulnerable = false
	)

	if consciousness <= 0:
		Engine.time_scale = 0.2
		if death_sound:
			death_sound.play()
		await get_tree().create_timer(0.4).timeout
		die()


func increase_consciousness(amount: int):
	consciousness += amount
	# Ya no lo limitamos a 100, sino al maximo actual(max_consciousness)
	if consciousness > max_consciousness:
		consciousness = max_consciousness
	update_bar()

func update_shoot_position(dir: String):
	match dir:
		"right": shoot_position.position = Vector2(20, 0)
		"left": shoot_position.position = Vector2(-20, 0)
		"up": shoot_position.position = Vector2(0, -20)
		"down": shoot_position.position = Vector2(0, 20)
		
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
		
		if is_attacking:
			return final_input
		
		if is_hurt:
			return final_input
		
		var anim_direction = "down" # Por defecto
	
		if final_input != Vector2.ZERO:
			last_direction = final_input # Guardamos la última dirección
			
			# Determinamos si el movimiento es más horizontal o vertical
			if abs(final_input.x) > abs(final_input.y):
				anim_direction = "right" if final_input.x > 0 else "left"
			else:
				anim_direction = "down" if final_input.y > 0 else "up"
			
			animated_sprite.play("run_" + anim_direction)
		else:
			# Si está quieto, usamos la última dirección para el Idle
			if abs(last_direction.x) > abs(last_direction.y):
				anim_direction = "right" if last_direction.x > 0 else "left"
			else:
				anim_direction = "down" if last_direction.y > 0 else "up"
			
			animated_sprite.play("idle_" + anim_direction)

		# Actualizar posición del spawn de balas según dirección (opcional)
		update_shoot_position(anim_direction)

	return final_input
	

func dash():
	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing and velocity.length() > 0:
		can_dash = false
		is_dashing = true
		
		var anim_dir = "down"
		if abs(velocity.x) > abs(velocity.y):
			anim_dir = "right" if velocity.x > 0 else "left"
		else:
			anim_dir = "down" if velocity.y > 0 else "up"
		
		animated_sprite.play("dash_" + anim_dir)
		
		velocity = velocity.normalized() * dash_speed
		
		dash_timer.start()
		await dash_timer.timeout
		
		is_dashing = false
		
		get_tree().create_timer(dash_cooldown).timeout.connect(func():
			if is_instance_valid(self):
				can_dash = true
		)


func _on_animation_finished():
	if animated_sprite.animation.begins_with("attack"):
		is_attacking = false
	if animated_sprite.animation.begins_with("hurt"):
		is_hurt = false
	
func shoot():
	if not can_shoot:
		return
	
	if Input.is_action_just_pressed("click_disparo") and shoot_timer.is_stopped():
		is_attacking = true
		
		var target_pos = get_global_mouse_position()
		var direction = (target_pos - global_position).normalized()
		
		var anim_dir = "down"
		if abs(direction.x) > abs(direction.y):
			anim_dir = "right" if direction.x > 0 else "left"
		else:
			anim_dir = "down" if direction.y > 0 else "up"
		
		animated_sprite.stop()
		animated_sprite.play("attack_" + anim_dir)
		animated_sprite.frame = 0
		
		var new_bullet = bullet_scene.instantiate()
		var spawn_offset = direction * 25 
		new_bullet.global_position = global_position + spawn_offset
		new_bullet.direction = direction
		new_bullet.rotation = direction.angle()
		new_bullet.set_bullet_type(skill3_name)
		
		# --- INTEGRACIÓN CON SAVEMANAGER ---
		# Sumamos los puntos de ataque guardados al daño base de la bala
		new_bullet.damage = int(new_bullet.damage * damage_boost) + SaveManager.get_attack()
		# -----------------------------------
		
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
	handle_skills()
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
	var final_duration = duration * (1.0 - effect_resistance)
	match effect_name:
		"invert_controls":
			controls_inverted = true
			# Cambiamos el color a un morado claro/medio
			# Puedes usar Color.MEDIUM_PURPLE o un código Hex como Color("9c59ff")
			modulate = Color(0.6, 0.4, 1.0) 
			
			var timer = get_tree().create_timer(final_duration)
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
			get_tree().create_timer(final_duration).timeout.connect(func():
				if is_instance_valid(self):
					# 3. Volvemos SIEMPRE al valor original real
					vision_light.texture_scale = base_vision_scale
					modulate = Color.WHITE
			)
		
		"random_speed_boost":
			var random_increase = randi_range(100, 250)
			var max_speed = 800 
			
			var speed_before = speed
			speed += random_increase
			
			if speed > max_speed:
				speed = max_speed
				
			var actual_increase = speed - speed_before
			
			if actual_increase > 0:
				modulate = Color.YELLOW 
				
				var timer = get_tree().create_timer(final_duration)
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
				get_tree().create_timer(final_duration).timeout.connect(func():
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
			
			var timer = get_tree().create_timer(final_duration)
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
			
			var timer = get_tree().create_timer(final_duration)
			timer.timeout.connect(func():
				if is_instance_valid(self):
					# Cuando acaba el efecto, aclaramos la vista suavemente
					var tween_out = create_tween()
					tween_out.tween_property(blur_rect.material, "shader_parameter/blur_amount", 0.0, 1.0)
					
					# Ocultamos el cuadro cuando termine de aclararse por completo
					tween_out.finished.connect(func(): blur_rect.visible = false)
			)
			
		"reduce_max_health":
			var reduction_amount = 3 
			
			# Reducimos el límite máximo, pero evitamos que baje de 40
			max_consciousness = max(40, max_consciousness - reduction_amount)
			
			# Si tu vida actual quedó por encima del nuevo límite, te la cortamos
			if consciousness > max_consciousness:
				consciousness = max_consciousness
				
			# Parpadeo verde para indicar daño por podredumbre
			var blink_tween = create_tween()
			blink_tween.tween_property(self, "modulate", Color.DARK_GREEN, 0.2)
			blink_tween.tween_property(self, "modulate", Color.WHITE, 0.2)
			update_bar()
			is_invulnerable = false
			take_damage(reduction_amount*2)
			
			
		"hipertension":
			if damage_multiplier > 1: return 
			
			damage_multiplier = 2
			modulate = Color.ORANGE_RED
			
			# Acelera todo el motor del juego
			Engine.time_scale = 1.5 
			
			# Como el tiempo del juego va más rápido, un timer normal de 4s duraría menos.
			# Le agregamos ", false, false, true" para que ignore el time_scale y cuente 4 segundos reales.
			var timer = get_tree().create_timer(final_duration, false, false, true)
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
			
			var timer = get_tree().create_timer(final_duration)
			timer.timeout.connect(func():
				if is_instance_valid(self):
					is_anxious = false
					modulate = Color.WHITE
			)
			
		"fatigue":
			# Siempre recargamos el cronómetro al máximo (1 segundo extra)
			fatigue_time_left = final_duration
			
			# Solo aplicamos los cambios si el jugador estaba sano
			if can_shoot: 
				can_shoot = false
				speed = 50
				modulate = get_target_color()
