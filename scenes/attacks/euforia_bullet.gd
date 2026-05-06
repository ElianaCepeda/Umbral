extends Area2D

@export var speed: float = 250.0
@export var damage: int
@export var effect_name: String = "random_speed_boost"
@export var effect_duration: float = 2.0

var direction: Vector2 = Vector2.ZERO

func _ready():
	# Conecta la señal automáticamente al iniciar para evitar errores del editor
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	
	get_tree().create_timer(5.0).timeout.connect(queue_free)

func _process(delta):
	# Movemos el proyectil en línea recta según la dirección
	position += direction * speed * delta

# Conecta la señal "body_entered" del Area2D a esta función
func _on_body_entered(body):
	if body.is_in_group("player"):
		# Aplicamos el daño y el efecto al jugador
		if body.has_method("take_damage"):
			body.take_damage(damage)
		if body.has_method("apply_effect"):
			body.apply_effect(effect_name, 0, effect_duration)
		
		queue_free() # Destruimos el proyectil al chocar con el jugador
	elif body.is_in_group("wall") or body is TileMap:
		queue_free() # Destruimos el proyectil si choca con una pared

# Opcional: Conecta la señal "screen_exited" de un VisibleOnScreenNotifier2D para borrar balas perdidas
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
