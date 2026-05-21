extends GutTest

func before_each():
	# Limpiamos el estado de la máquina para que las pruebas no se contaminen entre sí
	GameManager.current_campaign = ""
	GameManager.current_flow = GameManager.FlowState.NONE
	GameManager.current_enemy_index = 0

# ==========================================
# 1. PRUEBAS DE INTEGRIDAD DE DATOS (DATA-DRIVEN)
# ==========================================

func test_integridad_base_de_datos_campanas():
	# Verificamos que el diccionario maestro contenga información
	var db = GameManager.campaign_database
	assert_gt(db.keys().size(), 0, "La base de datos de campañas no debe estar vacía")
	
	# Estas son las llaves obligatorias que el GameManager necesita para no colapsar
	var required_keys = ["intro", "book", "phase1", "phase2", "boss", "phase1_q", "phase2_q"]
	
	# Auditamos CADA sustancia configurada en el juego
	for campaign_name in db.keys():
		var campaign_data = db[campaign_name]
		
		# 1. Verificamos que no falte ninguna llave de configuración
		for key in required_keys:
			assert_true(campaign_data.has(key), "La campaña '" + campaign_name + "' DEBE tener la clave: " + key)
			
		# 2. Verificamos que los rangos de preguntas sean válidos (arreglos de exactamente 2 números)
		if campaign_data.has("phase1_q"):
			assert_eq(campaign_data["phase1_q"].size(), 2, "El rango de Fase 1 en " + campaign_name + " debe tener inicio y fin")
		if campaign_data.has("phase2_q"):
			assert_eq(campaign_data["phase2_q"].size(), 2, "El rango de Fase 2 en " + campaign_name + " debe tener inicio y fin")

# ==========================================
# 2. PRUEBAS DE LÓGICA DE RECUPERACIÓN (PREGUNTAS)
# ==========================================

func test_get_current_question_range_fase1_alcohol():
	# Arrange: Simulamos estar en la sala de recuperación 1 de Alcohol
	GameManager.current_campaign = "alcohol"
	GameManager.current_flow = GameManager.FlowState.RECOVERY_1
	
	# Act
	var range = GameManager.get_current_question_range()
	
	# Assert
	assert_eq(range[0], 1, "La primera pregunta de Alcohol Fase 1 debe ser la 1")
	assert_eq(range[1], 5, "La última pregunta de Alcohol Fase 1 debe ser la 5")

func test_get_current_question_range_fase2_tabaco():
	# Arrange: Simulamos estar en la sala de recuperación 2 de Tabaco
	GameManager.current_campaign = "tabaco"
	GameManager.current_flow = GameManager.FlowState.RECOVERY_2
	
	# Act
	var range = GameManager.get_current_question_range()
	
	# Assert
	assert_eq(range[0], 16, "La primera pregunta de Tabaco Fase 2 debe ser la 16")
	assert_eq(range[1], 20, "La última pregunta de Tabaco Fase 2 debe ser la 20")

# ==========================================
# 3. PRUEBAS DE FALLA SEGURA (FALLBACKS)
# ==========================================

func test_get_current_question_range_fallback_campana_invalida():
	# Arrange: Simulamos un error donde la campaña se borró o escribió mal
	GameManager.current_campaign = "sustancia_inventada"
	GameManager.current_flow = GameManager.FlowState.RECOVERY_1
	
	# Act
	var range = GameManager.get_current_question_range()
	
	# Assert: Debe devolver el rango de emergencia [1, 9] definido en tu script
	assert_eq(range[0], 1, "Falla segura: El mínimo debe ser 1 ante campañas inválidas")
	assert_eq(range[1], 9, "Falla segura: El máximo debe ser 9 ante campañas inválidas")

func test_get_current_question_range_fallback_flujo_invalido():
	# Arrange: Simulamos pedir preguntas durante una pelea de Jefe (lo cual es ilógico)
	GameManager.current_campaign = "marihuana"
	GameManager.current_flow = GameManager.FlowState.BOSS 
	
	# Act
	var range = GameManager.get_current_question_range()
	
	# Assert: Al no ser ni RECOVERY_1 ni RECOVERY_2, debe aplicar la falla segura
	assert_eq(range[0], 1, "Falla segura: Flujos distintos a recuperación devuelven rango de emergencia")
	assert_eq(range[1], 9, "Falla segura: Flujos distintos a recuperación devuelven rango de emergencia")
