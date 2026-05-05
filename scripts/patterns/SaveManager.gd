# res://scripts/patterns/SaveManager.gd
extends Node

const SAVE_PATH: String = "user://player_save.res" # Binario para evitar trampas
var _current_profile: PlayerProfile = null

func _ready() -> void:
	_load_game()

func _load_game() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		_current_profile = ResourceLoader.load(SAVE_PATH) as PlayerProfile
	else:
		_current_profile = PlayerProfile.new()
		_save_disk()

func _save_disk() -> void:
	ResourceSaver.save(_current_profile, SAVE_PATH)

# ==========================================
# LA FACHADA: API PÚBLICA PARA EL JUEGO
# ==========================================

func get_consciousness() -> int: return _current_profile.current_consciousness
func get_max_consciousness() -> int: return _current_profile.max_consciousness
func get_attack() -> int: return _current_profile.attack_points
func has_defense1() -> bool: return _current_profile.defense1_unlocked
func has_defense2() -> bool: return _current_profile.defense2_unlocked
func get_preguntas_completas() -> bool: return _current_profile.preguntas_completadas
func set_preguntas_completadas(preguntas: bool) -> void: 
	_current_profile.preguntas_completadas = preguntas
	_save_disk()

# Actualiza y guarda en un solo paso. Usamos -1 y 2 para ignorar valores que no queramos actualizar.
func sync_and_save_player_state(health: int, max_health: int = -1, new_attack: int = -1, def1: int = 2, def2: int = 2) -> void:
	_current_profile.current_consciousness = health
	
	if max_health != -1: 
		_current_profile.max_consciousness = max_health
	
	if new_attack != -1: 
		# Aplicamos el límite de 1 a 10 solicitado
		_current_profile.attack_points = clamp(new_attack, 1, 10)
	
	if def1 != 2: _current_profile.defense1_unlocked = bool(def1)
	if def2 != 2: _current_profile.defense2_unlocked = bool(def2)
	
	_save_disk()

func unlock_macro_level(campaign_name: String) -> void:
	# Verificamos si el arreglo dentro del perfil ya tiene este nivel
	if not _current_profile.unlocked_levels.has(campaign_name):
		# Lo agregamos al perfil
		_current_profile.unlocked_levels.append(campaign_name)
		print("¡Nueva sustancia desbloqueada y guardada en disco: ", campaign_name, "!")
		# Ahora sí, al guardar el perfil, el arreglo actualizado se va al disco duro
		_save_disk()
		
func is_unlocked(campaign_name: String) -> bool:
	# Leemos directamente desde el arreglo del perfil cargado desde el disco
	return _current_profile.unlocked_levels.has(campaign_name)
	
func get_latest_unlocked_campaign() -> String:
	# Revisamos de la más difícil a la más fácil usando la función de arriba
	if is_unlocked("cocaina"): return "cocaina"
	if is_unlocked("marihuana"): return "marihuana"
	if is_unlocked("tabaco"): return "tabaco"
	return "alcohol" # Por defecto
		
func reset_phase_state() -> void:
	_current_profile.max_consciousness = 100
	_current_profile.attack_points = 1 
	_current_profile.defense1_unlocked = false
	_current_profile.defense2_unlocked = false
	
	_save_disk()
	print("Vida máxima restaurada y habilidades limpiadas para la nueva fase.")
	
func is_tutorial_completed() -> bool:
	return _current_profile.tutorial_completado

# Marca el tutorial como hecho y guarda en el disco duro
func mark_tutorial_completed() -> void:
	_current_profile.tutorial_completado = true
	_save_disk()
	
func clear_save_data() -> void:
	_current_profile = PlayerProfile.new()
	_save_disk()
	print("Memoria limpiada: El progreso del jugador ha sido reiniciado desde cero.")
