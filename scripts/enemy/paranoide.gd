extends EnemyBase
func _ready():
	super._ready()
	effect_name = "reduce_vision"
	effect_duration = 3.0
	damage_color = Color.DIM_GRAY
	speed = 150
