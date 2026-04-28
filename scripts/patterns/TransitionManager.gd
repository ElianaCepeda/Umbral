# res://scripts/patterns/TransitionManager.gd
extends Node

signal load_completed(loaded_scene: PackedScene, pending_state: LevelState)

var _loading_path: String = ""
var _pending_level: LevelState = null

func _ready() -> void:
	set_process(false) # Solo procesamos cuando estamos cargando algo

# Inicia la carga en segundo plano
func load_level_async(level_state: LevelState) -> void:
	_pending_level = level_state
	_loading_path = level_state.scene_path
	ResourceLoader.load_threaded_request(_loading_path)
	set_process(true) # Activamos el proceso de chequeo

func _process(_delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(_loading_path)
	
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed_scene = ResourceLoader.load_threaded_get(_loading_path) as PackedScene
		set_process(false)
		emit_signal("load_completed", packed_scene, _pending_level)
		
	elif status == ResourceLoader.THREAD_LOAD_FAILED or status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		push_error("Error crítico de arquitectura: No se pudo cargar asíncronamente: " + _loading_path)
		set_process(false)
