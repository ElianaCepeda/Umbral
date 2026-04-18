extends EnemyBase

# 1. Cargamos automáticamente el rastro (Asegúrate de que esta ruta sea exacta)
@export var fatigue_scene: PackedScene = preload("res://scenes/attacks/rastro_fatiga.tscn")

# Variable para el reloj que crearemos por código
var drop_timer: Timer 

@export var drop_time: float = 3.0
@export var wait_time: float = 2.0

func _ready():
	# Definimos atributos específicos del enemigo
	speed = 120
	health = 5
	points = 10
	collision_damage = 1
	damage_color = Color.DIM_GRAY 
	
	super._ready() # Inicializa la lógica base (Rebotar por el mapa)
	add_to_group("fatigue")
	
	# CREAMOS EL TIMER
	drop_timer = Timer.new()
	add_child(drop_timer)
	drop_timer.timeout.connect(leave_trail)
	
	start_fatigue_cycle()

func start_fatigue_cycle():
	# Deja caer una gota cada cierto tiempo
	drop_timer.start(0.06) 
	
	await get_tree().create_timer(drop_time).timeout
	drop_timer.stop()
	
	await get_tree().create_timer(wait_time).timeout
	start_fatigue_cycle()

func leave_trail() -> void:
	if fatigue_scene:
		var new_trail = fatigue_scene.instantiate()
		new_trail.global_position = global_position

		# Pintamos el rastro de color gris oscuro para diferenciarlo del veneno
		for child in new_trail.get_children():
			if child is Sprite2D:
				child.modulate = Color.DARK_SLATE_GRAY 
				break 
				
		get_parent().call_deferred("add_child", new_trail)
