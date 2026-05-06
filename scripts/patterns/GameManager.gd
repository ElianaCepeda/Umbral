# scripts/GameManager.gd
extends Node

enum FlowState { NONE, TUTORIAL, BOOK, INTRO, RECOVERY_1, PHASE_1, RECOVERY_2, PHASE_2, BOSS, GOOD_ENDING , DEATH}
var keys_mostradas := false
var current_level: LevelState = null
var preguntas_completadas = false
var player_position_before_questions: Vector2 = Vector2.ZERO

# --- VARIABLES DEL MACRO LOOP ---
var current_flow: FlowState = FlowState.NONE
var current_campaign: String = ""
var current_enemy_index: int = 0

func _ready() -> void:
	TransitionManager.load_completed.connect(_on_level_loaded)

# Base de datos centralizada de la campaña. 
# ¡Si quieres cambiar el orden de los enemigos, solo editas este diccionario!
var campaign_database = {
	"alcohol": {
		"intro": "AndresTioAlcohol",
		"book" : AlcoholBookProtectiveState,
		"phase1": [RetardoLevel, BorrosoLevel, EuforiaLevel],
		"phase2": [CirrosisLevel, HipertensionLevel2, GastritisLevel],
		"boss": AlcoholLevel,
		"good_ending": "AndresTioAlcoholFinalBueno",
		"bad_ending": "AndresTioAlcoholFinalMalo",
		"next_unlock": "tabaco",
		"phase1_q": [1, 5],    # Rango de preguntas Fase 1
		"phase2_q": [6, 10]   # Rango de preguntas Fase 2
	},
	"tabaco": {
		"intro": "SofiaTiaTabaco",
		"book" : TabacoBookProtectiveState,
		"phase1": [HipertensionLevel, AsfixiaLevel, TaquicardiaLevel],
		"phase2": [AnsiedadLevel, FatigaLevel, ObstruccionLevel],
		"boss": TabacoLevel,
		"good_ending": "SofiaTiaTabacoFinalBueno",
		"bad_ending": "SofiaTiaTabacoFinalMalo",
		"next_unlock": "marihuana",
		"phase1_q": [11, 15],
		"phase2_q": [16, 20]
	},
	"marihuana": {
		"intro": "LucasPrimoMarihuana",
		"book" : MarihuanaBookProtectiveState,
		"phase1": [ConjuntivitisLevel, ApetitoLevel, AsfixiaLevel],
		"phase2": [MemoriaLevel, DesbalanceLevel , ParanoideLevel],
		"boss": MarihuanaLevel,
		"good_ending": "LucasPrimoMarihuanaFinalBueno",
		"bad_ending": "LucasPrimoMarihuanaFinalMalo",
		"next_unlock": "cocaina",
		"phase1_q": [21, 25],
		"phase2_q": [26, 30]
	},
	"cocaina": {
		"intro": "MateoHermanoCocaina",
		"book" : CocainaBookProtectiveState,
		"phase1": [ParanoideLevel, InsomnioLevel, ConvulsionesLevel],
		"phase2": [NecrosisLevel, TaquicardiaLevel2, PerdidaApetitoLevel],
		"boss": CocainaLevel,
		"good_ending": "MateoHermanoCocainaFinalBueno",
		"bad_ending": "MateoHermanoCocainaFinalMalo",
		"next_unlock": "fin", # Puedes cambiar esto por una pantalla de victoria final
		"phase1_q": [31, 36],
		"phase2_q": [36, 40]
	}
}

# --- CONTROLADORES DE FLUJO ---

# Se llama desde el Main Menu al elegir una sustancia
func start_campaign(substance: String) -> void:
	print("2. GameManager recibió la orden de iniciar campaña: ", substance)
	current_campaign = substance
	current_flow = FlowState.NONE
	current_enemy_index = 0
	preguntas_completadas = SaveManager.get_preguntas_completas()
	advance_campaign_flow()

# El "Cerebro" que mueve al jugador por las etapas
func advance_campaign_flow() -> void:
	print("3. Avanzando flujo. Campaña actual: ", current_campaign)
	if current_campaign == "" or not campaign_database.has(current_campaign):
		return
		
	var data = campaign_database[current_campaign]
	
	match current_flow:
		FlowState.NONE:
		
			if not SaveManager.is_tutorial_completed():
				# Si el perfil está limpio, lo mandamos al tutorial
				current_flow = FlowState.TUTORIAL
				change_level(TestLevelState.new()) 
			else:
				# Si ya lo pasó antes, va directo a la historia
				current_flow = FlowState.INTRO
				change_level(StoryState.new(data["intro"]))
				
		FlowState.TUTORIAL:
			SaveManager.mark_tutorial_completed()
			current_flow = FlowState.INTRO
			change_level(StoryState.new(data["intro"]))
			
		FlowState.INTRO:
			current_flow = FlowState.RECOVERY_1
			change_level(RecoveryState.new())
		
		FlowState.RECOVERY_1:
			current_flow = FlowState.BOOK
			change_level(data["book"].new())
			
		FlowState.BOOK:
			current_flow = FlowState.PHASE_1
			current_enemy_index = 0
			_load_current_phase_enemy(data["phase1"])
			
		FlowState.PHASE_1:
			current_enemy_index += 1
			if current_enemy_index < 3: # Aún hay enemigos en la Fase 1
				_load_current_phase_enemy(data["phase1"])
			else:
				current_flow = FlowState.RECOVERY_2
				SaveManager.set_preguntas_completadas(false)
				preguntas_completadas = SaveManager.get_preguntas_completas()
				change_level(RecoveryState.new())
				
		FlowState.RECOVERY_2:
			current_flow = FlowState.PHASE_2
			current_enemy_index = 0
			_load_current_phase_enemy(data["phase2"])
			
		FlowState.PHASE_2:
			current_enemy_index += 1
			if current_enemy_index < 3:
				_load_current_phase_enemy(data["phase2"])
			else:
				current_flow = FlowState.BOSS
				change_level(data["boss"].new()) 
				
		FlowState.BOSS:
			_evaluate_ending(data)
			
		FlowState.GOOD_ENDING:
			SaveManager.set_preguntas_completadas(false)
			change_level(LevelMenuState.new())
			
		FlowState.DEATH:
			force_exit_to_main_menu()

