extends GutTest

var parent_node: Node2D
var spawner: Node2D
var spawn_area: Control

func before_each():
	# 1. Creamos un nodo padre falso (El spawner le agrega los hijos a su padre)
	parent_node = Node2D.new()
	add_child_autoqfree(parent_node)
	
	# 2. Instanciamos el spawner y le asignamos su script
	spawner = Node2D.new()
	# ¡OJO! Ajusta esta ruta a donde tengas guardado realmente tu spawner.gdaaaaaaa
	spawner.set_script(preload("res://scenes/spawner.gd")) 
	parent_node.add_child(spawner)
	
	# 3. Creamos el área de control falsa que el spawner necesita
	spawn_area = Control.new()
	# Le damos un tamaño de 200x200 píxeles
	spawn_area.size = Vector2(200, 200) 
	# La ponemos en la posición (50, 50) del mundo
	spawn_area.global_position = Vector2(50, 50) 
	spawner.area = spawn_area

# ==========================================
# PRUEBAS DEL SPAWNER
# ==========================================

func test_aparecer_enemigo_calcula_posicion_dentro_del_area():
	# Arrange: Usamos "alcohol" porque sabemos que no colapsa en el vacío
	spawner.tipo_enemigo_actual = "alcohol"
	
	# Act
	spawner.aparecer_enemigo()
	await get_tree().process_frame
	
	# Assert
	var enemigo = parent_node.get_child(1) # El índice 0 es el spawner, el 1 es el enemigo
	
	assert_between(enemigo.global_position.x, 50.0, 250.0, "La posición X debe estar dentro de los límites del Control")
	assert_between(enemigo.global_position.y, 50.0, 250.0, "La posición Y debe estar dentro de los límites del Control")	

func test_generar_oleada_respeta_rango_de_cantidades():
	# Arrange
	spawner.cantidad_minima = 3
	spawner.cantidad_maxima = 6
	spawner.tipo_enemigo_actual = "alcohol" # Usamos un enemigo real del Factory
	
	# Act
	spawner.generar_oleada()
	
	# TRUCO VITAL: Como el spawner usa 'call_deferred', debemos esperar a que Godot dibuje el frame
	await get_tree().process_frame
	
	# Assert: Contamos los hijos del padre (restando 1 que es el propio spawner)
	var enemigos_creados = parent_node.get_child_count() - 1
	
	assert_gte(enemigos_creados, 3, "Debe generar al menos la cantidad mínima (3)")
	assert_lte(enemigos_creados, 6, "No debe superar la cantidad máxima (6)")

func test_aparecer_enemigo_tipo_invalido_no_agrega_nodos():
	# Arrange: Un tipo que hará que el Factory devuelva null
	spawner.tipo_enemigo_actual = "enemigo_invalido"
	
	# Act
	spawner.aparecer_enemigo()
	await get_tree().process_frame
	
	# Assert
	assert_eq(parent_node.get_child_count(), 1, "Si el Factory falla (devuelve null), el Spawner no debe intentar agregarlo al árbol")
