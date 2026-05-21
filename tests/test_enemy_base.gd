extends GutTest

var enemy: EnemyBase
var mock_player: Node2D

func before_each():
	# 1. Creamos un jugador falso (Señuelo) y lo metemos al grupo que busca el enemigo
	mock_player = Node2D.new()
	mock_player.name = "Player"
	mock_player.add_to_group("player")
	mock_player.global_position = Vector2(100, 0) # Lo ponemos exactamente a la derecha
	add_child_autoqfree(mock_player)
	
	# 2. Instanciamos el cerebro base del enemigo
	enemy = EnemyBase.new()
	# Lo ponemos en el centro (0, 0)
	enemy.global_position = Vector2.ZERO 
	add_child_autoqfree(enemy)
	
	# Forzamos la inyección para asegurar la prueba
	enemy.player = mock_player

# ==========================================
# PRUEBAS DE VECTORES Y NAVEGACIÓN
# ==========================================

func test_snap_direction_respeta_cruz_4_direcciones():
	# Arrange
	enemy.tipo_movimiento = 0 # 0 = 4 Direcciones (Cruz)
	var vector_diagonal = Vector2(0.8, 0.2) # Casi a la derecha, un poco hacia abajo
	
	# Act
	var resultado = enemy.snap_direction(vector_diagonal)
	
	# Assert: Debe ignorar la "Y" y devolver un vector puro hacia la derecha (1, 0)
	assert_eq(resultado, Vector2(1, 0), "El movimiento en cruz debe redondear al eje dominante")

func test_snap_direction_respeta_libre_360_grados():
	# Arrange
	enemy.tipo_movimiento = 1 # 1 = Libre
	var vector_diagonal = Vector2(0.707, 0.707) 
	
	# Act
	var resultado = enemy.snap_direction(vector_diagonal)
	
	# Assert: Debe devolver exactamente el mismo vector sin alterarlo
	assert_eq(resultado, vector_diagonal, "El movimiento libre no debe alterar el vector original")

# ==========================================
# PRUEBAS DE TOMA DE DECISIONES (IA)
# ==========================================

func test_expand_towards_player_calcula_ruta_directa():
	# Arrange
	enemy.comportamiento = 2 # Expansivo (Va directo)
	enemy.tipo_movimiento = 1 # Libre
	
	# El enemigo está en (0,0) y el jugador en (100,0). La ruta directa es la derecha.
	
	# Act
	enemy.expand_towards_player()
	
	# Assert
	assert_eq(enemy.movement_direction, Vector2.RIGHT, "La IA expansiva debe apuntar directamente al jugador")

func test_trigger_recoil_invierte_direccion_y_aturde():
	# Arrange
	var damage_source_pos = Vector2(50, 0) # Un ataque que viene desde la derecha
	enemy.is_charging = true # Simulamos que venía corriendo
	enemy.tipo_movimiento = 1
	
	# Act
	enemy.trigger_recoil(damage_source_pos)
	
	# Assert
	assert_true(enemy.is_recoiling, "El enemigo debe entrar en estado de aturdimiento")
	assert_false(enemy.is_charging, "El impacto debe cancelar cualquier embestida activa")
	
	# Si el golpe vino de la derecha, debe rebotar hacia la izquierda (-1, 0)
	assert_eq(enemy.movement_direction, Vector2.LEFT, "El knockback debe empujar en dirección opuesta a la fuente")

func test_ia_segura_sin_jugador():
	# Arrange: Matamos al jugador falso
	mock_player.free()
	enemy.player = null
	enemy.comportamiento = 2 # Expansivo
	
	# Act
	enemy.expand_towards_player()
	
	# Assert: Si el jugador no existe, el enemigo debe quedarse quieto para no crashear
	assert_eq(enemy.movement_direction, Vector2.ZERO, "Si no hay jugador, la IA expansiva debe detenerse")
