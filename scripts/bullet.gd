extends CharacterBody2D

@export var speed = 800
@export var danio = 15
var direction = Vector2.ZERO # Esta variable la llenará el jugador

func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		var objeto_tocado = collision.get_collider()
		
		# Comprobamos si el objeto tiene la función de recibir daño
		if objeto_tocado.has_method("recibir_danio"):
			objeto_tocado.recibir_danio(danio)
		
		queue_free() # La bala desaparece al chocarsd
