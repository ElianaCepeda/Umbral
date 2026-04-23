extends EnemyBase

@export var poison_scene: PackedScene = preload("res://scenes/attacks/veneno.tscn")
@onready var poison_timer: Timer = $PoisonTimer

@export var drop_time: float = 3.0
@export var wait_time: float = 2.0

func _ready():
	damage_color = Color.RED
	super._ready() # Inicializa la lógica base
	
	if poison_timer:
		poison_timer.timeout.connect(leave_trail)
		start_poison_cycle()

func start_poison_cycle():
	poison_timer.start(0.01) 
	
	await get_tree().create_timer(drop_time).timeout
	poison_timer.stop()
	
	await get_tree().create_timer(wait_time).timeout
	start_poison_cycle()

func leave_trail() -> void:
	if poison_scene:
		var new_poison = poison_scene.instantiate()
		new_poison.global_position = global_position

		for child in new_poison.get_children():
			if child is Sprite2D:
				child.modulate = Color.GREEN
				break 
				
		get_parent().call_deferred("add_child", new_poison)
		
func decide_direction():
	# Si está rebotando por un golpe o tomando impulso morado, no lo dejamos pensar
	if is_recoiling or is_preparing_charge: return
	
	# Tiramos el dado: ¿Es hora de perder la paciencia y embestir?
	if randf() < charge_probability:
		comportamiento = 1 # ¡Engañamos al EnemyBase para que nos de la velocidad x4!
		prepare_charge()   # Llama al brillo morado y a la embestida heredada del padre
	else:
		is_charging = false
		comportamiento = 0 # Vuelve a ser un Constructor calmado
		movement_direction = calculate_heuristic_direction() # Sigue el rastro matemático
