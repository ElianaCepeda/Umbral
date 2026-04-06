extends EnemyBase
func _ready():
	super._ready()
	effect_name = "paralyze"
	effect_duration = 1.5
	damage_color = Color.YELLOW
	speed = 150
