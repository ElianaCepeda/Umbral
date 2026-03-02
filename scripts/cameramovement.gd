extends Camera2D

@export var target_path: NodePath = "../Player" # Ruta al nodo del jugador
@onready var target = get_node(target_path)

@export var suavizado: float = 0.1 # Entre 0 y 1 (más bajo = más lento)

func _physics_process(_delta):
	if is_instance_valid(target):
		# Interpolación lineal para un seguimiento suave
		global_position = global_position.lerp(target.global_position, suavizado)
	else:
		# Si el jugador muere, la cámara se queda quieta donde estaba
		pass
