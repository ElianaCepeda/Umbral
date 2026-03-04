extends CharacterBody2D

var esta_muerto: bool = false
@export var speed: int = 100
@export var consciousness: int = 50
@onready var shoot_timer = $ShootTimer
@onready var shoot_position = $bullet_pos
@onready var consciousness_bar = $HUD/ConsciousnessBar
@onready var animated_sprite = $AnimatedSprite2D

@onready var dash_timer = $DashTimer # Un Timer nuevo en tu escena
var is_dashing = false
@export var dash_speed: int = 400
@export var dash_duration: float = 0.0001

var bullet= preload("res://scenes/attacks/bullet.tscn")

func _ready():
	consciousness_bar.value = consciousness
	consciousness_bar.hide()
func mostrar_interfaz():
	consciousness_bar.show()
	
func recibir_danio(cantidad):
	if esta_muerto or not is_inside_tree():
		return
	consciousness -= cantidad
	update_bar()
	
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if consciousness <= 0:
		morir()

func increase_consciousness(amount):
	consciousness += amount
	if consciousness > 100:
		consciousness = 100
	update_bar()

func update_bar():
	consciousness_bar.value = consciousness
	
func morir():
	if esta_muerto:
		return
	esta_muerto = true

	GameManager.game_over()

func get_input():
	# Si estamos haciendo dash, ignoramos el input normal
	if is_dashing:
		return

	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	
	# Rotación hacia el mouse
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
		
		# Aplicar velocidad de dash
		velocity = velocity.normalized() * dash_speed
		
		dash_timer.start()
		await dash_timer.timeout
		
		is_dashing = false


func shoot():
	
	# 1. Detectar si se presionó el clic izquierdo (asegúrate de tener definida esta acción en Project Settings)
	if Input.is_action_just_pressed("click_disparo") and shoot_timer.is_stopped():
		

		var target_pos = get_global_mouse_position()
		var direction = (target_pos - global_position).normalized()
		

		var newBullet = bullet.instantiate()
		newBullet.global_position = shoot_position.global_position
		newBullet.direction = direction
		newBullet.rotation = direction.angle()
		
		get_parent().add_child(newBullet)
		shoot_timer.start()
		
func _physics_process(delta):
	dash()
	
	if not is_dashing and dash_timer.time_left == 0 and velocity.length() > 0:
		# Forzamos parada absoluta instantánea
		velocity = Vector2.ZERO
	# -----------------------------
		
	get_input() # Esto debe ir después para que si el jugador presiona una tecla, se mueva inmediatamente después de parar
	move_and_slide()
	shoot()
	
