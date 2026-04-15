extends Area2D

var time_passed: float = 0.0
var base_scale: Vector2 = Vector2(1, 1)

func _ready():
	body_entered.connect(_on_body_entered)
	
	# El pulso desaparece solo después de 6 segundos
	get_tree().create_timer(6.0).timeout.connect(queue_free)
	
	# Efecto visual al nacer: aparece de la nada
	scale = Vector2.ZERO
	modulate.a = 0.0
	
	# Aparece gradualmente mientras viaja
	var appearance_tween = create_tween()
	appearance_tween.set_parallel(true)
	appearance_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 1.0)
	appearance_tween.tween_property(self, "modulate:a", 1.0, 0.5)
	
	 
func _process(delta):
	time_passed += delta
	
	# El efecto "Agitado": Vibra violenta y rápidamente sobre su eje
	var shake_x = sin(time_passed * 50.0) * 1.5
	var shake_y = cos(time_passed * 60.0) * 1.5
	# Aplicamos el temblor al sprite directamente para no mover el Area2D
	$Sprite2D.position = Vector2(shake_x, shake_y)

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Daño leve por la presión (Dím Gray = Gris Tenue, color azulado)
		if body.has_method("take_damage"):
			body.take_damage(5, Color.DIM_GRAY)
		
		if body.has_method("apply_effect"):
			body.apply_effect("paralyze", 0, 2.5)
			
		queue_free()
