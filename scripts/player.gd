extends CharacterBody2D

@export var speed = 100
@export var health = 5
@onready var shoot_timer = $ShootTimer
@onready var shoot_position = $bullet_pos
var bullet= preload("res://scenes/bullet.tscn")
func recibir_danio(cantidad):
	health -= cantidad
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if health <= 0:
		morir()

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
	
