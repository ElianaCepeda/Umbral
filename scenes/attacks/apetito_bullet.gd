extends Area2D

var speed: float = 300.0
var direction: Vector2 = Vector2.ZERO
var damage: int = 10

func _ready():
	get_tree().create_timer(5.0).timeout.connect(queue_free)
	

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	# Si toca al jugador...
	if body.is_in_group("player"):
		# 1. Le hacemos daño
		if body.has_method("take_damage"):
			body.take_damage(damage, Color.RED) # Daño y color de impacto
			
	# Sin importar si chocó con pared o jugador, la bala se destruye
	queue_free()