func _load_current_phase_enemy(phase_array: Array) -> void:
	var enemy_level_class = phase_array[current_enemy_index]
	change_level(enemy_level_class.new())

func _evaluate_ending(data: Dictionary) -> void:
	var vida_final = SaveManager.get_consciousness()
	
	if vida_final < 30:
		# Ganó, pero quedó destruido (Final Triste)
		current_flow = FlowState.GOOD_ENDING 
		change_level(GameOverState.new(data["bad_ending"], true))
	else:
		# Ganó y mantuvo su conciencia (Final Bueno)
		current_flow = FlowState.GOOD_ENDING
		SaveManager.unlock_macro_level(data["next_unlock"])
		change_level(StoryState.new(data["good_ending"], false))

# --- FUNCIONES DE CAMBIO ---
func change_level(new_level: LevelState):
	TransitionManager.load_level_async(new_level)

func _on_level_loaded(packed_scene: PackedScene, new_level: LevelState) -> void:
	new_level.preloaded_scene = packed_scene
	call_deferred("_perform_change_level", new_level)

func _perform_change_level(new_level: LevelState):
	if current_level:
		current_level.exit()
		remove_child(current_level)
		current_level.queue_free()
	current_level = new_level
	add_child(current_level)
	current_level.level_manager = self
	current_level.enter()

# --- VICTORIA, DERROTA Y SALIDAS ---

# Modificamos el Game Over para que lance el final malo
func game_over():
	if current_level:
		current_level.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	call_deferred("_perform_game_over")

func _perform_game_over():
	get_tree().paused = false
	if Dialogic.current_timeline != null: Dialogic.end_timeline()
	
	if current_campaign != "":
		var data = campaign_database[current_campaign]
		current_flow = FlowState.DEATH 
		change_level(GameOverState.new(data["bad_ending"], false))
	else:
		force_exit_to_main_menu()

# FUNCIÓN NUEVA: Para usar en el Menú de Pausa y evitar el bug
func force_exit_to_main_menu():
	print("Saliendo de forma segura al menú principal...")
	current_flow = FlowState.NONE
	if current_level:
		current_level.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	call_deferred("_perform_exit_to_menu")

func _perform_exit_to_menu():
	get_tree().paused = false
	if Dialogic.current_timeline != null: Dialogic.end_timeline()
	
	if current_level:
		current_level.exit()
		remove_child(current_level)
		current_level.queue_free()
		current_level = null
		
	# Volvemos a instanciar la escena del menú
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
	
func get_current_question_range() -> Array:
	if current_campaign == "" or not campaign_database.has(current_campaign):
		return [1, 9] # Seguro de vida por si algo falla
		
	var data = campaign_database[current_campaign]
	
	# Leemos la variable 'current_flow' que controla la máquina de estados
	if current_flow == FlowState.RECOVERY_1:
		return data["phase1_q"]
	elif current_flow == FlowState.RECOVERY_2:
		return data["phase2_q"]
		
	return [1, 9]
	
	
# ==========================================
# 🛠️ FUNCIONES DE DEBUG (ELIMINAR EN PRODUCCIÓN)
# ==========================================

# Esta función prepara el estado y salta directamente a la fase solicitada
func debug_start_at_phase(substance: String, target_phase: String) -> void:
	print("🛠️ DEBUG: Saltando directo a ", substance, " - ", target_phase)
	
	# 1. Limpiamos cualquier nivel anterior
	if current_level:
		current_level.exit()
		remove_child(current_level)
		current_level.queue_free()
		current_level = null
		
	# 2. Configuramos la campaña
	current_campaign = substance
	current_enemy_index = 0
	
	# 3. Fingimos que ya pasamos todo lo anterior (Dar vida, habilidades, etc.)
	# Como es un salto, le damos al jugador vida completa para que no muera al instante
	SaveManager.sync_and_save_player_state(100, 100, 5, 1, 1) # Stats infladas para probar
	
	var data = campaign_database[current_campaign]
	
	# 4. Ajustamos el estado interno y cargamos la escena correcta
	match target_phase:
		"fase1":
			current_flow = FlowState.RECOVERY_1
			change_level(RecoveryState.new())
		"fase2":
			current_flow = FlowState.RECOVERY_2
			SaveManager.set_preguntas_completadas(false)
			preguntas_completadas = SaveManager.get_preguntas_completas()
			change_level(RecoveryState.new())
		"fase3": # En tu diseño, la fase 3 es el Boss
			current_flow = FlowState.BOSS
			change_level(data["boss"].new())
		_:
			push_error("Fase de debug no reconocida: " + target_phase)

# ==========================================
