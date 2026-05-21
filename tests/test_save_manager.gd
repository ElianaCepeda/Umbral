extends GutTest

func before_each():
	# Limpiamos el disco duro simulado antes de cada prueba para garantizar aislamiento total
	SaveManager.clear_save_data()

# ==========================================
# 1. PRUEBAS DE ESTADO INICIAL Y REINICIO
# ==========================================

func test_clear_save_data_inicializa_valores_por_defecto():
	# Verificamos que un perfil nuevo nazca con la configuración limpia de fábrica
	assert_eq(SaveManager.get_max_consciousness(), 100, "La conciencia máxima por defecto debe ser 100")
	assert_eq(SaveManager.get_attack(), 1, "Los puntos de ataque por defecto deben ser 1")
	assert_false(SaveManager.has_defense1(), "La defensa 1 debe iniciar bloqueada")
	assert_false(SaveManager.has_defense2(), "La defensa 2 debe iniciar bloqueada")
	assert_false(SaveManager.is_tutorial_completed(), "El tutorial debe iniciar como no completado")

func test_reset_phase_state_restaura_valores_de_combate():
	# Arrange: Simulamos un perfil alterado con estadísticas elevadas y habilidades obtenidas
	SaveManager.sync_and_save_player_state(50, 150, 8, 1, 1)
	
	# Act: Ejecutamos el reinicio que ocurre al cambiar de fase
	SaveManager.reset_phase_state()
	
	# Assert: Comprobamos que limpia las habilidades y devuelve la vida al tope estándar
	assert_eq(SaveManager.get_max_consciousness(), 100, "El reinicio de fase debe restaurar la vida máxima a 100")
	assert_eq(SaveManager.get_attack(), 1, "El reinicio de fase debe devolver los puntos de ataque a 1")
	assert_false(SaveManager.has_defense1(), "Se deben bloquear las defensas de la fase anterior")
	assert_false(SaveManager.has_defense2(), "Se deben bloquear las defensas de la fase anterior")

# ==========================================
# 2. PRUEBAS DE LA API DE SINCRONIZACIÓN (FALSA ALIMENTACIÓN)
# ==========================================

func test_sync_and_save_player_state_actualiza_valores_directos():
	# Act: Guardamos valores específicos de salud actual y máxima
	SaveManager.sync_and_save_player_state(85, 130)
	
	# Assert
	assert_eq(SaveManager.get_consciousness(), 85, "La conciencia actual debe registrarse como 85")
	assert_eq(SaveManager.get_max_consciousness(), 130, "La conciencia máxima debe registrarse como 130")

func test_sync_and_save_player_state_ignora_banderas_de_omision():
	# Arrange: Establecemos un estado previo conocido
	SaveManager.sync_and_save_player_state(90, 110, 4)
	
	# Act: Pasamos los parámetros de omisión (-1) para salud máxima y ataque
	SaveManager.sync_and_save_player_state(60, -1, -1)
	
	# Assert: La salud actual cambia, pero los demás atributos deben retener su valor previo
	assert_eq(SaveManager.get_consciousness(), 60, "La conciencia actual debió cambiar a 60")
	assert_eq(SaveManager.get_max_consciousness(), 110, "La conciencia máxima debió ignorar el -1 y mantener 110")
	assert_eq(SaveManager.get_attack(), 4, "Los puntos de ataque debieron ignorar el -1 y mantener 4")

func test_sync_and_save_player_state_aplica_clamp_estricto_al_ataque():
	# Caso Límite Superior: Intentamos inyectar un ataque desbordado (15)
	SaveManager.sync_and_save_player_state(100, 100, 15)
	assert_eq(SaveManager.get_attack(), 10, "La función debe truncar el ataque al límite máximo de 10")
	
	# Caso Límite Inferior: Intentamos inyectar un ataque inválido o negativo (-3)
	SaveManager.sync_and_save_player_state(100, 100, -3)
	assert_eq(SaveManager.get_attack(), 1, "La función debe elevar el ataque al límite mínimo seguro de 1")

func test_sync_and_save_player_state_actualiza_booleanos_de_defensas():
	# Act: Desbloqueamos defensa 1 (usando valor 1) y bloqueamos defensa 2 (usando valor 0)
	SaveManager.sync_and_save_player_state(100, 100, 3, 1, 0)
	
	# Assert
	assert_true(SaveManager.has_defense1(), "El valor de control 1 debe activar la bandera de la defensa 1")
	assert_false(SaveManager.has_defense2(), "El valor de control 0 debe apagar la bandera de la defensa 2")

# ==========================================
# 3. PRUEBAS DE MACRO-LOOP Y DESBLOQUEOS
# ==========================================

func test_unlock_macro_level_registra_campana_correctamente():
	# Assert Inicial: Validamos que inicie cerrado
	assert_false(SaveManager.is_unlocked("marihuana"), "La campaña debe estar bloqueada antes de la victoria")
	
	# Act
	SaveManager.unlock_macro_level("marihuana")
	
	# Assert Final
	assert_true(SaveManager.is_unlocked("marihuana"), "El arreglo persistente debe incluir la campaña tras el desbloqueo")

func test_get_latest_unlocked_campaign_evalua_orden_jerarquico():
	# Caso 1: Sin desbloqueos adicionales, el sistema retorna la campaña inicial por defecto
	assert_eq(SaveManager.get_latest_unlocked_campaign(), "alcohol", "La campaña base inicial debe ser alcohol")
	
	# Caso 2: Desbloqueamos de forma progresiva y evaluamos que el puntero jerárquico suba correctamente
	SaveManager.unlock_macro_level("tabaco")
	assert_eq(SaveManager.get_latest_unlocked_campaign(), "tabaco", "La campaña más alta detectada debe actualizarse a tabaco")
	
	SaveManager.unlock_macro_level("marihuana")
	assert_eq(SaveManager.get_latest_unlocked_campaign(), "marihuana", "La campaña más alta detectada debe actualizarse a marihuana")
	
	SaveManager.unlock_macro_level("cocaina")
	assert_eq(SaveManager.get_latest_unlocked_campaign(), "cocaina", "La campaña más alta detectada debe actualizarse a cocaina")

func test_mark_tutorial_completed_guarda_estado_en_disco():
	# Act
	SaveManager.mark_tutorial_completed()
	
	# Assert
	assert_true(SaveManager.is_tutorial_completed(), "La bandera de progreso del tutorial debe guardarse como verdadera")
