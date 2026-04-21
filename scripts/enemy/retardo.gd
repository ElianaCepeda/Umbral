extends EnemyBase

var is_recovering: bool = false
var original_speed: int = 70

func _ready():
	super._ready()
	effect_name = "input_delay"
	effect_duration = 3.0 
	speed = original_speed 
