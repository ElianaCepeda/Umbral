extends GutTest

var player_scene = preload("res://scenes/player.tscn")
var player: Node2D

func before_each():
	# 1. Limpiamos la persistencia para que el Player nazca siempre con 100 de vida y 1 de ataque
	SaveManager.clear_save_data()
	# 2. Instanciamos al jugador
	player = player_scene.instantiate()
	add_child_autoqfree(player) # GUT lo añadirá y lo borrará al final del test

# --- PRUEBAS DE DAÑO Y VIDA ---

func test_take_damage_reduce_vida():
	var vida_inicial = player.consciousness
	player.take_damage(20)
	assert_eq(player.consciousness, vida_inicial - 20, "El jugador debe perder exactamente 20 puntos de vida")

func test_take_damage_respeta_invulnerabilidad():
	player.is_invulnerable = true
	player.take_damage(50)
	assert_eq(player.consciousness, 100, "Si es invulnerable, no debe perder vida")

func test_take_damage_con_escudo_activo_reduce_15_porciento():
	player.damage_reduction = 0.15 # Simulamos que usó la Skill 1
	player.take_damage(100)
	# 100 * (1.0 - 0.15) = 85
	assert_eq(player.consciousness, 15, "Con escudo de 15%, un ataque de 100 debe quitar solo 85")

func test_curacion_no_supera_limite_maximo():
	player.consciousness = 50
	player.increase_consciousness(200)
	assert_eq(player.consciousness, 100, "La curación no debe superar el max_consciousness actual")

# --- PRUEBAS DE SÍNTOMAS (ESTADOS ALTERADOS) ---

func test_efecto_reduce_max_health_corta_la_barra():
	# Este es el efecto de Necrosis
	player.apply_effect("reduce_max_health", 0)
	
	assert_eq(player.max_consciousness, 97, "El límite máximo debe bajar en 3 puntos")
	
	# La vida baja a 97 por el recorte, y luego recibe 6 de daño por el take_damage interno (97 - 6 = 91)
	assert_eq(player.consciousness, 91, "La vida actual debe recortarse al límite y recibir el daño secundario")

func test_efecto_reduce_max_health_no_baja_de_40():
	player.max_consciousness = 42
	player.apply_effect("reduce_max_health", 0)
	assert_eq(player.max_consciousness, 40, "El límite máximo de vida nunca debe ser menor a 40")

func test_efecto_hipertension_duplica_el_dano():
	player.apply_effect("hipertension", 0, 10.0) # 10 segundos
	assert_eq(player.damage_multiplier, 2, "La hipertensión debe poner el multiplicador de daño en 2")
	
	player.take_damage(10)
	assert_eq(player.consciousness, 80, "Con hipertensión, un daño de 10 debe quitar 20")

func test_efecto_fatiga_deshabilita_disparo_y_reduce_velocidad():
	player.apply_effect("fatigue", 0, 5.0)
	assert_false(player.can_shoot, "La fatiga debe impedir disparar")
	assert_eq(player.speed, 50, "La fatiga debe reducir la velocidad a 50")

func test_efecto_paralisis_bloquea_movimiento():
	player.apply_effect("paralyze", 0, 5.0)
	assert_true(player.is_paralyzed, "El estado debe marcarse como paralizado")
	
	# Simulamos que el jugador intenta moverse
	var intento_movimiento = player.get_input()
	assert_eq(intento_movimiento, Vector2.ZERO, "Si está paralizado, get_input() debe devolver (0,0) sin importar qué teclas presione")

func test_efecto_controles_invertidos():
	player.apply_effect("invert_controls", 0, 5.0)
	assert_true(player.controls_inverted, "La bandera controls_inverted debe ser true")
	
func test_efecto_random_speed_boost_no_supera_limite_maximo():
	# Arrange: Ponemos al jugador al borde del límite de velocidad
	player.speed = 750
	
	# Act: Aplicamos el buff de velocidad (que suma entre 100 y 250)
	player.apply_effect("random_speed_boost", 0, 5.0)
	
	# Assert: Comprobamos que el límite lo frenó en 800
	assert_lte(player.speed, 800, "La velocidad NUNCA debe superar el límite de 800")
	assert_gt(player.speed, 750, "La velocidad debe haber aumentado al menos hasta el límite")
	
func test_efecto_input_delay_reduce_velocidad_y_limpia_buffer():
	# Arrange
	var initial_speed = player.speed # Por defecto es 100
	
	# Act
	player.apply_effect("input_delay", 0, 5.0)
	
	# Assert
	assert_true(player.has_input_delay, "Debe activar la bandera de retraso")
	assert_eq(player.speed, int(initial_speed / 2), "La velocidad debe cortarse exactamente a la mitad")
	assert_eq(player.input_buffer.size(), 0, "El buffer de teclas presionadas debe limpiarse")

func test_take_damage_calcula_reduccion_y_multiplicador_juntos():
	# Arrange: Configuramos un escenario caótico
	player.damage_reduction = 0.4 # 40% de escudo 
	player.damage_multiplier = 2  # Recibe el doble de daño
	var vida_inicial = player.consciousness
	
	# Act: Le pegan con 10 de daño
	player.take_damage(10)
	
	# Assert: La matemática debe ser: (10 - 50%) = 6 * 2 = 12 de daño final.
	assert_eq(player.consciousness, vida_inicial - 12, "Debe aplicar primero el escudo y luego el multiplicador del enemigo")
	
func test_die_activa_estado_muerto_y_evita_doble_muerte():
	# Act: Lo matamos
	player.die()
	
	# Assert
	assert_true(player.is_dead, "El estado is_dead debe ser true")
	
	# Act 2: Intentamos hacerle daño a un cadáver
	var vida_muerto = player.consciousness
	player.take_damage(50)
	
	# Assert 2: No debería perder más vida si ya está muerto
	assert_eq(player.consciousness, vida_muerto, "Un jugador muerto no puede recibir más daño")
