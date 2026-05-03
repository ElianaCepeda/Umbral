# levels/StoryState.gd
extends LevelState
class_name StoryState

var is_bad_ending: bool = false

# Recibimos qué diálogo reproducir y si este estado es el final triste
func _init(timeline: String, is_bad: bool = false):
	level_name = "Cinematica"
	scene_path = "res://scenes/cinematic.tscn" # Tu escena base para cinemáticas
	timeline_name = timeline
	is_bad_ending = is_bad
	macro_level = "" # No necesita habilidades

# Sobreescribimos la función para que no busque enemigos ni jugadores
func _on_timeline_ended():
	print("--- CINEMÁTICA TERMINADA ---")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	get_tree().paused = false
	
	# Si era el final malo (Game Over o menos de 30 de vida), lo sacamos al menú
	if is_bad_ending:
		GameManager.force_exit_to_main_menu()
	else:
		# Si era la Intro o el Final Bueno, avanzamos el flujo
		GameManager.advance_campaign_flow()
