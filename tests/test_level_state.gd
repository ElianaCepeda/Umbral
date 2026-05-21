extends GutTest

var level: LevelState

func before_each():
	# Instanciamos el estado del nivel limpio antes de cada prueba
	level = LevelState.new()
	add_child_autoqfree(level)
	
	var escenario_falso = Node2D.new()
	level.scene_instance = escenario_falso
	add_child_autoqfree(escenario_falso)

# ==========================================
# 1. PRUEBAS DE INYECCIÓN DE HABILIDADES
# ==========================================

func test_setup_skills_alcohol():
	level.macro_level = "alcohol"
	level._setup_skills_by_macro_level()
	assert_eq(level.skill1, "food_alcohol", "Skill 1 de alcohol debe ser comida")
	assert_eq(level.skill2, "medicine_alcohol", "Skill 2 de alcohol debe ser medicina")
	assert_eq(level.skill3, "water_attack", "El ataque de alcohol debe ser agua")

func test_setup_skills_tabaco():
	level.macro_level = "tabaco"
	level._setup_skills_by_macro_level()
	assert_eq(level.skill1, "exercise_tabaco", "Skill 1 de tabaco debe ser ejercicio")
	assert_eq(level.skill3, "gum_attack", "El ataque de tabaco debe ser chicle")

func test_setup_skills_marihuana():
	level.macro_level = "marihuana"
	level._setup_skills_by_macro_level()
	assert_eq(level.skill1, "dosis_measure_marihuana", "Skill 1 de marihuana debe ser dosis")
	assert_eq(level.skill3, "sleep_attack", "El ataque de marihuana debe ser dormir")

func test_setup_skills_cocaina():
	level.macro_level = "cocaina"
	level._setup_skills_by_macro_level()
	assert_eq(level.skill1, "nasalcare_cocaina", "Skill 1 de cocaína debe ser cuidado nasal")
	assert_eq(level.skill3, "temperature_attack", "El ataque de cocaína debe ser temperatura")

func test_setup_skills_vacio_falla_segura():
	level.macro_level = ""
	level._setup_skills_by_macro_level()
	assert_eq(level.skill1, "", "Si no hay macro_level, skill1 debe quedar vacía para no inyectar basura")

# ==========================================
# 2. PRUEBAS DE CONDICIÓN DE VICTORIA
# ==========================================

func test_check_win_condition_declara_victoria_sin_enemigos():
	# Arrange: Simulamos que estamos jugando
	level.is_gameplay_active = true
	# Le decimos que busque un grupo que sabemos que está vacío
	level.target_group = "grupo_vacio_inexistente" 
	
	# Act: Ejecutamos el chequeo
	level._check_win_condition()
	
	# Assert: Como no encontró nada, debe declarar victoria y apagar el gameplay
	assert_false(level.is_gameplay_active, "Al no quedar enemigos, is_gameplay_active debe pasar a false")

func test_check_win_condition_continua_si_hay_enemigos():
	# Arrange: Creamos un enemigo falso y lo metemos al grupo "enemy"
	level.is_gameplay_active = true
	level.target_group = "enemy"
	
	var enemigo_falso = Node2D.new()
	enemigo_falso.add_to_group("enemy")
	add_child_autoqfree(enemigo_falso)
	
	# Act: Ejecutamos el chequeo
	level._check_win_condition()
	
	# Assert: Como hay 1 enemigo, el gameplay debe seguir activo
	assert_true(level.is_gameplay_active, "Si quedan enemigos vivos, el gameplay no debe detenerse")

# ==========================================
# 3. PRUEBAS DEL CRONÓMETRO DE BÚSQUEDA (_process)
# ==========================================

func test_process_no_hace_nada_si_gameplay_inactivo():
	# Arrange
	level.is_gameplay_active = false
	level._win_check_timer = 0.0
	
	# Act: Simulamos que pasa 1 segundo (delta = 1.0)
	level._process(1.0)
	
	# Assert: El temporizador no debió sumar nada porque el gameplay no está activo
	assert_eq(level._win_check_timer, 0.0, "El temporizador no debe avanzar si el juego no está activo")

func test_process_acumula_tiempo_y_resetea_al_medio_segundo():
	# Arrange
	level.is_gameplay_active = true
	level._win_check_timer = 0.0
	level.target_group = "grupo_vacio" # Para que no falle al hacer el check_win
	
	# Act 1: Simulamos 0.3 segundos
	level._process(0.3)
	assert_eq(level._win_check_timer, 0.3, "El temporizador debió acumular 0.3 segundos")
	
	# Act 2: Simulamos otros 0.3 (total 0.6)
	level._process(0.3)
	
	# Assert: Como 0.6 >= 0.5, debió ejecutar check_win y resetearse a 0.0
	assert_eq(level._win_check_timer, 0.0, "El temporizador debió resetearse al superar 0.5 segundos")

# ==========================================
# 4. PRUEBAS DE LA PUERTA (EXIT DOOR)
# ==========================================

func test_on_exit_door_ignora_player_si_puerta_cerrada():
	# Arrange: Creamos un cuerpo falso simulando al jugador
	var body_player = Node2D.new()
	body_player.name = "Player"
	level.is_door_open = false # ¡La puerta está cerrada!
	
	# Le ponemos un estado falso al GameManager para ver si intenta cambiarlo
	GameManager.current_campaign = "alcohol"
	var flow_inicial = GameManager.current_flow
	
	# Act
	level._on_exit_door_body_entered(body_player)
	
	# Assert
	assert_eq(GameManager.current_flow, flow_inicial, "El jugador no debe poder avanzar si la puerta sigue cerrada")
	body_player.free()

func test_on_exit_door_ignora_cuerpos_no_player():
	# Arrange: Creamos un cuerpo falso (ej: una bala o un enemigo)
	var body_enemy = Node2D.new()
	body_enemy.name = "EnemigoCualquiera"
	level.is_door_open = true # La puerta está abierta
	
	var flow_inicial = GameManager.current_flow
	
	# Act
	level._on_exit_door_body_entered(body_enemy)
	
	# Assert
	assert_eq(GameManager.current_flow, flow_inicial, "Solo el jugador puede activar el avance de nivel")
	body_enemy.free()
