extends Area2D

var damage_rastro = 5

func _ready():
	modulate = Color.DARK_SLATE_GRAY
	scale = Vector2(1.8, 1.8) 
	
	# El rastro desaparece a los 6 segundos para no llenar la memoria ram
	get_tree().create_timer(6.0).timeout.connect(queue_free)

func _physics_process(_delta):
	# Mientras exista, revisa constantemente quién lo está pisando
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("player") and body.has_method("apply_effect"):
			# Le manda la orden de recargar su fatiga a 1 segundo
			body.take_damage(damage_rastro, body.get_target_color())
			body.apply_effect("fatigue", 0, 1.0)
