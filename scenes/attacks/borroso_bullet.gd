extends Area2D

@export var speed: float = 180.0 # Es una neblina, así que viaja un poco más lento
@export var damage: int = 5
@export var effect_name: String = "blur_vision"
@export var effect_duration: float = 4.0

var direction: Vector2 = Vector2.ZERO
var player_ref: Node2D = null

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player_ref = players[0]
		
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
		
	# Efecto opcional: hacemos que la neblina crezca lentamente mientras viaja
	var grow_tween = create_tween()
	grow_tween.tween_property(self, "scale", Vector2(1.5, 1.5), 2.0)
	
	get_tree().create_timer(5.0).timeout.connect(queue_free)

func _process(delta):
	var current_speed = speed
	if is_instance_valid(player_ref) and player_ref.get("has_input_delay") == true:
		current_speed = speed * 0.4
		
	position += direction * current_speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		if body.has_method("apply_effect"):
			body.apply_effect(effect_name, 0, effect_duration)
		queue_free()
	elif body.is_in_group("wall") or body is TileMap:
		queue_free()
