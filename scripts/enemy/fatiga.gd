extends EnemyBase

# 1. Cargamos automáticamente el rastro (Asegúrate de que esta ruta sea exacta)
@export var fatigue_scene: PackedScene = preload("res://scenes/attacks/rastro_fatiga.tscn")

# Variable para el reloj que crearemos por código
var drop_timer: Timer 

func _ready():
	# Definimos atributos específicos del enemigo
	speed = 120
	health = 5
	points = 10
	collision_damage = 1
	damage_color = Color.DIM_GRAY 
	
	super._ready() # Inicializa la lógica base
	add_to_group("fatigue")
	
	# CREAMOS EL TIMER
	drop_timer = Timer.new()
	add_child(drop_timer)
	drop_timer.timeout.connect(leave_trail)
	
	# Iniciamos el temporizador de forma permanente
	drop_timer.start(0.06) 

func leave_trail() -> void:
	# Si está preparándose o embistiendo, no deja rastro
	if is_preparing_charge or is_charging:
		return

	if fatigue_scene:
		var new_trail = fatigue_scene.instantiate()
		new_trail.global_position = global_position

		# Pintamos el rastro de color gris oscuro
		for child in new_trail.get_children():
			if child is Sprite2D:
				child.modulate = Color.DARK_SLATE_GRAY 
				break 
				
		get_parent().call_deferred("add_child", new_trail)
