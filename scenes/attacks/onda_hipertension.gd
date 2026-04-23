extends Area2D

var speed: float = 130.0
var direction: Vector2 = Vector2.ZERO
var max_scale: Vector2 = Vector2(4.0, 4.0) # Hasta qué tamaño va a crecer

func _ready():
	body_entered.connect(_on_body_entered)
	
	# La onda desaparece sola después de 3 segundos
	get_tree().create_timer(2.0).timeout.connect(queue_free)

func _process(delta):
	# 1. Se mueve hacia adelante
	position += direction * speed * delta
	
	# 2. Crece mientras viaja (Efecto de onda expansiva)
	if scale.x < max_scale.x:
		scale += Vector2(1, 1) * delta * 2.0

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Aplica el daño base (ej: 5 puntos)
		if body.has_method("take_damage"):
			body.take_damage(5, Color.ORANGE_RED)
			
		# Aplica el efecto de hipertensión por 4 segundos
		if body.has_method("apply_effect"):
			body.apply_effect("hipertension", 0, 4.0)
