extends CharacterBody2D

var is_dead: bool = false
var controls_inverted: bool = false
var original_scale = 3
@onready var vision_light = $PointLight2D
@export var speed: int = 100
@export var consciousness: int = 50

@onready var shoot_timer = $ShootTimer
@onready var shoot_position = $bullet_pos
@onready var consciousness_bar = $HUD/ConsciousnessBar
@onready var animated_sprite = $AnimatedSprite2D
@onready var dash_timer = $DashTimer 

var is_dashing: bool = false
@export var dash_speed: int = 400
@export var dash_duration: float = 0.0001

var bullet_scene = preload("res://scenes/attacks/bullet.tscn")

func _ready():
	consciousness_bar.value = consciousness
	consciousness_bar.hide()

func show_ui():
	consciousness_bar.show()
	
func take_damage(amount: int):
	if is_dead or not is_inside_tree():
		return
		
	consciousness -= amount
	update_bar()

	var previous_color = modulate
	
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = previous_color
	
	if consciousness <= 0:
		die()

func increase_consciousness(amount: int):
	consciousness += amount
	if consciousness > 100:
		consciousness = 100
	update_bar()

func update_bar():
	consciousness_bar.value = consciousness
	
func die():
	if is_dead:
		return
	is_dead = true
	GameManager.game_over()

func get_input():
	if is_dashing:
		return

	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if controls_inverted:
		input_direction = -input_direction
	velocity = input_direction * speed
	
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x < global_position.x:
		animated_sprite.flip_h = true
		shoot_position.position.x = -abs(shoot_position.position.x)
	else:
		animated_sprite.flip_h = false
		shoot_position.position.x = abs(shoot_position.position.x)

	if velocity.length() > 0:
		animated_sprite.play()
	else:
		animated_sprite.stop()

func dash():
	if Input.is_action_just_pressed("dash") and not is_dashing and velocity.length() > 0:
		is_dashing = true
		velocity = velocity.normalized() * dash_speed
		
		dash_timer.start()
		await dash_timer.timeout
		
		is_dashing = false

func shoot():
	if Input.is_action_just_pressed("click_disparo") and shoot_timer.is_stopped():
		var target_pos = get_global_mouse_position()
		var direction = (target_pos - global_position).normalized()
		
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_position = shoot_position.global_position
		new_bullet.direction = direction
		new_bullet.rotation = direction.angle()
		
		get_parent().add_child(new_bullet)
		shoot_timer.start()
		
func _physics_process(_delta):
	dash()
	
	if not is_dashing and dash_timer.time_left == 0 and velocity.length() > 0:
		velocity = Vector2.ZERO
		
	get_input() 
	move_and_slide()
	shoot()

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
			# 1. Guardamos el tamaño original para volver luego
			var original_scale = vision_light.texture_scale
			
			# 2. Reducimos el radio (el círculo se hace pequeño)
			vision_light.texture_scale = 0.2
			 
			modulate = Color.DARK_GRAY # Feedback en el personaje
			
			# 3. Timer para restaurar
			get_tree().create_timer(duration).timeout.connect(func():
				if is_instance_valid(self):
					# Volvemos al tamaño original
					vision_light.texture_scale = original_scale
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
			
