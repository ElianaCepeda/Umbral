extends Node2D

@export var enemigo_escena : PackedScene
@export var cantidad_minima = 3
@export var cantidad_maxima = 6

@onready var area = $AreaGeneracion # Tu ReferenceRect

func _ready():
	# Esperar un poco ayuda a que las posiciones globales se calculen bien
	await get_tree().process_frame
	generar_oleada()

func generar_oleada():
	var cantidad = randi_range(cantidad_minima, cantidad_maxima)
	for i in range(cantidad):
		aparecer_enemigo()

func aparecer_enemigo():
	if enemigo_escena == null: return
	
	var nuevo_enemigo = enemigo_escena.instantiate()
	
	# 1. Obtenemos el rectángulo del área
	var rect_size = area.size # En nodos Control usamos .size en lugar de .get_rect().size
	
	# 2. Elegimos el punto aleatorio dentro de ese tamaño
	var x_local = randf_range(0, rect_size.x)
	var y_local = randf_range(0, rect_size.y)
	
	# 3. Sumamos la posición GLOBAL del área para obtener el punto en el mundo
	# Esto funciona correctamente para nodos de interfaz y 2D
	var posicion_mundo = area.global_position + Vector2(x_local, y_local)
	
	# 4. Asignamos y añadimos al árbol de la escena
	nuevo_enemigo.global_position = posicion_mundo
	get_tree().root.add_child(nuevo_enemigo)
