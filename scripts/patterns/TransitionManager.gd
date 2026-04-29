# scripts/autoloads/TransitionManager.gd
extends Node

signal load_completed(loaded_scene: PackedScene, pending_state: LevelState)

var _loading_path: String = ""
var _pending_level: LevelState = null

func _ready() -> void:
	set_process(false)

func load_level_async(level_state: LevelState) -> void:
	_pending_level = level_state
	_loading_path = level_state.scene_path
	
	print("4. TransitionManager: Solicitando carga asíncrona de -> ", _loading_path)
	
	# Verificación de seguridad antes de intentar cargar
	if not ResourceLoader.exists(_loading_path):
		print("¡ERROR CRÍTICO! La escena no existe en tu proyecto en esta ruta: ", _loading_path)
		return
		
	ResourceLoader.load_threaded_request(_loading_path)
	set_process(true)

func _process(_delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(_loading_path)
	
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		print("5. TransitionManager: Carga en memoria completada. Entregando escena al GameManager...")
		var packed_scene = ResourceLoader.load_threaded_get(_loading_path) as PackedScene
		set_process(false)
		load_completed.emit(packed_scene, _pending_level) # Usamos .emit() para Godot 4
		
	elif status == ResourceLoader.THREAD_LOAD_FAILED or status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		print("¡ERROR CRÍTICO! Falló la compilación asíncrona del archivo: ", _loading_path)
		set_process(false)
