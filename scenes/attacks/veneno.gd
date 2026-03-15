extends Area2D

@onready var disappearance_timer = $DisappearTimer
@onready var damage_timer = $DamageTimer
@export var damage = 1

func _ready():
	disappearance_timer.timeout.connect(queue_free)
	disappearance_timer.start(3.0)
	damage_timer.timeout.connect(_on_damage_timer_timeout)
	damage_timer.start() 

func _on_damage_timer_timeout():
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("player"):
			if body.has_method("take_damage"):
				body.take_damage(damage)
