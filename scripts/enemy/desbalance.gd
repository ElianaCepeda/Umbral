extends EnemyBase
func _ready():
	super._ready()
	effect_name = "reduce_vision"
	effect_duration = 1.0
	damage_color = Color.PURPLE
	speed = 150
