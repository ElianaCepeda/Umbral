extends EnemyBase

var is_fast: bool = false
@export var normal_speed: int = 100
@export var fast_speed: int = 300

@export var min_interval: float = 1.5
@export var max_interval: float = 3.0

func _ready():
	super._ready() 
	speed = normal_speed
	var initial_delay = randf_range(0.1, 1.0)
	await get_tree().create_timer(initial_delay).timeout
	_start_next_cycle()

func _start_next_cycle():
	var random_time = randf_range(min_interval, max_interval)
	get_tree().create_timer(random_time).timeout.connect(_on_rhythm_timeout)

func _on_rhythm_timeout():
	if not is_inside_tree(): return 
	is_fast = !is_fast
	
	if is_fast:
		speed = fast_speed
		modulate = Color.ORANGE
	else:
		speed = normal_speed
		modulate = Color.WHITE
	_start_next_cycle()
