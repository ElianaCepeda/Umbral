extends Node2D

@export var area: Control
@export var cantidad_minima: int = 3
@export var cantidad_maxima: int = 6
@export var tipo_enemigo_actual: String = "" 

func generar_oleada():
	var cantidad = randi_range(cantidad_minima, cantidad_maxima)
	for i in range(cantidad):
		aparecer_enemigo()

func aparecer_enemigo():
	if not area:
		print(" Al Spawner le falta asignar el Área en el Inspector!")
		return
		
	var rect_size = area.size 
	var x_local = randf_range(0, rect_size.x)
	var y_local = randf_range(0, rect_size.y)
	
	var posicion_mundo = area.global_position + Vector2(x_local, y_local)
	
	var nuevo_enemigo = EnemyFactory.create_enemy(tipo_enemigo_actual, posicion_mundo)
	
	if nuevo_enemigo:
		get_parent().call_deferred("add_child", nuevo_enemigo)
	
