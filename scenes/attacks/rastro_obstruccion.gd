extends StaticBody2D

@onready var damage_area = $DamageArea
var player_inside: Node2D = null
var damage_timer: Timer

# NUEVO: Variable que el enemigo nos pasará
var is_horizontal: bool = true 

func _ready():
	# Si es vertical, giramos el muro completo (dibujo y colisiones) 90 grados
	if not is_horizontal:
		rotation_degrees = 90
		
	# --- ANIMACIÓN DE CRECIMIENTO ---
	scale = Vector2.ZERO 
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.8, 1.8), 0.2).set_trans(Tween.TRANS_BOUNCE)
	
	get_tree().create_timer(10.0).timeout.connect(queue_free)
	
	# --- TEMPORIZADOR DE DAÑO CONTINUO ---
	damage_timer = Timer.new()
	damage_timer.wait_time = 0.5 
	damage_timer.timeout.connect(_deal_continuous_damage)
	add_child(damage_timer)
	damage_timer.start()
	
	damage_area.body_entered.connect(_on_body_entered)
	damage_area.body_exited.connect(_on_body_exited)

func _deal_continuous_damage():
	if is_instance_valid(player_inside) and player_inside.has_method("take_damage"):
		player_inside.take_damage(2, Color.SADDLE_BROWN) 

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = body
		_deal_continuous_damage()

func _on_body_exited(body):
	if body == player_inside:
		player_inside = null
