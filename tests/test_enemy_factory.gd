extends GutTest

# ==========================================
# 1. PRUEBAS DE CREACIÓN VÁLIDA
# ==========================================

func test_create_enemy_instancia_correctamente():
	# Arrange: Posición arbitraria
	var spawn_pos = Vector2(150, 300)
	
	# Act: Creamos un enemigo de alcohol
	var enemy = EnemyFactory.create_enemy("alcohol", spawn_pos)
	
	# Assert
	assert_not_null(enemy, "El Factory debe devolver una instancia válida para un tipo existente")
	assert_true(enemy is Node2D, "El enemigo instanciado debe heredar de Node2D")
	
	# Limpieza manual (Como no lo añadimos al árbol de GUT, lo liberamos de la memoria)
	if enemy: enemy.free()

func test_create_enemy_asigna_posicion_inicial():
	var spawn_pos = Vector2(-50, 75)
	var enemy = EnemyFactory.create_enemy("tabaco", spawn_pos)
	
	assert_eq(enemy.position, spawn_pos, "El enemigo debe nacer exactamente en la posición solicitada")
	
	if enemy: enemy.free()

# ==========================================
# 2. PRUEBAS DE FALLA SEGURA (MANEJO DE ERRORES)
# ==========================================

func test_create_enemy_falla_segura_con_tipo_invalido():
	# Act: Pedimos un enemigo que no existe en el diccionario
	var enemy = EnemyFactory.create_enemy("sustancia_inventada_inexistente", Vector2.ZERO)
	
	# Assert: En lugar de colapsar Godot, tu código devuelve 'null'
	assert_null(enemy, "Si el tipo de enemigo no existe, el Factory debe devolver null de forma segura")

func test_create_enemy_falla_segura_con_string_vacio():
	# Act: Simulamos el error exacto que tuviste antes cuando el Spawner no tenía tipo
	var enemy = EnemyFactory.create_enemy("", Vector2.ZERO)
	
	# Assert
	assert_null(enemy, "Un string vacío no debe romper el Factory, debe devolver null")

# ==========================================
# 3. PRUEBAS DE INTEGRIDAD DE DATOS (LA PRUEBA DEFINITIVA)
# ==========================================

func test_integridad_de_todas_las_escenas_precargadas():
	# Esta prueba recorrerá todo tu diccionario ENEMY_SCENES automáticamente.
	# Si mañana agregas 10 enemigos más, esta prueba los validará sin que tengas que cambiar el código.
	
	var keys = EnemyFactory.ENEMY_SCENES.keys()
	assert_gt(keys.size(), 0, "El diccionario de escenas no debe estar vacío")
	
	var escenas_validas = 0
	
	for key in keys:
		var scene = EnemyFactory.ENEMY_SCENES[key]
		
		# 1. Verificamos que la ruta no esté rota (que el preload haya funcionado)
		assert_not_null(scene, "La ruta de la escena para '" + key + "' está rota o no existe")
		
		if scene != null:
			# 2. Verificamos que sea un PackedScene válido de Godot
			assert_true(scene is PackedScene, "El valor de '" + key + "' debe ser un PackedScene")
			
			# 3. Verificamos que se pueda instanciar sin errores internos
			assert_true(scene.can_instantiate(), "La escena '" + key + "' debe poder instanciarse sin errores")
			escenas_validas += 1
			
	assert_eq(escenas_validas, keys.size(), "Todos los enemigos en el diccionario deben ser instanciables")
