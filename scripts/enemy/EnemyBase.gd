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

var movement_direction: Vector2 = Vector2.ZERO
var player: Node2D = null

func _ready():
	find_player()
	choose_random_direction()
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING 

func find_player():
	var nodes = get_tree().get_nodes_in_group("player")
	for n in nodes:
		if n is Node2D:
			player = n
			break

func _physics_process(_delta):
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play()
	
	velocity = movement_direction * speed
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collided_object = collision.get_collider()
		
		if collided_object and collided_object.is_in_group("player"):
			if collided_object.has_method("take_damage"):
				collided_object.take_damage(collision_damage)
				if effect_name != "" and collided_object.has_method("apply_effect"):
					collided_object.apply_effect(effect_name, 0, effect_duration)
				choose_random_direction() 
	
	if is_on_wall():
		choose_random_direction()

func choose_random_direction():
	var angle = randf_range(0, TAU)
	movement_direction = Vector2.RIGHT.rotated(angle)

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
	queue_free()
