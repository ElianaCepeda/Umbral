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

func unlock_macro_level(level_name: String) -> void:
	if not _current_profile.unlocked_levels.has(level_name):
		_current_profile.unlocked_levels.append(level_name)
		_save_disk()
		
func reset_phase_state() -> void:
	_current_profile.max_consciousness = 100
	_current_profile.attack_points = 1 
	_current_profile.defense1_unlocked = false
	_current_profile.defense2_unlocked = false
	
	_save_disk()
	print("Vida máxima restaurada y habilidades limpiadas para la nueva fase.")
