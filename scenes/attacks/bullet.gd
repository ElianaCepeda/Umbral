extends CharacterBody2D

@export var speed = 800
@export var damage = 2
var bullet_type: String = "default"
var direction = Vector2.ZERO # Esta variable la llenará el jugador

# Nueva variable para guardar quién es el jugador
var player_ref: Node2D = null

func _ready():

	# Buscamos al jugador una sola vez al disparar
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player_ref = players[0]
		
	# Cambiamos la animacion de la bala segun el tipo recibido del jugador
	var animated_sprite = get_node_or_null("AnimatedSprite2D")
	if animated_sprite and bullet_type != "default" and bullet_type != "":
		if animated_sprite.sprite_frames.has_animation(bullet_type):
			animated_sprite.play(bullet_type)
		else:
			push_warning("No existe animacion para el tipo: " + bullet_type)
		
	get_tree().create_timer(5.0).timeout.connect(queue_free)
	
func set_bullet_type(type: String):
	bullet_type = type
	
func _physics_process(delta):
	# Empezamos asumiendo que la velocidad es la normal
	var current_speed = speed 
	
	# Si el jugador existe y está bajo el efecto de "Retardo"
	if is_instance_valid(player_ref) and player_ref.get("has_input_delay") == true:
		# Reducimos la velocidad de la bala a la mitad (puedes ajustar el 0.5)
		current_speed = speed * 0.2 
		
	# Movemos la bala con la velocidad calculada (lenta o normal)
	var collision = move_and_collide(direction * current_speed * delta)
	
	if collision:
		var objeto_tocado = collision.get_collider()
		
		# Comprobamos si el objeto tiene la función de recibir daño
		if objeto_tocado.has_method("take_damage"):
			objeto_tocado.take_damage(damage)
		
		queue_free() # La bala desaparece al chocar
