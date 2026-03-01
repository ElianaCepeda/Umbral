extends CharacterBody2D

@export var speed: int = 100
@export var consciousness: int = 50
@onready var shoot_timer = $ShootTimer
@onready var shoot_position = $bullet_pos
@onready var consciousness_bar = $HUD/ConsciousnessBar

var bullet= preload("res://scenes/bullet.tscn")

func _ready():
	consciousness_bar.value = consciousness

func recibir_danio(cantidad):
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
	queue_free()

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	if input_direction.x < 0:
		$AnimatedSprite2D.flip_h = true
		shoot_position.position.x = -7
	elif input_direction.x > 0:
		$AnimatedSprite2D.flip_h = false
		shoot_position.position.x = 7
	if velocity.length() >0 :
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()


func shoot():
	var shoot_dir = Input.get_vector("shoot_left", "shoot_right", "shoot_up", "shoot_down")
	if shoot_dir.length() > 0 and shoot_timer.is_stopped():
		
		var newBullet = bullet.instantiate()
		newBullet.global_position = $bullet_pos.global_position
		newBullet.direction = shoot_dir.normalized()
		newBullet.rotation = shoot_dir.angle()
		
		get_tree().root.add_child(newBullet)

		shoot_timer.start()

func _physics_process(delta):
	get_input()
	move_and_slide()
	shoot()
	
