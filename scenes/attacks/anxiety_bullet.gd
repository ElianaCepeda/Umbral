extends Area2D

var speed: float = 300.0
var direction: Vector2 = Vector2.ZERO

func _ready():
	get_tree().create_timer(5.0).timeout.connect(queue_free)
	

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	# Si toca al jugador...
	if body.is_in_group("player"):
		# 1. Le hacemos daño
		if body.has_method("take_damage"):
			body.take_damage(5, Color.PALE_TURQUOISE) # Daño y color de impacto
			
		# 2. Le aplicamos la ansiedad (temblor y controles resbaladizos)
		if body.has_method("apply_effect"):
			body.apply_effect("anxiety", 0, 3.0) 
			
	# Sin importar si chocó con pared o jugador, la bala se destruye
	queue_free()
