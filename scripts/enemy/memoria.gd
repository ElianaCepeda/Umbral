extends EnemyBase

@export var min_invisible_duration: float = 1.5
@export var max_invisible_duration: float = 3.0
@export var min_memory_interval: float = 1.0
@export var max_memory_interval: float = 2.0
@export var fade_speed: float = 0.6

func _ready():
	# Specific attributes
	speed = 100
	health = 4
	points = 15
	collision_damage = 1
	damage_color = Color.LIGHT_CYAN
	
	super._ready() # Initialize base logic
	
	# Add a random initial delay so they don't start at the exact same frame
	var initial_delay = randf_range(0.1, 5.0)
	await get_tree().create_timer(initial_delay).timeout
	
	start_memory_loss_cycle()

func start_memory_loss_cycle():
	while true:
		# 1. Wait for a random interval before "forgetting"
		var random_wait = randf_range(min_memory_interval, max_memory_interval)
		await get_tree().create_timer(random_wait).timeout
		
		# 2. Fade Out (Disappear)
		var fade_out = create_tween()
		fade_out.tween_property(self, "modulate:a", 0.0, fade_speed)
		# Optional: Make intangible while invisible
		# set_collision_layer_value(1, false)
		
		# 3. Stay invisible for a random duration
		var random_invisible_time = randf_range(min_invisible_duration, max_invisible_duration)
		await get_tree().create_timer(random_invisible_time).timeout
		
		# 4. Fade In (Reappear)
		var fade_in = create_tween()
		fade_in.tween_property(self, "modulate:a", 1.0, fade_speed)
		# Optional: Re-enable collision
		# set_collision_layer_value(1, true)
