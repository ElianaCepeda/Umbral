extends EnemyBase

@export var poison_scene: PackedScene = preload("res://scenes/attacks/veneno.tscn")
@onready var poison_timer: Timer = $PoisonTimer

func _ready():
	damage_color = Color.RED
	super._ready()
	
	if poison_timer:
		poison_timer.timeout.connect(leave_trail)
		poison_timer.start(0.01) # Rastro permanente

func leave_trail() -> void:
	# Si está preparándose o embistiendo, no deja rastro
	if is_preparing_charge or is_charging:
		return

	if poison_scene:
		var new_poison = poison_scene.instantiate()
		new_poison.global_position = global_position

		for child in new_poison.get_children():
			if child is Sprite2D:
				child.modulate = Color.SKY_BLUE
				break 
				
		get_parent().call_deferred("add_child", new_poison)
