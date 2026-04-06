extends EnemyBase

var is_recovering: bool = false
var original_speed: int = 70

func _ready():
	super._ready()
	effect_name = "input_delay"
	effect_duration = 3.0 
	speed = original_speed 

func _physics_process(delta):
	# Persecución precisa solo si no está aturdido
	if is_instance_valid(player) and not is_recovering:
		movement_direction = (player.global_position - global_position).normalized()
	
	super._physics_process(delta)

func choose_random_direction():
	super.choose_random_direction() 
	
	if is_recovering:
		return
		
	is_recovering = true
	speed = 130 
	
	var timer = get_tree().create_timer(2.5)
	timer.timeout.connect(func():
		if is_instance_valid(self):
			is_recovering = false
			speed = original_speed # Volvemos a su velocidad normal
	)
