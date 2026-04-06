extends EnemyBase
func _ready():
	super._ready()
	effect_name = "invert_controls"
	effect_duration = 3.0
	damage_color = Color.PURPLE
	speed = 150
