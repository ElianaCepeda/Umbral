extends EnemyBase

@export var pulse_scene: PackedScene

func _ready():
	super._ready()
	speed = 40 
	# Color base azulado y cansado
	modulate = Color(0.6, 0.6, 1.0)
	
	var shoot_timer = Timer.new()
	# Lanza un pulso en ese intevalo de tiempo
	shoot_timer.wait_time = randf_range(4.5, 6.5) 
	shoot_timer.timeout.connect(shoot_pulse)
	add_child(shoot_timer)
	
	shoot_timer.start()
	

func shoot_pulse():
	if pulse_scene and is_instance_valid(self):
		var pulse = pulse_scene.instantiate()
		pulse.global_position = global_position
		
		# El enemigo se estira y vibra al lanzar
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.3, 0.7), 0.1)
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
		
		# Apuntamos hacia el jugador para que el pulso viaje hacia él
		player = get_tree().get_first_node_in_group("player")
		if player:
			var direction = (player.global_position - global_position).normalized()
			var random_angle = randf_range(-0.4, 0.4) # Aproximadamente 20 grados de error
			direction = direction.rotated(random_angle)
			
			var travel_tween = create_tween()
			var destination = global_position + (direction * 220.0) # Viaja 220px
			travel_tween.tween_property(pulse, "global_position", destination, 1.5).set_trans(Tween.TRANS_SINE)
		
		var contenedor = get_parent().get_node_or_null("ContenedorAtaques")
		if contenedor:
			contenedor.add_child(pulse)
		else:
			get_parent().add_child(pulse)
