extends Area2D

@export var damage_per_second: int = 5
var player_inside: Node2D = null

func _ready():	
	# El charco desaparece solo después de 6 segundos para no llenar la memoria
	get_tree().create_timer(6.0).timeout.connect(queue_free)
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Temporizador para hacer daño continuo mientras estés adentro
	var tick_timer = Timer.new()
	tick_timer.wait_time = 1.0 # Hace daño cada 1 segundo
	tick_timer.timeout.connect(apply_poison)
	add_child(tick_timer)
	tick_timer.start()
	
	# Efecto visual: aparece chiquito y crece
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.5)

func apply_poison():
	if is_instance_valid(player_inside) and player_inside.has_method("take_damage"):
		player_inside.take_damage(damage_per_second, Color.GREEN_YELLOW)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = body
		apply_poison() # Daño inmediato al pisarlo

func _on_body_exited(body):
	if body == player_inside:
		player_inside = null
